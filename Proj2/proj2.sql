--Q1:

drop type if exists RoomRecord cascade;
create type RoomRecord as (valid_room_number integer, bigger_room_number integer);

create or replace function Q1(course_id integer)
    returns RoomRecord
as $$
--... SQL statements, possibly using other views/functions defined by you ...
declare c1 integer;
declare c2 integer;
declare valid_room_number integer;
declare bigger_room_number integer;
BEGIN
select count(distinct id) into valid_room_number from rooms where capacity >= (select count(student) from course_enrolments where course=$1);
select count(distinct student) into c1 from course_enrolments where course=$1;
select count(distinct student) into c2 from course_enrolment_waitlist where course=$1;
select count(distinct id) into bigger_room_number from rooms where capacity >= c1+c2;
IF c1=0 THEN
RAISE EXCEPTION 'INVALID COURSEID';
ELSE
return (valid_room_number,bigger_room_number) RoomRecord;
END IF;
END;
$$ language plpgsql;



--Q2:

drop type if exists TeachingRecord cascade;
create type TeachingRecord as (cid integer, term char(4), code char(8), name text, uoc integer, average_mark integer, highest_mark integer, median_mark integer, totalEnrols integer);

create or replace function Q2(staff_id integer)
 returns setof TeachingRecord
as $$


declare cid integer;
declare term char(4);
declare code char(8);
declare name text;
declare uoc integer;
declare average_mark integer;
declare highest_mark integer;
declare median_mark integer;
declare totalEnrols integer;
declare i record;
declare idi integer;
declare count integer;
declare medianmark integer;
declare mm record;
BEGIN
select count(*) into idi from staff where id=$1;
IF idi = 0 THEN
RAISE EXCEPTION 'INVALID STAFFID';
ELSE

for i in select zzz.course as cid,lower(zzz.substring) as term,zzz.code as code,zzz.name as name, zzz.uoc as uoc, zzz.avg as average_mark, zzz.max as highest_mark,zzz.totalEnrols as totalEnrols from
(select yyy.course,yyy.totalEnrols,yyy.max,yyy.avg,substring(cast(yyy.term as text)from 3 for 7),su.code,su.name,su.uoc from
(select xx.course,xx.totalEnrols,xx.max,xx.avg,s.year||''||s.term as term,xx.subject from
(select u.course,u.totalEnrols,c.semester,c.subject,u.max,u.avg from
(select max(mark),round(avg(mark),0) as avg,count(*) as totalEnrols,course from course_enrolments where course in (select course from course_staff where staff = $1) and mark is not Null group by course)
as u join courses c
on (c.id=u.course) where u.totalEnrols>0) as xx join semesters s on (s.id=xx.semester)) as yyy join subjects su on(su.id=yyy.subject)) as zzz

LOOP
  count := 1;
  medianmark := 0;
  for mm in select mark as mark from  course_enrolments where course = i.cid and mark is not null order by mark
  loop
  IF count = ceiling(cast(i.totalEnrols as float) / 2)  THEN
      medianmark := medianmark+mm.mark;
  END IF;
  IF count = floor(cast(i.totalEnrols as float) / 2) + 1  THEN
      medianmark := medianmark+mm.mark;
  END IF;
  count := count + 1;
  END LOOP;
  medianmark := round(medianmark / 2);

return next(i.cid,cast(i.term as char(4)),i.code,cast(i.name as text),i.uoc,cast(i.average_mark as integer),cast(i.highest_mark as integer),cast(medianmark as integer),cast(i.totalEnrols as integer))TeachingRecord;
--cid,term,code,name,uoc,average_mark,highest_mark,median_mark,totalEnrols)
END LOOP;
END IF;
END;
$$ language plpgsql;










--Q3:

drop type if exists CourseRecord cascade;
create type CourseRecord as (unswid integer, student_name text, course_records text);

create or replace function Q3(org_id integer, num_courses integer, min_score integer)
  returns setof CourseRecord
as $$
--... SQL statements, possibly using other views/functions defined by you ...
declare i record;
declare v_counter  integer default 0;
declare unswid integer;
declare student_name text;
declare course_records text;
declare idi integer;
BEGIN


select count(*) into idi from orgunits where id=$1;
IF idi = 0 THEN
RAISE EXCEPTION 'INVALID ORGID';
ELSE
for i in
select gg.student as id from
(select qqqqq.student,peo.unswid from people peo join
(select qqqq.student from
(select ce.student,count(ce.course),max(mark) from course_enrolments ce join
(select gaygay.id,gaygay.code,gaygay.name,gaygay.school,s.name as semester from semesters s join
(select c.id,c.semester,ggg.code,ggg.name,ggg.school from courses c join
(select s.id,s.code,s.name,gg.name as school from subjects s join
(select org.id,org.name from orgunits org join
(select * from (with recursive xxx as (select id from orgunits where id =$1 union select og.member as id from orgunit_groups og join xxx on xxx.id = og.owner)select * from xxx) as q) as g
on g.id=org.id) as gg
on  (gg.id=s.offeredBy)
) as ggg  on (c.subject=ggg.id)) as gaygay on (gaygay.semester=s.id)) as uuu on (uuu.id=ce.course) group by student) as qqqq where qqqq.count>$2 and qqqq.max>=$3) as qqqqq
 on (qqqqq.student=peo.id) order by peo.unswid) as gg

LOOP


select ggggggg.course_records_r into course_records from
(select string_agg(course_record,'') as course_records_r from
(select uuu.code||', '||uuu.name||', '||uuu.semester||', '||uuu.school||', '||vector.mark||''||E'\n' as course_record
FROM
(select gaygay.id,gaygay.code,gaygay.name,gaygay.school,s.name as semester from semesters s join
(select c.id,c.semester,ggg.code,ggg.name,ggg.school from courses c join
(select s.id,s.code,s.name,gg.name as school from subjects s join
(select org.id,org.name from orgunits org join
(select * from (with recursive xxx as (select id from orgunits where id =$1 union select og.member as id from orgunit_groups og join xxx on xxx.id = og.owner)select * from xxx) as q) as g
on g.id=org.id) as gg
on  (gg.id=s.offeredBy)
) as ggg  on (c.subject=ggg.id)) as gaygay on (gaygay.semester=s.id)) as uuu
join
(select uzi.id,uzi.unswid,uzi.name,ces.course,ces.mark from course_enrolments ces join
(select peo.id,peo.unswid,peo.name from people peo where peo.id=i.id) as uzi on(uzi.id=ces.student))
as vector on(vector.course=uuu.id) order by -vector.mark,vector.course  fetch first 5 row only) as zzz) as ggggggg;


select peo.unswid,peo.name into unswid,student_name from people peo where peo.id=i.id;


return next(unswid,student_name,course_records);
END LOOP;
END IF;
END;

$$ language plpgsql;
