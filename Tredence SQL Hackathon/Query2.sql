select activity_type, count(*) / (select count(*)
									from vle
									where course_code = (
										select course
										from (select course_code as course, (select count(*) from studentInfo where final_result = "Pass" and course_code = course group by course_code) / count(*) as passRate
												from studentInfo
												group by course) as SQ1
										order by passRate desc
										limit 1)) as percentage
from vle
where course_code = (
						select course
						from (select course_code as course, (select count(*) from studentInfo where final_result = "Pass" and course_code = course group by course_code) / count(*) as passRate
								from studentInfo
								group by course) as SQ1
						order by passRate desc
						limit 1)
group by activity_type;