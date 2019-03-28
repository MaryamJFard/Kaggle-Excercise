LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/studentAssessment.csv'
INTO TABLE studentAssessment
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/studentVle.csv'
INTO TABLE studentVle
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';