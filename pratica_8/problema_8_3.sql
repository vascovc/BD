use company;
go

-- i
-- uma vez que e chave primaria nao necessita de criar mais nenhum pois ja e criado

--ii
create index idx_f_l_name on employee(Fname,Lname)

--iii
create index idx_emp_dep on employee(Dno) 

--iv
-- com a tabela works on, ja se tem os funcionarios e projetos respetivos, sendo ambas as chaves primarias
-- pelo que ja sao indexadas
