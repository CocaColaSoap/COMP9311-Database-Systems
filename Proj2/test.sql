drop type if exists CourseRecord cascade;
create type CourseRecord as (unswid integer, student_name text, course_records text);

create or replace function Q3(org_id integer, num_courses integer, min_score integer)
  returns setof CourseRecord
as $$
--... SQL statements, possibly using other views/functions defined by you ...
declare i record;
declare v_counter  integer default 1;
declare unswid integer;
declare student_name text;
declare course_records text;
BEGIN
for i in select qqqq.student  as id from
(select ce.student,count(ce.course),max(mark) from course_enrolments ce join
(select gaygay.id,gaygay.code,gaygay.name,gaygay.school,s.name as semester from semesters s join
(select c.id,c.semester,ggg.code,ggg.name,ggg.school from courses c join
(select s.id,s.code,s.name,gg.name as school from subjects s join
(select org.id,org.name from orgunits org join
(select * from (with recursive xxx as (select id from orgunits where id =52 union select og.member as id from orgunit_groups og join xxx on xxx.id = og.owner)select * from xxx) as q) as g
on g.id=org.id) as gg
on  (gg.id=s.offeredBy)
) as ggg  on (c.subject=ggg.id)) as gaygay on (gaygay.semester=s.id)) as uuu on (uuu.id=ce.course) group by student) as qqqq where qqqq.count>35 and qqqq.max>=100

LOOP

  WHILE v_counter <= 5 LOOP
    select
    uuu.code||', '||uuu.name||', '||uuu.semester||', '||uuu.school||', '||vector.mark into course_records
    FROM
    (select gaygay.id,gaygay.code,gaygay.name,gaygay.school,s.name as semester from semesters s join
    (select c.id,c.semester,ggg.code,ggg.name,ggg.school from courses c join
    (select s.id,s.code,s.name,gg.name as school from subjects s join
    (select org.id,org.name from orgunits org join
    (select * from (with recursive xxx as (select id from orgunits where id =52 union select og.member as id from orgunit_groups og join xxx on xxx.id = og.owner)select * from xxx) as q) as g
    on g.id=org.id) as gg
    on  (gg.id=s.offeredBy)
    ) as ggg  on (c.subject=ggg.id)) as gaygay on (gaygay.semester=s.id)) as uuu
    join
    (select uzi.id,uzi.unswid,uzi.name,ces.course,ces.mark from course_enrolments ces join
    (select peo.id,peo.unswid,peo.name from people peo where peo.id=i.id) as uzi on(uzi.id=ces.student))
    as vector on(vector.course=uuu.id) order by -vector.mark,vector.course desc;
    v_counter :=v_counter + 1;
    RAISE NOTICE '11';
  END LOOP;
  v_counter := 1;
  select peo.unswid,peo.name into unswid,student_name from people peo where peo.id=i.id;


return next(unswid,student_name,course_records);
END LOOP;

END;

$$ language plpgsql;
