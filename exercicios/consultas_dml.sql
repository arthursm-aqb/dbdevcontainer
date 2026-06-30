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


DELETE FROM dbagconsultas.agendamento -- Comando que remove tabela ou instâncias com base numa condição ou não
WHERE DATE(dh_consulta) = '1783-05-19';

DELETE FROM dbagconsultas.agendamento
WHERE cpf_medico = '001' AND valor_consulta = 0.0;

DELETE FROM dbagconsultas.paciente
WHERE plano_saude = TRUE OR cpf_paciente IN(SELECT cpf FROM dbagconsultas.pessoa WHERE telefone IS NULL);

DELETE FROM dbagconsultas.agendamento
WHERE cpf_medico = '004';

DELETE FROM dbagconsultas.MedicoEspecialidade
WHERE cpf_medico = '004';

DELETE FROM dbagconsultas.medico
WHERE cpf_medico = '004';







