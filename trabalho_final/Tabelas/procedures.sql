use Rent_buy_car
go

create proc p_marcas @modelo varchar(20), @ano smallint, @combs tinyint, @transmissao tinyint
as
begin
	if @modelo = ''
		set @modelo = null
	if @ano = ''
		set @ano = null
	if @combs = ''
		set @combs = null
	if @transmissao = ''
		set @transmissao = null

	select distinct marca
	from veiculo join veiculo_de_aluguer on veiculo_de_aluguer.vin=veiculo.vin
	where estado = 0 	and (@modelo is null or modelo = @modelo)
						and (@ano is null or ano = @ano)
						and (@combs is null or combustivel = @combs)
						and (@transmissao is null or transmissao = @transmissao)
end
go

create proc p_marcas_Venda @modelo varchar(20), @ano smallint, @combs tinyint, @transmissao tinyint
as
begin
	if @modelo = ''
		set @modelo = null
	if @ano = ''
		set @ano = null
	if @combs = ''
		set @combs = null
	if @transmissao = ''
		set @transmissao = null

	select distinct marca
	from veiculo join veiculo_de_venda on veiculo_de_venda.vin=veiculo.vin
	where (estado = 0 or estado = 1) 	and (@modelo is null or modelo = @modelo)
						and (@ano is null or ano = @ano)
						and (@combs is null or combustivel = @combs)
						and (@transmissao is null or transmissao = @transmissao)
end
go

create proc p_modelos @marca varchar(20), @ano smallint, @combs tinyint, @transmissao tinyint
as
begin
	if @marca = ''
		set @marca = null
	if @ano = ''
		set @ano = null
	if @combs = ''
		set @combs = null
	if @transmissao = ''
		set @transmissao = null

	select distinct modelo
	from veiculo join veiculo_de_aluguer on veiculo_de_aluguer.vin=veiculo.vin
	where estado = 0 and (@marca is null or marca = @marca)
						and (@ano is null or ano = @ano)
						and (@combs is null or combustivel = @combs)
						and (@transmissao is null or transmissao = @transmissao)
end
go

create proc p_modelos_venda @marca varchar(20), @ano smallint, @combs tinyint, @transmissao tinyint
as
begin
	if @marca = ''
		set @marca = null
	if @ano = ''
		set @ano = null
	if @combs = ''
		set @combs = null
	if @transmissao = ''
		set @transmissao = null

	select distinct modelo
	from veiculo join veiculo_de_venda on veiculo_de_venda.vin=veiculo.vin
	where (estado = 0 or estado = 1) and (@marca is null or marca = @marca)
						and (@ano is null or ano = @ano)
						and (@combs is null or combustivel = @combs)
						and (@transmissao is null or transmissao = @transmissao)
end
go

create proc p_anos @marca varchar(20), @modelo varchar(20), @combs tinyint, @transmissao tinyint
as
begin
	if @marca = ''
		set @marca = null
	if @modelo = ''
		set @modelo = null
	if @combs = ''
		set @combs = null
	if @transmissao = ''
		set @transmissao = null

	select distinct ano
	from veiculo join veiculo_de_aluguer on veiculo_de_aluguer.vin=veiculo.vin
	where estado = 0 and (@marca is null or marca = @marca)
						and (@modelo is null or modelo = @modelo)
						and (@combs is null or combustivel = @combs)
						and (@transmissao is null or transmissao = @transmissao)
end
go

create proc p_anos_venda @marca varchar(20), @modelo varchar(20), @combs tinyint, @transmissao tinyint
as
begin
	if @marca = ''
		set @marca = null
	if @modelo = ''
		set @modelo = null
	if @combs = ''
		set @combs = null
	if @transmissao = ''
		set @transmissao = null

	select distinct ano
	from veiculo join veiculo_de_venda on veiculo_de_venda.vin=veiculo.vin
	where (estado = 0 or estado = 1) and (@marca is null or marca = @marca)
						and (@modelo is null or modelo = @modelo)
						and (@combs is null or combustivel = @combs)
						and (@transmissao is null or transmissao = @transmissao)
end
go


