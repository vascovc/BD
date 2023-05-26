SET NOCOUNT ON
GO

set nocount    on
set dateformat mdy

USE master

declare @dttm varchar(55)
select  @dttm=convert(varchar,getdate(),113)
raiserror('Beginning InstPubs.SQL at %s ....',1,1,@dttm) with nowait

GO

if exists (select * from sysdatabases where name='prescricao')
begin
  raiserror('Dropping existing prescricao database ....',0,1)
  DROP database prescricao
end
GO

CHECKPOINT
go

raiserror('Creating prescricao database....',0,1)
go
/*
   Use default size with autogrow
*/

CREATE DATABASE prescricao
GO

CHECKPOINT

GO

USE prescricao

GO

if db_name() <> 'prescricao'
   raiserror('Error in InstPubs.SQL, ''USE prescricao'' failed!  Killing the SPID now.'
            ,22,127) with log

GO

if CAST(SERVERPROPERTY('ProductMajorVersion') AS INT)<12 
BEGIN
  exec sp_dboption 'prescricao','trunc. log on chkpt.','true'
  exec sp_dboption 'prescricao','select into/bulkcopy','true'
END
ELSE ALTER DATABASE [prescricao] SET RECOVERY SIMPLE WITH NO_WAIT
GO

execute sp_addtype id      ,'varchar(11)' ,'NOT NULL'
execute sp_addtype tid     ,'varchar(6)'  ,'NOT NULL'
execute sp_addtype empid   ,'char(9)'     ,'NOT NULL'

raiserror('Now at the create table section ....',0,1)

GO
--------------------------------------------------
Create Table medico(
	numSNS			int				NOT NULL,
	nome			varchar(30),
	especialidade	varchar(30),
	primary key(numSNS)
);

Create Table paciente(
	numUtente			int			NOT NULL,
	nome				varchar(30)		NOT NULL,
	dataNasc			date,
	endereco			varchar(30),
	primary key(numUtente)
);

Create Table farmacia(
	nome				varchar(30)		NOT NULL,
	telefone			char(9),
	endereco			varchar(30)		NOT NULL,
	primary key(nome),
);

Create Table farmaceutica(
	numReg				char(9)			NOT NULL,
	nome				varchar(30)		NOT NULL,
	endereco			varchar(50)		NOT NULL,
	primary key(numReg),
);

Create Table farmaco(
	numRegFarm			char(9),
	nome				varchar(30)		unique NOT NULL,
	formula				varchar(15)		NOT NULL,
	primary key(numRegFarm, nome),
	foreign key(numRegFarm) references farmaceutica(numReg),
);

Create Table prescricao(
	numPresc			int				NOT NULL,
	numUtente			int				NOT NULL,
	numMedico			int				NOT NULL,
	farmacia			varchar(30),
	dataProc			date,
	primary key(numPresc),
	foreign key(numUtente) references paciente(numUtente),
	foreign key(numMedico) references medico(numSNS),
	foreign key(farmacia) references farmacia(nome)
);

Create Table presc_farmaco(
	numPresc				int				NOT NULL,
	numRegFarm				char(9)			NOT NULL,
	nomeFarmaco				varchar(30)		NOT NULL,
	primary key(numPresc, nomeFarmaco),
	foreign key(numPresc) references prescricao(numPresc),
	foreign key(numRegFarm) references farmaceutica(numReg),
	foreign key(nomeFarmaco) references farmaco(nome)
);
--------------------------------------------------
insert into medico values
(101,'Joao Pires Lima', 'Cardiologia'),
(102,'Manuel Jose Rosa', 'Cardiologia'),
(103,'Rui Luis Caraca', 'Pneumologia'),
(104,'Sofia Sousa Silva', 'Radiologia'),
(105,'Ana Barbosa', 'Neurologia');

insert into paciente values
(1,'Renato Manuel Cavaco','1980-01-03','Rua Nova do Pilar 35'),
(2,'Paula Vasco Silva','1972-10-30','Rua Direita 43'),
(3,'Ines Couto Souto','1985-05-12','Rua de Cima 144'),
(4,'Rui Moreira Porto','1970-12-12','Rua Zig Zag 235'),
(5,'Manuel Zeferico Polaco','1990-06-05','Rua da Baira Rio 1135');

insert into farmacia values
('Farmacia BelaVista','221234567','Avenida Principal 973'),
('Farmacia Central','234370500','Avenida da Liberdade 33'),
('Farmacia Peixoto','234375111','Largo da Vila 523'),
('Farmacia Vitalis','229876543','Rua Visconde Salgado 263');

