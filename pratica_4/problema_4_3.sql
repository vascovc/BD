CREATE SCHEMA problema_4_3;
GO

Create Table problema_4_3.PRODUTO(
	codigo				int				NOT NULL,
	nome				int				NOT NULL,
	preco				money,
	iva					decimal(3,2)	default 23,
	numero_unidades		int, --posteriormente deveria se verificar se e superior a 0
	primary key(codigo),
);

Create Table problema_4_3.FORNECEDOR(
	nif					char(9)			NOT NULL,
	nome				varchar(30)		NOT NULL,
	cond_pagamento		tinyint, --coloca se o numero de dias 
	n_fax				VarChar(15),
	endereco			VarChar(30),
	primary key(nif),
);

Create Table problema_4_3.ENCOMENDA(
	num_encomenda		int				NOT NULL,
	data_realizacao		datetime,
	nif					char(9),
	primary key(num_encomenda),
	foreign key(nif) references problema_4_3.FORNECEDOR(nif)
);

Create Table problema_4_3.CONTEM(
	num_encomenda		int				NOT NULL,
	codigo				int				NOT NULL,
	n_itens				int				default 1,
	primary key(num_encomenda, codigo),
	foreign key(num_encomenda) references problema_4_3.ENCOMENDA(num_encomenda) on update cascade,
	foreign key(codigo) references problema_4_3.PRODUTO(codigo) on update cascade
);

Create Table problema_4_3.TEM(
	nif					char(9)			NOT NULL,
	codigo				int				NOT NULL,
	primary key(nif, codigo),
	foreign key(nif) references problema_4_3.FORNECEDOR(nif),
	unique(codigo)
);

Create Table problema_4_3.TIPO(
	codigo				int				NOT NULL,
	designacao			varchar(30),
	primary key(codigo),
	foreign key(codigo) references problema_4_3.TEM(codigo) on update cascade
);