create proc p_combustivel @modelo varchar(20), @marca varchar(20), @ano smallint, @transmissao tinyint
as
begin
	if @marca = ''
		set @marca = null
	if @ano = ''
		set @ano = null
	if @modelo = ''
		set @modelo = null
	if @transmissao = ''
		set @transmissao = null

	select distinct combustivel
	from veiculo join veiculo_de_aluguer on veiculo_de_aluguer.vin=veiculo.vin
	where estado = 0 and (@marca is null or marca = @marca)
						and (@ano is null or ano = @ano)
						and (@modelo is null or modelo = @modelo)
						and (@transmissao is null or transmissao = @transmissao)
end
go

create proc p_combustivel_venda @modelo varchar(20), @marca varchar(20), @ano smallint, @transmissao tinyint
as
begin
	if @marca = ''
		set @marca = null
	if @ano = ''
		set @ano = null
	if @modelo = ''
		set @modelo = null
	if @transmissao = ''
		set @transmissao = null

	select distinct combustivel
	from veiculo join veiculo_de_venda on veiculo_de_venda.vin=veiculo.vin
	where (estado = 0 or estado = 1) and (@marca is null or marca = @marca)
						and (@ano is null or ano = @ano)
						and (@modelo is null or modelo = @modelo)
						and (@transmissao is null or transmissao = @transmissao)
end
go


create proc p_transmissao @modelo varchar(20), @marca varchar(20), @ano smallint, @combustivel tinyint
as
begin
	if @marca = ''
		set @marca = null
	if @ano = ''
		set @ano = null
	if @modelo = ''
		set @modelo = null
	if @combustivel = ''
		set @combustivel = null

	select distinct transmissao
	from veiculo join veiculo_de_aluguer on veiculo_de_aluguer.vin=veiculo.vin
	where estado = 0 and (@marca is null or marca = @marca)
						and (@ano is null or ano = @ano)
						and (@modelo is null or modelo = @modelo)
						and (@combustivel is null or combustivel = @combustivel)
end
go

create proc p_transmissao_venda @modelo varchar(20), @marca varchar(20), @ano smallint, @combustivel tinyint
as
begin
	if @marca = ''
		set @marca = null
	if @ano = ''
		set @ano = null
	if @modelo = ''
		set @modelo = null
	if @combustivel = ''
		set @combustivel = null

	select distinct transmissao
	from veiculo join veiculo_de_venda on veiculo_de_venda.vin=veiculo.vin
	where (estado = 0 or estado = 1) and (@marca is null or marca = @marca)
						and (@ano is null or ano = @ano)
						and (@modelo is null or modelo = @modelo)
						and (@combustivel is null or combustivel = @combustivel)
end
go

create proc p_balcao
as
begin
	select *
	from balcao
end
go

create proc p_veiculos_aluguer @marca as varchar(20), @modelo varchar(20), @ano smallint, @combs tinyint, @transmissao tinyint, @localizacao int
as
begin
	if @marca = ''
		set @marca = null
	if @modelo = ''
		set @modelo = null
	if @ano = ''
		set @ano = null
	if @combs = ''
		set @combs = null
	if @transmissao = ''
		set @transmissao = null
	if @localizacao = ''
		set @localizacao = null

	select veiculo.vin, marca, modelo, matricula, km, ano, combustivel, hp, localizacao, transmissao, limit_km_dia, preco_dia
	from veiculo join veiculo_de_aluguer on veiculo_de_aluguer.vin=veiculo.vin 
	where estado = 0 and (@marca is null or marca = @marca)
						and (@modelo is null or modelo = @modelo)
						and (@ano is null or ano = @ano)
						and (@combs is null or combustivel = @combs)
						and (@transmissao is null or transmissao = @transmissao)
						and (@localizacao is null or veiculo.localizacao = @localizacao)
end
go

