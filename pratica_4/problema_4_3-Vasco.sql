CREATE SCHEMA problema_4_3;
GO

Create Table problema_4_3.PRODUTO(
	codigo				int,
	nome				int,
	preco				money,
	iva					decimal(3,2),
	numero_unidades		int,
	primary key(codigo),
);

Create Table problema_4_3.FORNECEDOR(
	nif					int,
	nome				varchar(30),
	cond_pagamento		VarChar(30),
	n_fax				VarChar(30),
	endereco			VarChar(30),
	primary key(nif),
);

Create Table problema_4_3.ENCOMENDA(
	num_encomenda		int,
	data_realizacao		date,
	nif					int,
	primary key(num_encomenda),
	foreign key(nif) references problema_4_3.FORNECEDOR(nif)
);

Create Table problema_4_3.TIPO(
	codigo				int,
	designacao			varchar(30),
	primary key(codigo),
);

Create Table problema_4_3.CONTEM(
	num_encomenda		int,
	codigo				int,
	n_itens				int,
	primary key(num_encomenda, codigo),
	foreign key(num_encomenda) references problema_4_3.ENCOMENDA(num_encomenda),
	foreign key(codigo) references problema_4_3.PRODUTO(codigo)
);

Create Table problema_4_3.TEM(
	nif					int,
	codigo				int,
	primary key(nif,codigo),
	foreign key(nif) references problema_4_3.FORNECEDOR(nif),
	foreign key(codigo) references problema_4_3.TIPO(codigo)
);