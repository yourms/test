CREATE TABLE CUSTOMERS(
    CNO     NUMBER(5) PRIMARY KEY,
    CNAME   VARCHAR2(10) NOT NULL,
    ADDRESS VARCHAR2(50) NOT NULL,
    EMAIL   VARCHAR2(20) NOT NULL,
    PHONE   VARCHAR2(20) NOT NULL
);

CREATE TABLE ORDERS(
    ORDERNO     NUMBER(10) PRIMARY KEY,
    ORDERDATE   DATE DEFAULT SYSDATE NOT NULL,
    ADDRESS     VARCHAR2(50) NOT NULL,
    PHONE     VARCHAR2(20) NOT NULL,
    STATUS     VARCHAR2(20) NOT NULL,
    CNO     NUMBER(5) NOT NULL,
    CHECK(STATUS IN ('결제완료', '배송중', '배송완료')),
    FOREIGN KEY(CNO) REFERENCES CUSTOMERS(CNO)
);

CREATE TABLE PRODUCTS(
    PNO     NUMBER(5) PRIMARY KEY,
    PNAME   VARCHAR2(20) NOT NULL,
    COST    NUMBER(8) DEFAULT 0 NOT NULL,
    STOCK   NUMBER(5) DEFAULT 0 NOT NULL
);

CREATE TABLE ORDERDETAIL(
    ORDERNO  NUMBER(10) ,
    PNO      NUMBER(5),
    QTY      NUMBER(5) DEFAULT 0,
    COST     NUMBER(8) DEFAULT 0,
    
    FOREIGN KEY(ORDERNO) REFERENCES ORDERS(ORDERNO),
    FOREIGN KEY(PNO) REFERENCES PRODUCTS(PNO),
    PRIMARY KEY(ORDERNO, PNO)
);
drop table ORDERSDETAIL;
insert into products(pno, pname, cost, stock)
values(1001, '삼양라면',1000, 200);
insert into products(pno, pname, cost, stock)
values(1002, '새우깡', 1500, 500);
insert into products(pno, pname, cost, stock)
values(1003, '월드콘', 2000, 350);
insert into products(pno, pname, cost, stock)
values(1004, '빼빼로', 2000, 700);
insert into products(pno, pname, cost, stock)
values(1005, '코카콜라', 1800, 550);
insert into products(pno, pname, cost, stock)
values(1006, '환타', 1600, 300);
select * from products;

insert into customers(cno, cname, address, email, phone)
values(101,'김철수','서울 강남구','cskim@naver.com','899-6666');
insert into customers(cno, cname, address, email, phone)
values(102,'이영희','부산 서면','yhlee@empal.com','355-8882');
insert into customers(cno, cname, address, email, phone)
values(103,'최진국','제주 동광양','jkchoi@gmail.com','852-5764');
insert into customers(cno, cname, address, email, phone)
values(104,'강준호','강릉 홍제동','jhkang@hanmail.com','559-7777');
insert into customers(cno, cname, address, email, phone)
values(105,'민병국','대전 전민동','bgmin@hotmail.com','559-8741');
insert into customers(cno, cname, address, email, phone)
values(106,'오민수','광주 북구','msoh@microsoft.com','542-9988');

select * from customers;
select * from products;
commit;

select sysdate from dual;
select address from customers where cno = 101;
select * from orders;
select * from orderdetail;
select pno from products where pname = '삼양라면';

/*
4. 다음과 같은 주문 정보를 orders 테이블과 orderdetail 테이블에 입력하시오. cno는 customers 테이블에서
검색하여 입력할 것. orders에 1건, orderdetail에 1건을 입력한다. 

“김철수(101)가 3일전에 삼양라면(1001)을 개당 1000원에 50개 주문하였다.”
*/
insert into orders(orderno, orderdate, address, phone, status, cno)
values(1,
        (select sysdate from dual), 
        (select address from customers where cno = 101),
        (select phone from customers where cno = 101),
        '결제완료',
        101
        );

insert into orderdetail(orderno, pno, qty, cost)
values(1,
        (select pno from products where pname = '삼양라면'),
        50,
        (select cost from products where pname = '삼양라면'));

