select activity_type, sum(sum_click) as click
from vle as V, studentvle as SV
where V.id_site = SV.id_site and V.course_code = SV.course_code and V.batch_code = SV.batch_code
group by activity_type
order by click desc
limit 1;
