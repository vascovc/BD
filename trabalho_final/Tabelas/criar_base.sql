SET NOCOUNT ON
GO

set nocount    on
set dateformat mdy

USE master

declare @dttm varchar(55)
select  @dttm=convert(varchar,getdate(),113)
raiserror('Beginning InstPubs.SQL at %s ....',1,1,@dttm) with nowait

GO

if exists (select * from sysdatabases where name='Rent_buy_car')
begin
  raiserror('Dropping existing Rent_buy_car database ....',0,1)
  DROP database Rent_buy_car
end
GO

CHECKPOINT
go

raiserror('Creating Rent_buy_car database....',0,1)
go
/*
   Use default size with autogrow
*/

CREATE DATABASE Rent_buy_car
GO

CHECKPOINT

GO

USE Rent_buy_car

GO

if db_name() <> 'Rent_buy_car'
   raiserror('Error in InstPubs.SQL, ''USE Rent_buy_car'' failed!  Killing the SPID now.'
            ,22,127) with log

GO

if CAST(SERVERPROPERTY('ProductMajorVersion') AS INT)<12 
BEGIN
  exec sp_dboption 'Rent_buy_car','trunc. log on chkpt.','true'
  exec sp_dboption 'Rent_buy_car','select into/bulkcopy','true'
END
ELSE ALTER DATABASE [Rent_buy_car] SET RECOVERY SIMPLE WITH NO_WAIT
GO

execute sp_addtype id      ,'varchar(11)' ,'not null'
execute sp_addtype tid     ,'varchar(6)'  ,'not null'
execute sp_addtype empid   ,'char(9)'     ,'not null'

raiserror('Now at the create table section ....',0,1)

GO

------------------------------------------------------------------------

create table pessoa(
	nif					char(9) not null,
	nome				varchar(30) not null,
	morada				varchar(50) not null,
	data_nascimento		date	not null,
	phone				char(9),
	primary key (nif)
);

create table cliente(
	nif					char(9) not null,
	email				varchar(30),
	num_cliente			int identity(1, 1),			 
	num_carta			char(9) unique not null,
	primary key (num_cliente),
	foreign key (nif) references pessoa(NIF)
);

create table funcionario(
	nif					char(9) not null,
	email_empresa		varchar(30) unique not null,
	num_empregado		int identity(1,1) unique not null,
	num_carta			char(9) unique,
	balcao				int,							--falta adicionar a condicao de isto ser do balcao
	unique(nif,num_empregado),
	primary key (num_empregado),
	foreign key (nif) references pessoa(NIF)
);

/*create table localizacao(
	numero			int not null,
	endereco		varchar(50) not null,
	primary key(numero)
);
*/

create table balcao(
	numero			int identity(1,1),
	gerente			int,
	localizacao		varchar(50) unique not null,
	primary key(numero),
	foreign key(gerente) references funcionario(num_empregado) on delete set null
);

alter table funcionario
add constraint func_balcao foreign key (balcao) references balcao(numero)

create table veiculo(
	vin				char(17) unique		not null, --sao 17 que eu fui ver
	marca			varchar(20) ,
	modelo			varchar(20) ,
	matricula		char(8)				not null,
	seguro			varchar(17)         not null,			--numero da apolice
	km				int					default 0,
	ano				smallint,
	combustivel		tinyint				not null,   -- 1 gasolina, 2 gasoleo, 3 eletrico, 4 GPL, 5 hybrid 
	hp				smallint,
	localizacao		int					not null,
	transmissao     tinyint				default 1,      -- 1 manual, 2 automatico
	estado			tinyint				default 0,		--e o mais facil para usar,0 - venda/alguer, 1 - so venda, 2 - a ser usado, 3 - vendido
	primary key(vin),
	foreign key(localizacao) references balcao(numero)
);

create table veiculo_de_aluguer(
	vin				char(17) unique			not null,
	limit_km_dia	int						default 1000,
	preco_dia		smallmoney				not null,
	primary key(vin),
	foreign key(vin) references veiculo(vin)
);

create table veiculo_de_venda(
	vin				char(17) unique not null,
	valor_comerc	money,
	primary key(vin),
	foreign key(vin) references veiculo(vin)
);

create table aluguer(
	num_aluguer		int identity(1, 1),
	data_registo	datetimeoffset		not null,
	data_fim		date,
	cliente			int					not null,
	alug_balc		int					not null,
	funcionario		int					not null,
	veiculo			char(17)			not null,
	primary key(num_aluguer),
	foreign key(cliente) references cliente(num_cliente),
	foreign key(alug_balc) references balcao(numero),
	foreign key(funcionario) references funcionario(num_empregado),
	foreign key(veiculo) references veiculo(vin)
);

create table log(
	danos		varchar(300)				,
	data		datetimeoffset				not null,
	taxa		money,
	aluguer		int							not null,
	km_feitos	int							not null,
	drop_off	int							not null,
	funcionario	int							not null,
	
	primary key(aluguer),
	foreign key(aluguer) references aluguer(num_aluguer),
	foreign key(drop_off) references balcao(numero),
	foreign key(funcionario) references funcionario(num_empregado),
);

create table compra(
	num_compra	int identity(1, 1),
	data		datetimeoffset	not null,
	client_vend	int				not null,
	balcao		int				not null,
	funcionario	int				not null,
	primary key(num_compra),
	foreign key(client_vend) references cliente(num_cliente),
	foreign key(balcao) references balcao(numero),
	foreign key(funcionario) references funcionario(num_empregado),
);

create table venda(
	num_venda			int identity(1, 1),
	metodo_pagamento	tinyint,
	data_registo		datetimeoffset	not null,
	cliente				int				not null,
	balcao				int				not null,
	funcionario			int				not null,
	primary key(num_venda),
	foreign key(cliente) references cliente(num_cliente),
	foreign key(balcao) references balcao(numero),
	foreign key(funcionario) references funcionario(num_empregado),
);

create table vend_veic(
	num_venda		int			not null,
	veiculo			char(17)	not null,
	valor_venda		money		not null,
	primary key(num_venda,veiculo),
	foreign key(num_venda) references venda(num_venda),
	foreign key(veiculo) references veiculo(vin)
);

create table comp_veic(
	num_compra		int			not null,
	vin				char(17)	not null,
	valor_pago		money		not null,
	primary key(num_compra,vin),
	foreign key(num_compra) references compra(num_compra),
	foreign key(vin) references veiculo(vin)
);
-----------------------------------------------------------------------------------------------

CHECKPOINT
GO
USE master
GO


