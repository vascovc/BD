use Rent_buy_car;
go

insert into pessoa values
--(nif, nome, morada, data_De_nascimento,phone)
('847585764','Judah Dixon','Rua da Capela,23;Aveiro;Portugal','1998-12-01','919753483'),
('846445645','Zoe Hinton','Rua do Loureiro,2;Porto;Portugal','1931-08-30','936687887'),
('998475867','Garth Beard','Rua Garrett,456;Lisboa;Portugal','2000-06-14','960904571'),
('106349672','Harrison Maddox','Rua Dom Diogo De Sousa,9;Braga;Portugal','1965-12-31','960543278'),
('184098874','Lev Fletcher','Rua do Souto,102;Braga;Portugal','1980-03-10','919445345'),
('100937459','Gwendolyn Kline','Rua da Constituição,55;Porto;Portugal','1940-08-22','912331260'),
('947494570','Brynne Hardin','Rua dos Bacalhoeiros,234;Lisboa;Portugal','1933-09-16','930040601'),
('709658123','Amanda Vance','Rua Cega,977;Aveiro;Portugal','1985-08-05','930644789'),
('809612568','Chava Wilder','Rua das Flores,10;Porto;Portugal','1963-11-05','968121209'),
('199373983','Adena Carey','Rua de Aveiro,12;Ilhavo;Portugal','1994-11-24','910973498'),
('103857094','Brennan Holloway','Rua da Madalena,94;Lisboa;Portugal','1952-06-29','962738311'),
('300690796','Amery Vargas','Rua dos Fanqueiros,30;Lisboa;Portugal','1984-08-16','918788731'),
('936893073','Kelly Holcomb','Rua da Praia;Ilhavo;Portugal','1995-01-10','910098361'),
('906324580','Beverly Green','Avenida dos Banhos,24;Póvoa de Varzim;Portugal','1934-09-30','962839212'),
('780075478','Olivia Luna','Rua do Comercio,34;Lisboa;Portugal','1969-02-18','960127549');

insert into cliente (nif,email,num_carta) values 
('846445645','Zoe.Hinton@gmail.com','345890874'),
('998475867','Garth.Beard@gmail.com','896321457'),
('100937459','Gwendolyn.Kline@gmail.com','908754679'),
('947494570','Brynne.Hardin@gmail.com','109624681'),
('709658123','Amanda.Vance@gmail.com','100986908'),
('809612568','Chava.Wilder@gmail.com','567467098'),
('103857094','Brennan.Holloway@gmail.com','780124521'),
('300690796','Amery.Vargas@gmail.com','895446894'),
('936893073','Kelly.Holcomb@gmail.com','780098412'),
('906324580','Beverly.Green@gmail.com','111231442');

insert into funcionario (nif,email_empresa,num_carta,balcao) values
('106349672','Harrison.Maddox@r_car.com','145676787',null),
('184098874','Lev.Fletcher@r_car.com','156789098',null),
('199373983','Adena.Carey@r_car.com','445678567',null),
('780075478','Olivia.Luna@r_car.com','909990856',null),
('847585764','Judah.Dixon@r_car.com','120984566',null);

insert into balcao (gerente,localizacao) values --gerente,localizacao
(1,'Rua da Capela,23,Aveiro,Portugal'),
(2,'Rua do Vinho,18,Porto,Portugal'),
(3,'Rua dos Anjos,40,Faro,Portugal');

update funcionario 
set balcao=1
where num_empregado=1

update funcionario 
set balcao=2
where num_empregado=2

update funcionario 
set balcao=3
where num_empregado=3

update funcionario 
set balcao=1
where num_empregado=4

update funcionario 
set balcao=2
where num_empregado=5

 --https://vingenerator.org/
insert into veiculo (vin,marca,modelo,matricula,seguro,km,ano,combustivel,hp,localizacao,transmissao,estado)values
('1HGCP263X8A035447','Honda','Accord','AA-01-AA','ASFGH67',200,2008,1,150,1,1,0),
('1FMCU14T6JU400773','Ford','Bronco II','FX-05-95','ASFGH68',1000,1988,4,200,1,2,1),
('2G1WL54T4R9165225','Chevrolet','Lumina','ZZ-33-67','ASFGH69',50000,1994,2,250,1,2,0),
('1N4AB41DXWC732852','Nissan','Sentra','FF-56-97','ASFGH70',55000,1998,5,160,1,1,0),
('1FDWE35SX5HA40825','Ford','E 350','IJ-65-65','ASFGH71',10000,2005,2,202,2,2,0),
('JH4KA3260LC000123','Acura','Legend','GH-33-70','ASFGH72',5000,1990,1,400,2,1,1);

insert into veiculo_de_aluguer (vin,limit_km_dia,preco_dia) values
('1HGCP263X8A035447',500,20),
('2G1WL54T4R9165225',null,40),
('1N4AB41DXWC732852',null,52),
('1FDWE35SX5HA40825',null,60);

insert into veiculo_de_venda (vin, valor_comerc) values -- e preciso meter todos os veiculos
('1HGCP263X8A035447',15000),
('1FMCU14T6JU400773',17000),
('2G1WL54T4R9165225',16000),
('1N4AB41DXWC732852',5000),
('1FDWE35SX5HA40825',20000),
('JH4KA3260LC000123',40000);

use master
go