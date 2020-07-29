-- dml_work.sql

/*
 * DML: SELECT, INSERT, UPDATE, DELETE
 *  commit : 작업 내용 db 반영 
 *  commit 대상 : INSERT, UPDATE, DELETE
 *     -> 기본 쿼리 실습 
 *     -> 서브 쿼리 실습
 *  select : commit 대상 아님 
 */


-- 1. 레코드 삽입 
--table 생성
select *from dept01;       --있나 확인하고
drop table dept01 purge;   --있어서 지우고

CREATE TABLE DEPT01(       --새로만듬
DEPTNO NUMBER(4), 
DNAME VARCHAR2(30), 
LOC VARCHAR2(20) 
);

INSERT INTO DEPT01 (DEPTNO, DNAME, LOC)
VALUES(10, 'ACCOUNTING', 'NEW YORK');        --테이블에 내용추가

--전체 칼럼 입력시 -> 칼럼명 생략 가능
INSERT INTO DEPT01 VALUES(20, 'RESEARCH', 'DALLAS');

INSERT INTO DEPT01 (DEPTNO, DNAME, LOC) VALUES (10, 'ACCOUNTING');                   --정해진 칼럼보다 내용이적어도 오류
INSERT INTO DEPT01 (DEPTNO, DNAME, LOC) VALUES(10, 'ACCOUNTING', 'NEW YORK', 20);    --정해진 칼럼보다 내용이 더많아도 오류

--문제1)EMP 테이블의 4개 칼럼의 구조를 이용하여 SAM01 테이블을 생성하시오.
--     조건> 서브쿼리 이용
select *from emp;
CREATE TABLE SAM01
AS
(select empno, ename, job, sal from emp where 1=0 );     --서브쿼리사용, 조건을 false로해서 내용삭제 구조만 가져옴
select *from sam01;

--문제2)SAM01 테이블에 다음과 같은 데이터를 추가하시오.
insert into sam01 values (1000,'apple','police',10000);
insert into sam01 values (1010,'banana','nurse',15000);
insert into sam01 values (1020,'orange','doctor',25000);

select *from sam01;
--sequence 사용해서 한번더 연습해보기 

-- NULL 입력

--1) 묵시(암시)적 NULL 입력
INSERT INTO DEPT01(DEPTNO, DNAME) VALUES (30, 'SALES'); 

--2) 명시적 NULL 입력
INSERT INTO DEPT01 VALUES (40,'OPERATION','NULL');           
INSERT INTO DEPT01 VALUES (50,'','CHICAGO');
select *from dept01;   --둘다 null 값으로 입력은 되었음
--!추가로 저장한 30,40 지우기!(연습)

--문제3) 문제 1에서 생성한 SAM01 테이블에 다음과 같이 NULL 값을 갖는 행을 추가하시오.
insert into sam01 values (1030,'VERY','',25000);
insert into sam01 (empno, ename, sal) values (1040,'CAT',2000);

select *from sam01;


-- 서브쿼리를 이용한 레코드 삽입

-- 1) table 준비
drop table dept02 purge;

create table dept02
as
select *from dept where 1=0;    --dept테이블의 구조만 가져온 dept02   여기서는 구조만 가져온거

--2) 레코드 삽입 : 서브쿼리 
insert into dept02
select *from dept;              --DML에서는 AS를 안쓴다.    그구조에다가 dept 내용 삽입

select *from dept02;           --제대로 삽입됌

select *from dept;

select *from tab;
                           --!dept02 뭐가 문제인지 찾아보기!  --해결 철자 잘못쓴거.... 
                           
--문제3) 문제 1에서 생성한 SAM01 테이블에 서브 쿼리문을 사용하여 EMP 에 저장된 사원 중 10번 부서 소속 사원의 정보를 추가하시오.
select *from sam01;
select *from emp;  
insert into sam01
select empno, ename, job, sal from emp where deptno = 10;  --연습때 오류 뜬이유 칼럼을 지정안해서 칼럼이 더많아서 안합쳐짐?
select *from sam01;                                         --다시해보기


-- 2. 다중 테이블에 다중 행 삽입하기

--1) table (2개) 준비
create table EMP_HIR
as
select EMPNO, ENAME, HIREDATE from EMP
where 1=0;
select *from EMP_HIR;

create table EMP_MGR 
as
select EMPNO, ENAME, MGR from EMP
where 1=0;
select *from EMP_HIR;
--2) 다중 테이블에 다중 행 삽입 
INSERT ALL 
INTO EMP_HIR VALUES(EMPNO, ENAME, HIREDATE) 
INTO EMP_MGR VALUES(EMPNO, ENAME, MGR) 
SELECT EMPNO, ENAME, HIREDATE, MGR FROM EMP     --서브쿼리  (여러칼럼을 입력했지만 받아들이는곳에서 알아서 자기꺼만 받아들임?)
WHERE DEPTNO=20;

