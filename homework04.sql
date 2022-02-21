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
    CHECK(STATUS IN ('�����Ϸ�', '�����', '��ۿϷ�')),
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
values(1001, '�����',1000, 200);
insert into products(pno, pname, cost, stock)
values(1002, '�����', 1500, 500);
insert into products(pno, pname, cost, stock)
values(1003, '������', 2000, 350);
insert into products(pno, pname, cost, stock)
values(1004, '������', 2000, 700);
insert into products(pno, pname, cost, stock)
values(1005, '��ī�ݶ�', 1800, 550);
insert into products(pno, pname, cost, stock)
values(1006, 'ȯŸ', 1600, 300);
select * from products;

insert into customers(cno, cname, address, email, phone)
values(101,'��ö��','���� ������','cskim@naver.com','899-6666');
insert into customers(cno, cname, address, email, phone)
values(102,'�̿���','�λ� ����','yhlee@empal.com','355-8882');
insert into customers(cno, cname, address, email, phone)
values(103,'������','���� ������','jkchoi@gmail.com','852-5764');
insert into customers(cno, cname, address, email, phone)
values(104,'����ȣ','���� ȫ����','jhkang@hanmail.com','559-7777');
insert into customers(cno, cname, address, email, phone)
values(105,'�κ���','���� ���ε�','bgmin@hotmail.com','559-8741');
insert into customers(cno, cname, address, email, phone)
values(106,'���μ�','���� �ϱ�','msoh@microsoft.com','542-9988');

select * from customers;
select * from products;
commit;

select sysdate from dual;
select address from customers where cno = 101;
select * from orders;
select * from orderdetail;
select pno from products where pname = '�����';

/*
4. ������ ���� �ֹ� ������ orders ���̺�� orderdetail ���̺� �Է��Ͻÿ�. cno�� customers ���̺���
�˻��Ͽ� �Է��� ��. orders�� 1��, orderdetail�� 1���� �Է��Ѵ�. 

����ö��(101)�� 3������ �����(1001)�� ���� 1000���� 50�� �ֹ��Ͽ���.��
*/
insert into orders(orderno, orderdate, address, phone, status, cno)
values(1,
        (select sysdate from dual), 
        (select address from customers where cno = 101),
        (select phone from customers where cno = 101),
        '�����Ϸ�',
        101
        );

insert into orderdetail(orderno, pno, qty, cost)
values(1,
        (select pno from products where pname = '�����'),
        50,
        (select cost from products where pname = '�����'));

/*
5. ���� ���� �ֹ� �������� �ش� ��ǰ(products)�� ���(stock)�� �����Ͻÿ�.
�������(1001)�� ��� 150(=200-50)���� �����Ѵ١�
*/
update products set stock=150 
where pname = '�����';

/*
6. ������ ���� �ֹ� ������ orders ���̺�� orderdetail ���̺� �Է��Ͻÿ�. cno�� customers ���̺���
�˻��Ͽ� �Է��� ��. orders�� 1��, orderdetail�� 2���� �Է��Ѵ�.
���̿���(102)�� ��Ʋ���� �����(1002)�� ���� 1500���� 100��, ������(1003)�� ���� 2000���� 150��
�ֹ��Ͽ���.��
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
        '�����Ϸ�',
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
        (select pno from products where pname = '�����'),
        100,
        (select cost from products where pname = '�����'));
insert into orderdetail(orderno, pno, qty, cost)
values(2,
        (select pno from products where pname = '������'),
        150,
        (select cost from products where pname = '������'));

select o.orderno, o.orderdate, ct.cname, o.address, o.phone, o.status, pd.pname, od.cost, od.qty
from   orders o
join   orderdetail od on(o.orderno = od.orderno)
join   customers ct on(ct.cno = o.cno)
join   products pd on(pd.pno = od.pno)
where  o.orderno = 2

/*
7. ���� ���� �ֹ� �������� �ش� ��ǰ(products)�� ���(stock)�� �����Ͻÿ�
�������(1002)�� ��� 400(=500-100)���� �����Ѵ١�
 ��������(1003)�� ��� 200(=350-150)���� �����Ѵ١�

*/
update products set stock=400
where pname = '�����';
update products set stock=200
where pname = '������';

