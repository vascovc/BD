use pubs;

--a) seleciona todos os autores
SELECT * FROM authors;

--b) primeiro nome, ultimo e o phone
select au_fname,au_lname,phone from authors;

--c) a ordenacao por default e ascending
select au_fname, au_lname, phone from authors
order by au_fname, au_lname;

--d) renomear
select au_fname as first_name, au_lname as last_name, phone as telephone
from authors
order by au_fname, au_lname;

--e) adicao do where para restringir
select au_fname as first_name, au_lname as last_name, phone as telephone
from authors
where state = 'CA' AND au_lname != 'Ringer'
order by first_name, last_name;

--f) colocar % da 0 ou mais caracteres antes ou depois
select * from publishers
where pub_name like '%Bo%';

--g) juntar editoras aos titlos e escolher os titulos com tipo business
select pub_name
from publishers join titles on publishers.pub_id=titles.pub_id
where titles.type = 'Business'
group by pub_name;

--h) juntar titulos, editoras e as vendas. Agrupar por nome da editora
select pub_name, sum(qty) as total_sales
from publishers join titles on publishers.pub_id = titles.pub_id join sales on titles.title_id = sales.title_id
group by pub_name;

--i) juntar como em h) e agrupar por editora e por titulo
select pub_name, title, sum(qty) as total_sales
from publishers join titles on publishers.pub_id = titles.pub_id join sales on titles.title_id = sales.title_id
group by pub_name, title
order by pub_name;

--j) juntar sales, titulos e lojas e escolher as lojas que tem o nome
select title
from  (titles join sales on titles.title_id = sales.title_id) join stores on sales.stor_id = stores.stor_id
where stor_name = 'Bookbeat'

--k) juntar titulo, tittleautor e author e agrupar por id com o nome e escolher aqueles que tem mais que um tipo associado
select au_fname, au_lname
from (titles join titleauthor on titles.title_id = titleauthor.title_id) join authors on titleauthor.au_id = authors.au_id
group by authors.au_id, au_fname, au_lname
having count(type) > 1;

--l) juntar titulos com as vendas. agrupar por tipo, id da editora e titulo, fazendo a media do preco e sumar num vendas
select titles.title, avg(price) as preco_medio, sum(qty) as num_vendas
from (titles join sales on titles.title_id = sales.title_id)
group by type, pub_id, title;

--m) 
select titles.type, titles.advance, avg_adv
from titles join ( select titles.type, avg(advance) as avg_adv
				   from titles
				   group by type ) as temp
				   on titles.type = temp.type
where titles.advance > temp.avg_adv * 1.5;

select titles.type,avg(advance)
from titles
group by titles.type
having max(advance) > 1.5*avg(advance)


--n) juntar titulo titleauthor, author, sales. o lucro tem que ser o numero de vendas a multiplicar pelo royalty dele e pelo de cada um mas em decimal porque esta %
select title, au_fname, au_lname, ytd_sales * royalty * 0.01 * royaltyper * 0.01 as profit
from   titles join titleauthor on titles.title_id = titleauthor.title_id
	   join authors on titleauthor.au_id = authors.au_id
	   join sales on titles.title_id = sales.title_id
group by title, au_fname, au_lname, ytd_sales, royalty, royaltyper

--o) a faturacao total e o preco*numero de vendas, o autor tem de lucro isso mas vezes os seus royalties, a editora vai fazer de lucro o primeiro ponto menos o segundo
select title,ytd_sales, price*ytd_sales as faturacao, royalty*0.01*price*ytd_sales as authors_profit, price*ytd_sales - royalty*0.01*price*ytd_sales as publisher_profit
from titles
order by title;

--p) fazer o de antes mas juntar com tudo aquilo do autor para se ir buscar o nome
select title,ytd_sales, au_fname, au_lname, royalty*0.01*price*ytd_sales as authors_profit, price*ytd_sales - royalty*0.01*price*ytd_sales as publisher_profit
from titles join titleauthor on titles.title_id = titleauthor.title_id
			join authors on titleauthor.au_id = authors.au_id
order by title;

--q) juntar stores, sales e titulos. agrupar por stor_id e selecionar aquelas que tem o numero de titulos igual a todos os titulos
select stores.stor_id, count(sales.title_id) as number_title
from stores join sales on stores.stor_id = sales.stor_id join titles on sales.title_id=titles.title_id
group by stores.stor_id
having count(sales.title_id) = (select count(*) from titles);

--r) juntar stores e sales, agrupar por stor_id e escolher aquelas que a soma de vendas for superior a media de todas as lojas que e feita dentro do having
select st.stor_id, sum(qty) as number_sales
from stores as st join sales as sa on st.stor_id=sa.stor_id
group by st.stor_id
having sum(qty) > (select avg(qty) as average_q
				   from stores join sales on stores.stor_id = sales.stor_id);

--s) escolher os titulos que nao estao em -> tirar os title_id de juntar sales com a stor Bookbeat
select title_id,title
from titles
where title_id not in (select sales.title_id
					   from stores join sales on stores.stor_id=sales.stor_id
					   where stores.stor_name='Bookbeat')

--t) ligar todas as stores e as publishers, todas as combinacoes possiveis, e tirar os pares que existem.
--		os pares que existem sao dados por se ligar stores a sales
select p.pub_name, st.stor_id
from stores as st, publishers as p
--order by p.pub_name
except
(select p.pub_name, st.stor_id
from publishers as p join titles as t on p.pub_id=t.pub_id join sales as sa on t.title_id=sa.title_id join stores as st on sa.stor_id=st.stor_id
group by p.pub_name, st.stor_id
);