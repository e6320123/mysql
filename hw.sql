
create database iii default character set utf8;

use iii;

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

create table customers (id int primary key auto_increment,name varchar(20),tel varchar(15)
    unique key ,email varchar(30),address varchar(40));

create table suppliers (id int primary key auto_increment,name varchar(20),tel varchar(15)
    unique key, address varchar(40));

create table products (id int primary key auto_increment,product_id varchar(5) unique key,
name varchar(20),price int,supplier_id int ,
          foreign key (supplier_id) references suppliers (id));

create table orders (id int primary key auto_increment,
	order_id varchar(5) unique key,customer_id int,
          foreign key (customer_id) references customers (id));

create table order_details (id int primary key auto_increment,
	order_id varchar(5) ,product_id varchar(5), price int ,count int,
          foreign key (order_id) references orders (order_id),
		foreign key (product_id) references products (product_id));
 
/*-----------------------------Procedures列表-----------------------
---客戶表---

call add_c(name,tel,email,address);
call up_cname(id,name);
call up_ctel(id,tel);
call up_cmail(id,email);
call up_caddr(id,address);
call del_c(id);

---供應商表---

call add_s(name,tel,address);
call up_sname(id,name);
call up_stel(id,tel);
call up_saddr(id,addr);
call del_s(id);

---產品表---

call add_p(product_id,name,price,supplier_id);
call up_pname(id,name);
call up_pprice(id,price);
call up_p_sid(id,supplier_id);
call del_p(id);

---訂單表---

call add_o(order_id,customer_id);
call del_o(id);                  --->trigger delete od

---訂單細項表---

call add_od(order_id,product_id,price,count);
call up_odprice(id,price);
call up_odcount(id,count);
call del_od(id);

---搜尋---

call s_cname(name);
call s_ctel(tel);
call s_sname(name);
call s_stel(tel);
call s_pname(name);

---綜合搜尋---

call sa(name);
call sb(id);        (客戶表id)
call sc(product_id);
call sd(id);        (供應商表id)

*/
 ----------------------------------------客戶表------------------------------------- 
 \d #

--新增客戶data
create procedure add_c(in add_name varchar(20),in add_tel varchar(15),add_email varchar(30),add_addr varchar(40))
begin
    insert into customers (name,tel,email,address) values(add_name,add_tel,add_email,add_addr);
end#
--修改客戶name
create procedure up_cname(in n int,in new_name varchar(20))
begin
     update customers set name=new_name where id =n;    
end#
--修改客戶tel
create procedure up_ctel(in n int,in new_tel varchar(15))
begin
     update customers set tel=new_tel where id =n;    
end#
--修改客戶email
create procedure up_cmail(in n int,in new_amil varchar(30))
begin
     update customers set email=new_amil where id =n;    
end#
--修改客戶address
create procedure up_caddr(in n int,in new_addr varchar(40))
begin
     update customers set address=new_addr where id =n;    
end#
--刪除客戶data
create procedure del_c(in n int)
begin
    delete from customers where id=n;
end#
\d ;

 ----------------------------------------供應商表------------------------------------- 
 \d #
--新增供應商data
create procedure add_s(in add_name varchar(20),in add_tel varchar(15),add_addr varchar(40))
begin
    insert into suppliers (name,tel,address) values(add_name,add_tel,add_addr);
end#
--修改供應商name
create procedure up_sname(in n int,in new_name varchar(20))
begin
     update suppliers set name=new_name where id =n;    
end#
--修改供應商tel
create procedure up_stel(in n int,in new_tel varchar(15))
begin
     update suppliers set tel=new_tel where id =n;    
end#
--修改供應商address
create procedure up_saddr(in n int,in new_addr varchar(40))
begin
     update suppliers set address=new_addr where id =n;    
end#
--刪除供應商data
create procedure del_s(in n int)
begin
    delete from suppliers where id=n;
end#
\d ;

----------------------------------------產品表------------------------------------- 
 \d #
--新增產品data
create procedure add_p(in n1 varchar(5),in n2 varchar(20),n3 int,n4 int)
begin
    insert into products (product_id,name,price,supplier_id) values(n1,n2,n3,n4);
end#
--修改產品name
create procedure up_pname(in n int,in new_name varchar(20))
begin
     update products set name=new_name where id =n;    
end#
--修改產品price
create procedure up_pprice(in n int,in new int)
begin
     update products set price=new where id =n;    
end#
--修改產品supplier_id
create procedure up_p_sid(in n int,in new int)
begin
     update products set supplier_id=new where id =n;