/*
5. 위와 같은 주문 정보에서 해당 상품(products)의 재고(stock)을 수정하시오.
“삼양라면(1001)의 재고를 150(=200-50)개로 변경한다”
*/
update products set stock=150 
where pname = '삼양라면';

/*
6. 다음과 같은 주문 정보를 orders 테이블과 orderdetail 테이블에 입력하시오. cno는 customers 테이블에서
검색하여 입력할 것. orders에 1건, orderdetail에 2건을 입력한다.
“이영희(102)가 이틀전에 새우깡(1002)을 개당 1500원에 100개, 월드콘(1003)을 개당 2000원에 150개
주문하였다.”
*/
CREATE SEQUENCE ORDERS_SEQ ; 
SELECT ORDERS_SEQ FROM DUAL ; 
SELECT ORDERS_SEQ.NEXTVAL FROM DUAL ; 
SELECT ORDERS_SEQ.CURRVAL FROM DUAL ; 
select sysdate - 2 from dual;

insert into orders(orderno, orderdate, address, phone, status, cno)
values(ORDERS_SEQ.nextval,
        (select sysdate - 2 from dual), 
        (select address from customers where cno = 102),
        (select phone from customers where cno = 102),
        '결제완료',
        102
        );
select o.orderno, o.orderdate, ct.cname, o.address, o.phone, o.status, pd.pname, od.cost, od.qty
from   orders o
join   orderdetail od on(o.orderno = od.orderno)
join   customers ct on(ct.cno = o.cno)
join   products pd on(pd.pno = od.pno)
where  o.orderno = 1

insert into orderdetail(orderno, pno, qty, cost)
values(2,
        (select pno from products where pname = '새우깡'),
        100,
        (select cost from products where pname = '새우깡'));
insert into orderdetail(orderno, pno, qty, cost)
values(2,
        (select pno from products where pname = '월드콘'),
        150,
        (select cost from products where pname = '월드콘'));

select o.orderno, o.orderdate, ct.cname, o.address, o.phone, o.status, pd.pname, od.cost, od.qty
from   orders o
join   orderdetail od on(o.orderno = od.orderno)
join   customers ct on(ct.cno = o.cno)
join   products pd on(pd.pno = od.pno)
where  o.orderno = 2

/*
7. 위와 같은 주문 정보에서 해당 상품(products)의 재고(stock)을 수정하시오
“새우깡(1002)의 재고를 400(=500-100)개로 변경한다”
 “월드콘(1003)의 재고를 200(=350-150)개로 변경한다”

*/
update products set stock=400
where pname = '새우깡';
update products set stock=200
where pname = '월드콘';

select * from products;

/*
8. 다음과 같은 주문 정보를 orders 테이블과 orderdetail 테이블에 입력하시오. cno는 customers 테이블에서
검색하여 입력할 것. orders에 1건, orderdetail에 2건을 입력한다.
“오민수(106)가 어제 빼빼로(1004)를 개당 2000원에 100개, 코카콜라(1005)를 개당 1800원에 50개 주문하였다.”

*/

select cno from customers where cname = '오민수'
insert into orders(orderno, orderdate, address, phone, status, cno)
values(ORDERS_SEQ.nextval,
        (select sysdate from dual), 
        (select address from customers where cno = (select cno from customers where cname = '오민수')),
        (select phone from customers where cno = (select cno from customers where cname = '오민수')),
        '결제완료',
        (select cno from customers where cname = '오민수')
        );
select o.orderno, o.orderdate, ct.cname, o.address, o.phone, o.status, pd.pname, od.cost, od.qty
from   orders o
join   orderdetail od on(o.orderno = od.orderno)
join   customers ct on(ct.cno = o.cno)
join   products pd on(pd.pno = od.pno)
where  o.orderno = 1


insert into orderdetail(orderno, pno, qty, cost)
values(3,
        (select pno from products where pname = '빼빼로'),
        100,
        (select cost from products where pname = '빼빼로'));
insert into orderdetail(orderno, pno, qty, cost)
values(3,
        (select pno from products where pname = '코카콜라'),
        50,
        (select cost from products where pname = '코카콜라'));