-- ppt 내용 참고하기


-- 3. UPDATE

/*UPDATE table_name 
SET column_name1 = value1, column_name2 = value2 , … 
WHERE conditions 
*/      --조건을 꼭넣어야함 안그러면 다 수정되어버림
drop table emp01 purge;
select *from emp01;  --있는지 확인 없어서 새로 만듬

--table 준비
create table emp01    --전체 구조 + 내용 (조건이없기떄문에)
as
select *from emp01;

-- 기본 쿼리문 : 레코드 수정
UPDATE EMP01 SET DEPTNO=30;    --전체 레코드 수정 : 부서번호를 모두 30 번으로 바꿈(조건없음)
select *from emp01;
-- 전체 사원 급여 급여 10% 인상
UPDATE EMP01 SET SAL=SAL*1.1 ;
--조건을 부서번호 30번인 사원만 급여 10프로인상
UPDATE EMP01 SET SAL=SAL*1.1 WHERE DEPTNO = 30;    --위아래같은이유는 지금 모든사원의 부서번호가 30번이기때문(따라서 이때는 WHERE절 안써도됌)

--입사년도 수정  (SYSDATE = 지금날짜시간)
UPDATE EMP01 SET HIREDATE = SYSDATE;    --모두 현재시간날짜로 입사날짜 변경됌

--WHERE절 이용 : 특정 레코드만 수정
UPDATE EMP01 SET SAL = SAL*1.1 WHERE SAL <=2000;    --급여가 2000이하인사원만 급여 10프로 인상
select *from emp01;

--특정 입사년도에입사한 사원의 입사년도 수정
UPDATE EMP01 SET HIREDATE = SYSDATE 
WHERE SUBSTR(HIREDATE, 1, 2)='87';   -- 1987년에 입사한 사원의 입사일을 오늘로 수정

--문제4) SAM01 테이블에 저장된 사원 중 급여가 10000 이상인 사원들의 급여만 5000원씩 삭감하시오.
update sam01 set sal = sal-5000
where sal >= 10000;
select *from sam01;

--2개 이상의 칼럼 수정 (,로 나열하면된다)
UPDATE EMP01 SET DEPTNO=20, JOB='MANAGER' 
WHERE ENAME='SCOTT'; 

select *from emp01;
--3개의 칼럼수정
UPDATE EMP01 SET HIREDATE = SYSDATE, SAL=50, COMM=4000 
WHERE ENAME='SCOTT'; 

--괄호로묶인게 서브쿼리
UPDATE DEPT01 SET LOC=
(SELECT LOC FROM DEPT01 WHERE DEPTNO=10)         --서브쿼리(값: 뉴욕)
WHERE DEPTNO=20;

--문제5) 서브 쿼리문을 사용하여 EMP 테이블에 저장된 데이터의 특정 컬럼만으로 구성된 SAM02 테이블을 생성하시오.
create table sam02
as
(select ename,sal,hiredate,deptno from emp );
select *from sam02;

--문제6) 생성 후 DALLAS 에 위치한 부서 소속 사원들의 급여를 1000 인상하시오. 
-- 메인 : sam02 , 서브 : dept
update sam02 set sal = sal+1000
where deptno = 
(select deptno from dept where LOC = 'DALLAS');            --문자열에 '' 꼭쓰기..
select *from dept;
select *from sam02;

--서브쿼리 이용 두개 이상 칼럼 수정 
UPDATE DEPT01 SET (DNAME, LOC)=
(SELECT DNAME, LOC FROM DEPT01 WHERE DEPTNO=10) 
WHERE DEPTNO=50;

select *from dept01;

--문제7) 서브 쿼리문을 사용하여 SAM02 테이블의 모든 사원의 급여와 입사 일을 이름이 KING 인 사원의 급여와 입사일로 변경하시오. 
update sam02 set (sal, hiredate) =
(select sal, hiredate from sam02 where ename = 'KING');

select *from sam02;

-- 4. DELETE
select *from dept01;
DELETE FROM DEPT01 WHERE DEPTNO=30;
select *from dept01;

--수당을 받는 사원 삭제
 select *from emp01;

 delete from emp01 
 where comm is not null ; 

 select *from emp01;

--전체 레코드 삭제시 조건을 안넣으면됌
delete from dept01;
select *from dept01;   --구조는 남지만 내용은 다 지워짐    되도록이면 내용지울때는  truncate table emp01;  을사용 권장

--문제8) SAM01 테이블에서 직책이 정해지지 않은 사원을 삭제하시오.
select *from sam01;

delete from sam01
where job is null;

--서브쿼리 이용 레코드 삭제
select *from emp01;
select *from dept;

DELETE FROM EMP01
WHERE DEPTNO=
(SELECT DEPTNO FROM DEPT WHERE DNAME='SALES');   --sales 의 부서번호는 30번

--부서번호가 모두 30번이라서 다지워짐



