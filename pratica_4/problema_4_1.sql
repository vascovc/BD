CREATE SCHEMA problema_4_1;
GO

Create Table problema_4_1.CLIENTE(
	nif				char(9)				NOT NULL,
	num_carta		char(9)				NOT NULL,
	endereco		VarChar(30),
	nome			VarChar(30)	,
	primary key(nif),
	Unique(num_carta)
);

Create Table problema_4_1.BALCAO(
	numero			varchar(9)				NOT NULL,
	endereco		varchar(30),
	nome			varchar(30),
	primary key(numero)
);

Create Table problema_4_1.TIPO_VEICULO(
	designacao		varchar(30),
	ar_condicionado	bit default 0,
	codigo			int				NOT NULL,
	primary key(codigo)
);

Create Table problema_4_1.VEICULO(
	matricula		char(6)			NOT NULL,
	ano				int,
	marca			varchar(30),
	codigo			int				NOT NULL,
	primary key(matricula),
	foreign key(codigo) references problema_4_1.TIPO_VEICULO(codigo)
);

Create Table problema_4_1.ALUGUER(
	numero_alug		int				NOT NULL,
	duracao			smallint,
	data_			smalldatetime,
	nif				char(9)			NOT NULL,
	numero			varchar(9)		NOT NULL,
	matricula		char(6)			NOT NULL,
	primary key(numero_alug),
	foreign key(numero) references problema_4_1.BALCAO(numero) on update cascade,
	foreign key(nif) references problema_4_1.CLIENTE(nif),
	foreign key(matricula) references problema_4_1.VEICULO(matricula)
);

Create Table problema_4_1.LIGEIRO(
	codigo			int				NOT NULL,
	num_lugares		tinyint,
	portas			tinyint,
	combustivel		tinyint,	--atribui-se a um numero o tipo 0 diesel 1 gasolina 2 gpl 3 eletrico 4 hidrogenio
	primary key(codigo),
	foreign key(codigo) references problema_4_1.TIPO_VEICULO(codigo)
);

Create Table problema_4_1.PESADO(
	codigo			int				NOT NULL,
	peso			int,
	passageiros		tinyint,
	primary key(codigo),
	foreign key(codigo) references problema_4_1.TIPO_VEICULO(codigo)
);

Create Table problema_4_1.SIMILARIDADE(
	codigo_1		int				NOT NULL,
	codigo_2		int				NOT NULL,
	primary key(codigo_1,codigo_2),
	foreign key(codigo_1) references problema_4_1.TIPO_VEICULO(codigo),
	foreign key(codigo_2) references problema_4_1.TIPO_VEICULO(codigo)
);