create proc p_veiculos_venda @marca as varchar(20), @modelo varchar(20), @ano smallint, @combs tinyint, @transmissao tinyint, @balcao int
as
begin
	if @marca = ''
		set @marca = null
	if @modelo = ''
		set @modelo = null
	if @ano = ''
		set @ano = null
	if @combs = ''
		set @combs = null
	if @transmissao = ''
		set @transmissao = null
	if @balcao = ''
		set @balcao = null

	select veiculo.vin, marca, modelo, matricula, km, ano, combustivel, hp, localizacao, transmissao, valor_comerc --podia ter sido um all
	from veiculo join veiculo_de_venda on veiculo_de_venda.vin=veiculo.vin 
	where (estado = 0 or estado = 1) and (@marca is null or marca = @marca)
						and (@modelo is null or modelo = @modelo)
						and (@ano is null or ano = @ano)
						and (@combs is null or combustivel = @combs)
						and (@transmissao is null or transmissao = @transmissao)
						and (@balcao is null or veiculo.localizacao = @balcao)
end
go

create proc p_get_alug-- os alugueres ativos ou seja nao tem log
as
begin	
	select num_aluguer, vin
	from aluguer join veiculo on aluguer.veiculo = veiculo.vin
	where num_aluguer not in(select num_aluguer from aluguer join log on num_aluguer = log.aluguer)
	order by aluguer.data_fim asc
end
go

create proc p_new_cliente @nif as char(9), @nome as varchar(30), @morada as varchar(50), @data_nascimento as date, @phone as char(9),
							@email as varchar(30), @num_carta as char(9)
as
begin
	if not exists(select nif from pessoa where @nif = nif) --ou seja ainda nao esta registada
	begin
		if(exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'pessoas_deleted'))
			delete from pessoas_deleted where pessoas_deleted.nif = @nif
		
		insert into pessoa values
		(@nif, @nome, @morada, @data_nascimento, @phone);
	end
	insert into cliente values
	(@nif,@email,@num_carta);

end
go

create proc p_new_func @nif as char(9), @nome as varchar(30), @morada as varchar(50), @data_nascimento as date, @phone as char(9),
							@email as varchar(30), @num_carta as char(9), @balcao as int
as
begin
	if not exists(select nif from pessoa where @nif = nif) --ou seja ainda nao esta registada
	begin	
		if(exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'funcs_fired'))
			delete from funcs_fired where funcs_fired.nif = @nif		
		if(exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'pessoas_deleted'))
			delete from pessoas_deleted where pessoas_deleted.nif = @nif
		
		insert into pessoa values
		(@nif, @nome, @morada, @data_nascimento, @phone);
	end
	insert into funcionario values
	(@nif,@email,@num_carta,@balcao);
end
go

create proc p_get_num_cliente @nif as char(9), @carta as char(9), @num_cliente as int
as
begin
	if @nif = ''
		set @nif = null
	if @carta = ''
		set @carta = null
	if @num_cliente = ''
		set @num_cliente = null

	select num_cliente, nome, num_carta, pessoa.nif
	from cliente join pessoa on pessoa.nif=cliente.nif
	where (@nif is null or pessoa.nif = @nif) and
			(@carta is null or num_carta = @carta) and
			(@num_cliente is null or num_cliente = @num_cliente)
end
go


create proc p_get_num_emp @nif as char(9)
as
begin
	select num_empregado
	from funcionario
	where nif=@nif
end
go

create proc p_get_func @num_emp as int
as
begin
	select *
	from funcionario join pessoa on funcionario.nif=pessoa.nif
	where @num_emp=num_empregado
end
go

create proc p_demitir_func @num_empregado as int
as
begin
	if(not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'pessoas_deleted'))
		create table pessoas_deleted(nif char(9) not null primary key, nome varchar(30) not null, morada varchar(50) not null, data_nascimento date	not null, phone	char(9));
	if(not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'funcs_fired'))
		create table funcs_fired(nif char(9) not null foreign key references pessoas_deleted(nif), email_empresa varchar(30) unique not null, num_empregado	int primary key, num_carta char(9) unique, balcao int);

	insert into pessoas_deleted
	select pessoa.nif, nome, morada, data_nascimento, phone
	from pessoa join funcionario on pessoa.nif=funcionario.nif
	where num_empregado=@num_empregado

	insert into funcs_fired
	select nif, email_empresa, @num_empregado, num_carta, balcao
	from funcionario
	where num_empregado=@num_empregado

	delete from funcionario where num_empregado = @num_empregado
	delete from pessoa where pessoa.nif = (select nif from funcionario where num_empregado=@num_empregado)

