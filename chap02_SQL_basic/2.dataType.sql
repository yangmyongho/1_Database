-- dataType.sql : Oracle 주요 자료형 

create table student(
sid int primary key,            -- 학번 ,정수형
name varchar(25) not null,  -- 이름 ,가변길이문자형
phone varchar(30) unique,  -- 전화번호 ,가변길이문자형
email char(50),                  -- 이메일 ,고정길이문자형
enter_date date not null     -- 입학년도 ,날짜형(날짜/시간)
);


/*
 * Oracle 주요 자료형 
 *  1. number(n) : n 크기 만큼 숫자 저장 (실수) 
 *                자릿수이므로 n에 2를넣으면 10~99까지
 *  2. int : 4바이트 정수 저장  (숫자,정수)
 *  3. varchar2(n) : n 크기 만큼 가변길이 문자 저장 
 *                  메모리를 효율적으로 사용가능하지만 속도에 차이가있다. 느려짐
 *  4. char(n) : n 크기 만큼 고정길이 문자 저장
 *              길이가 대체로 비슷하면 고정길이로 사용(길이를정해놔서속도가빠름)
 *  5. date : 날짜/시간 저장 - sysdate : system의 날짜/시간 저장 
 */

/*
 * 제약조건 
 *  1. primary key : 해당 칼럼을 기본키로 지정(중복불가+null불가)
 *  2. not null : null값 허용 불가 
 *  3. unique : 중복 불가(null 허용)
 */
--sequence 는 chap07에서제대로
/*
 * sequence?
 *  - 시작값을 기준으로 일정한 값이 증가하는 객체 
 *    ex)사원번호같이 중복없이 일정하게 증가하는 값을 만들때 사용
 *  - 형식) create sequence 이름 increment by 증가값 start with 시작값;
 */
--여기서는 이름=seq_sid  증가값=1  시작값=2020001
create sequence seq_sid increment by 1 start with 2020001;
--내용이 길때는 줄바꿈 가능
create sequence seq_sid 
increment by 1 start with 2020001;

sequence 이용 -> 레코드 삽입 
insert into student values(seq_sid.nextval,
'홍길동','010-1111-1111','hong@naver.com',sysdate);

insert into student values(seq_sid.nextval,
'이순신','010-2222-2222','lee@naver.com',sysdate);

insert into student values(seq_sid.nextval,
'유관순','010-3333-3333','yoo@naver.com',sysdate);

select *from student;
--결과가 2020001부터 1씩 늘어나면서 저장됌 
--메일은 같아도 가능
insert into student values(seq_sid.nextval,
'강감찬','010-4444-4444','yoo@naver.com',sysdate);
--이름도같아도가능
insert into student values(seq_sid.nextval,
'유관순','010-5555-5555','yoo@naver.com',sysdate);


--제약조건 위배사례(중복불가한데 중복했기떄문)
create sequence seq_sid 
increment by 1 start with 2020001; 
--여기서 이미 2020001 이있기때문에 중복 불가로 실패뜸


--연습)
create table student1(
sid int primary key,            -- 학번 ,정수형
name varchar(25) not null,  -- 이름 ,가변길이문자형
phone varchar(30) unique,  -- 전화번호 ,가변길이문자형
email char(50),                  -- 이메일 ,고정길이문자형
enter_date date not null     -- 입학년도 ,날짜형(날짜/시간)
);
--seq_sid 대신 sid 만써보기
create sequence sid 
increment by 1 start with 2020001;  --가능

insert into student1 values(sid.nextval,
'홍길동','010-1111-1111','hong@naver.com',sysdate);  --가능
--처음에 실수로 2번 눌렀는데 오류가 떠서 2020001,2020002는 번호가 입력되어버림
--그래서 2020003부터시작 
select *from student1;

insert into student1 values(2020003,
'김구','010-1111-1111','hong@naver.com',sysdate); --불가능 
--이미 2020003은있기떄문에
insert into student1 values('2020004',
'김구','010-1111-1111','hong@naver.com',sysdate);  --불가능

insert into student1 values('2020050',
'김구','010-1111-1111','hong@naver.com',sysdate);  --불가능

insert into student1 values(2020054,
'김구','010-1111-1111','hong@naver.com',sysdate);  --불가능

insert into student1 values(sid.nextval,
'김구','010-1111-1111','hong@naver.com',sysdate);
  --뭐가문제인지 모르겠음

--연습끝



