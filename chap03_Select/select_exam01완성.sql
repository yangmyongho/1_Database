-- <연습문제1>
-- 문1) 다음 문장에서 에러를 올바르게 수정(년봉은 별칭)
SELECT empno,ename,sal X 12 년봉 FROM emp;  --문제
SELECT empno, ename, sal*12 년봉 FROM emp;  --답
-- 문2) EMP 테이블의 구조 조회(힌트 : DESC  테이블)
desc emp;  --eclips에서 안됌
-- 문3) EMP 테이블의 모든 내용 조회
select *from emp;
-- 문4) EMP 테이블에서 중복되지 않는 deptno 출력(힌트 : distinct)
select distinct deptno from emp;
-- 문5) EMP 테이블의 ename과 job를 연결하여 출력
select ename || ' ' || job as 사원명과직책 from emp;
-- 문6) DEPT 테이블의 dname과 loc를 연결하여 출력
select dname ||','|| loc "부서명,위치" from  dept;
-- 문7) EMP 테이블의 job과 sal를 연결하여 출력
select job || '은'|| sal "직업과급여" from emp;