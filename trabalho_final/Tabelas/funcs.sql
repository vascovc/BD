use Rent_buy_car
go

create function func_price_to_pay (@num_aluguer int) returns @table table(preco_total int)-- func para calcular o preco final
as
begin
	declare @num_dias_extra int;
	declare @taxa_de_dias as int;
	declare @preco_total as money;
	declare @taxa_km as int;
	declare @km as int;
	declare @preco_dia as int;

	select @num_dias_extra = DATEDIFF(DAY,data_fim, GETDATE()), @km = km_feitos --km do log
	from aluguer join log on num_aluguer=log.aluguer
	where num_aluguer=@num_aluguer

	set @taxa_de_dias = 0
	if @num_dias_extra > 0 --retornou mais tarde
		set @taxa_de_dias = 1.2
	
	-- preco = taxa + preco_dia*(num_dias_feitos + num_dias_extra*taxa_de_dias), taxa -> danos feitos; 
 
	select @preco_total = taxa + preco_dia*(DATEDIFF(DAY,data_registo, GETDATE()) + @num_dias_extra*@taxa_de_dias), @preco_dia=preco_dia,@taxa_km=DATEDIFF(DAY,data_registo, GETDATE())*limit_km_dia
	from aluguer join log on aluguer.num_aluguer=log.aluguer
					join veiculo_de_aluguer on veiculo_de_aluguer.vin=aluguer.veiculo
	where @num_aluguer=num_aluguer

	
	if @taxa_km < @km -- se ele fez mais km do que o que devia, numero_de_dias_feitos*limit_km_por_dia < km_feitos
		set @taxa_km = 0.02*@preco_dia*(@taxa_km-@km) -- 2% do valor diario por cada km extra
	else
		set @taxa_km = 0

	set @preco_total = @preco_total + @taxa_km
	insert into @table values (@preco_total);
	return;
end
go

use master
go
