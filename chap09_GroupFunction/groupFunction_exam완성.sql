/*
 * 집합 함수(COUNT,MAX,MIN,SUM,AVG) 
 * 작업 대상 테이블 : EMP, STUDENT, PROFESSOR
 */

--Q1. EMP 테이블에서 소속 부서별 최대 급여와 최소 급여 구하기
SELECT *FROM EMP;
SELECT DEPTNO,MAX(SAL),MIN(SAL) 
FROM EMP 
GROUP BY DEPTNO
ORDER BY DEPTNO;

--Q2. EMP 테이블에서 JOB의 수 출력하기 
SELECT COUNT(JOB) FROM EMP;

--Q3. EMP 테이블에서 전체 사원의 급여에 대한 분산과 표준편차 구하기
SELECT ROUND(VARIANCE(SAL),3), ROUND(STDDEV(SAL),3) FROM EMP;

--Q4. Professor 테이블에서 학과별 급여(pay) 평균이 400 이상 레코드 출력하기
SELECT *FROM PROFESSOR;
SELECT DEPTNO, AVG(PAY) 
FROM PROFESSOR 
GROUP BY DEPTNO 
HAVING AVG(PAY) >= 400
ORDER BY AVG(PAY);

--Q5. Professor 테이블에서 학과별,직위별 급여(pay) 평균 구하기
SELECT DEPTNO, POSITION, AVG(PAY) FROM PROFESSOR
GROUP BY DEPTNO, POSITION                         --1차 학과별 그룹 -> 2차 직위별 그룹
ORDER BY DEPTNO;

--Q6. Student 테이블에서 학년(grade)별로 
-- weight, height의 평균값, 최대값, 최소값을 구한 
-- 결과에서 키의 평균이 170 이하인 경우 구하기
SELECT *FROM STUDENT;
SELECT  GRADE, AVG(WEIGHT),MAX(WEIGHT), MIN(WEIGHT), 
        AVG(HEIGHT), MAX(HEIGHT), MIN(HEIGHT)
FROM STUDENT
GROUP BY GRADE
HAVING AVG(HEIGHT) <= 170;




