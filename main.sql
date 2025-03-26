begin;
drop table if exists customers, products, orders, orderitems;
create extension if not exists "uuid-ossp";
create table customers (
    id uuid primary key default uuid_generate_v4(),
    firstname text,
    lastname text,
    email text
);

create table products (
    id uuid primary key default uuid_generate_v4(),
    name text,
    price int
);

create table orders (
    id uuid primary key default uuid_generate_v4(),
    customer_id uuid,
    orderdate timestamp default now(),
    total int,
    constraint fk_customer foreign key (customer_id) references customers (id)
);

create table orderitems (
    id uuid primary key default uuid_generate_v4(),
    orderid uuid,
    productid uuid,
    quantity int,
    subtotal int,
    constraint fk_order foreign key (orderid) references orders (id),
    constraint fk_product foreign key (productid) references products (id)
);

insert into customers (firstname, lastname, email) VALUES
('Bob', 'Bonnignton', 'qwerty@gmail.com');

insert into products(name, price) VALUES
('a', 2);


commit;
-- 1
begin;

insert into orders (customer_id, orderdate, total)
values ((select id from customers where firstname = 'Bob'), now(), 0);

insert into orderitems (orderid, productid, quantity, subtotal)
values
((select id from orders where customer_id = (select id from customers where firstname = 'Bob')), (select id from products where name = 'a'), 2, 200);



update orders
set total = (
    select sum(subtotal)
    from orderitems
    where orderid = (select id from orderitems where subtotal = 200)
);

commit;
-- 2
begin;

update customers
set email = 'qwerty@example.com'
where id = (select id from customers where firstname = 'Bob');

commit;
-- 3
begin;

insert into products (name, price)
values ('new product', 499);

commit;