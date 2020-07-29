-- select_work.sql

/*
여러줄의 주석문
*/

select *from tab;  --커리문의 명령어는 대문자,소문자 상관없다


--2. 전체 검색(특정 컬럼 검색)


--전체 컬럼 조회
SELECT * FROM emp;  --*은 전체 컬럼을 조회할떄 사용한다 열 의미
--특정 칼럼 조회
SELECT empno, ename, sal, job FROM emp;  --*자리에 보고싶은 컬럼명을 입력하면 됌
--특정 칼럼 조회중 산술적 표현 사용
SELECT ename, sal, sal+300  FROM emp;  --숫자의 의미를 가진 컬럼에만 산술적 표현 사용가능
--전체 모든사원들에대해 급여 10%인상
select ename, sal, sal*1.1 from emp;

SELECT empno, ename, sal, comm, sal+comm/100 FROM emp;  --수당의 0.01을 급여와 더한다 
                                        --(이때 null값은 사칙연산이 안되므로 null로 결과가나온다)
--null처리가능  null값을 0으로 변환한뒤에 계산
SELECT empno, ename, sal, comm, sal+comm/100+NVL(comm,0) FROM emp;  --틀린식
SELECT empno, ename, sal, comm, sal+NVL(comm,0)/100 FROM emp;  --맞는식

--null 처리 함수 이용 : 연봉+수당
SELECT ename,sal,comm,sal*12+NVL(comm,0) FROM emp;  --맞는식

--수식 sal*12+NVL(comm,0) 이런것은 컬럼의 이름이 지정이 안되어있으므로 이름지우기 (별칭)
--열에 별칭(Alias) 부여
SELECT ename,sal,comm,sal*12+NVL(comm,0) as 실급여 FROM emp;  --as 는 Alias의 약자
SELECT ename,sal,comm,sal*12+NVL(comm,0) as 실 급 여 FROM emp;  --별칭에 공백,특수문자가있을경우는 ""사용
SELECT ename,sal,comm,sal*12+NVL(comm,0) as "실 급 여" FROM emp;  
SELECT ename,sal,comm,sal*12+NVL(comm,0) 실급여 FROM emp;  --as 생략가능
SELECT ename AS 이름, sal 급여 FROM emp;  --as 를 생략해도 순서대로 별칭입력

--연결 연산자 (||)  컬럼과켤럼의 결과를 연결시켜줌
select ename || ' ' || job from emp;   --이름과 직업사이에 띄어쓰기 하나로 연결
select ename || '~' || job from emp;   --이름과 직업사이에 ~로 연결
SELECT ename || ' ' || job AS "employees" FROM emp;  --연결시킨 컬럼의 별칭지어줌
-- a ||'~'|| b ||'~' from  이거처럼 뒤에 연결할게 없으면 || 쓰지않기

--''과""의 특징 확인  ''은 문자나 숫자  ""는 별칭에사용
SELECT ename || ' ' || 'is a' || ' ' || job AS "employees Details" FROM emp;

--DISTINCT : 범주(집단)형 컬럼 (gender) 적용 
Select job from emp;  --전체직업을 보여줌
select distinct job from emp;  --겹치지않는 직업종류를 보여줌
--1차 칼럼 -> 2차 칼럼
SELECT deptno, job FROM emp;  --원래의것
SELECT DISTINCT deptno, job FROM emp;  --부서를 먼저 범주하고 그다음 직업을보여줌 20번부서에서 한직업씩만보여줌


--2. 조건 검색(특정 행 검색)


--비교연산자
SELECT empno, ename, job, sal FROM emp WHERE sal >= 3000;  --급여가 3000이상인 직원  where 뒤에 조건 sal >= 3000 을 넣어줌
--띄어쓰기 가능
SELECT empno, ename, job, sal FROM emp 
WHERE sal >= 3000;

--문자 literal : 문자 칼럼, 날짜 칼럼
SELECT empno, ename, job, sal, deptno FROM emp 
WHERE job = 'MANAGER';  --직책이 관리자인 칼럼만 검색   (manager은 문자칼럼)  또한 문자 상수안에서는 대문자 소문자 구별해야한다
SELECT empno, ename, job, sal, deptno FROM emp 
WHERE job = 'manager';  --결과값이 일치하는 값이 없다고 나옴
SELECT empno, ename, job, sal, deptno FROM emp 
WHERE job <> 'MANAGER';  --직업이 manager가 아닌 칼럼 검색

select empno,ename,job,sal,hiredate,deptno from emp 
where hiredate >= to_date('1982/01/01', 'yyyy/mm/dd'); 
--문자상수를 날짜형식로 형변환해주는 함수 to_date (앞에가'문자상수', 뒤에가'날짜형식') 
--날짜는 숫자로 인식해서 비교연산 가능