end
go
create proc p_update_func @nif as char(9), @nome as varchar(30), @morada as varchar(50), @phone as char(9),
							@num_carta as char(9), @balcao as int
as
begin
	update pessoa
	set nome=@nome, morada=@morada, phone=@phone
	where nif=@nif

	update funcionario
	set num_carta = @num_carta, balcao=@balcao
	where nif=@nif
end
go

create proc p_submit_aluguer @data_fim as date, @cliente as int, @alug_balc as int, @veiculo as char(17), @funcionario as int
as
begin
	insert aluguer (data_registo, data_fim, cliente, alug_balc, veiculo, funcionario)  values 
			(SYSDATETIMEOFFSET(), @data_fim, @cliente, @alug_balc, @veiculo, @funcionario)
end
go

create proc p_submit_log @danos as varchar(300), @num_aluguer as int, @taxa as money, @km_feitos as int, @drop_off as int, @funcionario as int
as
begin
	declare @quil_prev as int;

	select @quil_prev = km --no log metem se os km feitos nesta instancia
	from veiculo join aluguer on veiculo.vin = aluguer.veiculo
	where aluguer.num_aluguer = @num_aluguer

	set @km_feitos = @km_feitos - @quil_prev

	insert log (danos, data, taxa, aluguer, km_feitos, drop_off, funcionario) values
			(@danos,SYSDATETIMEOFFSET(), @taxa, @num_aluguer, @km_feitos, @drop_off, @funcionario)
	
	declare @preco_total as int
	select @preco_total
	from dbo.func_price_to_pay(@num_aluguer)

	update log
	set taxa = 0
	where aluguer=@num_aluguer

	update veiculo
	set estado=0, localizacao = @drop_off
	where vin = (select veiculo from aluguer where aluguer.num_aluguer=@num_aluguer)
end
go

create proc p_get_log @vin as char(17)
as
begin
	select  num_aluguer, danos
	from log join aluguer on log.aluguer = aluguer.num_aluguer join veiculo on aluguer.veiculo=veiculo.vin
	where veiculo.vin=@vin
end
go

create proc p_submit_venda @vin char(17), 
							@metodo_pagamento tinyint, @cliente int, @balcao int, @funcionario int,
							@valor_venda money
as	
begin
	-- altera se o estado
	update veiculo 
	set estado=3
	where vin=@vin

	--seria possivel apagar mas pode nao se justificar, ja depende da utilizacao
	/*
	delete from veiculo_de_aluguer
	where veiculo_de_aluguer.vin = @vin
	delete from veiculo_de_venda
	where veiculo_de_venda.vin = @vin
	*/
	-- inserir em venda
	declare @data as datetimeoffset
	set @data = SYSDATETIMEOFFSET()
	insert into venda(metodo_pagamento,data_registo,cliente,balcao,funcionario) values
				(@metodo_pagamento, @data, @cliente, @balcao, @funcionario);
	
	-- ir buscar num_venda
	declare @num_venda as int

	select @num_venda = num_venda
	from venda
	where metodo_pagamento=@metodo_pagamento and data_registo=@data and cliente=@cliente and balcao=@balcao and 
							funcionario=@funcionario

	-- inserir em vend_veic
	insert into vend_veic(num_venda,veiculo,valor_venda) values
				(@num_venda, @vin, @valor_venda)
end
go

create proc p_submit_compra @vin char(17), @marca varchar(20), @modelo varchar(20), @matricula char(8),
							@seguro	varchar(17), @km int, @ano char(4), @combustivel tinyint,
							@hp	smallint, @transmissao tinyint, @estado tinyint, -- veiculo

							@limit_km_dia int, @preco_dia int,--veiculo_aluguer
							@valor_comerc int,--veiculo_venda

							@client_vend int, @balcao int, @funcionario	int,
							@valor_pago int -- para o comp_veic
