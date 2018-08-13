-- COMP9311 18s1 Project 1
--
-- MyMyUNSW Solution Template


-- Q1:
create or replace view Q1(unswid, name)
as
--... SQL statements, possibly using other views/functions defined by you ...
select distinct unswid,name from (students stu join people peo on(peo.id=stu.id))
where stu.stype = 'intl' and (select count(y.mark) from (select x.mark from course_enrolments x where x.mark>=85  and x.student = peo.id) as y) > 20;





-- Q2:
create or replace view Q2(unswid, name)
as
--... SQL statements, possibly using other views/functions defined by you ...
select distinct g.unswid,g.longname from (select * from (rooms r join room_types t on(r.rtype = t.id)))
as g join buildings b on (g.building = b.id) where b.name='Computer Science Building' and g.description = 'Meeting Room' and g.capacity>=20 ;



-- Q3:
create or replace view Q3(unswid, name)
as
--... SQL statements, possibly using other views/functions defined by you ...
select unswid,name from people where id in (select staff from course_staff where course in(select course from course_enrolments where student in (select id from people where name='Stefan Bilek')))
;



-- Q4:
create or replace view Q4(unswid, name)
as
--... SQL statements, possibly using other views/functions defined by you ...
select unswid,name from people where id in
(select student from course_enrolments where course in(select id from courses where subject in (select id from subjects where code='COMP3331'))
EXCEPT
select student from course_enrolments where course in(select id from courses where subject in (select id from subjects where code='COMP3231')));




-- Q5:
create or replace view Q5a(num)
as
--... SQL statements, possibly using other views/functions defined by you ...
select count(*) from students where id in (select student from Program_enrolments where id in (select partOf from Stream_enrolments where stream in (select id from streams where name='Chemistry'))
and semester in (select id from Semesters where name='Sem1 2011')) and stype='local';



-- Q5:
create or replace view Q5b(num)
as
--... SQL statements, possibly using other views/functions defined by you ...
select count(*) from students where id in (select student from Program_enrolments where program in
(select id from programs where offeredBy in (select id  from orgunits where longname = 'School of Computer Science and Engineering'))
and semester in (select id from Semesters where name='Sem1 2011')) and stype='intl'
;



-- Q6:
create or replace function
	Q6(text) returns text
as
$$
--... SQL statements, possibly using other views/functions defined by you ...
select code||' '||name||' '||uoc from subjects where code = $1
$$ language sql;



-- Q7:
create or replace view Q7(code, name)
as
--... SQL statements, possibly using other views/functions defined by you ...

select code,name from programs where id in (
select id from (
select cast(c1 as float)/cast(c2 as float) as percentage, pp as id from
(select count(id) as c1, p as pp from
(students s join (select student as s, program as p from program_enrolments pe join programs p on (p.id=pe.program)) as t on (t.s = s.id)) as r
where r.stype = 'intl' and exists
(select s from (select  student as s, program as p from program_enrolments pe join programs p on (p.id=pe.program)) as t where p = r.p and s = id) group by p) as u
join
(select count(id) as c2, p from (students s join (select  student as s, program as p from program_enrolments pe join programs p on (p.id=pe.program)) as t on (t.s = s.id)) as r
where exists (select s from (select student as s, program as p from program_enrolments pe join programs p on (p.id=pe.program)) as t where p = r.p and s = id) group by p) as v
on (u.pp = v.p)) as q where percentage > 0.5);



-- Q8:
create or replace view Q8(code, name, semester)
as
--... SQL statements, possibly using other views/functions defined by you ...
select s.code,s.name,se.name from subjects s,semesters se where s.id in (select subject from courses where id in(
select x.course from (
select count(t.mark),t.course,avg(t.mark) from
(select q.course,q.mark from (select ce.mark,ce.course from course_enrolments ce where ce.mark is not null)
as q join courses c on(c.id=q.course)) as t group by t.course) as x where x.count > 15 order by x.avg desc fetch first 1 row only))  and se.id in (
select semester from courses where id in(
select x.course from (
select count(t.mark),t.course,avg(t.mark) from
(select q.course,q.mark from (select ce.mark,ce.course from course_enrolments ce where ce.mark is not null)
as q join courses c on(c.id=q.course)) as t group by t.course) as x where x.count > 15 order by x.avg desc fetch first 1 row only));



-- Q9:
create or replace view Q9(name, school, email, starting, num_subjects)
as
--... SQL statements, possibly using other views/functions defined by you ...
select zzzz.name,zzzz.longname,zzzz.email,zzzz.starting,ccccc.count from
(select xxx.name,opp.longname,xxx.email,opp.starting,xxx.id from(
select p.name,p.email,p.id from people p where p.id in (
(select distinct z.staff from
(select staff from
(select count(x.staff),x.staff from
(select staff,orgunit,role from Affiliations where role in (select id from Staff_roles where name = 'Head of School') and ending is null and isprimary ='t') as x group by x.staff) as y where y.count = 1) as z join course_staff c on (z.staff = c.staff))))
as xxx join
(select pp.staff,o.longname,pp.starting from (
select orgunit,staff,starting from Affiliations where staff in (
select distinct z.staff from
(select staff from
(select count(x.staff),x.staff from
(select staff,orgunit,role from Affiliations where role in (select id from Staff_roles where name = 'Head of School') and ending is null and isprimary ='t') as x group by x.staff) as y where y.count = 1) as z join course_staff c on (z.staff = c.staff))
and ending is null and isprimary='t' and role in (select id from Staff_roles where name = 'Head of School'))as pp join orgunits o on (pp.orgunit=o.id)) as opp on (opp.staff=xxx.id)) as zzzz join

