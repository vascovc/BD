SET NOCOUNT ON
GO

set nocount    on
set dateformat mdy

USE master

declare @dttm varchar(55)
select  @dttm=convert(varchar,getdate(),113)
raiserror('Beginning InstPubs.SQL at %s ....',1,1,@dttm) with nowait

GO

if exists (select * from sysdatabases where name='company')
begin
  raiserror('Dropping existing company database ....',0,1)
  DROP database company
end
GO

CHECKPOINT
go

raiserror('Creating company database....',0,1)
go
/*
   Use default size with autogrow
*/

CREATE DATABASE company
GO

CHECKPOINT

GO

USE company

GO

if db_name() <> 'company'
   raiserror('Error in InstPubs.SQL, ''USE company'' failed!  Killing the SPID now.'
            ,22,127) with log

GO

if CAST(SERVERPROPERTY('ProductMajorVersion') AS INT)<12 
BEGIN
  exec sp_dboption 'company','trunc. log on chkpt.','true'
  exec sp_dboption 'company','select into/bulkcopy','true'
END
ELSE ALTER DATABASE [company] SET RECOVERY SIMPLE WITH NO_WAIT
GO

execute sp_addtype id      ,'varchar(11)' ,'not null'
execute sp_addtype tid     ,'varchar(6)'  ,'not null'
execute sp_addtype empid   ,'char(9)'     ,'not null'

raiserror('Now at the create table section ....',0,1)

GO

------------------------------------------------------------------------

CREATE TABLE employee(
	Fname				varchar(15) not null,
	Minit				char,
	Lname				varchar(15) not null,
	Ssn					char(9)		not null,
	Bdate				date,
	Address				varchar(30),
	Sex					char,
	Salary				DECIMAL(10,2),
	Super_ssn			char(9),
	Dno					int,
	primary key (Ssn)   ,
	foreign key (Super_ssn) references EMPLOYEE(Ssn)
);


CREATE TABLE department(
	Dname			varchar(15) not null,
	Dnumber			int			not null,
	Mgr_ssn			char(9)     ,
	Mgr_start_date	date        ,
	primary key(Dnumber)        ,
	foreign key (Mgr_ssn) references employee(Ssn) on delete set null on update cascade
);

alter table employee
add constraint emp_depart foreign key (Dno) references department(Dnumber);

CREATE TABLE dependent(
	Essn			char(9)		not null,
	Dependent_name	varchar(15) not null,
	Sex				char        ,
	Bdate			date        ,
	Relationship	varchar(8)  ,
	primary key (Essn, Dependent_name),
	foreign key (Essn) references employee(Ssn) on update cascade
);

CREATE TABLE dept_location(
	Dnumber		int			not null,
	Dlocation	varchar(15)	not null,
	primary key (Dnumber, Dlocation),
	foreign key (Dnumber) references department(Dnumber) on update cascade
);

CREATE TABLE project(
	Pname		varchar(15) not null,
	Pnumber		int			not null,
	Plocation	varchar(15) ,
	Dnum		int			not null,
	primary key (Pnumber)   ,
	foreign key (Dnum) references department(Dnumber) on update cascade
);

CREATE TABLE works_on(
	Essn	char(9)			not null,
	Pno		int				not null,
	Hours	DECIMAL(3,1)	,
	primary key (Essn, Pno) ,
	foreign key (Essn) references employee(Ssn),
	foreign key (Pno) references project(Pnumber)
);

insert into employee values --preciso meter a null os departamentos ainda por nao se terem criado os departamentos
('Paula','A','Sousa','183623612','2001-08-11','Rua da FRENTE','F',1450.00,NULL,NULL),
('Carlos','D','Gomes','21312332' ,'2000-01-01','Rua XPTO','M',1200.00,NULL,NULL),
('Juliana','A','Amaral','321233765','1980-08-11','Rua BZZZZ','F',1350.00,NULL,NULL),
('Maria','I','Pereira','342343434','2001-05-01','Rua JANOTA','F',1250.00,21312332,NULL),
('Joao','G','Costa','41124234' ,'2001-01-01','Rua YGZ','M',1300.00,21312332,NULL),
('Ana','L','Silva','12652121' ,'1990-03-03','Rua ZIG ZAG','F',1400.00,21312332,NULL);

insert into department values
('Investigacao',1,'21312332' ,'2010-08-02'),
('Comercial',2,'321233765','2013-05-16'),
('Logistica',3,'41124234' ,'2013-05-16'),
('RecursosHumanos',4,'12652121','2014-04-02'),
('Desporto',5,NULL,NULL);

insert into dependent values
('21312332 ','Joana Costa','F','2008-04-01', 'Filho'),
('21312332 ','Maria Costa','F','1990-10-05', 'Neto'),
('21312332 ','Rui Costa','M','2000-08-04','Neto'),
('321233765','Filho Lindo','M','2001-02-22','Filho'),
('342343434','Rosa Lima','F','2006-03-11','Filho'),
('41124234 ','Ana Sousa','F','2007-04-13','Neto'),
('41124234 ','Gaspar Pinto','M','2006-02-08','Sobrinho');

