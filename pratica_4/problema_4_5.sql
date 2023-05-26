CREATE SCHEMA problema_4_5;
GO

Create Table problema_4_5.PESSOA(
	endereco_email		varchar(30)		NOT NULL,
	nome				varchar(30),
	primary key(endereco_email)
);

Create Table problema_4_5.AUTOR(
	endereco_email		varchar(30)		NOT NULL,
	primary key(endereco_email),
	foreign key(endereco_email) references problema_4_5.PESSOA(endereco_email) on update cascade
);

Create Table problema_4_5.PARTICIPANTE(
	endereco_email		varchar(30)		NOT NULL,
	data_inscricao		smalldatetime,	
	primary key(endereco_email),
	foreign key(endereco_email) references problema_4_5.PESSOA(endereco_email) on update cascade
);

Create Table problema_4_5.INSTITUICAO(
	nome				varchar(30)		NOT NULL,
	endereco			varchar(30)		NOT NULL,	
	primary key(endereco),
);

Create Table problema_4_5.ESTUDANTE(
	endereco_email		varchar(30)				NOT NULL,
	comprovativo		varchar(30)		unique	NOT NULL,
	localizacao			varchar(30),
	endereco			varchar(30),
	primary key(endereco_email),
	foreign key(endereco_email) references problema_4_5.PARTICIPANTE(endereco_email) on update cascade,
	foreign key(endereco) references problema_4_5.INSTITUICAO(endereco) on update cascade
);

Create Table problema_4_5.NAO_ESTUDANTE(
	endereco_email		varchar(30)		NOT NULL,
	referencia			varchar(30)		NOT NULL,	
	primary key(endereco_email),
	unique(referencia),
	foreign key(endereco_email) references problema_4_5.PARTICIPANTE(endereco_email) on update cascade
);

Create Table problema_4_5.ARTIGO(
	titulo				varchar(30)		NOT NULL,
	num_registo			int				NOT NULL,	
	primary key(num_registo),
);

Create Table problema_4_5.ASSOCIADO(
	endereco_email		varchar(30)		NOT NULL,
	endereco			varchar(30)		NOT NULL,	
	primary key(endereco_email, endereco),
	foreign key(endereco_email) references problema_4_5.PESSOA(endereco_email) on update cascade,
	foreign key(endereco) references problema_4_5.INSTITUICAO(endereco) on update cascade
);

Create Table problema_4_5.ESCRITO(
	endereco_email		varchar(30)		NOT NULL,
	num_registo			int				NOT NULL,	
	primary key(endereco_email, num_registo),
	foreign key(endereco_email) references problema_4_5.AUTOR(endereco_email) on update cascade,
	foreign key(num_registo) references problema_4_5.ARTIGO(num_registo) on update cascade
);