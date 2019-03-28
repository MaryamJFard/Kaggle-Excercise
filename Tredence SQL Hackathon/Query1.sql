CREATE TABLE regionScore 
select region, score
from assessments as A, studentassessment as SA, studentinfo as SInfo
where A.assessment_type = "Exam" and SA.id_assessment = A.id_assessment and SA.id_student = SInfo.id_student;


SET @rowNumber:=0; 
SET @groupName:='';

select groupName, avg(score)
from
(select @rowNumber:=CASE
        WHEN @groupName = region THEN @rowNumber + 1
        ELSE 1
		END AS rowNumber,
		@groupname:=region AS groupName,region, score, (select count(*)
						from regionScore
						where SQ1.region = region) as groupSize
from 
	(select region, score
	from regionScore
    order by region, score) as SQ1) as SQ3
where rowNumber between groupSize / 2 and groupSize / 2 + 1
group by groupName
order by score desc
limit 1;

