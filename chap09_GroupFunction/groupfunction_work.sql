-- groupfuncrtion_work.sql;

/*
 * 그룹 함수 : 그룹 단위 집계/통계 구하는 함수
 * - 사용 칼럼 : 범주형(집단형) 칼럼
 */


-- 1. 그룹 함수
/*
SUM 그룹의 누적 합계를 반환
AVG 그룹의 평균을 반환
COUNT 그룹의 총 개수를 반환
MAX 그룹의 최대값.을 반환
MIN 그룹의 최소값.을 반환
STDDEV 그룹의 표준편차(standard deviation)를 반환
VARIANCE 그룹의 분산을 반환 */

--1) sum()   숫자로된 여러개의 레코드를 다 더해서 하나의 상수로 변환
select sum(sal) from emp;
select sum(comm) from emp;      --이때  null 무시 

--2) avg()     숫자로된 여러개의 레코드를 다 더하고 나눠서 평균을 구함
select avg(sal) from emp; 
select round(avg(sal),3) from emp;    --소수점 3자리까지 반올림
select avg(comm) from emp;      --이때 null을 무시하고 sum에 나누기 null이 아닌 레코드수로 나눔 
select sum(comm)/4 from emp;    --위아래 같음 
--이때 0으로 입력되어 있어도 null이 아니여서 연산에 넣어버린다.

--3) min/max() 
select min(sal) from emp;
select max(sal) from emp;
SELECT MAX(SAL), MIN(SAL) FROM EMP;
--문제1) 가장 최근에 입사한 사원의 입사일과 입사한지 가장 오래된 사원의 입사일 을 출력하는 쿼리문을 작성하시오. 
SELECT MAX(hiredate) 가장최근입사 , MIN(hiredate) 가장오래된입사 FROM EMP;    --날짜도 가능

--4) count : 조건을 만족시키는 행의 갯수  (null 제외)
select count(comm) from emp;          --4  comm을 받는 사람수
select count(hpage) from professor;   --4  hpage가 있는사람수
select count(*) from professor;       --16 행의개수
--문제2) 10번 부서 소속 사원중에서 커미션을 받는 사원의 수를 구해보시오.(EMP)
select count(comm) from emp where deptno = 10;
--문제2-2) 'SCOTT' 사원과 같은 부서에 근무하는 사원에 대한 급여 합계, 평균구하기
select *from emp;
select sum(sal), avg(sal) from emp
where deptno = 
(select deptno from emp where ename = 'SCOTT');    --scott라고하면 값이안나옴 무조건 칼럼에 쓰여있는대로 SCOTT로 입력
--내가하는연습  (두개가 같은 문구 만들기)
select avg(comm) from emp;
select sum(comm)/count(comm) from emp;

--5) 분산 variance() / 표준편차  stddev()  : 산포도
--분산 : (편차)^2 총합/ 변수의 갯수 = 편차제곱의 평균값
select variance(bonus) from professor;  --951.11
--표준편차 : 분산의 양의 제곱근
select stddev(bonus) from professor;    --30.84
--표준편차와 같은값
select sqrt(variance(bonus)) from professor;  --sqrt 루트로 만드는 함수식


-- 2. GROUP BY 절 : 범주형 칼럼(집단형)
-- 형식: SELECT 칼럼명 , 그룹함수 FROM 테이블명 WHERE 조건 ( 연산자 ) GROUP BY 칼럼명;
-- 동일한 집단별로 묶어서 집단별 집계를 구한다. 급여(연속형)같은경우는 사용해도 효과없다

SELECT DEPTNO FROM EMP GROUP BY DEPTNO;  --10,20,30   부서번호를 범주로 그룹을 만들었다.
--문제1) 각부서별로 급여의 합계와 평균 
select *from emp;
select deptno, sum(sal), avg(sal) from emp group by deptno;
--문제2) 각부서별로 급여의 최댓값과 최솟값
select deptno, max(sal), min(sal) from emp group by deptno;
--문제3) 교수테이블에서 직급별 교수의 평균 급여를 구하시오.(소수점 3자리에서 반올림)
select *from professor;
select position, round(avg(pay),3) as "급여의 평균"
from professor 
group by position;
--  !! 내가내는문제   이거를 큰값부터 순서대로 나열하시오.( ORDER BY desc사용해서 )
select position, round(avg(pay),3) as "급여의 평균"
from professor 
group by position
ORDER BY round(avg(pay),3) desc;   

--연습
select position, deptno, round(avg(pay),3) as "급여의 평균"
from professor 
group by position;  --오류 : 범주에 다른값들이 나와서 오류



-- 3. HAVING 절
/* 
 * SQL문에서 조건절
 * 1. SELECT *FROM 테이블명 WHERE 조건식;
 * 2. SELECT *FROM 테이블명 GROUP BY 칼럼명;
 * 3. SELECT *FROM 테이블명 GROUP BY 칼러명 HAVING 조건식; (그룹이있으면 WHERE 절 불가능)   */