as
begin
	if not exists(select * from veiculo where vin=@vin) -- se nao foi comprado anteriormente
	begin
		insert into veiculo (vin,marca,modelo,matricula,seguro,km,ano,combustivel,hp,localizacao,transmissao,estado)values
							(@vin,@marca,@modelo,@matricula,@seguro,@km,@ano,@combustivel,@hp,@balcao,@transmissao,@estado);
	
		if @estado = 0 --e de aluguer
		begin
			insert into veiculo_de_aluguer (vin,limit_km_dia,preco_dia) values
											(@vin,@limit_km_dia,@preco_dia);
		end
	
		insert into veiculo_de_venda(vin,valor_comerc) values (@vin,@valor_comerc);
	end
	else -- se ja estava na base de dados, muda se o estado e atualizam-se parametros
	begin
		update veiculo
		set seguro=@seguro, km=@km, combustivel=@combustivel, hp=@hp, localizacao = @balcao, estado=@estado
		where vin = @vin

		if @estado = 0
		begin
			if not exists(select * from veiculo_de_aluguer where vin=@vin) --pode se ter tornado agr em veiculo de aluguer
			begin
			insert into veiculo_de_aluguer (vin,limit_km_dia,preco_dia) values (@vin,@limit_km_dia,@preco_dia);
			end
			else
			begin
			update veiculo_de_aluguer
			set limit_km_dia = @limit_km_dia, preco_dia=@preco_dia
			where vin = @vin
			end
		end

		update veiculo_de_venda
		set valor_comerc = @valor_comerc
		where vin=@vin
	end

	declare @data as datetimeoffset
	set @data = SYSDATETIMEOFFSET()
	declare @num_compra as int

	insert into compra (data, client_vend, balcao, funcionario) values
			(@data, @client_vend, @balcao, @funcionario);
	
	select @num_compra = num_compra
	from compra
	where data=@data and client_vend=@client_vend and balcao=@balcao and funcionario = @funcionario
	--nao havia outra forma de ir buscar o numero da compra, mas como se usa o sysdatetimeoffset e capaz de nao dar grande asneira

	insert into comp_veic(num_compra,vin,valor_pago) values (@num_compra,@vin,@valor_pago);

end
go

--numero de alugueres por cliente
create proc p_num_alug_clientes
as
begin
	select num_cliente, count(num_aluguer) as num_total_alug
	from cliente join aluguer on cliente.num_cliente=aluguer.cliente
	group by num_cliente
	order by num_total_alug desc
end
go

create proc p_lucro_cliente
as
begin
	
	select num_cliente, sum(taxa) as valor	  
	from (
		select num_cliente, taxa --dinheiro dos alugueres
		from cliente join aluguer on cliente.num_cliente=aluguer.cliente join log on log.aluguer=aluguer.num_aluguer 
		
		union all 
		
		select num_cliente, valor_venda as taxa --passa se o valor da venda como nome da taxa para se poder somar facilmente
		from cliente join venda on num_cliente=venda.cliente join vend_veic on vend_veic.num_venda=venda.num_venda
	) t
	group by num_cliente
	order by valor desc
end
go

-- funcionario nas vendas ver numero de vendas e lucro delas, ano e mes tambem 
create proc p_func_vendas @balcao int
as
begin
	if @balcao = ''
		set @balcao = null

	select YEAR(venda.data_registo) as ano, MONTH(venda.data_registo) as mes,num_empregado, count(venda.num_venda) as num_vendas, (sum(valor_venda) - sum(veiculo_de_venda.valor_comerc) ) as lucro_das_vendas
	from funcionario join venda on venda.funcionario=num_empregado join vend_veic on vend_veic.num_venda=venda.num_venda join veiculo_de_venda on vend_veic.veiculo=veiculo_de_venda.vin
	where (@balcao is null or funcionario.balcao = @balcao)
	group by num_empregado, YEAR(venda.data_registo), MONTH(venda.data_registo)
	order by ano, mes, lucro_das_vendas desc
end
go

create proc p_balcao_veiculo_alug
as
begin
	select balcao.numero as balcao, marca, modelo, count(num_aluguer) as numero_alugueres, avg(Datediff(DAY,data_fim,data_registo)) as avg_dias
	from balcao join aluguer on balcao.numero = aluguer.alug_balc join veiculo on aluguer.veiculo=veiculo.vin
	group by balcao.numero,marca,modelo
end
go

use master
go