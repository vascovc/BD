use company;
go

--a
create proc p_del_func @ssn char(9)
as
begin
	delete from dependent where Essn = @ssn;
	delete from works_on where Essn = @ssn;
	update department set Mgr_ssn = null where Mgr_ssn = @ssn;
	update employee set Super_ssn = null where @ssn = Super_ssn;
	delete from employee where Ssn = @ssn;
end
go
-- e necessario apagar tambem a informacao de onde este e retirado, passar a null ou apagar ate
-- apagar os dependentes, do works_on, caso fosse gestor 


--b
create proc p_dep_gestores (@ssn char(9) output, @Fname varchar(15) output, @Lname varchar(15) output, @diff int output)
as
begin
	select Ssn, Fname, Lname
	from employee join department on Ssn=Mgr_ssn;

	select top 1 Ssn, DATEDIFF(YEAR, Mgr_start_date, GETDATE()) as anos_gestao
	from employee join department on Ssn=Mgr_ssn
end
go

declare @ssn char(9);
declare @Fname varchar(15);
declare @Lname varchar(15);
declare @diff int;
exec dbo.p_dep_gestores @ssn output, @Fname output, @Lname output, @diff output; 


go

--c
create trigger t_gest_dep on department
after insert, update
as
begin
	declare @ssn as char(9);
	select @ssn = Mgr_ssn from inserted

	if exists(select Mgr_ssn from department where @ssn = Mgr_ssn)
	begin
		raiserror('Ja e gestor de um departamento e nao pode ser de mais nenhum', 16, 1);
		rollback tran;
	end
end

update department
set Mgr_ssn = '21312332'
where Mgr_ssn = '12652121'

/*
 -- esta ideia era melhor mas existe um erro por Cannot create INSTEAD OF DELETE or INSTEAD OF UPDATE TRIGGER 't_gest_dep' on table 'department'. This is  because the table has a FOREIGN KEY with cascading DELETE or UPDATE.
create trigger t_gest_dep on department
instead of insert, update
as
begin
	declare @ssn as char(9);
	select @ssn=Mgr_ssn from inserted;
	if exists(select Mgr_ssn from department where @ssn = Mgr_ssn)
	begin
		raiserror('Ja e gestor de um departamento', 16, 1);
		rollback tran;
	end
	else
	begin
		declare @upd as int;
		select @upd = count(*) from deleted;
		
		if(@upd = 0) -- quer dizer que nao foi update mas sim um insert
		begin
			insert into department
			select *
			from inserted;
		end
		
		else -- se foi um update, atualizar tudo
		begin
			update department
			set Dname = inserted.Dname, Mgr_ssn = @ssn, Mgr_start_date = inserted.Mgr_start_date
			from inserted
			where department.Dnumber = inserted.Dnumber
		end
	end
end
go
*/


--d
go
create trigger t_func_salar on employee
instead of insert, update
as
begin
	declare @salary as decimal(10,2);
	declare @emp_salary as decimal(10,2);
	declare @emp_dno as int;

	select @emp_dno = Dno from inserted
	select @emp_salary = Salary from inserted --salario do empregado

	select @salary = Salary --salario do gestor do departamento
	from employee join department on Ssn = Mgr_ssn
	where Dnumber = @emp_dno

	if(@emp_salary > @salary) -- se o salario for maior passa a ser igual a menos uma unidade
		set @emp_salary = @salary-1;

	declare @upd as int;
	select @upd = count(*) from deleted;
	if(@upd = 0) -- quer dizer que nao foi update mas sim um insert
	begin
		insert into employee
		select Fname, Minit, Lname, Ssn, Bdate, Address, Sex, @emp_salary,Super_ssn,Dno
		from inserted;
	end
	else
	begin
		update employee
		set Fname = inserted.Fname, Minit = inserted.Minit, Lname = inserted.Lname, Bdate = inserted.Bdate, Address=inserted.Address, Sex=inserted.Sex, Salary = @emp_salary, Super_ssn = inserted.Super_ssn, Dno = @emp_dno
		from inserted
		where employee.Ssn = inserted.Ssn
	end
end

update employee
set Salary = 14000.00
where Ssn='12652121'

