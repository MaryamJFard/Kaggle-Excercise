create table courses(
	course_code varchar(25),
    batch_code varchar(25),
    length int,
    primary key(course_code, batch_code)
);
create table studentRegistration(
	course_code varchar(25),
    batch_code varchar(25),
    id_student int,
    date_registration int,
    date_unregistration int,
    primary key(course_code, batch_code, id_student),
    foreign key(course_code, batch_code) references courses(course_code, batch_code),
    foreign key (course_code, batch_code, id_student) references studentinfo(course_code, batch_code, id_student)
); 
create table studentInfo(
	course_code varchar(25),
    batch_code varchar(25),
    id_student int,
    gender varchar(25),
    region varchar(25),
    highest_education varchar(25),
    imd_band varchar(25),
    age_band varchar(25),
    num_of_prev_attempts int,
    studied_credits int,
    disability varchar(25),
    final_result varchar(25),
    primary key (course_code, batch_code, id_student),
    foreign key (course_code, batch_code) 
    references courses(course_code, batch_code)
);
create table assessments(
	course_code varchar(25),
    batch_code varchar(25),
    id_assessment int,
    assessment_type varchar(25),
    date int,
    weight int,
    primary key(course_code, batch_code, id_assessment),
    foreign key(course_code, batch_code) references courses(course_code, batch_code)
);
create table studentAssessment(
	id_assessment int,
    id_student int, 
    date_submitted int,
    is_banked int,
    score float,
    primary key(id_student, id_assessment),
    foreign key (id_assessment) references assessments(id_assessment) 
);
create table vle(
	id_site int,
    course_code varchar(25),
    batch_code varchar(25),
    activity_type varchar(25),
    week_from int,
    week_to int,
    primary key(id_site, course_code, batch_code), 
    foreign key(course_code, batch_code) references courses(course_code, batch_code)
);
create table studentVle(
	course_code varchar(25),
	batch_code varchar(25),
    id_student int,
	id_site int,
	date int,
    sum_click int,
    primary key (course_code, batch_code, id_student, id_site,date, sum_click),
    foreign key (id_site, course_code, batch_code) 
    references vle(id_site, course_code, batch_code)
);
