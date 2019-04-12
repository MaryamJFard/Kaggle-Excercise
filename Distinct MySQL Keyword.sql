#Substitude for Distinct On in PostgreSQL
create table test1(
	col1 int,
    col2 int,
    col3 int,
    col4 int,
    col5 int,
	primary key(col1, col2, col3, col4, col5)
);

insert into test1
values (1 ,2, 3, 777, 888),
	   (1 ,2 ,3, 888, 999),
       (3, 3, 3, 555, 555);
       
select col4, col5
from test1
group by col1, col2, col3;

select col4, col5
from (select *
		from test1
        order by col1, col2, col3, col4) as SQ1
group by col1, col2, col3;

select col4, col5
from test1 inner join
(select col1, col2, col3, min(col4) as m_col4
from test1
group by col1, col2, col3) as SQ1
on test1.col1 = SQ1.col1 and test1.col2 = SQ1.col2 and test1.col3 = SQ1.col3 and test1.col4 = SQ1.m_col4;