--e
go
create function func_emp_nome_loc (@ssn char(9)) returns table
as
	return( select Pname, Plocation
			from Employee join works_on on Ssn = Essn join project on Pno=Pnumber
			where Ssn=@ssn);

go
select * from func_emp_nome_loc('21312332');
--f
go
create function func_abv_avg(@dno int) returns table
as
	return( select Fname, Minit, Lname, Ssn, Salary
			from employee
			where @dno = Dno and Salary >( select avg(salary)
											from employee
											where Dno=@dno));
go
select * from employee;
select * from func_abv_avg(3);
--g
go
create function func_budget(@dno int) returns @table Table(pname varchar(15), number int, plocation varchar(15),
															dnum int, budget decimal(10,2), total_budget decimal(10,2))
as
begin
	declare @pname as varchar(15), @number as int, @plocation as varchar(15), @dnum as int, @budget as decimal(10,2), @total_budget as decimal(10,2);
	declare c cursor fast_forward 
	for select Pname, Pnumber, Plocation, Dnumber, Sum(Salary*Hours/40)
		from department join project on Dnumber=Dnum 
						join works_on on Pnumber=Pno 
						join employee on Essn=Ssn
		where Dnumber = @dno
		group by Pname, Pnumber, Plocation, Dnumber;
	open c;
	fetch c into @pname, @number, @plocation, @dnum, @budget;
	select @total_budget=0;

	while @@Fetch_Status = 0
	begin
		set @total_budget += @budget;
		insert into @table values(@pname, @number, @plocation, @dnum, @budget, @total_budget)
		fetch c into @pname, @number, @plocation, @dnum, @budget;
	end
	close c;
	deallocate c;
	return;
end
go

select * from func_budget(3);
--h
-- instead of
go
create trigger t_del_dept_inst on department
instead of delete
as
begin
	if(not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'department_deleted'))
		create table department_deleted(Dname varchar(15) not null, Dnumber int primary key, Mgr_ssn char(9), Mgr_start_date date);
	
	delete from project where Dnum in (select Dnumber from deleted);
	update employee set Dno=null where Dno in (select Dnumber from deleted);
	insert into department_deleted select * from deleted;
	delete from department where Dnumber in (select Dnumber from deleted);
end
go

select * from department;
delete from department where Dnumber=5

use master
use company
-- after
go
create trigger t_del_dept_after on department
after delete
as
begin
	if(not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'department_deleted'))
		create table department_deleted(Dname varchar(15) not null, Dnumber int primary key, Mgr_ssn char(9), Mgr_start_date date);
	insert into department_deleted select * from deleted;
end
go
select * from department;
delete from department where Dnumber=5;
/*
	A utilizacao de um trigger instead of em relacao ao uso de usar um after e a
	maior facilidade com que se consegue lidar com as dependencia em que se trata com maior seguranca
	o mecanismo de remocao, a titulo de exemplo, caso em employee nao se tenha o update on cascade este ira ficar com
	o numero do departamento apagado. No entanto, caso se tenha colocado nao iria haver diferenças, neste caso,
	para os outros dependentes tambem seria necessario ter isso em consideracao. ainda assim e um metodo mais seguro
	e uma boa pratica, apesar de levar a overlapping, algo que nao e necessariamente mau.

	e possivel ainda utilizar varios trigger after por tabela e permite efetuar validacao de dados 
	
	o uso de instead of obriga a uma redefinicao por completo dos metodos pelos quais se pretendem redefinir
*/

--i

/*
	Stored Procedure - uma batch armazenada com um nome, compilado uma vez e na primeira vez
						armazenado na cache sendo mais rapido de executar. Permite parametros
						de entrada, valor de retorno indicativo do sucesso ou devolver registos
						Maneira com um maior desempenho e facilidade de uso assim como uma maneira
						mais segura de interagir com a base de dados atraves do uso exclusivo destes
	UDF - codigo compilado e otimizado previament, permitindo logica complexa e ser uma fonte de dados
			assim como criar novas funcoes contendo expressoes complexas
			retorna escalar ou tabela ou tuplo de uma tabela
			nao sao permitidos o uso de funcoes nao deterministicas como o uso de numeros aleatorios
			nao permite atualizar dados
	o uso de SELECT/WHERE/HAVING e exclusivo a SP
	SP permite chamar outros SP, tratar excecoes e efetuar transacoes, UDF nao

*/