select * from products;

/*
8. ������ ���� �ֹ� ������ orders ���̺�� orderdetail ���̺� �Է��Ͻÿ�. cno�� customers ���̺���
�˻��Ͽ� �Է��� ��. orders�� 1��, orderdetail�� 2���� �Է��Ѵ�.
�����μ�(106)�� ���� ������(1004)�� ���� 2000���� 100��, ��ī�ݶ�(1005)�� ���� 1800���� 50�� �ֹ��Ͽ���.��

*/

select cno from customers where cname = '���μ�'
insert into orders(orderno, orderdate, address, phone, status, cno)
values(ORDERS_SEQ.nextval,
        (select sysdate from dual), 
        (select address from customers where cno = (select cno from customers where cname = '���μ�')),
        (select phone from customers where cno = (select cno from customers where cname = '���μ�')),
        '�����Ϸ�',
        (select cno from customers where cname = '���μ�')
        );
select o.orderno, o.orderdate, ct.cname, o.address, o.phone, o.status, pd.pname, od.cost, od.qty
from   orders o
join   orderdetail od on(o.orderno = od.orderno)
join   customers ct on(ct.cno = o.cno)
join   products pd on(pd.pno = od.pno)
where  o.orderno = 1


insert into orderdetail(orderno, pno, qty, cost)
values(3,
        (select pno from products where pname = '������'),
        100,
        (select cost from products where pname = '������'));
insert into orderdetail(orderno, pno, qty, cost)
values(3,
        (select pno from products where pname = '��ī�ݶ�'),
        50,
        (select cost from products where pname = '��ī�ݶ�'));
select o.orderno, o.orderdate, ct.cname, o.address, o.phone, o.status, pd.pname, od.cost, od.qty
from   orders o
join   orderdetail od on(o.orderno = od.orderno)
join   customers ct on(ct.cno = o.cno)
join   products pd on(pd.pno = od.pno)
where  o.orderno = 3
update orders set orderdate =  (select sysdate from dual) where orderno = 3

/*
9. ���� ���� �ֹ� �������� �ش� ��ǰ(products)�� ���(stock)�� �����Ͻÿ�.
 ��������(1004)�� ��� 600(=700-100)���� �����Ѵ١�
 ����ī�ݶ�(1005)�� ��� 500(=550-50)���� �����Ѵ�
*/
update products set stock=600
where pname = '������';
update products set stock=500
where pname = '��ī�ݶ�';

/*
10. ������ ���� ��ü �ֹ� ����� ����ϴ� ������ �ۼ��Ͻÿ�.
*/
select o.orderno, o.orderdate, ct.cname, o.address, o.phone, o.status, pd.pname, od.cost, od.qty, od.cost*od.qty
from   orders o
join   orderdetail od on(o.orderno = od.orderno)
join   customers ct on(ct.cno = o.cno)
join   products pd on(pd.pno = od.pno)
order by 1 asc
/*
11. ������ ���� �Ϻ� ���� ����� ����ϴ� ������ �ۼ��Ͻÿ�.
*/

select o.orderdate, sum(od.cost*od.qty)
from   orders o
join   orderdetail od on(o.orderno = od.orderno)
group by o.orderdate

order by 1 asc;

/*
12. ������ ���� �ű� ��ǰ ������ products ���̺� �Է��Ͻÿ�.
����ǰ��ȣ�� 1007, ��ǰ���� ��ĵ��, �ܰ��� 3000��, ���� 500���̴�.��
*/
insert into products(pno, pname, cost, stock)
values(1007, '��ĵ��', 3000, 500);

