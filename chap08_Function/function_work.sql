--function_work.sql


-- 1. 숫자 처리 함수 
/*
ABS 절대값을 구한다. 
COS COSINE 값을 반환한다. 
EXP e(2.71828183…)의 n승을 반환한다. 
LOG LOG값을 반환한다. 
SIN SINE값을 반환한다. 
TAN TANGENT값을 반환한다. 
ROUND 특정 자릿수에서 반올림한다. 
TRUNC 특정 자릿수에서 잘라낸다. (버림) 
MOD 입력 받은 수를 나눈 나머지 값을 반환한다*/

--1)ABS : 절대값
select -10, abs(-10) from dual;  --abs(-10)이 10으로 반환됌

--2)ROUND : 반올림
select 12.345, round(12.345,2) from dual;  --round(반올림할값,반올림할소수점자릿수)
select 12.345678, round(12.345678,3) from dual;  --12.346
select 34.5678, round(34.5678,-1) from dual;  (자릿수에서 - 가붙으면 정수자릿수)
select 3456.789, round(3456.789,-3) from dual;  --3000

--3)MOD : 나머지 값  (나눌칼럼,나눌값) 조건식에 사용가능                         --? (if(num % 2) == 0  이거  뭔말인지..
select mod(10,2), mod(27,2), mod(27,5) from dual;
select *from professor where mod(deptno,2)=0;  --학과번호를 2로 나눴을때 0이나오는값만 검색 = 학과번호가 짝수인경우
--실습) 사번이 홀수인 사람들을 검색해 보십시오.(EMP 테이블)
select *from emp where mod(empno,2)=1;
select *from emp where mod(empno,2)!=0;  --위아래같은의미 (0과 같지않은것)
select *from emp where mod(ename,2)=1;  --문자열은 나눌수없으므로 오류


-- 2. 문자 처리 함수
/*
LOWER 소문자로 변환한다. 
UPPER 대문자로 변환한다. 
INITCAP 첫 글자만 대문자로 나머지 글자는 소문자로 변환한다. 
CONCAT 문자의 값을 연결한다. 
SUBSTR 문자를 잘라 추출한다. (한글 1Byte) 
SUBSTRB 문자를 잘라 추출한다. (한글 2Byte) 
LENGTH 문자의 길이를 반환한다.(한글 1Byte) 
LENGTHB 문자의 길이를 반환한다.(한글 2Byte) 
LPAD, RPAD 입력 받은 문자열과 기호를 정렬하여 특정 길이의 문자열 로 반환한다. 
TRIM 잘라내고 남은 문자를 표시한다. 
CONVERT CHAR SET을 변환한다. 
CHR ASCII 코드 값으로 변환한다. 
ASCII ASCII 코드 값을 문자로 변환한다. 
REPLACE 문자열에서 특정 문자를 변경한다. */

--1) UPPER : 소문자 -> 대문자
SELECT 'Welcome to Oracle', 
UPPER('Welcome to Oracle') FROM DUAL; 
SELECT 'Welcome to Oracle', 
UPPER('홍길동') FROM DUAL;        --한글은 변환없이 그대로 출력
--실습) 'manager'로 검색하고 직책이 'MANAGER'인 직원 검색하기
select EMPNO, ENAME, JOB  FROM EMP  
WHERE JOB= upper('manager');             
SELECT EMPNO, ENAME, JOB  FROM EMP  WHERE JOB='manager';  --manager 로검색하면 검색결과 없음

--2) LOWER : 대문자 -> 소문자
SELECT 'Welcome to Oracle', 
LOWER('Welcome to Oracle') FROM DUAL; 

--3) INITCAP : 단어의 첫자만 대문자로 변환
SELECT 'WELCOME TO ORACLE',
INITCAP('WELCOME TO ORACLE'),
INITCAP('welcome to oracle') FROM DUAL; 

