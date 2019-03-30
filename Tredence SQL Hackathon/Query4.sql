select course_code, batch_code, date
from studentVle
where (course_code, batch_code, sum_click) in (
											select course_code, batch_code, max(sum_click)
											from studentVle
											group by course_code, batch_code);
