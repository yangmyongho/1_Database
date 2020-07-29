-- ddl_work.sql
/*
 * DDL : 테이블 생성(제약조건), 구조변경, 삭제
 *  - 자동 커밋(AUTO COMMIT)  -DML인경우 자동커밋이안됌 
 */

-- 1. 의사컬럼 (rownum, rowid) : 가짜 컬럼
-- rownum : 레코드 순번
select *from emp;
SELECT ROWNUM, EMPNO, ENAME, ROWID
FROM EMP WHERE ROWNUM <=10 ;    --조건이 rownum이 10이하인거 검색하게 했음
--emp 테이블에 empno,ename 는 존재하지만 rownum, rowid 는 실제 존재하지않지만 
--rownum은 목록의 번호를 매겨주고 rowid는 행의위치를 지정해주는 논리적인 주소값

-- 연습) rownum : 5~10
SELECT ROWNUM, EMPNO, ENAME, ROWID
FROM EMP WHERE ROWNUM >=5 and ROWNUM <=10 ;   --오류 범위지정을 실행할수없음(ROWNUM >=5) 의사컬럼의 특성
-- 해결법) 의사컬럼, 서브쿼리
SELECT rnum, EMPNO, ENAME
FROM (select empno, ename, rownum as rnum from emp)
WHERE rnum >=5 and rnum <=10;                                --서브쿼리에서 먼저 rownum의 별칭을 지어주고 그별칭으로 main과 where에서 검색가능
--연습 변환해보기
SELECT rnum, EMPNO, ENAME
FROM (select empno, ename, rownum as rnum from emp)
WHERE rnum between 5 and 10;

--나혼자연습 (메인에서 별칭은 효과없음 =오류)
SELECT ROWNUM as rnum, EMPNO, ENAME, ROWID
FROM EMP WHERE RNUM >=5 and RNUM <=10 ; 



-- 2. 실수형 데이터 저장 테이블
--테이블이있었다면 지우기 drop table emp01 purge;
CREATE TABLE EMP01( 
EMPNO NUMBER(4), 
ENAME VARCHAR2(20), 
SAL NUMBER(7, 2));    --(전체, 소수점)

insert into emp01 values(1, '홍길동',1234.1);
insert into emp01 values(2, '이순신',234.12);
insert into emp01 values(3, '강감찬',34567.125);      --소수점 3째자리에서 반올림되서 34567.13 으로 표현
insert into emp01 values(4, '유관순',123456.1234);    --자리수를 초과했기때문에 오류 6자리+소수2자리 = 8자리

select *from emp01;


-- 3. 서브쿼리 이용 테이블 생성
--구조 + 내용 모두 복제한 테이블
create table emp02     --main 
as
select *from emp;      --sub

select *from emp02;

--특정 칼럼 + 내용복제
create table emp03
as
select empno, ename, sal, comm from emp;

select *from emp03;

--과제1) EMP 테이블을 복사하되 사원번호, 사원이름, 급여 컬럼으로 구성 된 테이블을 생성하시오.(단 테이블의 이름은 EMP04) 
create table emp04
as
select empno, ename, sal from emp;

select *from emp04;

--특정 행 구조 + 내용 복제
CREATE TABLE EMP05 
AS 
SELECT * FROM EMP WHERE DEPTNO=10;

select *from emp05;

--문제1) 직책(JOB)이 관리자(MANAGER)만 대상으로 테이블 생성하기 (emp_test)
create table emp_test
as
select *from emp where JOB = 'MANAGER';       --MANAGER문자열이므로 '' 사용!

select *from emp_test;

--테이블 구조(스키마) 복제               구조만 복제하려면 조건식을 false 로 만들면 된다 (조건식은 꼭 저렇게가아니라 false 로만 만들면된다)
CREATE TABLE EMP06 
AS 
SELECT * FROM EMP WHERE 1=0;              --where 1=0 은 항상 거짓이므로 오류는 나지않지만 내용은 값이 나오지않음 

select *from emp06;

--과제2) DEPT 테이블과 동일한 구조의 빈 테이블을 생성하시오. (테이블의 이름은 DEPT02) 
create table dept02
as
select *from dept where 7=9;

select *from dept02;

insert into dept02 values(1,'기획실','대전');


-- 4. 제약조건

-- 1) 기본키 (primary key) : 널, 중복 불가 
--칼럼 level
create table test_tab1(
id number(2) primary key,
name varchar2(30)
);
--테이블 level
create table test_tab2(
id number(2),
name varchar(30),
primary key(id)
);

insert into test_tab1 values(11,'홍길동');
insert into test_tab1 values(22,'유관순');
insert into test_tab1(name) values('홍길동');            --id에 null이 입력되어서 오류
insert into test_tab1(id,name) values(null, '홍길동');   --id에 null값을 넣으려해서 오류
insert into test_tab1(id,name) values(22, '이순신');     --id에 중복된값을 넣으려해서 오류  

-- 2) 외래키  : 특정 테이블의 기본키를 다른 테이블에서 참조하는 키 
-- 작업절차 : 기본키 테이블 생성 -> 외래키 테이블 생성

--( chap10 에서 제대로)