--4) LENGTH / LENGTHB  : 문자길이 / 문자바이트
select ENAME, LENGTH(ENAME), LENGTHB(ENAME) from emp;   --영어는 한글자에 1바이트
select NAME, LENGTH(NAME), LENGTHB(NAME) from student;  --한글 한글자에 3바이트

--5) SUBSTR : 문자열 일부만 추출      형식: SUBSTR( 대상 , 시작위치 , 추출할 개수 )
select SUBSTR ('Welcome To Oracle',4,3) from dual;
--예1) 오늘 태어난 사람의 생년월일중 월 만 추출
select substr ('200224-1234567',3,2) from dual;
--예2) student 테이블에서 생일이 10월생인 학생만 추출  (년도의 시작 19는 숫자 세지않음)
--내가한풀이
select *from student;
select *from student where substr(BIRTHDAY,4,2);  --틀린이유 조건을 마무리 하지않았기때문
--정답
select NAME, BIRTHDAY, SUBSTR(BIRTHDAY,4,2)
FROM student WHERE SUBSTR(BIRTHDAY,4,2) = 10;
--연습
select NAME, BIRTHDAY, SUBSTR(BIRTHDAY,4,2) 태어난달
FROM student WHERE SUBSTR(BIRTHDAY,4,2) = 10;
--문제3) 9월에 입사한 사원을 출력해보세요. (emp테이블)
select *from emp where substr(HIREDATE,4,2)=9;

--6) TRIM / LTRIM / RTRIM : 공백 / 앞공백 / 뒤공백
SELECT TRIM(' Oracle ')  FROM DUAL;    --전체공백
SELECT LTRIM(' Oracle ')  FROM DUAL;   --앞부분공백
SELECT RTRIM(' Oracle ')  FROM DUAL;   --뒤부분 공백
--연습 
SELECT TRIM(' Oracle is easy ')  FROM DUAL;     --제일 앞뒤 공백만없앰

-- 3. 날짜 처리 함수
/*
SYSDATE 시스템 저장된 현재 날짜를 반환한다. 
MONTHS_BETWEEN 두 날짜 사이가 몇 개월인지를 반환한다. 
ADD_MONTHS 특정 날짜에 개월 수를 더한다. 
NEXT_DAY 
특정 날짜에서 최초로 도래하는 인자로 받은 요일의 날짜를 반
환한다. 
LAST_DAY 해당 달의 마지막 날짜를 반환한다. 
ROUND 인자로 받은 날짜를 특정 기준으로 반올림한다. 
TRUNC 인자로 받은 날짜를 특정 기준으로 버린다. */

--1) SYSDATE : 현재날짜시간
SELECT SYSDATE FROM DUAL; 
--sysdate날짜연산
SELECT SYSDATE-1 as 어제, SYSDATE 오늘, SYSDATE+1 내일 FROM DUAL;   --뒤에 AS 생략된것

--2) ADD_MONTHS : 개월수를 더한다       형식: ADD_MONTHS(칼럼명, 월수)
select HIREDATE, ADD_MONTHS(HIREDATE,12) from professor; --입사한 날짜와 입사한지 1년후의 날짜 
SELECT ENAME, HIREDATE, ADD_MONTHS(HIREDATE, 6) FROM EMP;  --입사한지 6개월지난날짜

--3) NEXT_DAY : 기준으로 가장 가까운 요일이 언제인지 검색     형식: NEXT_DAY(기준날짜, '요일')
SELECT SYSDATE, NEXT_DAY(SYSDATE, '수요일')  FROM DUAL; 
--연습
SELECT SYSDATE, NEXT_DAY(SYSDATE,'토요일')  FROM DUAL;   --기준날짜3/7/토  검색  3/14/토

-- 4. 형 변환 함수 
/*
 * 기존 자료형 -> 다른 자료형
TO_CHAR()    날짜형 혹은 숫자형을 문자형으로 변환한다. 
TO_DATE()    문자형을 날짜형으로 변환한다. 
TO_NUMBER()  문자형을 숫자형으로 변환한다. */

