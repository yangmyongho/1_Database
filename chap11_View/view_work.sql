-- view_work.sql;

-- 뷰(view) : 가상 테이블 

-- 1. 물리적 테이블 생성
create table db_view_tab(
id varchar(15) primary key,
name varchar(20) not null,
email varchar(50),
regdate date not null
);

insert into db_view_tab values('hong','홍길동','hong@naver.com',sysdate);
insert into db_view_tab values('admin','관리자','admin@naver.com',sysdate);
select *from db_view_tab;
commit work;

-- 2. 뷰(view) 생성 : 서브 쿼리 이용
create view admin_view            --가상테이블
as                                --오류 이유 scott은 view를 만들 권한이 없음
select * from db_view_tab
where id = 'admin';               --물리 테이블
/*
 * 관리자로 들어가서 scott에게 권한주기
 *conn system/1234;
 *grant create view to scott (scott 에게 view 를 만들수있는 권한을 주겠다.)
*/
create view admin_view            --가상테이블           
as                                
select * from db_view_tab
where id = 'admin';               --물리 테이블 
--view는 수정가능
create or replace view admin_view      --새로만들거나 수정 가능하게               
as                                
select * from db_view_tab
where id = 'admin' with read only ;    --with read only : 읽기 전용 (view에서 지우면 물리적 테이블에서도 내용이 지워짐)
--view 전체 목록 확인 
select *from user_views;
--특정 view 내용 확인
select *from admin_view;
--view 삭제
drop view admin_view;

--<실습3> 뷰 정의하기
-- 물리적 테이블 : EMP , 가상테이블 : EMP_VIEW30
-- 조건 : 사번,이름,부서번호  읽기 전용 뷰 생성
select *from emp;
create or replace view emp_view30
as
select empno, ename, deptno
from emp where deptno = 30
with read only;
select *from emp_view30;       --테이블 말고 굳이 뷰를 만드는 이유 : 메모리(사이즈) 크기 차이 때문 <뷰가 메모리 작음>


-- 3. view 사용 목적(용도)
/*
 * 1) 복잡한 sql문 사용시
 * 2) 보안 목적 : 접근 권한에 따라서 서로 다르게 정보 제공 
 * 
 */

--1) 복잡한 sql문 사용시
select *from product;
select *from sale;

create or replace view join_view
as
(select p.code, p.name, s.price, s.sdate
from product p, sale s
where p.code = s.code and p.name like '%기')
with read only;

select *from join_view;

--2) 보안 목적 : 접근 권한에 따라서 서로 다르게 정보 제공
select *from emp;
--(1) 영업사원(경쟁의목적으로 수당은공개)에게 제공하는 view
create or replace view sales_view
as
(select empno, ename, comm from emp
where job = 'SALESMAN')
order by comm desc   --orderby 위치확인
with read only;
select *from sales_view;
--읽기전용인지 확인해보기 
delete from sales_view where empno=7499;    --오류

--(2) 일반사원에게 제공하는 view 
create or replace view clerk_view
as
(select empno, ename, mgr, hiredate, deptno
from emp where job = 'CLERK')
with read only;
select *from clerk_view;

--(3)<실습>  관리자에게 제공하는 view
/*
 * 조건1> view이름 : manager_view
 * 조건2> 대상 칼럼 : 전체
 * 조건3> 직책(영업,사원,분석자)
 * 조건4> 물리적 테이블 : emp
 */
select distinct(job) from emp;
create or replace view manager_view
as
(select *from emp
where job in ('SALESMAN','CLERK','ANALYST'))       --여러개일때는 in 사용
with read only;
--내가만든거 (오류뜸)
create or replace view manager_view
as
(select *from emp
where job like '%SALESMAN' or '%CLERK' or '%ANALYST')     
with read only;                               


-- 4. 의사칼럼(rownum) 이용 view 생성 (의사칼럼일때는 쿼리문에 ()생략가능)
--ex) 최초 입사자 top5 , 급여 랭킹 top3 
select rownum, empno, ename from emp
where rownum <= 5;                     --rownum(의사컬럼)이 5이하인것들

--(1) 입사일(hiredate) TOP5(오래된) view 생성    <이경우는 입사일순서대로 rownum 이 생성되었기때문>
create or replace view top5_hire_view
as
select empno, ename, hiredate
from emp
where rownum <= 5
order by hiredate
with read only;       --오름차순
select *from top5_hire_view;
--이거 연습 내림차순이랑 오름차순 구분   -> 오름차순일때 낮은거부터 아래로 갈수록 커짐 , 
-- 또 아무것도없는 테이블 어떻게 하는지 -> dual
select order by (1,2,3,4,5,6) from dual;    --dual 은 하나의 칼럼에 하나의 행 이라서 안됌

--맞긴한데 조금오류있어서 다시 제대로 만듬
--1단계 : 정렬 -> view
create or replace view top5_hire_view
as
select empno, ename, hiredate
from emp
order by hiredate
with read only; 
--2단계 : 입사자 top5
select rownum, empno, ename, hiredate from top5_hire_view
where rownum <=5;

--(2) 가장 많은 급여 수령자 TOP3 view 생성(desc)  <이경우는 급여정보와 rownum순서가 다르기 때문>
-- view 이름 : top3_sal_view
-- 칼럼 : 사번,이름,급여,입사일 
drop view top3_sal_view;
--1단계 : 급여에따른 내림차순 뷰 생성
create or replace view top3_sal_view
as
select empno, ename, sal, hiredate
from emp
order by sal desc
with read only;
select *from top3_sal_view;
--2단계 : select 사용 top3 
select rownum, empno, ename, sal, hiredate
from top3_sal_view 
where rownum <= 3;








