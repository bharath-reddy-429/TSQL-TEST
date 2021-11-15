--1)
select *
from sales.orders


ALTER FUNCTION sales.years(@MIN VARCHAR(20), @MAX VARCHAR(20))
RETURNS TABLE
AS
RETURN(SELECT *
		FROM sales.orders
		WHERE YEAR(order_date) BETWEEN @MIN AND @MAX);

SELECT order_id, customer_id,order_status,store_id,staff_id
FROM sales.years('2016','2017')



--2)
CREATE TABLE sales.cust(
	customer_id INT IDENTITY (1, 1),
	first_name VARCHAR (255) NOT NULL,
	last_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255) NOT NULL,
	street VARCHAR (255),
	city VARCHAR (50),
	state VARCHAR (25),
	zip_code VARCHAR (5),
    updated_at DATETIME NOT NULL,
    operation CHAR(3) NOT NULL,
    CHECK(operation='DEL')
);

select * from sales.cust


alter TRIGGER sales.trg_customer
ON sales.customers
AFTER INSERT, DELETE
AS
BEGIN
SET NOCOUNT ON;
SET IDENTITY_INSERT sales.customers Off;
SET IDENTITY_INSERT sales.cust ON;
INSERT INTO sales.cust(customer_id,first_name, last_name, phone, email, street, city, state, zip_code, updated_at, operation)
SELECT i.customer_id,first_name, last_name, phone, email, street, city, state, zip_code,
	GETDATE(), 'INS'
FROM inserted AS i
UNION ALL
SELECT d.customer_id,first_name, last_name, phone, email, street, city, state, zip_code,
        getdate(), 'DEL'
FROM deleted AS d;
SET IDENTITY_INSERT sales.cust off;
end;


SET IDENTITY_INSERT sales.customers ON;
INSERT INTO sales.customers(customer_id,first_name, last_name, email) VALUES (20888,'bharath','reddy', 'bharath@hotmail.com');



select *
from sales.cust

delete from sales.customers
where customer_id=20888;

delete from sales.customers
where customer_id=429;