-- SQL 연산자
SELECT ename, job, sal, deptno FROM emp 
WHERE sal BETWEEN 1300 AND 1500;  --급여가 1300~1500인 사람 검색  (between a and b 과같은 SQL연산자는  관계연산자로 풀어쓸수있음)

-- 관계/논리 연산자
SELECT ename, job, sal, deptno FROM emp 
WHERE sal >= 1300 and sal <= 1500;      --결과는 같은 급여가 1300~1500인 사람 검색 

-- IN 연산자
SELECT empno,ename,job,sal,hiredate FROM emp   --조건에 맞는 칼럼만 검색
WHERE empno IN (7902,7788,7566);  

-- 관계/논리 연산자    1982년도에 입사한 직원검색
SELECT empno,ename,job,sal,hiredate,deptno FROM emp 
where hiredate >= to_date('1982/01/01', 'yyyy/mm/dd') 
and hiredate <= to_date('1982/12/31', 'yyyy/mm/dd');  --between 대신에 관계연산자로 조건을 부여
--between a and b 로 적용
SELECT empno,ename,job,sal,hiredate,deptno FROM emp 
where hiredate between to_date('1982/01/01', 'yyyy/mm/dd') 
and to_date('1982/12/31', 'yyyy/mm/dd');

-- LIKE 연산자  조건을 포함하는 검색  (%문자가 없거나 하나이상인 문자를 대체)
SELECT empno,ename,job,sal,hiredate,deptno FROM emp 
where hiredate LIKE '82%';            --입사년도에 82가 포함되는 사람 검색
SELECT empno,ename,job,sal,hiredate,deptno FROM emp 
where hiredate LIKE '87%';           --입사년도에 87이 포함되는 사람 검색

select *from emp where ename like 'M%';   --이름이 M으로 시작 사람검색

-- 서재수 검색
select *from student where name like '서%';   --서로 시작하는이름 검색
select *from student where name like '%재%';   --가운데가 재인 이름 검색
select *from student where name like '%수';     --끝이 수로 끝나는 이름 검색

-- is null 연산자
SELECT empno,ename,job,sal,comm,deptno FROM emp 
WHERE comm IS NULL;                              --수당이없는사람 검색
SELECT empno,ename,job,sal,comm,deptno FROM emp 
WHERE comm IS not NULL;                          --수당이있는사람 검색  (수당이 0이여도 null이 아니므로 검색이가능)

-- 관계/논리 연산자 (and,or,not)
SELECT empno,ename,job,sal,hiredate,deptno FROM emp 
WHERE sal >= 1100 AND job = 'MANAGER';             --급여가 1100이상이고 직업이 manager인 사람검색

--문제1) 부서번호 (deptno)가 10번이고, 급여가 2500 이상인 사원 검색
select *from emp 
where sal >= 2500 and deptno = '10';

--문제2)직책(job)이 사원(CLERK)이거나 부서번호(deptno)가 30인 사원 검색
select *from EMP
where job = 'CLERK' or deptno = '30';

SELECT empno,ename,job,sal,deptno FROM emp 
WHERE job NOT IN ('MANAGER','CLERK','ANALYST');  --직업이 manager,clerk,analyst 가 아닌 직업인사람 검색


--3. 검색 레코드 정렬


--order by  ,  order by~desc
SELECT hiredate,empno,ename,job,sal,deptno FROM emp 
ORDER BY hiredate;            -- default : 오름차순   
SELECT hiredate,empno,ename,job,sal,deptno FROM emp 
ORDER BY hiredate desc;        -- 내림차순
-- 별칭 이용 정렬
SELECT empno,ename,job,sal,sal*12 연봉 FROM emp 
ORDER BY 연봉;                                        --연봉(별칭) 이낮은사람부터 정렬
-- 수식 이용 정렬
SELECT empno,ename,job,sal,sal*12 annsal FROM emp 
ORDER BY sal*12;
-- 컬럼 위치 정렬
SELECT empno,ename,job,sal,sal*12 annsal FROM emp 
ORDER BY 5;                                          --empno부터 5번째  있는 컬럼을 오름차순 정렬하였다
-- 두개 이상 칼럼으로 정렬
SELECT deptno,sal,empno,ename,job FROM emp 
ORDER BY deptno, sal DESC;                           --1차정렬: 부서번호 오름차순   , 2차정렬:급여 내림차순 정렬
SELECT deptno,sal,empno,ename,job FROM emp 
ORDER BY deptno ASC, sal DESC;                       --ASC생략가능
--우선 deptno를 오름차순으로 정렬하고 그뒤에 sal을 내림차순으로 정렬





