-- <최종 연습문제>

-- [문1] gift 테이블을 대상으로 각 필드에 별칭을 사용하여 출력
/* <출력 형식>
       선물번호      선물이름 
      1      참치세트
      2      샴푸세트   */ 
select gno as 선물번호, gname as "선물이름" from gift;
-- [문2] emp에서 30번 부서에 근무하는 사원의 이름, 급여, 사번 출력하기 
-- 사용 칼럼명 : 이름(ename),급여(sal),사번(empno) 출력하기
select ename, sal, empno from emp
where deptno = 30;
-- [문3] student 테이블의 전체 학생들을 대상으로 다음 예)와 같이 출력하기 
-- 예) 홍길동의 키는 175cm, 몸무게는 65kg입니다.
-- 사용 컬럼명 : 키(height), 몸무게(weight)
select name ||'의 키는 '|| 
height ||'cm, 몸무게는'|| 
weight ||'kg입니다.' as "학생들의 키와이름" from STUDENT;
--[문4] student 테이블을 사용하여 2학년 중에서 키가 180cm 보다 크고,
--     몸무게가 70kg 보다 큰 학생들의 이름,학년,키,몸무게 출력하기
-- 사용 컬럼명 : 이름(name), 학년(grade), 키(height), 몸무게(weight)
select name, grade, height, weight from student
where grade = 2 and height >= 180 and weight >= 70;
--[문5] student 테이블을 사용하여 1학년 학생의 이름, 키, 몸무게 출력하기 
--  (단, 키는 오름차순, 몸무게는 내림차순으로 정렬하여 출력)
select name, height, weight from STUDENT
where grade = 1
order by height asc, weight desc;
--[문6] student 테이블을 사용하여 1학년 학생의 '이름'과  '키' 출력(별칭 이용)
--  (단, 이름 오름차순으로 정렬)
select name as 이름, height as 키 from  STUDENT
where grade = 1
order by name;
--[문7] professor 테이블에서 교수들의 이름을 조회하여 
-- 성 부분에 '김'이 포함된 사람의 이름을 오름차순으로 출력
select name from PROFESSOR
where name like '김%'
order by name;
--[문8] professor 테이블를 대상으로 '전임'으로 검색하여 전임강사를 모두 검색하기
-- 사용 칼럼명 : position
select *from PROFESSOR
where position like '전임%';
