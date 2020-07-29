/*
 * 주요 함수 
 * 작업 대상 테이블 : STUDENT, EMP, PROFESSOR 
 */

--Q1. STUDENT 테이블에서 JUMIN 칼럼을 사용하여 
-- 태어난 달이 8월인 사람의 이름과 생년월일 출력하기
-- 힌트 : substr() 함수 이용
select *from student;  
--연습:
select name, birthday from student 
where substr(BIRTHDAY,4,2)=08;        --여기에 왜 4가 들어가는지(1975뒤에 - 이것도 하나로 세서 4번째로해야함)
select name, birthday from student 
where substr(BIRTHDAY,5,1)=8; 
--정답: 
select name, birthday from student 
where substr(jumin,3,2)=8;
select name, birthday from student 
where substr(jumin,4,1)=8;

--Q2. EMP 테이블에서 사번이 홀수인 사람들을 검색하기
-- 힌트 : mod() 함수 이용
select *from emp; 
select *from emp
where mod(empno,2)=1;

--Q3. Professor 테이블에서 교수명, 급여, 보너스, 연봉을 출력하기 
-- 조건) 연봉 = pay*12+bonus 으로 계산, bonus가 없으면 bonus 0 처리
-- 힌트 : nvl2() 함수 이용
select *from professor;
select name, pay as 급여, bonus 보너스,                  --별칭 쓸때 as 는 써도되고안써도되지만 ''는 사용하면 오류뜸 !! ''는별칭에사용 x ""사용
nvl2(bonus,pay*12+bonus,pay*12) 연봉 from professor;    --nvl2(여기에 bonus 라고 쓰는이유 보너스 칼럼에 null값이 있기때문)

--Q4. Professor 테이블에서 교수명, 학과명을 출력하되 
--  deptno가 101번이면 ‘컴퓨터 공학과’, 102번이면 
-- ‘멀티미디어 공학과’, 103번이면 ‘소프트웨어 공학과’, 
-- 나머지는 ‘기타학과’로 출력하기
-- decode()함수 이용
select *from professor;
select name, decode(deptno,101,'컴퓨터 공학과',
                    102,'멀티미디어 공학과',
                    103,'소프트웨어 공학과',
                    '기타학과') 학과명
from professor;