insert into farmaceutica values
('905','Roche','Estrada Nacional 249'),
('906','Bayer','Rua da Quinta do Pinheiro 5'),
('907','Pfizer','Empreendimento Lagoas Park - Edificio 7'),
('908','Merck', 'Alameda Fernão Lopes 12');

insert into farmaco values
('905','Boa Saude em 3 Dias','XZT9'),
('906','Voltaren Spray','PLTZ32'),
('906','Xelopironi 350','FRR-34'),
('906','Gucolan 1000','VFR-750'),
('907','GEROaero Rapid','DDFS-XEN9'),
('908','Aspirina 1000','BIOZZ02');

insert into prescricao values
(10001,1,105,'Farmacia Central','2015-03-03'),
(10002,1,105,NULL,NULL),
(10003,3,102,'Farmacia Central','2015-01-17'),
(10004,3,101,'Farmacia BelaVista','2015-02-09'),
(10005,3,102,'Farmacia Central','2015-01-17'),
(10006,4,102,'Farmacia Vitalis','2015-02-22'),
(10007,5,103,NULL,NULL),
(10008,1,103,'Farmacia Central','2015-01-02'),
(10009,3,102,'Farmacia Peixoto','2015-02-02');

insert into presc_farmaco values
(10001,'905','Boa Saude em 3 Dias'),
(10002,'907','GEROaero Rapid'),
(10003,'906','Voltaren Spray'),
(10003,'906','Xelopironi 350'),
(10003,'908','Aspirina 1000'),
(10004,'905','Boa Saude em 3 Dias'),
(10004,'908','Aspirina 1000'),
(10005,'906','Voltaren Spray'),
(10006,'905','Boa Saude em 3 Dias'),
(10006,'906','Voltaren Spray'),
(10006,'906','Xelopironi 350'),
(10006,'908','Aspirina 1000'),
(10007,'906','Voltaren Spray'),
(10008,'905','Boa Saude em 3 Dias'),
(10008,'908','Aspirina 1000'),
(10009,'905','Boa Saude em 3 Dias'),
(10009,'906','Voltaren Spray'),
(10009,'908','Aspirina 1000');
----------------------------------------------------
use prescricao;

--a)π paciente.numUtente,nome (σ numPresc=null ( (prescricao) ⟖ prescricao.numUtente=paciente.numUtente (paciente) ))
select paciente.numUtente,nome
from prescricao right outer join paciente on prescricao.numUtente=paciente.numUtente
where numPresc is null

--b)γ especialidade; count(especialidade) -> num_prescricoes ((medico) ⨝ numSNS=numMedico (prescricao))
select especialidade, count(especialidade) as num_prescricoes
from medico join prescricao on numSNS=numMedico
group by especialidade

--c)σ farmacia ≠ null (γ farmacia; count(farmacia) -> num_presc (prescricao))
select farmacia, count(farmacia) as num_presc
from prescricao
where farmacia is not null
group by farmacia

--d)π nome (σ numPresc=null (σ numRegFarm=906 (farmaco) ⟕ nome=nomeFarmaco (presc_farmaco)))
select nome
from farmaco left outer join presc_farmaco on nome=nomeFarmaco
where farmaco.numRegFarm='906' and numPresc is null

--e)σ prescricao.farmacia ≠ null (γ prescricao.farmacia, farmaceutica.nome; count(farmaceutica.nome) -> num_farm ((prescricao) ⨝ prescricao.numPresc=presc_farmaco.numPresc (presc_farmaco) ⨝ numRegFarm = numReg (farmaceutica)))
select prescricao.farmacia, farmaceutica.nome, count(farmaceutica.nome) as num_farm
from prescricao join presc_farmaco on prescricao.numPresc=presc_farmaco.numPresc join farmaceutica on numRegFarm = numReg
where prescricao.farmacia is not null
group by prescricao.farmacia, farmaceutica.nome
order by prescricao.farmacia

--f)π numUtente,nome ((paciente)⨝(σ num_med > 1 γ numUtente;count(numUtente) -> num_med  π numUtente,numMedico prescricao))
select pa.numUtente, nome
from paciente as pa join prescricao as pr on pa.numUtente=pr.numUtente
group by pa.numUtente, nome
having count(numMedico)>1
------------------------------------------------------
CHECKPOINT

GO

USE master

GO