create table emp_tab(
empno number(4) primary key,
enmae varchar(30),
sal number(7)
);

insert into emp_tab values(1111,'홍길동',1500000);
insert into emp_tab values(2222,'이순신',2500000);
insert into emp_tab values(3333,'유관순',3500000);

select *from emp_tab;

drop table emp_tab purge;                --다시 해보기

--마스터 테이블 생성 
create table dept_tab(
deptno number (2) primary key,                          --기본키 
dname varchar(10) not null,
loc varchar(10) not null
);
--레코드 삽입
insert into dept_tab values(10,'기획','대전');
insert into dept_tab values(20,'총무','서울');
insert into dept_tab values(30,'판매','미국');

select *from dept_tab;

--외래키 생성   
create table emp_tab(
empno number(4) primary key,                             --기본키
enmae varchar(30),
sal number(7),
deptno number (2) not null,
foreign key(deptno) references dept_tab(deptno)          --외래키
);
--레코드 삽입
insert into emp_tab values(1111,'홍길동',1500000,10);
insert into emp_tab values(2222,'이순신',2500000,20);
insert into emp_tab values(3333,'유관순',3500000,30);

select *from emp_tab;

--참조무결성 위배   (deptno자리에는 아무숫자나 넣을수없고 deptno 가 가지고있는 인수 사용해야함)
insert into emp_tab values(4444,'강감찬',4500000,40); 

--문) 서브쿼리를 이용하여 사번이 2222 사번을 갖는 사원의 부서 정보 출력하기
--    서브(emp_tab), 메인(dept_tab)
select *from dept_tab
where deptno = 
(select deptno from emp_tab where empno = 2222 );

-- 3) 유일키(unique key)  중복은 불가능 하지만 null 은 가능
 CREATE TABLE UNI_TAB1 ( 
 DEPTNO NUMBER(2) UNIQUE,                                --unique not null은 primary 와 동일  (해보기)
 DNAME CHAR(14), 
 LOC CHAR(13)
 ); 

insert into uni_tab1 values(11,'영업부','서울');
insert into uni_tab1 values(22,'기획실','대전');
insert into uni_tab1(dname, loc) values('기획실2','대전');  --null은 허용
insert into uni_tab1 values(22,'기획부3','대전');           --중복은 불가

select *from uni_tab1;

-- 4) NOT NULL : 컬럼 level에서만 가능 

-- 5) CHECK 
CREATE TABLE CK_TAB1 (
DEPTNO NUMBER(2) NOT NULL CHECK (DEPTNO IN (10,20,30,40,50)),   --공백안되고 10,20,30,40,50 중에 하나만 입력가능
DNAME CHAR(14), 
LOC CHAR(13)
); 

insert into ck_tab1 values(10,'회계','서울');
insert into ck_tab1 values(60,'연구','대전');            --정해준구간에 포함되지않아서 오류 
insert into ck_tab1 (dname, loc)values('회계','서울');   --not null 에서 오류


-- 5. 테이블 구조 변경 (alter table)

-- 1) 칼럼 추가 (기존내용 있을경우 오류) add
select *from emp01;      --기존에 emp01 테이블이 있는지 확인 

ALTER TABLE EMP01 ADD(JOB VARCHAR2(9));   --job 추가되었음  job의 내용이 null 로 표시

select *from emp01;

ALTER TABLE EMP01 ADD(JOB2 VARCHAR2(9) not null); --job2 에 null이 들어가는데 조건이 not null 이므로 오류

select *from emp01;

--과제3) DEPT02 테이블에 문자 타입의 부서장(DMGR) 칼럼을 추가하시오.
select *from dept02;

alter table dept02 add(DMGR varchar (10) );

-- 2) 칼럼 수정 : 주의-컬럼명 수정 불가능   modify
-- 컬럼 자료형, 크기, 기본값 수정
ALTER TABLE EMP01 MODIFY(JOB VARCHAR2(30));    --자릿값을 (9) 에서 (30) 으로 변경

select *from emp01;                            --변경 되었는지는 구조 확인 불가능
desc emp01;                                    --command line에서 확인가능

--과제4) DEPT02 테이블의 부서장(DMGR) 칼럼을 숫자 타입 으로 변경하시오.
alter table dept02 modify (DMGR number (10));
alter table dept02 modify (DMGR number (20));
desc dept02; 

-- 3) 칼럼 삭제 
ALTER TABLE EMP01 DROP COLUMN JOB; 

select *from emp01;

--과제5) DEPT02 테이블의 부서장(DMGR) 칼럼을 삭제하시오.
alter table dept02 drop column DMGR;
select *from dept02;


-- 6. 테이블의 모든 ROW(레코드) 제거
truncate table emp01;   --내용 삭제 (구조는 그대로)
select *from emp01;


-- 7. 테이블 삭제  (임시파일이남음)
drop table 테이블이름 ;
drop table 테이블이름 purge;     --그럴경우 purge 를 붙이면 임시파일까지 삭제됌 
purge recyclebin;              --또는 임시파일만 지울경우

select *from tab;
drop table emp01;             
drop table emp01 purge;       --이미 emp01 이란 테이블은 지워져서 임시로 되어있으므로 오류가뜬다 
purge recyclebin;