end#
--刪除產品data
create procedure del_p(in n int)
begin
    delete from products where id=n;
end#
\d ;


----------------------------------------訂單表------------------------------------- 
 \d #
--新增訂單data
create procedure add_o(in n1 varchar(5) , in n2 int)
begin
    insert into orders (order_id,customer_id) values(n1,n2);
end#
--刪除訂單data
create procedure del_o(in n int)
begin
     select order_id into @a from orders where id=n;
     delete from orders where id=n;
end#
--刪除訂單觸發刪除訂單細節
create trigger del_o_od before delete on orders for each row
begin
     delete from order_details where order_id=@a;
end#
\d ;
 
----------------------------------------訂單細項表------------------------------------- 
 \d #
--新增訂單細項data
create procedure add_od(in n1 varchar(5),in n2  varchar(5),in n3  int ,in n4 int)
begin
    insert into order_details (order_id,product_id,price,count) values(n1,n2,n3,n4);
end#
--修改訂單細項price
create procedure up_odprice(in n int,in new int)
begin
     update order_details set price=new where id =n;    
end#
--修改訂單細項count
create procedure up_odcount(in n int,in new int)
begin
     update order_details set count=new where id =n;    
end#
--刪除訂單細項data
create procedure del_od(in n int)
begin
    delete from order_details where id=n;
end#
\d ;
---------------------------------------搜尋-------------------------------------------------
--用名稱搜尋客戶
 \d #
create procedure s_cname(in kw varchar(50))
begin
set @keyword =concat("%",kw,"%");
set @dir= 'select * from customers where name like ?';
      prepare stament from @dir;
      execute stament using @keyword;
end #
\d ;

--用電話搜尋客戶
 \d #
create procedure s_ctel(in kw varchar(50))
begin
set @keyword =concat("%",kw,"%");
set @dir= 'select * from customers where tel like ?';
      prepare stament from @dir;
      execute stament using @keyword;
end #
\d ;

--用名稱搜尋供應商
 \d #
create procedure s_sname(in kw varchar(50))
begin
set @keyword =concat("%",kw,"%");
set @dir= 'select * from suppliers where name like ?';
      prepare stament from @dir;
      execute stament using @keyword;
end #
\d ;
--用電話搜尋供應商
 \d #
create procedure s_stel(in kw varchar(50))
begin
set @keyword =concat("%",kw,"%");
set @dir= 'select * from suppliers where tel like ?';
      prepare stament from @dir;
      execute stament using @keyword;
end #
\d ;

--用名稱搜尋產品
 \d #
create procedure s_pname(in kw varchar(50))
begin
set @keyword =concat("%",kw,"%");
set @dir= 'select * from products where name like ?';
      prepare stament from @dir;
      execute stament using @keyword;
end #
\d ;

--------------------------------綜合搜尋-------------------------------
--a. 指定客戶查詢訂單,含訂單明細
 \d #
create procedure sa(in kw varchar(50))
begin
set @keyword =concat("%",kw,"%");
set @dir= 'select o.customer_id,od.order_id,od.product_id,od.price,od.count 
from order_details od join orders o on (o.order_id=od.order_id)
where o.customer_id in (select id from customers where name like ?)';
      prepare stament from @dir;
      execute stament using @keyword;
end #
\d ;

--b. 指定客戶查詢訂單總金額
 \d #
create procedure sb(in id int)
begin
set @keyword =id;
set @dir= 'select o.order_id,sum(od.price*od.count) `total cost per order`  
from orders o join order_details od on
(o.order_id=od.order_id) where o.customer_id =?
group by od.order_id';
      prepare stament from @dir;
      execute stament using @keyword;
end #
\d ;

--c. 指定商品查詢訂單中的客戶, 例如: 商品P001的客戶有哪些,買幾個
 \d #
create procedure sc(in kw varchar(50))
begin
set @keyword=kw;
set @dir= 'select od.product_id,c.name,od.count from orders o 
join order_details od on(o.order_id=od.order_id)
join customers c on(c.id=o.customer_id)
where product_id=?';
      prepare stament from @dir;
      execute stament using @keyword;
end #
\d ;

--d. 指定供應商查詢訂單中的商品清單
 \d #
create procedure sd(in kw int)
begin
set @keyword=kw;
set @dir= 'select p.supplier_id,o.order_id,p.name from order_details od
join products p on (p.product_id=od.product_id)
join orders o on (o.order_id=od.order_id)
where p.supplier_id=?';
      prepare stament from @dir;
      execute stament using @keyword;
end #
\d ;
