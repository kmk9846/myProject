/*DROP DATABASE IF EXISTS db2018007938;
CREATE DATABASE IF NOT EXISTS db2018007938;
USE db2018007938;*/

# create table
 
 CREATE TABLE admin(
	adminID varchar(15),
	adminPassword varchar(20),
	adminName varchar(20)
 );
 
 CREATE TABLE course(
	course_id varchar(7) primary key,
    name varchar(20),
    credit tinyint unsigned not null
);

CREATE TABLE major(
	major_id tinyint unsigned not null primary key,
    name varchar(20)
);

CREATE TABLE lecture(
	lecturer_id int unsigned not null primary key,
    name varchar(25),
    major_id tinyint unsigned not null,
    foreign key (major_id) references major (major_id) on update cascade on delete cascade
);

CREATE TABLE building (
	building_id int unsigned not null primary key,
    name varchar(20),
    admin varchar(20),
    rooms int unsigned not null    
);

CREATE TABLE room(
	room_id tinyint unsigned not null primary key,
    building_id int unsigned not null,
    occupancy tinyint unsigned not null,
    foreign key (building_id) references building (building_id) on update cascade on delete cascade
);

CREATE TABLE class(
	class_id int unsigned not null primary key,
    class_no int unsigned not null,
    course_id varchar(7),
    name varchar(20),
    major_id int unsigned not null,
    year int unsigned not null,
    credit int unsigned not null,
    lecturer_id int unsigned not null,
    person_max int unsigned not null,
    opened int unsigned not null,
    room_id tinyint unsigned not null,
    foreign key (course_id) references course (course_id) on update cascade on delete cascade,
    foreign key (lecturer_id) references lecture (lecturer_id) on update cascade on delete cascade,
    foreign key (room_id) references room (room_id) on update cascade on delete cascade
);

CREATE TABLE student(
	student_id int unsigned not null primary key,
    password varchar(20),
    name varchar(20),
    sex varchar(6),
    major_id tinyint unsigned not null,
    lecturer_id int unsigned not null,
    year tinyint unsigned not null,
    foreign key(major_id) references major (major_id) on update cascade on delete cascade,
    foreign key(lecturer_id) references lecture (lecturer_id) on update cascade on delete cascade
);

CREATE TABLE credits(
	credits_id smallint unsigned not null primary key,
    student_id int unsigned not null,
    course_id varchar(7),
    year int(4) unsigned not null,
    grade varchar(3),
    foreign key (student_id) references student (student_id) on update cascade on delete cascade,
    foreign key (course_id) references course (course_id) on update cascade on delete cascade
);

CREATE TABLE time(
	time_id tinyint unsigned not null primary key,
    class_id int unsigned not null,
    period tinyint unsigned not null,
    begin text,
    end text,
    foreign key (class_id) references class (class_id) on update cascade on delete cascade
);

CREATE TABLE user(
  student_id int unsigned,
  userPassword varchar(20),
  userName varchar(20),
  userGender varchar(20),
  userEmail varchar(30),
  foreign key (student_id) references student (student_id) on update cascade on delete cascade
 );

CREATE TABLE registed_class(
	student_id int unsigned not null,
    class_id int unsigned not null,
    course_id varchar(7),
    name varchar(20),
    credit int unsigned not null,
    period tinyint unsigned not null,
	begin text,
    end text
);

CREATE TABLE registed_want_class(
	student_id int unsigned not null,
    class_id int unsigned not null,
    course_id varchar(7),
    name varchar(20),
    credit int unsigned not null,
    period tinyint unsigned not null,
	begin text,
    end text
);

INSERT INTO admin ( adminID, adminPassword, adminName) values
('admin', 'pwd', '관리자');