select o.orderno, o.orderdate, ct.cname, o.address, o.phone, o.status, pd.pname, od.cost, od.qty
from   orders o
join   orderdetail od on(o.orderno = od.orderno)
join   customers ct on(ct.cno = o.cno)
join   products pd on(pd.pno = od.pno)
where  o.orderno = 3
update orders set orderdate =  (select sysdate from dual) where orderno = 3

/*
9. 위와 같은 주문 정보에서 해당 상품(products)의 재고(stock)을 수정하시오.
 “빼빼로(1004)의 재고를 600(=700-100)개로 변경한다”
 “코카콜라(1005)의 재고를 500(=550-50)개로 변경한다
*/
update products set stock=600
where pname = '빼빼로';
update products set stock=500
where pname = '코카콜라';

/*
10. 다음과 같은 전체 주문 목록을 출력하는 문장을 작성하시오.
*/
select o.orderno, o.orderdate, ct.cname, o.address, o.phone, o.status, pd.pname, od.cost, od.qty, od.cost*od.qty
from   orders o
join   orderdetail od on(o.orderno = od.orderno)
join   customers ct on(ct.cno = o.cno)
join   products pd on(pd.pno = od.pno)
order by 1 asc
/*
11. 다음과 같이 일별 매출 목록을 출력하는 문장을 작성하시오.
*/

select o.orderdate, sum(od.cost*od.qty)
from   orders o
join   orderdetail od on(o.orderno = od.orderno)
group by o.orderdate

order by 1 asc;

/*
12. 다음과 같은 신규 상품 정보를 products 테이블에 입력하시오.
“제품번호는 1007, 상품명은 목캔디, 단가는 3000원, 재고는 500개이다.”
*/
insert into products(pno, pname, cost, stock)
values(1007, '목캔디', 3000, 500);

/*
13. 다음과 같은 4번 주문 정보를 입력하고, 재고를 적절히 수정하시오. 주문 정보를 입력하고, 10번 문제에서
작성한 문장으로 검색하면 다음과 같다.
“최진국(103)이 오늘 목캔디(1007)를 개당 3000원에 200개 주문하였으며, 배송지의 주소는 제주 동광양이며,
연락처는 352-4657이고, 결제가 완료된 상태이다.”
*/


select cno from customers where cname = '오민수';
insert into orders(orderno, orderdate, address, phone, status, cno)
values(ORDERS_SEQ.nextval,
        (select sysdate from dual), 
        (select address from customers where cno = (select cno from customers where cname = '최진국')),
        (select phone from customers where cno = (select cno from customers where cname = '최진국')),
        '결제완료',
        (select cno from customers where cname = '최진국')
        );
select o.orderno, o.orderdate, ct.cname, o.address, o.phone, o.status, pd.pname, od.cost, od.qty
from   orders o
join   orderdetail od on(o.orderno = od.orderno)
join   customers ct on(ct.cno = o.cno)
join   products pd on(pd.pno = od.pno)
where  o.orderno = 4;


insert into orderdetail(orderno, pno, qty, cost)
values(4,
        (select pno from products where pname = '목캔디'),
        200,
        (select cost from products where pname = '목캔디'));

select o.orderno, o.orderdate, ct.cname, o.address, o.phone, o.status, pd.pname, od.cost, od.qty
from   orders o
join   orderdetail od on(o.orderno = od.orderno)
join   customers ct on(ct.cno = o.cno)
join   products pd on(pd.pno = od.pno)
where  o.orderno = 4

update products set stock=300
where pname = '목캔디';

select o.orderno, o.orderdate, ct.cname, o.address, o.phone, o.status, pd.pname, od.cost, od.qty, od.cost*od.qty
from   orders o
join   orderdetail od on(o.orderno = od.orderno)
join   customers ct on(ct.cno = o.cno)
join   products pd on(pd.pno = od.pno)
order by 1 asc;

commit;

CREATE TABLE MEMBER(
    MEMBER_ID     NUMBER(10) PRIMARY KEY,
    NAME   VARCHAR2(25) NOT NULL,
    ADDRESS VARCHAR2(100) ,
    CITY   VARCHAR2(30) ,
    PHONE   VARCHAR2(15) ,
    JOIN_DATE   DATE DEFAULT SYSDATE NOT NULL
);

