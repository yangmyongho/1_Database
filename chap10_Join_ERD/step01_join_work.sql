-- step01_join_work.sql

/*
 * 조인(join)
 * - 특정 칼럼(외래키)을 이용하여 두개 이상의 테이블을 연결하는 DB 기법
 */

/*
 * 조인 절차
 * 1. 기본키를 갖는 테이블 생성
 * 2. 레코드 추가
 * 3. 외래키를 갖는 테이블 생성
 * 4. 레코드 추가
 * 
 * 조인 테이블 삭제 : 위의 순서 역순으로
 * 강제 테이블 삭제 : drop table 테이블명 cascade constraint; (외래키말고 기본키 삭제)
 */


-- 단계1 : 기본키를 갖는 테이블 생성
create table product(
code char(4) primary key,         --코드
name varchar(30) not null         --상품명
);

-- 단계2 : 레코드 삽입
insert into product values('p001','냉장고');
insert into product values('p002','세탁기');
insert into product values('p003','전화기');
select *from product;

-- 단계3 : 외래키를 갖는 테이블 생성
create table sale(
code char(4) not null,          --코드(외래키)
sdate date not null,            --판매날짜
price int not null,             --가격
foreign key(code) references product(code)   --외래키
);

-- 단계4 : 레코드 추가
insert into sale values ('p001', '2020-02-24',850000);
insert into sale values ('p002', sysdate,550000);
insert into sale values ('p003', '2020-02-25',150000);
select *from sale;
-- 참조 무결성 제약조건 위배 (마스터테이블에 등록되지않은 코드번호가 들어왔기때문)
insert into sale values ('p004', '2020-02-24',850000);  --오류 

commit work;  --DB에반영

-- 단계5 : join 이용 데이터 조회      (테이블별칭.칼럼)
select p.code, p.name, s.sdate, s.price
from product p , sale s       --별칭을 p와s 로 만듬
where p.code = s.code and p.name like '%기';   --끝이 기로끝나는 상품

--erd사용해서 그림으로 관계 보기

--연습  그룹함수부분에




















































