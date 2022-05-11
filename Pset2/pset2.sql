-- Feito em mysql

-- Questão 01
select avg(f.salario) as media_salario, d.nome_departamento 
from funcionario f 
inner join departamento d 
on d.numero_departamento = f.numero_departamento 
group by d.nome_departamento;

-- Questão 02
select avg(f.salario) as media_salario, f.sexo
from funcionario f
group by f.sexo;

-- Questão 03
select nome_departamento as departamento, concat(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) as nome, data_nascimento as data_de_nascimento,
floor(DATEDIFF(CURDATE(),data_nascimento)/365.25) as idade, 
salario as salario 
from funcionario f inner join departamento d
where f.numero_departamento = d.numero_departamento order by nome_departamento;

-- Questão 04
select concat(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) as nome, floor(datediff(curdate(), data_nascimento)/365.25) as idade, 
salario as salario, cast((salario*1.2) as decimal(10,2)) as salario_reajuste from funcionario f
where salario < '35000'
union
select concat(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) as nome, floor(datediff(curdate(), data_nascimento)/365.25) as idade, 
salario as salario, cast((salario*1.15) as decimal(10,2)) as salario_reajuste from funcionario f
where salario >= '35000';

-- Questão 05
select nome_departamento as departamento, g.primeiro_nome as gerente, f.primeiro_nome as funcionario, salario as salarios
from departamento d inner join funcionario f, 
(select primeiro_nome, cpf from funcionario f inner join departamento d where f.cpf = d.cpf_gerente) as g
where d.numero_departamento = f.numero_departamento and g.cpf = d.cpf_gerente order by d.nome_departamento asc, f.salario desc;

--Questão 06
select concat(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) as nome, dto.nome_departamento as departamento,
dpd.nome_dependente as dependente, floor(datediff(curdate(), dpd.data_nascimento)/365.25) as idade_dependente,
case when dpd.sexo = 'M' then 'masculino' when dpd.sexo = 'm' then 'masculino'
when dpd.sexo = 'F' then 'Feminino' when dpd.sexo = 'f' then 'feminino' end as sexo_dependente
from funcionario f 
inner join departamento dto on f.numero_departamento = dto.numero_departamento inner join dependente dpd ON dpd.cpf_funcionario = f.cpf;

--Questão 07
select distinct concat(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) as nome, dp.nome_departamento as departamento,
cast((f.salario) as decimal(10,2)) as salario from funcionario f
inner join departamento dp inner join dependente dnp
where dp.numero_departamento = f.numero_departamento and
f.cpf not in (select dnp.cpf_funcionario from dependente dnp);

--Questão 08
select d.nome_departamento as departamento, p.nome_projeto as projeto,
concat(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) as nome, t.horas as horas
from funcionario f inner join departamento d inner join projeto p inner join trabalha_em t
where d.numero_departamento = f.numero_departamento and
p.numero_projeto = t.numero_projeto and f.cpf = t.cpf_funcionario order by p.numero_projeto;

--Questão 09
select d.nome_departamento as departamento, p.nome_projeto as projeto, sum(t.horas) as total_horas
from departamento d inner join projeto p inner join trabalha_em t
where d.numero_departamento = p.numero_departamento AND p.numero_projeto = t.numero_projeto group by p.nome_projeto;

--Questão 10
select d.nome_departamento as departamento, cast(avg(f.salario) as decimal(10,2)) as media_salarial
from departamento d inner join funcionario f
where d.numero_departamento = f.numero_departamento group by d.nome_departamento;

--Questão 11
select concat(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) as nome, p.nome_projeto as projeto,
cast((f.salario) as decimal(10,2)) as recebimento
from funcionario f inner join projeto p inner join trabalha_em t
where f.cpf = t.cpf_funcionario and p.numero_projeto = t.numero_projeto group by f.primeiro_nome;

--Questão 12
select d.nome_departamento as departamento, p.nome_projeto as projeto,
concat(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) as nome, t.horas as horas
from funcionario f inner join departamento d inner join projeto p inner join trabalha_em t
where f.cpf = t.cpf_funcionario and p.numero_projeto = t.numero_projeto and (t.horas = 0 or t.horas = null) group by f.primeiro_nome;

--Questão 13
select concat(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) as nome,
case when sexo = 'M' then 'masculino' when sexo = 'm' then 'masculino'
when sexo = 'f' then 'feminino' when sexo = 'f' then 'feminino' end as sexo,
floor(datediff(curdate(), f.data_nascimento)/365.25) as idade
from funcionario f
union
select d.nome_dependente as nome,
case when sexo = 'M' then 'masculino' when sexo = 'm' then 'masculino'
when sexo = 'F' then 'Feminino' when sexo = 'f' then 'Feminino' end as sexo,
floor(datediff(curdate(), d.data_nascimento)/365.25) as idade
from dependente d order by idade;

--Questão 14
select d.nome_departamento as departamento, count(f.numero_departamento) as numero_funcionario
from funcionario f inner join departamento d
where f.numero_departamento = d.numero_departamento group by d.nome_departamento;

-- Questão 15
select distinct concat(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) as nome,
d.nome_departamento as departamento, 
p.nome_projeto as projeto
from departamento d inner join projeto p inner join trabalha_em t inner join funcionario f 
where d.numero_departamento = f.numero_departamento and p.numero_projeto = t.numero_projeto and
t.cpf_funcionario = f.cpf
union
select distinct concat(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) as Nome,
d.nome_departamento as departamento, 
'sem projeto' as projeto
from departamento d inner join projeto p inner join trabalha_em t inner join funcionario f 
where d.numero_departamento = f.numero_departamento and p.numero_projeto = t.numero_projeto and
(f.cpf not in (select t.cpf_funcionario from trabalha_em t));