--1) TO_CHAR : 날짜,숫자 -> 문자형       형식: TO_CHAR(날짜데이터,'출력형식') = TO_CHAR(컬럼,'FORMAT')
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD') FROM DUAL; 
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YY/MM/DD') FROM DUAL;    --이렇게 지정한 출력형식으로 변환되서 출력됌
--예1) 날짜출력 - 사원들의 입사날짜를 출력하되 요일까지 출력하기
SELECT HIREDATE, TO_CHAR (HIREDATE, 'YYYY/MM/DD DAY')  FROM EMP; 
SELECT HIREDATE, TO_CHAR (HIREDATE, 'YY/MM/DD DAY')  FROM EMP; 
--예2) 시간출력 - 지금 날짜를 시간까지 (24시간기준으로) 출력하기
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD, HH24:MI:SS') FROM DUAL; 
--연습 
SELECT HIREDATE, TO_CHAR (HIREDATE, 'YYYY/MM/DD DAY, HH24:MI:SS')  FROM EMP; --입력된 시간이 없어서 시간자리에 00으로 표시
--예3) 급여출력 - 화폐기호 넣고 천의자리에서 , 를 넣어서 표현     : 9를넣으면 그자리가비어있으면 생략 0을 넣으면 빈자리에 0으로 표시
SELECT ENAME, SAL, TO_CHAR (SAL, 'L999,999')  FROM EMP; 
SELECT ENAME, SAL, TO_CHAR (SAL, 'L000,000')  FROM EMP; 

--2) TO_DATE : 문자,숫자 -> 날짜형        형식: TO_DATE('문자','형식')   문자를 형식에 맞게 날짜로 변환
SELECT ENAME, HIREDATE FROM EMP 
WHERE HIREDATE=TO_DATE(19810220,'YYYYMMDD'); 
SELECT ENAME, HIREDATE FROM EMP 
WHERE HIREDATE=TO_DATE(810220,'YYMMDD');   --이거는 같은 문자가없어서 결과가 안나옴 (19가빠져서 일치하는결과 X)
SELECT ENAME, HIREDATE FROM EMP 
WHERE HIREDATE=TO_DATE('1981/02/20','YYYY/MM/DD'); 
SELECT SYSDATE, TO_DATE(19990216,'YYYYMMDD') FROM DUAL; 
SELECT SYSDATE, TO_DATE('19990216','YYYY/MM/DD') FROM DUAL;

--3) TO_NUMBER ('string', 'format')
select TO_NUMBER('20,000', '99,999') - TO_NUMBER('10,000', '99,999') FROM DUAL;


-- 5. NULL 처리 함수
/*
 * 1. NVL(칼럼명, 값) : 해당 칼럼명 값이 NULL이면 뒤에있는 값으로 대체한다.
 * 2. NVL2(칼럼명, 값1, 값2) : 칼럼명이 NULL이면 값2로 대체 , NULL이 아닌경우 값1로 대체한다. */

--1) NVL2
select *from professor where deptno = 101;
--보너스가 0이면 0을 주고 보너스를받던사람은 두배로주겠다
select name, pay, bonus, nvl2(bonus,bonus*2,0) from professor where deptno = 101;
select name, pay, bonus, nvl2(bonus,bonus*2,bonus*2) from professor where deptno = 101;  --null은변환할때 null을 사용해서 그대로 null이나옴


-- 6. DECODE 함수          
--                 형식: decode(칼럼명, 값, 디코딩내용)
select *from emp;
select ename, deptno, 
decode(deptno, 10,'기획실',
               20,'연구실',
               '영업부')               --마지막만 남았을경우 숫자 생략가능
from emp;

select ename, deptno, 
decode(deptno, 10,'기획실',
               20,'연구실',
               '영업부')  "부서명"          --별칭도 만들수있다  (as랑 " "생략)
from emp;


--연습
create table emp11
as
select * from emp;
select *from emp11;

select ename, deptno,
decode(deptno, 10, '곱창',20,'막창','대창') as 회식메뉴 from emp11;








