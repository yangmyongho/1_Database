-- step02_join_work.sql

/*
 * 카티전 조인 (cartesian join)
 *  - 물리적 join 없이 논리적으로 테이블을 연결하는 기법(공통 칼럼 기준)
 * - [종류]
 *  1. inner join
 *   - 조인 대상의 테이블에 모두 데이터가 존재하는 경우
 *  2. outer join
 *   - 두 개의 테이블 중 하나의 테이블에 데이터가 존재하는 경우
 *   - left outer join, roght outer join, full outer join
 */

============================================================================================================================================
-- 1. inner join : 학생(student) vs 학과(department)
select *from student;        --주전공(deptno1)
select *from department;     --학과번호(deptno)
--학생(이름,주전공),학과(학과이름)  : 20개 테이블 에 null 이없어야함 
select s.name, s.deptno1, d.dname
from student s, department d      --두 테이블에 null 없음
where s.deptno1 = d.deptno;       --join조건
--학과번호로 정렬
select s.name, s.deptno1, d.dname
from student s, department d
where s.deptno1 = d.deptno
order by d.deptno; 
-- ANSI 표준 : inner join (표준이므로 오라클 뿐만아니라 어디서도 사용가능)
select s.name, s.deptno1, d.dname
from student s inner join department d                -- ,대신에 서로를 inner join 으로 연결
on s.deptno1 = d.deptno;                              -- where 대신에 on 으로변경

--!! 어제한거이걸로해보기

-- 문제1) 학생 테이블과 교수 테이블 조인
-- <조건1> join 칼럼 : 교수번호(profno) 
-- <조건2> 이름(s), 학과번호(s), 교수명(p), 교수번호(p)
select *from student;     --20명학생
select *from professor;   --16명교수
select s.name, s.deptno1, p.name, p.profno  --15개의 결과물
from student s, professor p
where s.profno = p.profno
order by p.profno;

-- 문제2) 문제1의 결과에서 101학과 학생만 검색되도록 하시오.
select s.name, s.deptno1, p.name, p.profno 
from student s, professor p
where s.profno = p.profno and s.deptno1=101
order by p.profno;

-- 2개 이상 테이블 join : 학생, 학과, 교수
-- join 조건 : 학생 - deptno(1) - 학과, 학생 - profno - 교수
select s.name as "학생명", d.dname as 학과명, p.name 교수명
from student s, department d, professor p
where s.deptno1 = d.deptno and s.profno = p.profno;

=========================================================================================================================================
-- 2. outer join 

--1)left outer join : 학생(기준) vs 교수  <기준이없는부분에 + 를써준다>
-- join 조건 : 학생 - profno - 교수
select s.profno, s.name 학생명, p.name 교수명 --20개 결과물 (교수에데이터가 null이여도 결과나옴)
from student s, professor p
where s.profno = p.profno(+);     --교수에 데이터가없어도 기준의데이터로하겠다
--학생의 이름은 있는데 교수번호가없어도 결과 출력
--ANSI 표준 : outer join 
select s.profno, s.name 학생명, p.name 교수명 
from student s left outer join professor p       -- ,대신 left outer join 사용
on s.profno = p.profno(+);

--2) right outer join : 학생 vs 교수(기준)
select s.profno, s.name 학생명, p.name 교수명    --22개 결과물(전에 15개중에 담당학생이 없는 교수 7명추가)
from student s, professor p
where s.profno(+) = p.profno;   --오른쪽테이블이기준
--ANSI 표준 : outer join
select s.profno, s.name 학생명, p.name 교수명 
from student s right outer join professor p       -- ,대신 left outer join 사용
on s.profno(+) = p.profno;

--3) full outer join : 완전 외부 join = 완전 outer join
--퀴리문에선 이렇게하면 해석불가능 (오류)
select s.profno, s.name 학생명, p.name 교수명
from student s, professor p
where s.profno(+) = p.profno(+);  
--ANSI 표준 : outer join  <full outer join은 ANSI표준방법 밖에 못쓴다.>
select s.profno, s.name 학생명, p.name 교수명      --27개 결과물 (학생기준과 교수기준 전부 합침)
from student s full outer join professor p   
on s.profno = p.profno;
--이거는 inner join
select s.profno, s.name 학생명, p.name 교수명
from student s, professor p
where s.profno = p.profno;

