(select count(distinct ss.code),ggg.staff from
(select g.staff,cc.subject from (
select distinct z.staff,c.course from
(select staff from
(select count(x.staff),x.staff from
(select staff,orgunit,role from Affiliations where role in (select id from Staff_roles where name = 'Head of School') and ending is null and isprimary ='t') as x group by x.staff) as y where y.count = 1) as z join course_staff c on (z.staff = c.staff)) as g
join courses cc on (g.course = cc.id)) as ggg join subjects ss on (ss.id=ggg.subject) group by ggg.staff) as ccccc on (ccccc.staff=zzzz.id);





-- Q10:
create or replace view Q10(code, name, year, s1_HD_rate, s2_HD_rate)
as
--... SQL statements, possibly using other views/functions defined by you ...
select  abc.code,abc.name,substring(cast(abc.year as text) from 3 for 4),xyz.s1_term,abc.s2_term from
(select qqq.id,qqq.code,qqq.name,qqq.year,qqq.numeric as s1_term from
(select gggg.id,gggg.code,gggg.name,gggg.year,gggg.term, cast(cast(COALESCE(gggg.hd_mark,0) as float)/cast(gggg.mark as float) as numeric(4,2)) from
(select  xiaomi.id,xiaomi.code,xiaomi.name,xiaomi.year,xiaomi.term,xiaomi.mark,huawei.hd_mark from
(select apple.id,apple.code,apple.name,apple.year,apple.term,count(co.mark) as hd_mark from
(select lenovo.id,lenovo.code,se.year,se.term,lenovo.name from
(select c.id,z.code,c.semester,z.name from
(select ss.id,ss.code,ss.name from
(select q.code,q.name,count(c.semester) from
(select id,name,code from subjects where code like 'COMP93%') as q join courses c on (c.subject=q.id) group by q.code,q.name) as g join subjects ss on (ss.code = g.code) where g.count >=24) as z
join courses c on (c.subject = z.id)) as lenovo join semesters se on  (se.id = lenovo.semester)) as apple join course_enrolments  co on (co.course = apple.id) where co.mark >= 85
group by apple.id,apple.code,apple.year,apple.term,apple.name) as huawei right join

(select apple.id,apple.code,apple.name,apple.year,apple.term,count(co.mark) as mark from
(select lenovo.id,lenovo.code,se.year,se.term,lenovo.name from
(select c.id,z.code,c.semester,z.name from
(select ss.id,ss.code,ss.name from
(select q.code,q.name,count(c.semester) from
(select id,name,code from subjects where code like 'COMP93%') as q join courses c on (c.subject=q.id) group by q.code,q.name) as g join subjects ss on (ss.code = g.code) where g.count >=24) as z
join courses c on (c.subject = z.id)) as lenovo join semesters se on  (se.id = lenovo.semester)) as apple join course_enrolments  co on (co.course = apple.id) where co.mark >= 0
group by apple.id,apple.code,apple.year,apple.term,apple.name) as xiaomi on (huawei.id=xiaomi.id)) as gggg) as qqq where qqq.term='S1') as xyz

join

(select qqq.id,qqq.code,qqq.name,qqq.year,qqq.numeric as s2_term from
(select gggg.id,gggg.code,gggg.name,gggg.year,gggg.term, cast(cast(COALESCE(gggg.hd_mark,0) as float)/cast(gggg.mark as float) as numeric(4,2)) from
(select  xiaomi.id,xiaomi.code,xiaomi.name,xiaomi.year,xiaomi.term,xiaomi.mark,huawei.hd_mark from
(select apple.id,apple.code,apple.name,apple.year,apple.term,count(co.mark) as hd_mark from
(select lenovo.id,lenovo.code,se.year,se.term,lenovo.name from
(select c.id,z.code,c.semester,z.name from
(select ss.id,ss.code,ss.name from
(select q.code,q.name,count(c.semester) from
(select id,name,code from subjects where code like 'COMP93%') as q join courses c on (c.subject=q.id) group by q.code,q.name) as g join subjects ss on (ss.code = g.code) where g.count >=24) as z
join courses c on (c.subject = z.id)) as lenovo join semesters se on  (se.id = lenovo.semester)) as apple join course_enrolments  co on (co.course = apple.id) where co.mark >= 85
group by apple.id,apple.code,apple.year,apple.term,apple.name) as huawei right join

(select apple.id,apple.code,apple.name,apple.year,apple.term,count(co.mark) as mark from
(select lenovo.id,lenovo.code,se.year,se.term,lenovo.name from
(select c.id,z.code,c.semester,z.name from
(select ss.id,ss.code,ss.name from
(select q.code,q.name,count(c.semester) from
(select id,name,code from subjects where code like 'COMP93%') as q join courses c on (c.subject=q.id) group by q.code,q.name) as g join subjects ss on (ss.code = g.code) where g.count >=24) as z
join courses c on (c.subject = z.id)) as lenovo join semesters se on  (se.id = lenovo.semester)) as apple join course_enrolments  co on (co.course = apple.id) where co.mark >= 0
group by apple.id,apple.code,apple.year,apple.term,apple.name) as xiaomi on (huawei.id=xiaomi.id)) as gggg) as qqq where qqq.term='S2') as abc on (abc.year = xyz.year and abc.name=xyz.name) order by abc.name desc;
