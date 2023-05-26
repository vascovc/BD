SET NOCOUNT ON
GO

set nocount    on
set dateformat mdy

USE master

declare @dttm varchar(55)
select  @dttm=convert(varchar,getdate(),113)
raiserror('Beginning InstPubs.SQL at %s ....',1,1,@dttm) with nowait

GO

if exists (select * from sysdatabases where name='geststock')
begin
  raiserror('Dropping existing geststock database ....',0,1)
  DROP database geststock
end
GO

CHECKPOINT
go

raiserror('Creating geststock database....',0,1)
go
/*
   Use default size with autogrow
*/

CREATE DATABASE geststock
GO

CHECKPOINT

GO

USE geststock

GO

if db_name() <> 'geststock'
   raiserror('Error in InstPubs.SQL, ''USE geststock'' failed!  Killing the SPID now.'
            ,22,127) with log

GO

if CAST(SERVERPROPERTY('ProductMajorVersion') AS INT)<12 
BEGIN
  exec sp_dboption 'geststock','trunc. log on chkpt.','true'
  exec sp_dboption 'geststock','select into/bulkcopy','true'
END
ELSE ALTER DATABASE [geststock] SET RECOVERY SIMPLE WITH NO_WAIT
GO

execute sp_addtype id      ,'varchar(11)' ,'NOT NULL'
execute sp_addtype tid     ,'varchar(6)'  ,'NOT NULL'
execute sp_addtype empid   ,'char(9)'     ,'NOT NULL'

raiserror('Now at the create table section ....',0,1)

GO
--------------------------------------------------
Create Table produto(
	codigo				int				NOT NULL,
	nome				varchar(30)		NOT NULL,
	preco				money,
	iva					decimal(5,2)	default 23,
	numero_unidades		int,
	primary key(codigo),
);

Create Table fornecedor(
	nif					char(9)			NOT NULL,
	nome				varchar(30)		NOT NULL,
	fax				    VarChar(15),
	endereco			VarChar(30),
	condpag				tinyint, 
	tipo				int,
	primary key(nif),
);

Create Table encomenda(
	numero			int				NOT NULL,
	data			datetime,
	fornecedor		char(9),
	primary key(numero),
	foreign key(fornecedor) references fornecedor(nif)
);

Create Table item(
	numEnc		int				NOT NULL,
	codProd		int				NOT NULL,
	unidades	int				default 1,
	primary key(numEnc, codProd),
	foreign key(numEnc) references encomenda(numero),
	foreign key(codProd) references produto(codigo) on update cascade
);

Create Table tipo_fornecedor(
	codigo				int				NOT NULL,
	designacao			varchar(30),
	primary key(codigo),
);
alter table fornecedor
add constraint forn_tipo foreign key (tipo) references tipo_fornecedor(codigo);
-------------------------------------------------------------------------------
insert into tipo_fornecedor values
(101,'Carnes'),
(102,'Laticinios'),
(103,'Frutas e Legumes'),
(104,'Mercearia'),
(105,'Bebidas'),
(106,'Peixe'),
(107,'Detergentes');

insert into fornecedor values
('509111222','LactoSerrano','234872372',NULL,60,102),
('509121212','FrescoNorte','221234567','Rua do Complexo Grande - Edf 3',90,102),
('509294734','PinkDrinks','2123231732','Rua Poente 723',30,105),
('509827353','LactoSerrano','234872372',NULL,60,102),
('509836433','LeviClean','229343284','Rua Sol Poente 6243',30,107),
('509987654','MaduTex','234873434','Estrada da Cincunvalacao 213',30,104),
('590972623','ConservasMac', '34112233','Rua da Recta 233',30,104);

insert into produto values
(10001,'Bife da Pa', 8.75,23,125),
(10002,'Laranja Algarve',1.25,23,1000),
(10003,'Pera Rocha',1.45,23.00,2000),
(10004,'Secretos de Porco Preto',10.15,23,342),
(10005,'Vinho Rose Plus',2.99,13,5232),
(10006,'Queijo de Cabra da Serra',15.00,23,3243),
(10007,'Queijo Fresco do Dia',0.65,23,452),
(10008,'Cerveja Preta Artesanal',1.65,13,937),
(10009,'Lixivia de Cor', 1.85,23,9382),
(10010,'Amaciador Neutro', 4.05,23,932432),
(10011,'Agua Natural',0.55,6,919323),
(10012,'Pao de Leite',0.15,6,5434),
(10013,'Arroz Agulha',1.00,13,7665),
(10014,'Iogurte Natural',0.40,13,998);

insert into encomenda values
(1,'2015-03-03','509111222'),
(2,'2015-03-04','509121212'),
(3,'2015-03-05','509987654'),
(4,'2015-03-06','509827353'),
(5,'2015-03-07','509294734'),
(6,'2015-03-08','509836433'),
(7,'2015-03-09','509121212'),
(8,'2015-03-10','509987654'),
(9,'2015-03-11','509836433'),
(10,'2015-03-12','509987654');

insert into item values
(1,10001,200),
(1,10004,300),
(2,10002,1200),
(2,10003,3200),
(3,10013,900),
(4,10006,50),
(4,10007,40),
(4,10014,200),
(5,10005,500),
(5,10008,10),
(5,10011,1000),
(6,10009,200),
(6,10010,200),
(7,10003,1200),
(8,10013,350),
(9,10009,100),
(9,10010,300),
(10,10012,200);
--------------------------------------------------
use geststock;

--a)π nome, nif (σ fornecedor=null ((fornecedor) ⟕ nif=fornecedor (encomenda)))
select nome, nif
from fornecedor left outer join encomenda on nif=fornecedor
where encomenda.fornecedor is null

--b)γ codProd;avg(unidades) -> avg_prod item
select codProd, avg(unidades) as avg_unidades
from item
group by codProd

--c)n_p = (γ numEnc; count(codProd) -> n_prod (item) )
--    γ avg(n_prod) -> avg_enc (n_p)
select avg(I.n_prod) as avg_enc
from ( select numEnc, count(codProd) as n_prod
	   from item
	   group by numEnc) as I
--nao esta a fazer bem o avg ca fora, porque o interior esta a fazer certo, bate certo com o do online

--d)γ codProd, fornecedor; sum(unidades) -> uni (item ⨝ numEnc=numero encomenda)
select codProd, fornecedor, sum(unidades) as sum_unidades
from item join encomenda on numEnc = numero
group by codProd, fornecedor
order by codProd;
-----------------------------------------------------
CHECKPOINT

GO

USE master

GO