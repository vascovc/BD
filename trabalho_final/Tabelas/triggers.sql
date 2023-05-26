use Rent_buy_car
go

create trigger t_log on log -- para atualizar o carro, usando o log
after insert 
as
begin
	
	declare @quil_inserted as int;
	declare @vin as char(17);
	declare @quil_prev as int;

	select @quil_prev = km, @vin=veiculo.vin
	from log join aluguer on aluguer=num_aluguer
			join veiculo_de_aluguer on veiculo=vin
			join veiculo on veiculo_de_aluguer.vin=veiculo.vin
			join inserted on inserted.aluguer = num_aluguer

	
	select @quil_inserted = inserted.km_feitos 
	from inserted

	if @quil_inserted < 0
	begin
		raiserror('Quilometros anteriores superiores a agora',16,1);
		rollback tran;
	end
	else
	begin
		update veiculo
		set km = @quil_prev + @quil_inserted, estado=0
		from inserted
		where vin=@vin
	end
end
go

create trigger t_veiculo_alug on veiculo_de_aluguer -- para se verficar que nao se insere um veiculo so de venda no alugue
after insert
as
begin
	declare @estado as tinyint;

	select @estado=estado
	from inserted join veiculo on inserted.vin=veiculo.vin

	if @estado = 1 --usar convencao do criar_base
	begin
		raiserror('Veiculo so para venda',16,1);
		rollback tran;
	end

end
go

--nao testado 
create trigger t_venda on venda -- quando se faz venda muda se o estado do veiculo
after insert
as
begin
	
	update veiculo
	set estado = 3 --usar convencao do criar_base
	from inserted join vend_veic on vend_veic.num_venda=inserted.num_venda
				join veiculo on veiculo=vin
end
go

create trigger t_aluguer on aluguer -- quando se faz aluguer muda se o estado do veiculo
after insert
as
begin

	declare @data_fim as date
	declare @data_registo as date
	select @data_fim=data_fim, @data_registo=data_registo
	from inserted

	if DATEDIFF(DAY,@data_fim, @data_registo)>0
	begin
		raiserror('Data de fim nao pode ser antes de data de registo',16,1);
		rollback tran
	end

	update veiculo
	set estado = 2 --usar convencao do criar_base
	from inserted join veiculo_de_aluguer on inserted.veiculo = veiculo_de_aluguer.vin
					join veiculo on veiculo_de_aluguer.vin = veiculo.vin
end
go

create trigger t_idade on pessoa -- para verificar se a pessoa tem 18 anos
after insert, update
as 
begin
	declare @idade as int;

	select @idade = DATEDIFF(YEAR, inserted.data_nascimento, GETDATE())
	from inserted

	if @idade < 18
	begin
		raiserror('Idade menor a 18 anos, nao possivel de registar',16,3);
		rollback tran;
	end
end
go

create trigger t_funcionario on funcionario
after insert, update
as 
begin
	declare @balcao as int
	select @balcao = balcao
	from inserted

	if not (@balcao = null or exists(select numero from funcionario join balcao on funcionario.balcao=balcao.numero))
	begin
		raiserror('Balcao inexistente',16,1)
		rollback tran
	end
end
go

create trigger t_transmicao_combustivel on veiculo
after insert
as
begin
	declare @transmissao as tinyint;
	declare @combustivel as tinyint;

	select @transmissao = transmissao, @combustivel = combustivel 
	from inserted 
				  

	if (@transmissao = 1 and @combustivel = 3) or (@transmissao = 1 and @combustivel = 5)
	begin
		raiserror('Transmição passada para automatica. Carros eletricos ou hybrids usam apenas transmição automatica.',15,1);
		update veiculo
		set transmissao = 2
		from inserted join veiculo on inserted.vin = veiculo.vin
	end
end
go

use master
go