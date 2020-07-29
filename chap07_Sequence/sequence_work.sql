-- sequence_work.sql


-- 1. 테이블 생성
select *from dept01;
drop table dept01 purge;
--구조 복사
create table dept01 
as
select *from dept where 1=0;


-- 2. sequence 생성 (한번 만들어진 sequence번호는 중복불가,다시만들기 불가능)
CREATE SEQUENCE DEPT_DEPTNO_SEQ 
INCREMENT BY 1 
START WITH 1;    --increment 와 start 는 순서 변경 가능


-- 3. 레코드 삽입  (nextval : 현재 값에서 다음 값으로 )
insert into dept01 values(DEPT_DEPTNO_SEQ.nextval,
 'test', '서울시');
 
insert into dept01 values(DEPT_DEPTNO_SEQ.nextval,
 'test2', '대전시');

select *from dept01;

desc scott_sequence;  --command line 에서 확인 가능


-- 4. sequence 목록 보기
select *from user_sequences;
--비슷하게 
select *from tab;  --테이블 전체 목록보기
select *from user_tables;  --테이블 전체 목록보기

--sequence 값을 조회할때    dual : 테스트를 목적으로한 의사 테이블 (실제 존재하지않음)
select dept_deptno_seq.nextval from dual;  --3이나옴    검색할때마다 증가?
select dept_deptno_seq.currval from dual;   --왜 오류인지

insert into dept01 values(DEPT_DEPTNO_SEQ.nextval,
 'test3', '대시');       --단점 시퀀스 번호가 증가한채로 지나감

--실습) 시퀀스를 테이블의 기본 키에 접목하기
--1. 시퀀스 생성
CREATE SEQUENCE EMP_SEQ 
START WITH 1 
INCREMENT BY 1 
MAXVALUE 100000 ; 
--2. 테이블 생성
DROP TABLE EMP01; 
CREATE TABLE EMP01( 
EMPNO NUMBER(4) PRIMARY KEY, 
ENAME VARCHAR2(10), 
HIREDATE DATE );
--3. 레코드 삽입
INSERT INTO EMP01 
VALUES(EMP_SEQ.NEXTVAL, 'JULIA' , SYSDATE); 
INSERT INTO EMP01 
VALUES(EMP_SEQ.NEXTVAL, 'JULIA2' , SYSDATE); 

select *from emp01;
delete from emp01 where empno = 2;   --2번째 값 삭제

INSERT INTO EMP01 
VALUES(EMP_SEQ.NEXTVAL, 'JULIA3' , SYSDATE);

select *from emp01;  --1번과 3번 이나옴 

--sequence는 한번삭제된 번호는 복구 불가능

-- 5. 시퀀스 삭제하기(delete) , 시퀀스 수정하기 (alter) -> 시퀀스 초기값은 수정불가능  삭제후 다시만들어야함
                           --다른 번호에서 다시 시작하려면 이전 시퀀스를 삭제하고 다시 생성 해야 한다. 
DROP SEQUENCE DEPT_DEPTNO_SEQ;  --얘는 임시파일이 남지않고 바로 삭제됌

select *from user_sequences;  --시퀀스가 남아있는지 확인

--6. 문자열 +시퀀스 숫자
create table board(
bno varchar(20) primary key,    --숫자가아닌 가변길이문자타입 (보통 한글 한자는  3자리 정도 차지)
writer varchar(20) not null     --작성자
); 

-- 시퀀스 생성
create sequence bno_seq
start with 1001
increment by 1;

-- '홍길동 1001, 이순신 1002' 이런형식으로 만들것   (to_char 문자로 바꿔라는 명령어)
insert into board 
values ('홍길동'||to_char(bno_seq.nextval),'홍길동');
insert into board 
values ('이순신'||to_char(bno_seq.nextval),'이순신');
insert into board 
values ('홍길동'||to_char(bno_seq.nextval),'홍길동');    --저자이름은 같지만 제목의 번호는 다르므로 중복아니라서 가능 

select *from board




