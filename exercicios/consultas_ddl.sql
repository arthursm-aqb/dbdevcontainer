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

    CONSTRAINT cpf_paciente_fk FOREIGN KEY (cpf_paciente) REFERENCES dbagconsultas.pessoa(cpf)
);

CREATE TABLE IF NOT EXISTS dbagconsultas.medico(
    cpf_medico char(11) PRIMARY KEY,
    crm varchar(10) UNIQUE NOT NULL,

    CONSTRAINT cpf_medico_fk FOREIGN KEY(cpf_medico) REFERENCES dbagconsultas.pessoa(cpf) 
);