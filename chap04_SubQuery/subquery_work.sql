-- subQuery_work.sql

/*
형식1)
main query  -> 2차실행
as
subquery;   -> 1차실행

형식2)  오늘수업에서 주로사용
main query 관계연산자 (sub query);  --()안에것을 최우선적으로해야함  
*/

--형식1)
create table dept01  -- main(2차)
as
select *from dept;   --sub(1차)      이명령어는 dept를 dept01 이라는 테이블로 새로 만들겠다  (이거 다시공부해보기)
select *from dept01; --내용(data) +구조(desc)

select *from dept01;
create table dept01
as
select deptno, dname from dept; 

drop table dept01 purge;
--애초에 create에는 where 불가능  칼럼명도없는데 조건이성립이안됌
create table dept01
where deptno =
select deptno from dept; 



--형식2) : main(dept) + sub(desc)
select *from emp;    --deptno(o), dname(x)
--TABLE JOIN(DEPT vs EMP)   SCOTT의 부서번호로 부서명 알아내기  JOIN이란 독립된 테이블을 연결시켜줌
select *from dept
where deptno =                                    --여기에나오는 =은관계연산자
(select deptno from emp where ename = 'SCOTT' );  --scott의 부서번호는 알수있지만 부서이름은 알수없다
--두개가 같은 결과가 나옴 ()안에 결과가 20이 나오기때문
select *from dept
where deptno = 20 

--서브쿼리의 장점 : emp테이블에서 검색한결과로 dept 테이블에서 답을 구함 (emp테이블에서는 부서번호는나오지만 부서이름은 나오지않음)


--1. 단일행 서브쿼리


--<실습1> SCOTT과 같은 부서에서 근무하는 사원의 이름과 부서 번호를 출력 하는 SQL 문을 작성해 보시오. main query(emp), sub query(emp)
/*main
관계연산자
(sub); */  --이런형식으로 만들기
select ename, deptno from emp
where deptno =
(select deptno from emp where ename = 'SCOTT');

--<실습2> SCOTT와 동일한 직속상관(MGR)을 가진 사원을 출력하는 SQL 문을 작성해 보시오. (EMP)
select *from EMP
where mgr =
(select mgr from emp where ename = 'SCOTT');  --scott 의 직속상관은 7566

--<실습3> SCOTT의 급여와 동일하거나 더 많이 받는 사원 명과 급여를 출력하 시오.(EMP)
select ename, sal from EMP
where sal >=
(select sal from emp where ename='SCOTT');

--<실습4> DALLAS에서 근무하는 사원의 이름, 부서 번호를 출력하시오. (서브쿼리 : DEPT01, 메인쿼리 : EMP)
select ename, deptno from EMP
where deptno =
(select deptno from dept01 where loc in 'DALLAS');    --질문!  in 이랑 = 차이점       답: in은 다중 , =은 단일 
--위아래 같음                                                                                        --따라서 단일에 in 을사용해도됌
select ename, deptno from EMP
where deptno in
(select deptno from dept01 where loc = 'DALLAS');     --단, 순서가 왜 역순으로 변하는지는 모름

--<실습5> SALES(영업부) 부서에서 근무하는 모든 사원의 이름과 급여를 출력하시오.(서브쿼리 : DEPT01, 메인쿼리 : EMP
select ename, sal from EMP
where deptno =
(select deptno from dept01 where dname = 'SALES');

--<문제> 연구부서(RESEARCH)에서 근무하는 모든 사원 정보를 출력하시오.
select *from EMP
where deptno = 
(select deptno from dept01 where dname = 'RESEARCH');


--2. 단일행 서브쿼리 (집합함수)


--sub쿼리 의 값이 단일로 나오면 단일행 서브쿼리
--평균 이상 급여 수령자 출력하기 
SELECT ENAME, SAL FROM EMP 
WHERE SAL > 
(SELECT AVG(SAL) FROM EMP);     --함수의 결과 단일하게 나옴 
--<문제>평균 이하 급여 수령자 출력하기 
SELECT ENAME, SAL FROM EMP 
WHERE SAL <=
(SELECT AVG(SAL) FROM EMP);

select sum(sal) from emp;                --함수뒤에는 숫자가 나와야한다


--3. 다중행 서브쿼리(IN, ANY, ALL)


--1) IN (list)
SELECT ENAME, SAL, DEPTNO FROM EMP 
WHERE DEPTNO 
in
(SELECT DISTINCT DEPTNO FROM EMP WHERE SAL>=3000);  
-- = 단일쿼리로표현  결과는 동일
SELECT ENAME, SAL, DEPTNO FROM EMP 
WHERE DEPTNO IN (10,20);
--<실습1> 직급(JOB)이 MANAGER인 사람이 속한 부서의 부서 번호와 부서명과 지역을 출력하시오.(DEPT01과 EMP 테이블 이용)
select deptno, dname, loc from dept01
where deptno 
in
(select deptno from emp where job = 'MANAGER');
-- 위아래 같음   deptno, dname, loc = *전부라서
select *from dept01
where deptno 
in
(select deptno from emp where job = 'MANAGER');


--최댓값 최솟값 개념이 아니라 모두만족 , 하나라도포함 개념으로 이해

--2) ALL : 서브쿼리의 최댓값 이상 검색 (나온값을 모두 만족해야함)(AND 와 비슷)
--(950~2850)
SELECT ENAME, SAL FROM EMP 
WHERE SAL 
> ALL                                     --최댓값(2850)보다 큰 값 
(SELECT SAL FROM EMP WHERE DEPTNO =30); 

SELECT ENAME, SAL FROM EMP 
WHERE SAL 
< ALL                                     --최솟값(950)보다 작은 값 
(SELECT SAL FROM EMP WHERE DEPTNO =30);   --800하나

--3) ANY : 서브쿼리의 최솟값 이상 검색 (나온값을 하나라도 만족해도됌)(OR 과 비슷)
----(950~2850)
SELECT ENAME, SAL FROM EMP 
WHERE SAL 
> ANY                                     --최솟값(950)보다 큰값
(SELECT SAL FROM EMP WHERE DEPTNO =30);

SELECT ENAME, SAL FROM EMP 
WHERE SAL 
< ANY                                     --최댓값(2850)보다 작은값
(SELECT SAL FROM EMP WHERE DEPTNO =30);



--연습
SELECT ENAME, SAL FROM EMP 
WHERE SAL 
in                                     --최댓값(2850)보다 큰 값 
(SELECT SAL FROM EMP WHERE DEPTNO =30);

select *from dept01
where deptno 
> ANY
(select deptno from emp where job = 'MANAGER');

--오류  =은단일값에쓰는데 sub값이 현재 다중이여서
SELECT ENAME, SAL, DEPTNO FROM EMP 
WHERE DEPTNO 
=
(SELECT DISTINCT DEPTNO FROM EMP WHERE SAL>=3000); 
--any사용
SELECT ENAME, SAL, DEPTNO FROM EMP 
WHERE DEPTNO 
> any
(SELECT DISTINCT DEPTNO FROM EMP WHERE SAL>=3000);   --10 또는 20 초과인거 (즉 10 초과인거)
--all사용
SELECT ENAME, SAL, DEPTNO FROM EMP 
WHERE DEPTNO 
> all
(SELECT DISTINCT DEPTNO FROM EMP WHERE SAL>=3000);   --10과20 초과인거 (즉 20 초과인거)



