-- <연습문제2>
-- 문1) sal이 3000이상인 사원의 empno, ename, job, sal 출력 
select empno, ename, job, sal from emp where sal >=3000;
-- 문2) empno가 7788인 사원의 ename, deptno, empno 출력 
select ename, deptno, empno from emp where empno in 7788;
select ename, deptno, empno from emp where empno = 7788;
select ename, deptno, empno from emp where empno in (7788);                     --in,==둘다 사용가능하고 ()생략가능
-- 문3) sal이 1500이상이고 deptno가 10,30인 사원의 ename과 sal를 출력
select ename, sal from emp where sal >= 1500 and  deptno in (10,30);
-- 문4) hiredate가 1982년 입사한 사원의 모든 정보 출력(힌트 : between ~ and ~) 
select *from emp where hiredate between to_date('1982.01.01','yyyy,mm,dd') and to_date('1982.12.31','yyyy,mm,dd');
select *from emp where hiredate between '1982.01.01' and '1982.12.31';
select *from emp where hiredate like '82%';
-- 문5) comm에 NULL이 아닌 사원의 모든 정보를 출력(힌트 : is not null)
select *from emp where comm is not null;
-- 문6) comm이 sal보다 10%가 많은 모든 사원에 대하여 ename,sal,comm 출력 
select ename, sal, comm from emp where comm > sal*1.1;
-- 문7) job이 CLERK이거나 ANALYST이고 sal이 1000,3000,5000이 아닌 모든 사원 출력(힌트 : in, not in)
select *from emp where job in ('CLERK','ANALYST') and sal not in ('1000','3000','5000');
select *from emp where job in ('CLERK') or job in ('ANALYST') and sal not in ('1000','3000','5000');
-- 문8) ename에 L이 두 자가 있고 deptno가 30이거나 또는 mgr이 7782인 모든 사원 출력(힌트 : like)
select *from emp where ename like 'L%L' and deptno = 30 or mgr = 7782;
select *from emp where ename like '%L%L%' and deptno = 30 or mgr = 7782;