CREATE SCHEMA problema_4_4;
GO

Create Table problema_4_4.MEDICO(
	num_ident			int				NOT NULL,
	nome				varchar(30),
	primary key(num_ident)
);

Create Table problema_4_4.ESPECIALIDADE_MEDICO(
	num_ident			int				NOT NULL,
	especialidade		varchar(30)		NOT NULL,
	primary key(num_ident,especialidade),
	foreign key (num_ident) references problema_4_4.MEDICO(num_ident)
);

Create Table problema_4_4.PACIENTE(
	data_nascimento		date,
	nome				varchar(30)		NOT NULL,
	endereco			varchar(30),
	num_utente			char(9)			NOT NULL,
	primary key(num_utente)
);

Create Table problema_4_4.FARMACIA(
	nif					char(9)			NOT NULL,
	telefone			char(9),
	nome				varchar(30),
	endereco			varchar(30)		NOT NULL,
	primary key(nif),
	Unique(endereco)
);

Create Table problema_4_4.PRESCRICAO(
	num_prescricao		int				NOT NULL,
	data_				datetime,
	data_avio			datetime,
	paciente			char(9),
	avio				char(9),
	primary key(num_prescricao),
	foreign key(paciente) references problema_4_4.PACIENTE(num_utente),
	foreign key(avio) references problema_4_4.FARMACIA(nif),
	check(data_avio > data_)
);

Create Table problema_4_4.EFETUA(
	num_ident				int			NOT NULL,
	prescricao				int			NOT NULL,
	primary key(num_ident, prescricao),
	foreign key(num_ident) references problema_4_4.MEDICO(num_ident),
	foreign key(prescricao) references problema_4_4.PRESCRICAO(num_prescricao)
);

Create Table problema_4_4.COMP_FARMAC(
	num_registo			char(9)			NOT NULL,
	nome				varchar(30)		NOT NULL,
	endereco			varchar(30)		NOT NULL,
	telefone			char(9)			NOT NULL,
	primary key(num_registo),
);

Create Table problema_4_4.FARMACO(
	nome				varchar(30),
	formula				VarChar(30)		NOT NULL,--do tipo da formula mas n consegui fazer com que ficasse a funcionar
	num_registo			char(9)			NOT NULL,
	primary key(formula, num_registo),
	foreign key(num_registo) references problema_4_4.COMP_FARMAC(num_registo),
	Unique(formula)
);

Create Table problema_4_4.CONTEM(
	num_prescricao			int			NOT NULL,
	farmaco					varchar(30)	NOT NULL,
	primary key(num_prescricao),
	foreign key(num_prescricao) references problema_4_4.PRESCRICAO(num_prescricao),
	foreign key(farmaco) references problema_4_4.FARMACO(formula)
);