CREATE TABLE TITLE(
    TITLE_ID     NUMBER(10) PRIMARY KEY,
    TITLE        VARCHAR2(60) NOT NULL,
    DESCRIPTION  VARCHAR2(400) NOT NULL,
    RATING       VARCHAR2(20),
    CATEGORY     VARCHAR2(20),
    RELEASE_DATE     DATE,
    CHECK(RATING IN ('18가', '15가', '12가', '전체가')),
    CHECK(CATEGORY IN ('드라마', '코미디', '액션', '아동', 'SF', '다큐멘터리'))
    
);

CREATE TABLE TITLE_COPY(
    COPY_ID     NUMBER(10),
    TITLE_ID    NUMBER(10),
    STATUS      VARCHAR2(20) NOT NULL,
    CHECK(STATUS IN ('대여가능', '파손', '대여중', '예약')),
    FOREIGN KEY(TITLE_ID) REFERENCES TITLE(TITLE_ID),
    PRIMARY KEY(COPY_ID, TITLE_ID)
);

CREATE TABLE RENTAL(
    BOOK_DATE   DATE DEFAULT SYSDATE,
    MEMBER_ID   NUMBER(10),
    COPY_ID     NUMBER(10),
    TITLE_ID    NUMBER(10),
    ACT_RET_DATE  DATE ,
    EXP_RET_DATE  DATE DEFAULT SYSDATE + 2,
    FOREIGN KEY(MEMBER_ID) REFERENCES MEMBER(MEMBER_ID),
    FOREIGN KEY(COPY_ID, TITLE_ID) REFERENCES TITLE_COPY(COPY_ID, TITLE_ID),
    PRIMARY KEY(BOOK_DATE, MEMBER_ID, COPY_ID, TITLE_ID)
);
CREATE TABLE RESERVATION(
    RES_DATE   DATE ,
    MEMBER_ID   NUMBER(10),
    TITLE_ID    NUMBER(10),
    FOREIGN KEY(MEMBER_ID) REFERENCES MEMBER(MEMBER_ID),
    FOREIGN KEY(TITLE_ID) REFERENCES TITLE(TITLE_ID),
    PRIMARY KEY(RES_DATE, MEMBER_ID, TITLE_ID)
);
drop table TITLE;
drop table TITLE_COPY;
drop table RENTAL;
drop table RESERVATION;
/*
--2. member 테이블과 title 테이블의 각 행을 고유하게 식별하기 위한 시퀀스를 생성하시오.
A. member 테이블의 member_id : 101번부터 부여되며 캐시하지 않음. 시퀀스명은 member_id_seq
B. title 테이블의 title_id : 92번부터 부여되며 캐시하지 않음. 시퀀스명은 title_id_seq
*/


/*
CREATE SEQUENCE SEQUENCE_NAME 
START WITH 10
INCREMENT BY 10 
MAXVALUE 100
*/
-- NEXTVAL , CURRVAL

CREATE SEQUENCE TEST_SEQ ; 
SELECT TEST_SEQ.NEXTVAL FROM DUAL ; 
SELECT TEST_SEQ.CURRVAL FROM DUAL ; 

DROP SEQUENCE TEST_SEQ ; 

CREATE SEQUENCE member_id_seq 
START WITH 101
INCREMENT BY 1 ;
DROP SEQUENCE member_id_seq ; 
CREATE SEQUENCE title_id_seq 
START WITH 92
INCREMENT BY 1 ;
DROP SEQUENCE title_id_seq ; 
commit;
/*
3. title 테이블에 다음 데이터를 입력하시오. title_id는 시퀀스로부터 값을 받아 입력할 것.

*/
select to_date('95/10/05') from dual;

insert into title(title_id, title, description, rating, category, release_date)
values(title_id_seq.nextval, '인어공주', '인어공주 설명', '전체가', '아동', to_date('95/10/05'));
insert into title(title_id, title, description, rating, category, release_date)
values(title_id_seq.nextval, '매트릭스','매트릭스 설명','15가','SF', to_date('95/05/19'));
insert into title(title_id, title, description, rating, category, release_date)
values(title_id_seq.nextval, '에이리언','에이리언 설명','18가','SF', to_date('95/08/12'));
insert into title(title_id, title, description, rating, category, release_date)
values(title_id_seq.nextval, '모던타임즈','모던타임즈 설명','전체가','코미디', to_date('95/07/12'));
insert into title(title_id, title, description, rating, category, release_date)
values(title_id_seq.nextval, '러브스토리','러브스토리 설명','전체가','드라마', to_date('95/09/12'));
insert into title(title_id, title, description, rating, category, release_date)
values(title_id_seq.nextval, '람보','람보 설명','18가','액션', to_date('95/06/01'));
select title_id_seq.nextval from dual;