insert into dept_location values
(2,'Aveiro'),
(3,'Coimbra');

insert into project values
('Aveiro Digital', 1, 'Aveiro', 3),
('BD Open Day', 2, 'Espinho', 2),
('Dicoogle', 3, 'Aveiro', 4),
('GOPACS', 4, 'Aveiro', 3);

insert into works_on values
('183623612',1,20.0),
('183623612',3,10.0),
('21312332 ',1,20.0),
('321233765',1,25.0),
('342343434',1,20.0),
('342343434',4,25.0),
('41124234 ',2,20.0),
('41124234 ',3,30.0);

update employee
set Dno=3
where Ssn='183623612';

update employee
set Dno=1
where Ssn='21312332 ';

update employee
set Dno=3
where Ssn='321233765';

update employee
set Dno=2
where Ssn='342343434';

update employee
set Dno=2
where Ssn='41124234 ';

update employee
set Dno=2
where Ssn='12652121 ';

-----------------------------------------------------------------------------------------------
use company;

--a) π Ssn, Pname, Fname, Minit, Lname ((project) ⨝ Pnumber=Pno (works_on) ⨝ Essn=Ssn (employee))
select Ssn, Pname, Fname, Minit, Lname
from project join works_on on Pnumber=Pno join employee on Essn = Ssn;

--b)π Fname, Minit, Lname (π Fname, Minit, Lname, Super_ssn (employee) ⨝ employee.Super_ssn=sup_ssn.Ssn (ρ sup_ssn (π Ssn (σ Fname='Carlos' ∧ Minit='D' ∧ Lname='Gomes' (employee) ))))
select e.Fname, e.Minit, e.Lname
from employee as e
where e.Super_ssn = (select Ssn
					 from employee as sup
					 where sup.Fname='Carlos' and sup.Minit='D' and sup.Lname='Gomes')

--c)π Pname,sum_hours (γ Pname, Pnumber; sum(Hours) -> sum_hours (project ⨝ Pnumber = Pno works_on))
select Pname, sum(Hours) as sum_hours
from project join works_on on Pnumber=Pno
group by Pname, Pnumber

--d)π Fname,Minit,Lname,Ssn ((employee) ⨝ Ssn=Essn (σ (Hours > 20) ((project) ⨝ (Pname='Aveiro Digital' ∧ Pnumber=Pno) (works_on))))
select Fname, Minit, Lname, Ssn
from works_on join project on Pnumber=Pno join employee on Ssn=Essn
where Hours>20 and Pname='Aveiro Digital'

--e)π Fname, Minit, Lname (σ Pno=null ( (employee) ⟕ Ssn=Essn (works_on)))
select Fname, Minit, Lname
from employee left outer join works_on on Ssn=Essn
where Pno is null 

--f)γ Dname; avg(Salary) -> avg_salary ((department) ⨝ Dno=Dnumber ((σ Sex='F' employee)))
select Dname,avg(Salary) as avg_salary
from department join employee on Dno=Dnumber
where Sex ='F' 
group by Dname

--g)σ num_dependents > 2 (γ Ssn,Fname, Minit, Lname; count(Essn) -> num_dependents ((employee) ⨝ Ssn=Essn (dependent)))
select Ssn, Fname, Minit, Lname, count(Essn) as num_dependents
from employee join dependent on Ssn=Essn
group by Ssn, Fname, Minit, Lname
having count(Essn) > 2

--h)π Ssn, Fname, Minit, Lname (σ Essn=null (dependent ⟖ Essn=Ssn ((employee) ⨝ Ssn=Mgr_ssn (department))))
select Ssn, Fname, Minit, Lname
from dependent right outer join (employee join department on Ssn=Mgr_ssn) on Essn=Ssn
where Essn is null

--i)temp = (dept_location) ⨝ (dept_location.Dnumber = department.Dnumber ∧ dept_location.Dlocation ≠ 'Aveiro') (department) -- os departamentos que interessam
--  temp_1 = ((project) ⨝ (Pnumber=Pno ∧ Plocation='Aveiro') (works_on) ⨝ Essn=Ssn (employee)) -- os projetos que interessam assim como quem trabalha neles
--  π Fname, Minit, Lname, Address ((temp) ⨝ Dno=department.Dnumber (temp_1))
select distinct e.Fname, e.Minit, e.Lname, e.Address
from project as p join works_on as w on p.Pnumber=w.Pno join employee as e on w.Essn=e.Ssn
	 join department as d on p.Dnum=d.Dnumber join dept_location as dep on d.Dnumber=dep.Dnumber
where Dlocation != 'Aveiro' and p.Plocation = 'Aveiro'
-----------------------------------------------------------------------------------------------

CHECKPOINT

GO

USE master

GO