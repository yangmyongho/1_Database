-- select_work.sql

/*
여러줄의 주석문
*/

select *from tab;

--전체 칼럼 조회
select *from emp;  --  *은 전체 칼럼을 조회할때 사용한다 열 의미 
--특정 칼럼 조회
select empno, ename, sal, job from emp;  --*자리에 보고싶은 칼럼명 입력하면됌
--특정 칼럼 조회중 산술적 표현 사용
select ename, sal, sal+300 from emp;     --숫자의 의미를 가진 칼럼에만 산술적 표현 사용가능
--문제1)전체 모든 사원들에 대해 급여 10%인상
select ename, sal, sal*1.1 from emp;
--문제2)수당의 0.01을 급여와 더한다(이때 null값은 null로 표현된다.)
select empno, ename, sal, comm,sal+comm/100 from emp;

--null값을 처리하려면 null값을 0 으로 변환한뒤에 계산
--NVL(null이들어있는 칼럼, null값을 바꾸려는 값) 
select empno, ename, sal, comm, sal+comm/100+NVL(comm,0) from emp;  --null값이 여전히 존재해서 오류
select empno, ename, sal, comm, sal+NVL(comm,0)/100 from emp;  --맞는식
--문제)null 처리 함수 이용 : 연봉 + 수당
select ename, sal, comm, sal*12+NVL(comm,0) from emp;
--수식 sal*12+NVL(comm,0) 은 이름지정이 안되어있으므로 이름(별칭)지어주기 (Alias)
select ename, sal, comm, sal*12+NVL(comm,0) as 실급여 from emp;     --as는 Alias 의 약자
select ename, sal, comm, sal*12+NVL(comm,0) as 실 급 여 from emp;   --별칭에 공백,특수문자안됌
select ename, sal, comm, sal*12+NVL(comm,0) as "실 급 여" from emp;  --그럴때는 "" 사용
select ename, sal, comm, sal*12+NVL(comm,0) 실급여 from emp;        --as 생략가능
select ename as 이름, sal 급여 from emp;                             --칼럼뒤에 순서대로 별칭 입력

--연결 연산자 (||) 칼럼과 칼럼의 결과를 연결시켜줌
select ename ||' '|| job from emp;  --이름과 직업사이에 띄어쓰기 한개로 연결
select ename ||'~'|| job from emp;  --이름과 직업사이에 ~로 연결
select ename ||' '|| job as "employess" from emp;  --연결시킨 칼럼을 별칭만들어줌
select ename ||' '|| job employess from emp;    --as 생략가능 한데 대문자로 변경됌

--DISTINCT : 범주(집단)형 칼럼 (gender) 적용 
select job from emp;  --직업이라는칼럼 보여줌
select distinct job from emp;  --직업칼럼에서 겹치는 내용삭제
select deptno, job from emp;   --범주하기전
select distinct deptno, job from emp;  --우선 부서를 먼저 범주하고 그부서안에서 직업을 범주함











