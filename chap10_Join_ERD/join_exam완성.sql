-- 1. 고객 테이블 
create table user_data(
user_id int primary key,        
gender number(1) not null,     
age number(3) not null,     
house_type number(1) not null,  
resident varchar(10) not null, 
job number(1) not null          
);

create sequence seq_id increment by 1 start with 1001;

insert into user_data values(seq_id.nextval, 1, 35,	1,	'전북', 	6);
insert into user_data values(seq_id.nextval, 2, 45,	3,	'경남', 	2);
insert into user_data values(seq_id.nextval, 1, 55,	3,	'경기', 	6);
insert into user_data values(seq_id.nextval, 1, 43,	3,	'대전', 	1);
insert into user_data values(seq_id.nextval, 2, 55,	4,	'경기', 	2);
insert into user_data values(seq_id.nextval, 1, 45,	1,	'대구', 	1);
insert into user_data values(seq_id.nextval, 2, 39,	4,	'경남', 	1);
insert into user_data values(seq_id.nextval, 1, 55,	2,	'경기', 	6);
insert into user_data values(seq_id.nextval, 1, 33,	4,	'인천', 	3);
insert into user_data values(seq_id.nextval, 2, 55,	3,	'서울', 	6);
select * from user_data;


-- 2. 지불 테이블 
create table pay_data(
user_id int not null,            
product_type number(1) not null, 
pay_method varchar(20) not null, 
price int not null,               
foreign key(user_id)             
references User_data(user_id)
);

insert into pay_data values(1001, 1, '1.현금', 153000);
insert into pay_data values(1002, 2, '2.직불카드', 120000);
insert into pay_data values(1003, 3, '3.신용카드', 780000);
insert into pay_data values(1003, 4, '3.신용카드', 123000);
insert into pay_data values(1003, 5, '1.현금', 79000);
insert into pay_data values(1003, 1, '3.신용카드', 125000);
insert into pay_data values(1007, 2, '2.직불카드', 150000);
insert into pay_data values(1007, 3, '4.상품권', 78879);
select * from pay_data;


-- 3. 반품 테이블  
create table return_data(
user_id int not null,            
return_code number(1) not null,  
foreign key(user_id) 
references User_data(user_id)    
);

insert into return_data values(1003, 1);
insert into return_data values(1003, 4);
insert into return_data values(1007, 1);
insert into return_data values(1009, 2);

select * from return_data;

commit work;



select * from user_data;
select * from pay_data;
select * from return_data;
-- 문1) 고객(user_data)테이블과 지불(pay_data)테이블을 inner join하여 다음과 같이 출력하시오.
-- 조건1) 고객ID, 성별, 연령, 직업유형, 상품유형, 지불방법, 구매금액 칼럼 출력  
-- 조건2) 고객ID 오름차순 정렬
select u.user_id, u.gender, u.age, u.job, p.product_type, p.pay_method, p.price
from user_data u, pay_data p
where u.user_id = p.user_id
order by u.user_id;                      --[해설]전체 고객 중에서 상품 구매 고객 정보 조회

-- 문2) 문1)의 결과에서 성별이 '여자'이거나 지불방법이 '1.현금'인 경우만 출력하시오.
-- 조건1) 남자 : gender = 1 , 여자 : gender = 2
select u.user_id, u.gender, u.age, u.job, p.product_type, p.pay_method, p.price
from user_data u, pay_data p
where u.user_id = p.user_id and (u.gender=2 or p.pay_method='1.현금')
order by u.gender;                       --[해설]상품 구매 고객 중에서 특정 고객 조회

-- 문3) 고객(user_data)테이블과 지불(pay_data)테이블을 left outer join하여 다음과 같이 출력하시오.
-- 조건) 고객ID, 성별, 나이, 상품유형, 지불방법 칼럼 출력   
select u.user_id, u.gender, u.age, p.product_type, p.pay_method
from user_data u, pay_data p
where u.user_id = p.user_id(+)
order by u.user_id;                      --[해설]전체 고객 중에서 상품을 구매하지 않은 고객 까지 모두 조회

-- 문4) 고객(user_data)테이블과 반품(return_data)테이블을 이용하여 left outer join하여 다음과 같이 출력하시오.
-- 조건1) 고객ID, 성별, 나이, 거주지역, 반품코드 칼럼 출력   
-- 조건2) 반품한 고객만 출력
select u.user_id, u.gender, u.age, u.resident, r.return_code
from user_data u, return_data r
where u.user_id = r.user_id(+) and r.return_code is not null;   --[해설]전체 고객 중에서 상품을 반품한 고객만 조회
--left outer join 안쓰고 inner join사용 해도 가능
select u.user_id, u.gender, u.age, u.resident, r.return_code
from user_data u, return_data r
where u.user_id = r.user_id;            
--이거는 return_code에서 null값도 출력되므로 오류
select u.user_id, u.gender, u.age, u.resident, r.return_code
from user_data u left outer join return_data r
on u.user_id = r.user_id(+) and r.return_code is not null;
--이렇게 하면 가능
select u.user_id, u.gender, u.age, u.resident, r.return_code
from user_data u left outer join return_data r
on u.user_id = r.user_id(+) where r.return_code is not null;

-- 문5) ERD를 시각화 하시오.
-- 파일명 : user_pay_return

--문6) 내가 해보는문제   full outer join 만들어보기(2개)
select u.user_id, u.gender, u.age, u.job, p.product_type, p.pay_method, p.price
from user_data u full outer join pay_data p
on u.user_id = p.user_id;
--문6) 내가 해보는문제   full outer join 만들어보기(2개)






