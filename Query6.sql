select batch_code, avg(weight*score/100)
from studentvle
inner join (
select course_code, batch_code, id_student, id_assessment, weight, score
from assessments 
inner join studentassessment using (id_assessment)
inner join studentinfo using (id_student, course_code, batch_code)
where batch_code in ('2013J', '2014J') and assessment_type = 'TMA' and gender = 'F') as SQ1
using (id_student, course_code, batch_code)
inner join ((select distinct id_assessment, batch_code 
										from assessments 
                                        where batch_code = '2013J'
                                        order by id_assessment
                                        limit 2)
union
(select distinct id_assessment, batch_code 
										from assessments 
                                        where batch_code = '2014J'
                                        order by id_assessment
                                        limit 2)) as SQ2 using (id_assessment, batch_code)
where date = 28
group by batch_code;

