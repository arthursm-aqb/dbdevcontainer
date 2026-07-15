CREATE SCHEMA dbagconsultas;

CREATE TABLE IF NOT EXISTS dbagconsultas.pessoa(
    cpf char(11) PRIMARY KEY,
    email varchar(50) NOT NULL,
    nome varchar(150) NOT NULL,
    data_nasc DATE NOT NULL,
    endereco varchar(300) NOT NULL,
    telefone varchar(15) NULL,
    CONSTRAINT unique_1 UNIQUE(email, nome)
);

CREATE TABLE IF NOT EXISTS dbagconsultas.paciente(
    cpf_paciente char(11) PRIMARY KEY,
    senha varchar(20) NOT NULL,
    plano_saude boolean NOT NULL DEFAULT FALSE,
    CONSTRAINT cpf_paciente_fk1 FOREIGN KEY (cpf_paciente) REFERENCES dbagconsultas.pessoa(cpf)
);

CREATE TABLE IF NOT EXISTS dbagconsultas.medico(
    cpf_medico char(11) PRIMARY KEY,
    crm varchar(10) UNIQUE NOT NULL,
    CONSTRAINT cpf_medico_fk1 FOREIGN KEY(cpf_medico) REFERENCES dbagconsultas.pessoa(cpf) 
);

CREATE TABLE IF NOT EXISTS dbagconsultas.agendamento(
    cpf_paciente char(11),
    cpf_medico char(11),
    dh_consulta TIMESTAMP,
    dh_agendamento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor_consulta float NOT NULL DEFAULT 0.0,

    PRIMARY KEY (cpf_paciente, cpf_medico, dh_consulta),
    CONSTRAINT cpf_paciente_fk2 FOREIGN KEY(cpf_paciente) REFERENCES dbagconsultas.paciente(cpf_paciente),
    CONSTRAINT cpf_medico_fk2 FOREIGN KEY(cpf_medico) REFERENCES dbagconsultas.medico(cpf_medico)
);

CREATE TABLE IF NOT EXISTS dbagconsultas.especialidade(
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao varchar(300) NOT NULL
);

CREATE TABLE IF NOT EXISTS dbagconsultas.MedicoEspecialidade(
    cpf_medico char(11),
    id_especialidade int,

    PRIMARY KEY (cpf_medico, id_especialidade),
    CONSTRAINT cpf_medico_fk3 FOREIGN KEY(cpf_medico) REFERENCES dbagconsultas.medico(cpf_medico),
    CONSTRAINT id_especialidade_fk FOREIGN KEY(id_especialidade) REFERENCES dbagconsultas.especialidade(id)
);

-- 1)
INSERT INTO dbagconsultas.pessoa(nome, email, cpf, data_nasc, endereco, telefone) -- Comando para cadastrar instâncias numa tabela existente
VALUES ('Pedro I', 'pp@email.com', '002', '1479-01-10', 'R. Vasco', NULL),
       ('Pedro II', 'ps@email.com', '003', '1516-02-10', 'R. Flamengo', '5501'),
       ('D João VI', 'dj@email.com', '001', '1415-12-01', 'R. Portugal', NULL),
       ('JJ Xavier', 'jj@email.com', '004', '1746-11-12', 'R. Minas', '5502');

INSERT INTO dbagconsultas.paciente(cpf_paciente, senha, plano_saude)
VALUES  ('002', 'senha1', FALSE),
        ('003', 'senha2', TRUE);

INSERT INTO dbagconsultas.medico(cpf_medico, crm)
VALUES  ('001', '111'),
        ('004', '112');

INSERT INTO dbagconsultas.especialidade(descricao)
VALUES  ('Pediatra'),
        ('Cardiologista'),
        ('Ortopedista');

INSERT INTO dbagconsultas.MedicoEspecialidade(cpf_medico, id_especialidade)
VALUES  ('001', 1),
        ('004', 2),
        ('004', 3);

INSERT INTO dbagconsultas.agendamento(cpf_paciente, cpf_medico, dh_consulta, dh_agendamento, valor_consulta)
VALUES  ('002', '001', '1782-04-14 16:00:00', '1782-03-14 10:04:45', 80),
        ('002', '004', '1782-04-15 10:00:00', '1782-03-14 10:04:45', 100),
        ('002', '004', '1783-05-17 08:00:00', '1783-05-10 16:32:00', 100),
        ('003', '001', '1783-05-17 08:30:00', '1783-05-09 09:05:56', 0);

-- 2)
UPDATE dbagconsultas.pessoa -- Comando para modificar valores de instância já existente
SET data_nasc = '1416-12-01'
WHERE nome = 'D João VI';

UPDATE dbagconsultas.pessoa
SET email = 'pf@email.com', telefone = '5503' 
WHERE nome = 'Pedro I';

UPDATE dbagconsultas.pessoa
SET telefone = '9' || telefone
WHERE telefone is NOT NULL;

UPDATE dbagconsultas.agendamento
SET dh_consulta = '1783-05-19', valor_consulta = '150.00'
WHERE DATE(dh_consulta) = '1783-05-17';

UPDATE dbagconsultas.MedicoEspecialidade
SET id_especialidade = 1
WHERE id_especialidade = 2 AND cpf_medico = '004';

