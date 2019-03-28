UPDATE assessments
SET date = Null
WHERE date = 0;

UPDATE vle
SET week_from = Null
WHERE week_from = 0;
UPDATE vle
SET week_to = Null
WHERE week_to = 0;

update studentregistration
set date_unregistration = null
where date_unregistration = 0;

