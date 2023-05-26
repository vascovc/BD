CREATE SCHEMA problema_4_6;
GO

Create Table problema_4_6.ADULTO(
	cc					char(9)			unique NOT NULL,
	nome				varchar(30),
	morada				varchar(30),
	data_nascimento		date,
	telefone			char(9)			unique,
	email				varchar(30)		unique,
	primary key(cc),
);

Create Table problema_4_6.PESSOAS_AUTORIZACAO(
	cc					char(9)			NOT NULL,
	relacao				varchar(10),
	primary key(cc),
	foreign key(cc) references problema_4_6.ADULTO(cc)
);

Create Table problema_4_6.ATIVIDADE(
	identificador		int				NOT NULL,
	designacao			varchar(30),
	custo				smallmoney,
	primary key(identificador)
);

Create Table problema_4_6.PROFESSOR(
	cc					char(9)		NOT NULL,
	num_funcionario		int			unique NOT NULL,
	primary key(cc),
	foreign key(cc) references problema_4_6.ADULTO(cc)
);

Create Table problema_4_6.TURMA(
	identificador				int		NOT NULL,
	ano_letivo					date,
	num_max_alunos				tinyint,
	designacao					varchar(30),
	escolaridade				tinyint,
	num_funcionario				int,
	primary key(identificador),
	foreign key(num_funcionario) references problema_4_6.PROFESSOR(num_funcionario)
);

Create Table problema_4_6.ALUNO(
	cc						char(9)		NOT NULL,
	nome					varchar(30),
	morada					varchar(30),
	data_nascimento			date,
	encarregado_educacao	char(9)		NOT NULL,
	identificador			int,
	primary key(cc),
	foreign key(encarregado_educacao) references problema_4_6.PESSOAS_AUTORIZACAO(cc),
	foreign key(identificador) references problema_4_6.TURMA(identificador)
);

Create Table problema_4_6.DISPONIVEL(
	identificador_1			int		NOT NULL,
	identificador_2			int		NOT NULL,
	primary key(identificador_1,identificador_2),
	foreign key(identificador_1) references problema_4_6.TURMA(identificador),
	foreign key(identificador_2) references problema_4_6.ATIVIDADE(identificador)
);

Create Table problema_4_6.FREQUENTA(
	cc						char(9)	NOT NULL,
	identificador			int		NOT NULL,
	primary key(cc,identificador),
	foreign key(cc) references problema_4_6.ALUNO(cc),
	foreign key(identificador) references problema_4_6.ATIVIDADE(identificador)
);

Create Table problema_4_6.ENTREGA_LEVANTA(
	cc_1					char(9)	NOT NULL,
	cc_2					char(9)	NOT NULL,
	primary key(cc_1,cc_2),
	foreign key(cc_1) references problema_4_6.ALUNO(cc),
	foreign key(cc_2) references problema_4_6.PESSOAS_AUTORIZACAO(cc),
);