--------------------------------------------------------------------------------------------------------------------------------------


-- Listar todos os dados de todas as pessoas cadastradas.
SELECT * FROM dbagconsultas.pessoa;

-- Listar nome, e-mail e data de nascimento das pessoas cadastradas.
SELECT nome, email, data_nasc FROM dbagconsultas.pessoa;

-- Listar nome, e-mail e data de nascimento da 3a à 8a pessoa cadastrada.
SELECT nome, email, data_nasc FROM dbagconsultas.pessoa LIMIT 6 OFFSET 2;

-- Listar nome, e-mail e idade das pessoas cadastradas.
SELECT nome, email, EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM data_nasc) AS idade FROM dbagconsultas.pessoa;

-- Listar a quantidade de agendamentos.
SELECT COUNT(*) AS quantidade_agendamentos FROM dbagconsultas.agendamento;

-- Listar a data/hora das consultas e os respectivos valores com desconto de 5%. Os valores devem ser precedidos com "R$". Por exemplo: R$ 150.00.
SELECT dh_consulta, concat('R$ ', (valor_consulta * 0.95)) AS valor_com_desconto FROM dbagconsultas.agendamento;

-- Listar nome, cpf e e-mail dos pacientes que não possuem plano de saúde.
SELECT p.nome, p.cpf, p.email 
FROM dbagconsultas.pessoa p, dbagconsultas.paciente pa
WHERE p.cpf = pa.cpf_paciente AND pa.plano_saude = FALSE;

-- Listar os dados dos agendamentos registrados para o mesmo o mês da consulta.
SELECT * 
FROM dbagconsultas.agendamento
WHERE EXTRACT(MONTH FROM dh_agendamento) = EXTRACT(MONTH FROM dh_consulta)
  AND EXTRACT(YEAR FROM dh_agendamento) = EXTRACT(YEAR FROM dh_consulta);

-- Listar cpf, nome e e-mail dos pacientes que não possuem telefone.
SELECT p.cpf, p.nome, p.email 
FROM dbagconsultas.pessoa p, dbagconsultas.paciente pa
WHERE p.cpf = pa.cpf_paciente AND p.telefone IS NULL;

-- Listar a data das consultas cujo o valor está entre R$ 50.00 e R$ 100.00.
SELECT dh_consulta 
FROM dbagconsultas.agendamento
WHERE valor_consulta BETWEEN 50.00 AND 100.00;

-- Listar cpf, nome e e-mail dos pacientes que moram em "Natal".
SELECT p.cpf, p.nome, p.email 
FROM dbagconsultas.pessoa p, dbagconsultas.paciente pa
WHERE p.cpf = pa.cpf_paciente AND lower(p.endereco) = 'natal';

-- Listar cpf, nome, e-mail e data de nascimento dos pacientes ordenados pela data de nascimento.
SELECT p.cpf, p.nome, p.email, p.data_nasc 
FROM dbagconsultas.pessoa p, dbagconsultas.paciente pa
WHERE p.cpf = pa.cpf_paciente
ORDER BY p.data_nasc;

-- Listar a quantidade de pacientes que não possuem plano de saúde.
SELECT COUNT(*) AS qtd_sem_plano 
FROM dbagconsultas.paciente 
WHERE plano_saude = FALSE;

-- Listar o maior e o menor valor das consultas agendadas para cada dia que contém consulta.
SELECT DATE(dh_consulta) AS dia_consulta, 
       MAX(valor_consulta) AS maior_valor, 
       MIN(valor_consulta) AS menor_valor 
FROM dbagconsultas.agendamento
GROUP BY DATE(dh_consulta);

-- Listar a média dos valores das consultas agendadas para o mês de Dezembro.
SELECT AVG(valor_consulta) AS media_valor_dezembro 
FROM dbagconsultas.agendamento
WHERE EXTRACT(MONTH FROM dh_consulta) = 12;

-- Listar nome e e-mail das pessoas que agendaram alguma consulta para o dia do seu aniversário.
SELECT T p.nome, p.email 
FROM dbagconsultas.pessoa p, dbagconsultas.agendamento a
WHERE p.cpf = a.cpf_paciente
  AND EXTRACT(MONTH FROM a.dh_consulta) = EXTRACT(MONTH FROM p.data_nasc)
  AND EXTRACT(DAY FROM a.dh_consulta) = EXTRACT(DAY FROM p.data_nasc);

-- Listar o nome, e-mail, cpf dos médicos e as suas respectivas especialidades.
SELECT p.nome, p.email, p.cpf, e.descricao AS especialidade 
FROM dbagconsultas.pessoa p, dbagconsultas.medico m, dbagconsultas.MedicoEspecialidade me, dbagconsultas.especialidade e
WHERE p.cpf = m.cpf_medico
  AND m.cpf_medico = me.cpf_medico
  AND me.id_especialidade = e.id;

-- Listar a quantidade de consultas para cada médico.
SELECT m.cpf_medico, p.nome, 
       (SELECT COUNT(*) FROM dbagconsultas.agendamento a WHERE a.cpf_medico = m.cpf_medico) AS qtd_consultas 
FROM dbagconsultas.medico m, dbagconsultas.pessoa p
WHERE m.cpf_medico = p.cpf;
