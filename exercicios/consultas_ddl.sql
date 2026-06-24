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