select * from title

/*
4. member 테이블에 다음 데이터를 입력하시오. member_id는 시퀀스로부터 값을 받아 입력할 것.

*/
insert into member(member_id, name, address, city, phone, join_date)
values(member_id_seq.nextval, '김철수','강남구','서울','899-6666',to_date('90/03/08'));
insert into member(member_id, name, address, city, phone, join_date)
values(member_id_seq.nextval, '이영희','서면','부산','355-8882',to_date('90/03/08'));
insert into member(member_id, name, address, city, phone, join_date)
values(member_id_seq.nextval, '최진국','동광양','제주','852-5764',to_date('91/06/17'));
insert into member(member_id, name, address, city, phone, join_date)
values(member_id_seq.nextval, '강준호','홍제동','강릉','559-7777',to_date('90/04/07'));
insert into member(member_id, name, address, city, phone, join_date)
values(member_id_seq.nextval, '민병국','전민동','대전','559-8741',to_date('91/01/18'));
insert into member(member_id, name, address, city, phone, join_date)
values(member_id_seq.nextval, '오민수','북구','광주','542-9988',to_date('91/01/18'));

select * from member;

/*
5. 다음과 같은 테이프 정보를 title_copy 테이블에 입력하시오. title_id 컬럼의 값을 title 테이블에서 확인하여
입력할 것. 즉, 인어공주를 title에서 검색하여 리턴된 값(92)을 입력하시오.
*/
select title_id from title where title = '인어공주';
insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '인어공주'), 1, '대여가능');
insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '매트릭스'), 1, '대여가능');

insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '매트릭스'), 2, '대여중');

insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '에이리언'), 1, '대여가능');

insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '모던타임즈'), 1, '대여가능');

insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '모던타임즈'), 2, '대여가능');

insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '모던타임즈'), 3, '대여중');

insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '러브스토리'), 1, '대여가능');

insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '람보'), 1, '대여가능');

select * from title_copy ;

/*
6. 다음과 같은 대여 정보를 rental 테이블에 입력하시오. 여기서, 인어공주를 title에서 검색하여 리턴된 값
(92)과 김철수를 member에서 검색하여 리턴 된 값(101)을 테이블에 입력하시오.

*/
insert into rental(title_id, copy_id , member_id, book_date, exp_ret_date, act_ret_date)
values(
        (select title_id from title where title = '인어공주'),
        (select copy_id from title_copy where title_id = (select title_id from title where title = '인어공주')),
        (select member_id from member where  name= '김철수'),
        (select sysdate-3 from dual),
        (select sysdate-1 from dual),
        (select sysdate-2 from dual)
    );
insert into rental(title_id, copy_id , member_id, book_date, exp_ret_date)
values(
        (select title_id from title where title = '매트릭스'),
        (2),
        (select member_id from member where  name= '최진국'),
        (select sysdate-1 from dual),
        (select sysdate+1 from dual)
    );   
insert into rental(title_id, copy_id , member_id, book_date, exp_ret_date)
values(
        (select title_id from title where title = '모던타임즈'),
        (3),
        (select member_id from member where  name= '강준호'),
        (select sysdate-2 from dual),
        (select sysdate from dual)
    ); 
insert into rental(title_id, copy_id , member_id, book_date, exp_ret_date, act_ret_date)
values(
        (select title_id from title where title = '람보'),
        1,
        (select member_id from member where  name= '민병국'),
        (select sysdate-4 from dual),
        (select sysdate-2 from dual),
        (select sysdate-2 from dual)
    );

select * from rental;

CREATE OR REPLACE VIEW title_avail
AS     
    select ti.title, tc.copy_id, tc.status, re.exp_ret_date
    from title ti
    join title_copy tc on (ti.title_id = tc.title_id)
    left join rental re on (tc.title_id = re.title_id and tc.copy_id = re.copy_id)
    order by ti.title_id, tc.copy_id;
    