/*
13. ������ ���� 4�� �ֹ� ������ �Է��ϰ�, ��� ������ �����Ͻÿ�. �ֹ� ������ �Է��ϰ�, 10�� ��������
�ۼ��� �������� �˻��ϸ� ������ ����.
��������(103)�� ���� ��ĵ��(1007)�� ���� 3000���� 200�� �ֹ��Ͽ�����, ������� �ּҴ� ���� �������̸�,
����ó�� 352-4657�̰�, ������ �Ϸ�� �����̴�.��
*/


select cno from customers where cname = '���μ�';
insert into orders(orderno, orderdate, address, phone, status, cno)
values(ORDERS_SEQ.nextval,
        (select sysdate from dual), 
        (select address from customers where cno = (select cno from customers where cname = '������')),
        (select phone from customers where cno = (select cno from customers where cname = '������')),
        '�����Ϸ�',
        (select cno from customers where cname = '������')
        );
select o.orderno, o.orderdate, ct.cname, o.address, o.phone, o.status, pd.pname, od.cost, od.qty
from   orders o
join   orderdetail od on(o.orderno = od.orderno)
join   customers ct on(ct.cno = o.cno)
join   products pd on(pd.pno = od.pno)
where  o.orderno = 4;


insert into orderdetail(orderno, pno, qty, cost)
values(4,
        (select pno from products where pname = '��ĵ��'),
        200,
        (select cost from products where pname = '��ĵ��'));

select o.orderno, o.orderdate, ct.cname, o.address, o.phone, o.status, pd.pname, od.cost, od.qty
from   orders o
join   orderdetail od on(o.orderno = od.orderno)
join   customers ct on(ct.cno = o.cno)
join   products pd on(pd.pno = od.pno)
where  o.orderno = 4

update products set stock=300
where pname = '��ĵ��';

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
    CHECK(RATING IN ('18��', '15��', '12��', '��ü��')),
    CHECK(CATEGORY IN ('���', '�ڹ̵�', '�׼�', '�Ƶ�', 'SF', '��ť���͸�'))
    
);

CREATE TABLE TITLE_COPY(
    COPY_ID     NUMBER(10),
    TITLE_ID    NUMBER(10),
    STATUS      VARCHAR2(20) NOT NULL,
    CHECK(STATUS IN ('�뿩����', '�ļ�', '�뿩��', '����')),
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
--2. member ���̺�� title ���̺��� �� ���� �����ϰ� �ĺ��ϱ� ���� �������� �����Ͻÿ�.
A. member ���̺��� member_id : 101������ �ο��Ǹ� ĳ������ ����. ���������� member_id_seq
B. title ���̺��� title_id : 92������ �ο��Ǹ� ĳ������ ����. ���������� title_id_seq
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
3. title ���̺� ���� �����͸� �Է��Ͻÿ�. title_id�� �������κ��� ���� �޾� �Է��� ��.

*/
select to_date('95/10/05') from dual;

insert into title(title_id, title, description, rating, category, release_date)
values(title_id_seq.nextval, '�ξ����', '�ξ���� ����', '��ü��', '�Ƶ�', to_date('95/10/05'));
insert into title(title_id, title, description, rating, category, release_date)
values(title_id_seq.nextval, '��Ʈ����','��Ʈ���� ����','15��','SF', to_date('95/05/19'));
insert into title(title_id, title, description, rating, category, release_date)
values(title_id_seq.nextval, '���̸���','���̸��� ����','18��','SF', to_date('95/08/12'));
insert into title(title_id, title, description, rating, category, release_date)
values(title_id_seq.nextval, '���Ÿ����','���Ÿ���� ����','��ü��','�ڹ̵�', to_date('95/07/12'));
insert into title(title_id, title, description, rating, category, release_date)
values(title_id_seq.nextval, '���꽺�丮','���꽺�丮 ����','��ü��','���', to_date('95/09/12'));
insert into title(title_id, title, description, rating, category, release_date)
values(title_id_seq.nextval, '����','���� ����','18��','�׼�', to_date('95/06/01'));
select title_id_seq.nextval from dual;

select * from title

/*
4. member ���̺� ���� �����͸� �Է��Ͻÿ�. member_id�� �������κ��� ���� �޾� �Է��� ��.

*/
insert into member(member_id, name, address, city, phone, join_date)
values(member_id_seq.nextval, '��ö��','������','����','899-6666',to_date('90/03/08'));
insert into member(member_id, name, address, city, phone, join_date)
values(member_id_seq.nextval, '�̿���','����','�λ�','355-8882',to_date('90/03/08'));
insert into member(member_id, name, address, city, phone, join_date)
values(member_id_seq.nextval, '������','������','����','852-5764',to_date('91/06/17'));
insert into member(member_id, name, address, city, phone, join_date)
values(member_id_seq.nextval, '����ȣ','ȫ����','����','559-7777',to_date('90/04/07'));
insert into member(member_id, name, address, city, phone, join_date)
values(member_id_seq.nextval, '�κ���','���ε�','����','559-8741',to_date('91/01/18'));
insert into member(member_id, name, address, city, phone, join_date)
values(member_id_seq.nextval, '���μ�','�ϱ�','����','542-9988',to_date('91/01/18'));

select * from member;

/*
5. ������ ���� ������ ������ title_copy ���̺� �Է��Ͻÿ�. title_id �÷��� ���� title ���̺��� Ȯ���Ͽ�
�Է��� ��. ��, �ξ���ָ� title���� �˻��Ͽ� ���ϵ� ��(92)�� �Է��Ͻÿ�.
*/
select title_id from title where title = '�ξ����';
insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '�ξ����'), 1, '�뿩����');
insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '��Ʈ����'), 1, '�뿩����');

insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '��Ʈ����'), 2, '�뿩��');

insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '���̸���'), 1, '�뿩����');

insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '���Ÿ����'), 1, '�뿩����');

insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '���Ÿ����'), 2, '�뿩����');

insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '���Ÿ����'), 3, '�뿩��');

insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '���꽺�丮'), 1, '�뿩����');

insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '����'), 1, '�뿩����');

select * from title_copy ;

/*
6. ������ ���� �뿩 ������ rental ���̺� �Է��Ͻÿ�. ���⼭, �ξ���ָ� title���� �˻��Ͽ� ���ϵ� ��
(92)�� ��ö���� member���� �˻��Ͽ� ���� �� ��(101)�� ���̺� �Է��Ͻÿ�.

*/
insert into rental(title_id, copy_id , member_id, book_date, exp_ret_date, act_ret_date)
values(
        (select title_id from title where title = '�ξ����'),
        (select copy_id from title_copy where title_id = (select title_id from title where title = '�ξ����')),
        (select member_id from member where  name= '��ö��'),
        (select sysdate-3 from dual),
        (select sysdate-1 from dual),
        (select sysdate-2 from dual)
    );
insert into rental(title_id, copy_id , member_id, book_date, exp_ret_date)
values(
        (select title_id from title where title = '��Ʈ����'),
        (2),
        (select member_id from member where  name= '������'),
        (select sysdate-1 from dual),
        (select sysdate+1 from dual)
    );   
insert into rental(title_id, copy_id , member_id, book_date, exp_ret_date)
values(
        (select title_id from title where title = '���Ÿ����'),
        (3),
        (select member_id from member where  name= '����ȣ'),
        (select sysdate-2 from dual),
        (select sysdate from dual)
    ); 
