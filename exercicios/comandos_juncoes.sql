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

--  Listar o nome, e-mail e crm dos médicos.
SELECT p.nome, p.email, m.crm
FROM dbagconsultas.pessoa p
inner join dbagconsultas.medico m ON p.cpf = m.cpf_medico;

--  Listar o nome, e-mail e senha dos pacientes.
SELECT p.nome, p.email, pa.senha
FROM dbagconsultas.pessoa p
inner join dbagconsultas.paciente pa ON p.cpf = pa.cpf_paciente;

--  Listar os CRM dos médicos e as descrições das suas respectivas especialidades.
SELECT m.crm, e.descricao
FROM dbagconsultas.medico m
inner join dbagconsultas.MedicoEspecialidade me ON m.cpf_medico = me.cpf_medico
inner join dbagconsultas.especialidade e ON me.id_especialidade = e.id;

--  Listar o crm de todos os médicos cardiologistas.
SELECT m.crm
FROM dbagconsultas.medico m
inner join dbagconsultas.MedicoEspecialidade me ON m.cpf_medico = me.cpf_medico
inner join dbagconsultas.especialidade e ON me.id_especialidade = e.id
WHERE lower(e.descricao) = 'cardiologista';

--  Listar o nome, CPF, crm e senha dos pacientes que também são médicos.
SELECT p.nome, p.cpf, m.crm, pa.senha
FROM dbagconsultas.pessoa p
inner join dbagconsultas.paciente pa ON p.cpf = pa.cpf_paciente
inner join dbagconsultas.medico m ON p.cpf = m.cpf_medico;

--  Listar o nome dos médicos e as respectivas quantidades de consultas agendadas. Observem que alguns médicos podem não ter consulta agendada.
SELECT p.nome, COUNT(a.dh_consulta) AS quantidade_consultas
FROM dbagconsultas.medico m
inner join dbagconsultas.pessoa p ON m.cpf_medico = p.cpf
left outer join dbagconsultas.agendamento a ON m.cpf_medico = a.cpf_medico
GROUP BY p.nome;

--  Listar as especialidades e a quantidade de médicos cadastrados nessa especialidade. Observem que algumas especialidades podem não ter médicos associados.
SELECT e.descricao, COUNT(me.cpf_medico) AS quantidade_medicos
FROM dbagconsultas.especialidade e
left outer join dbagconsultas.MedicoEspecialidade me ON e.id = me.id_especialidade
GROUP BY e.descricao;

--  Listar os dados dos agendamentos, exibindo: (a) o nome e e-mail do paciente, (b) data/hora e valor da consulta, e (c) o nome e crm dos médicos.
SELECT pp.nome AS nome_paciente, pp.email AS email_paciente, a.dh_consulta, a.valor_consulta, pm.nome AS nome_medico, m.crm
FROM dbagconsultas.agendamento a
inner join dbagconsultas.paciente pa ON a.cpf_paciente = pa.cpf_paciente
inner join dbagconsultas.pessoa pp ON pa.cpf_paciente = pp.cpf
inner join dbagconsultas.medico m ON a.cpf_medico = m.cpf_medico
inner join dbagconsultas.pessoa pm ON m.cpf_medico = pm.cpf;

--  Listar a data/hora das consultas agendadas para todos os cardiologistas cadastrados.
SELECT a.dh_consulta
FROM dbagconsultas.agendamento a
inner join dbagconsultas.medico m ON a.cpf_medico = m.cpf_medico
inner join dbagconsultas.MedicoEspecialidade me ON m.cpf_medico = me.cpf_medico
inner join dbagconsultas.especialidade e ON me.id_especialidade = e.id
WHERE lower(e.descricao) = 'cardiologista';

--  Listar o nome e CRM dos médicos e a média das suas consultas agendadas para o mês de dezembro/2020.
SELECT p.nome, m.crm, AVG(a.valor_consulta) AS media_consultas
FROM dbagconsultas.medico m
inner join dbagconsultas.pessoa p ON m.cpf_medico = p.cpf
left outer join dbagconsultas.agendamento a ON m.cpf_medico = a.cpf_medico 
    AND EXTRACT(MONTH FROM a.dh_consulta) = 12 
    AND EXTRACT(YEAR FROM a.dh_consulta) = 2020
GROUP BY p.nome, m.crm;