select * from title_avail;

/*
8. 다음 데이터를 추가하시오.
A. 새로운 비디오 정보를 title 테이블에 입력한다. 제목은 ‘스타워즈’, 등급은 ‘전체가’, 붂류는 ‘SF’, 설명은
‘스타워즈 설명’, 출시일은 ‘77/07/07’이다. 이 비디오는 2개의 테이프를 보유하고 있으며, 이 정보를
title_copy에 입력한다. 2개의 테이프는 모두 대여가능한 상태이다.
B. 2건의 예약정보를 reservation 테이블에 입력한다. ‘이영희’가 ‘스타워즈’를 예약하였고, ‘오민수’가 ‘러브
스토리’를 예약하였다.
C. ‘이영희’가 ‘스타워즈’의 1번 테이프를 대여하였으므로, reservation 테이블의 예약정보를 삭제하고,
rental 테이블에 대여정보를 입력하시오. 예상 반납 일자(exp_ret_date)는 디폴트 값을 입력하시오.
title_copy 테이블의 status를 변경하시오. 앞서 생성한 뷰를 검색하면 다음과 같은 결과가 표시된다.

*/
insert into title(title_id, title, description, rating, category, release_date)
values(title_id_seq.nextval, '스타워즈', '스타워즈 설명', '전체가', 'SF', to_date('77/07/07'));    

insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '스타워즈'), 1, '대여가능');
insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '스타워즈'), 2, '대여가능');

select * from title;
select * from title_copy;

insert into reservation(res_date, member_id , title_id)
values(sysdate, (select member_id from member where name = '이영희'), (select title_id from title where title = '스타워즈'));

insert into reservation(res_date, member_id , title_id)
values(sysdate, (select member_id from member where name = '오민수'), (select title_id from title where title = '러브스토리'));

select * from reservation;
select * from member;
delete from reservation where member_id = 102;
select * from rental;
insert into rental(title_id, copy_id , member_id, book_date)
values(
        (select title_id from title where title = '스타워즈'),
        1,
        (select member_id from member where  name= '이영희'),
        (select sysdate from dual)    
    );
select * from title_copy;
update title_copy set status = '대여중' where copy_id = 1 and title_id = 98;
select * from title_avail;

/*
9. title 테이블에 price 컬럼을 number(5) 타입으로 추가하고, 각 비디오에 대한 가격을 업데이트하시오. 또한,
price 컬럼에 not null 제약조건을 지정하시오.
*/
ALTER TABLE TITLE ADD PRICE NUMBER(5)DEFAULT 0 NOT NULL;
SELECT * FROM TITLE;

UPDATE TITLE SET PRICE = 3000 WHERE  TITLE = '인어공주'; 
인어공주 3000
UPDATE TITLE SET PRICE = 2500 WHERE  TITLE = '매트릭스'; 
매트릭스 2500
UPDATE TITLE SET PRICE = 2000 WHERE  TITLE = '에이리언'; 
에이리언 2000
UPDATE TITLE SET PRICE = 3000 WHERE  TITLE = '모던타임즈'; 
모던타임즈 3000
UPDATE TITLE SET PRICE = 3500 WHERE  TITLE = '러브스토리'; 
러브스토리 3500
UPDATE TITLE SET PRICE = 2000 WHERE  TITLE = '람보'; 
람보 2000
UPDATE TITLE SET PRICE = 1500 WHERE  TITLE = '스타워즈'; 
스타워즈 1500
SELECT * FROM TITLE;

/*
10. 다음과 같은 보고서를 작성 할 수 있는 쿼리 문장을 작성하시오. 이 보고서에는 고객의 비디오 대여 이력
이 포함되며, 고객명, 대여한 비디오 제목, 대여일, 대여기갂이 포함되어 있어야 함.
*/
select  me.name as 회원명, 
        ti.title as 제목, 
        re.book_date as 대여일, 
       re.act_ret_date - re.book_date as 기간
from  rental re
join  title_copy  tc on (re.title_id = tc.title_id and re.copy_id = tc.copy_id)
join  title       ti on (tc.title_id = ti.title_id)
join  member      me on (re.member_id = me.member_id);


commit;
