insert into rental(title_id, copy_id , member_id, book_date, exp_ret_date, act_ret_date)
values(
        (select title_id from title where title = '����'),
        1,
        (select member_id from member where  name= '�κ���'),
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
8. ���� �����͸� �߰��Ͻÿ�.
A. ���ο� ���� ������ title ���̺� �Է��Ѵ�. ������ ����Ÿ���, ����� ����ü����, ������ ��SF��, ������
����Ÿ���� ����, ������� ��77/07/07���̴�. �� ������ 2���� �������� �����ϰ� ������, �� ������
title_copy�� �Է��Ѵ�. 2���� �������� ��� �뿩������ �����̴�.
B. 2���� ���������� reservation ���̺� �Է��Ѵ�. ���̿��񡯰� ����Ÿ����� �����Ͽ���, �����μ����� ������
���丮���� �����Ͽ���.
C. ���̿��񡯰� ����Ÿ����� 1�� �������� �뿩�Ͽ����Ƿ�, reservation ���̺��� ���������� �����ϰ�,
rental ���̺� �뿩������ �Է��Ͻÿ�. ���� �ݳ� ����(exp_ret_date)�� ����Ʈ ���� �Է��Ͻÿ�.
title_copy ���̺��� status�� �����Ͻÿ�. �ռ� ������ �並 �˻��ϸ� ������ ���� ����� ǥ�õȴ�.

*/
insert into title(title_id, title, description, rating, category, release_date)
values(title_id_seq.nextval, '��Ÿ����', '��Ÿ���� ����', '��ü��', 'SF', to_date('77/07/07'));    

insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '��Ÿ����'), 1, '�뿩����');
insert into title_copy(title_id, copy_id , status)
values((select title_id from title where title = '��Ÿ����'), 2, '�뿩����');

select * from title;
select * from title_copy;

insert into reservation(res_date, member_id , title_id)
values(sysdate, (select member_id from member where name = '�̿���'), (select title_id from title where title = '��Ÿ����'));

insert into reservation(res_date, member_id , title_id)
values(sysdate, (select member_id from member where name = '���μ�'), (select title_id from title where title = '���꽺�丮'));

select * from reservation;
select * from member;
delete from reservation where member_id = 102;
select * from rental;
insert into rental(title_id, copy_id , member_id, book_date)
values(
        (select title_id from title where title = '��Ÿ����'),
        1,
        (select member_id from member where  name= '�̿���'),
        (select sysdate from dual)    
    );
select * from title_copy;
update title_copy set status = '�뿩��' where copy_id = 1 and title_id = 98;
select * from title_avail;

/*
9. title ���̺� price �÷��� number(5) Ÿ������ �߰��ϰ�, �� ������ ���� ������ ������Ʈ�Ͻÿ�. ����,
price �÷��� not null ���������� �����Ͻÿ�.
*/
ALTER TABLE TITLE ADD PRICE NUMBER(5)DEFAULT 0 NOT NULL;
SELECT * FROM TITLE;

UPDATE TITLE SET PRICE = 3000 WHERE  TITLE = '�ξ����'; 
�ξ���� 3000
UPDATE TITLE SET PRICE = 2500 WHERE  TITLE = '��Ʈ����'; 
��Ʈ���� 2500
UPDATE TITLE SET PRICE = 2000 WHERE  TITLE = '���̸���'; 
���̸��� 2000
UPDATE TITLE SET PRICE = 3000 WHERE  TITLE = '���Ÿ����'; 
���Ÿ���� 3000
UPDATE TITLE SET PRICE = 3500 WHERE  TITLE = '���꽺�丮'; 
���꽺�丮 3500
UPDATE TITLE SET PRICE = 2000 WHERE  TITLE = '����'; 
���� 2000
UPDATE TITLE SET PRICE = 1500 WHERE  TITLE = '��Ÿ����'; 
��Ÿ���� 1500
SELECT * FROM TITLE;

/*
10. ������ ���� ������ �ۼ� �� �� �ִ� ���� ������ �ۼ��Ͻÿ�. �� �������� ���� ���� �뿩 �̷�
�� ���ԵǸ�, ����, �뿩�� ���� ����, �뿩��, �뿩��A�� ���ԵǾ� �־�� ��.
*/
select  me.name as ȸ����, 
        ti.title as ����, 
        re.book_date as �뿩��, 
       re.act_ret_date - re.book_date as �Ⱓ
from  rental re
join  title_copy  tc on (re.title_id = tc.title_id and re.copy_id = tc.copy_id)
join  title       ti on (tc.title_id = ti.title_id)
join  member      me on (re.member_id = me.member_id);


commit;
