SELECT DEPTNO, AVG(SAL) 
FROM EMP 
GROUP BY DEPTNO
HAVING AVG(SAL) >= 2000;    --조건을 급여의 평균이 2000이상인경우만 (30번부서는 급여가 1566이라서 출력 안됌)
--결과적으로 위아래 같음
SELECT DEPTNO, AVG(SAL) 
FROM EMP 
GROUP BY DEPTNO
HAVING DEPTNO IN (10,20);  --조건을 부서번호가 10번과 20번인경우만  
--예제1)  부서의 최대값과 최소값을 구하되 최대 급여가 2900이상인 부서만 출력한다. 
SELECT DEPTNO, MAX(SAL), MIN(SAL) 
FROM EMP 
GROUP BY DEPTNO
HAVING MAX(SAL) >= 2900;
--예제2) 부서의 최대값과 최소값을 구하되 최소 급여가 900이상인 부서만 출력한다.
SELECT DEPTNO, MAX(SAL), MIN(SAL) 
FROM EMP 
GROUP BY DEPTNO
HAVING MIN(SAL) >= 900;

--문제1) 학생 테이블에서 학년별로 몸무게 평균이 60 이상인 학년 조회하기  
SELECT GRADE, AVG(WEIGHT) FROM STUDENT
GROUP BY GRADE
HAVING AVG(WEIGHT) >=60;

--문제2) 교수 테이블에서 학과별 급여의 평균이 300 미만인 학과 조회하기 
SELECT *FROM PROFESSOR;  
SELECT DEPTNO, AVG(PAY) FROM PROFESSOR
GROUP BY DEPTNO
HAVING AVG(PAY)<300;


-- !!내가 내는 문제  여기에 과이름까지 입력하기
--(1)기존에 있는 테이블에서 dname 이라는 칼럼추가하고 내용 옮기기
--테이블생성
create table PROFESSOR04
AS
SELECT *FROM PROFESSOR;

create table DEPARTMENT04
AS
SELECT *FROM DEPARTMENT;
--필요없는 칼럼삭제
ALTER TABLE PROFESSOR04 DROP COLUMN EMAIL;
--테이블에 칼럼추가
ALTER TABLE PROFESSOR04 ADD(DNAME VARCHAR2(30));
-- DEPARTMENT 테이블에서 내용삽입 
UPDATE PROFESSOR04
SET DNAME = 
(SELECT DNAME FROM DEPARTMENT04 WHERE DEPTNO = 203)    --DEPTNO숫자 계속 변경
WHERE DEPTNO = 203; 

--확인
SELECT *FROM PROFESSOR04
ORDER BY DEPTNO;

--(2)decode 함수이용
create table PROFESSOR05
AS
SELECT *FROM PROFESSOR;

select profno, name, id, position, pay, bonus, deptno, 
decode(deptno,101,'컴퓨터공학과',102,'멀티미디어공학과',103,'소프트웨어공학과',
201,'전자공학과',202,'기계공학과',203,'화학공학과','문헌정보학과') dname from professor05;


--(3) join 사용    <프라이머리키 설정값만가능한지 랑 중복불가능은 어떻게하는지>
select *from professor;
select *from department;

create table professor06
as
select profno, name, id, position, pay, bonus, deptno from professor;
select *from professor06;

create table department06(
deptno number(3) not null,         
dname varchar(25) not null,       
foreign key(deptno) references professor06(deptno)
);

-----------------------------------------------------
create table professor07(
 profno number(4) not null,    
 name  varchar2(10) not null, 
 id  varchar2(15) not null,
 position varchar2 (15) not null, 
 pay number(3) not null,      
 bonus number(4) ,             
 deptno  number(3) primary key             
);
select *from professor07;

insert into professor07
values(1001,'조인형','captain','정교수',550,100,101);
insert into professor07
values (2001,'양선희','lamb1','전임강사',250,null,102);
insert into professor07
values (3001,'김도형','angel1004','정교수',530,110,103);
insert into professor07
values (4001,'심슨','simson','정교수',570,130,201);
insert into professor07
values (4003,'박원범','mypride','조교수',310,50,202);
insert into professor07
values (4005,'바비','standkang','정교수',500,80,203);
insert into professor07
values (4006,'전민','napeople','전임강사',220,null,301);
select *from professor07;

insert into professor
values (3002,'나한열','naone10','조교수',330,50,103);    --deptno 중복  오류

create table department07(
deptno number(3) not null,         
dname varchar(25) not null,       
foreign key(deptno) references professor07(deptno)
);

insert into department07 
values (101,'컴퓨터공학과');
insert into department07
values (102,'멀티미디어공학과');
insert into department07
values (103,'소프트웨어공학과');
insert into department07
values (201,'전자공학과');
insert into department07
values (202,'기계공학과');
insert into department07
values (203,'화학공학과');
insert into department07
values (301,'문헌정보학과');

select * from department07;

insert into department07
values (100,'컴퓨터정보학부');  

select p.profno, p.name, p.id, p.position, p.pay, p.bonus, p.deptno, d.dname
from professor07 p , department07 d     
where p.deptno = d.deptno ;

--(4)




--문제2) 교수 테이블에서 학과별 급여의 평균이 300 미만인 학과 조회하기 <decode는 안됌>
SELECT DEPTNO, DNAME, AVG(PAY) FROM PROFESSOR04
GROUP BY DEPTNO, DNAME 
HAVING AVG(PAY)<300;

SELECT DEPTNO, dname, AVG(PAY) FROM PROFESSOR05
GROUP BY DEPTNO,dname 
HAVING AVG(PAY)<300;                         --오류 dname 이 존재 x 
--해결 <단 dname 순서는 안됌>
SELECT DEPTNO, decode(deptno,101,'컴퓨터공학과',102,'멀티미디어공학과',103,'소프트웨어공학과',
201,'전자공학과',202,'기계공학과',203,'화학공학과','문헌정보학과') dname , AVG(PAY) FROM PROFESSOR05
GROUP BY DEPTNO
HAVING AVG(PAY)<300; 







