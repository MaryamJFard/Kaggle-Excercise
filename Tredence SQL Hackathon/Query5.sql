select *, (select count(*) 
			from
            (
			select id_student, final_result, sum(sum_click) as SC
			from studentinfo
			inner join studentvle
			using (id_student, course_code, batch_code)
			where concat(course_code, ' ', batch_code ) = 'AAA 2013J'
			group by id_student, final_result
            )
            as SQ2
            where SQ2.SC > SQ1.activity and SQ2.final_result = 'Pass'
            )  / (
				select count(*)
				from
				(
				select id_student, final_result
				from studentinfo
				inner join studentvle
				using (id_student, course_code, batch_code)
				where concat(course_code, ' ', batch_code ) = 'AAA 2013J'
				group by id_student, final_result
                ) as SQ3
				) as percentage
from(
select id_student, final_result, sum(sum_click) as activity
from studentinfo
inner join studentvle
using (id_student, course_code, batch_code)
where concat(course_code, ' ', batch_code ) = 'AAA 2013J'
group by id_student, final_result) as SQ1;


