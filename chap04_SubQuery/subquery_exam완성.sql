select * from STUDENT; -- profno, deptno01
select * from PROFESSOR; -- profno

-- [문1] STUDENT 테이블 검색 결과(sub)를 이용하여 STUDENT01 테이블 생성(main) 
-- Sub(STUDENT), Main(STUDENT01)
create table STUDENT01
as                                               --subquery 형식1) 사용 
(select *from student);                    
-- [문2] 교수번호가 2001인 지도교수를 모시는 전체 학생 명부 출력
-- Sub(PROFESSOR), Main(STUDENT01)
select *from STUDENT01
where profno =
(select profno from PROFESSOR where profno= '2001');
-- 위아래같음
select *from STUDENT01
where profno = '2001';
-- [문3] 보너스를 받는 교수들의 이름, 직위, 급여, 보너스 출력
-- 조건)   IN()함수 이용 : 다중 행 처리  
select name, position, pay, bonus from PROFESSOR
where bonus in
(select bonus from PROFESSOR where bonus is not null); --보너스값들여러개
--위아래같음
select name, position, pay, bonus from PROFESSOR
where profno in
(select profno from PROFESSOR where bonus is not null);  --보너스를받는교수번호 여러개
-- [문4] 301 학과(DEPTNO) 교수들 보다 더 많은 급여를 받는 교수들의 이름, 직위, 급여, 학과 출력
-- 조건) ALL()함수 이용 : 다중 행 처리 
select name, position, pay, deptno from PROFESSOR
where pay 
> all 
(select pay from PROFESSOR where deptno = '301');       
       
       
       
       
       
       
       
       
       
       