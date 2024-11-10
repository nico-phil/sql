-- ATOMICITY EXAMPLE -- 

-- we have 2 tables products(id name, price, enventory)
-- sales(id, product_id, price, quantity)
-- if one of the query fails, or the database fails the transaction will also fails
BEGIN TRANSACTION; 
    SELECT * FROM products;

    UPDATE products SET inventory = inventory - 5 WHERE id = 1;
    INSERT INTO sales(product_id, price, quantity) VALUES(1, 99.99, 5);
    
    SELECT * FROM products;
    SELECT * FROM sales;

    COMMIT;


-- ISOLATION EXAMPLE
-- we have 2 concurrent requests: first one select the product for reporting
--  the second one insert some sales
-- the first start, and the second start also. the second commit before the first one. 
-- we will have a problem in the first transaction, we will see the commit row of the second transaction

-- TRANSACTION 1
BEGIN TRANSACTION;
    SELECT product_id, count(product_id) from sales group by product_id;
    SELECT product_id, price, quantity from sales;
    COMMIT;

-- TRASACTION 2
BEGIN TRANSACTION;
    INSERT INTO sales(product_id, price, quantity) VALUES(1, 99.99, 10);
    UPDATE products SET inventory = inventory - 10 WHERE id = 1;
    COMMIT;



-- ISOLATION LEVEL "REPEATABLE READ", fix the problem of the example 1
-- the repeatable read will make sure the rows dont change while the transaction is running
--TRANSACTION 1
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    SELECT product_id, count(product_id) from sales group by product_id;
    SELECT product_id, price, quantity from sales;
    COMMIT;

-- TRASACTION 2
BEGIN TRANSACTION;
    INSERT INTO sales(product_id, price, quantity) VALUES(1, 99.99, 10);
    UPDATE products SET inventory = inventory - 10 WHERE id = 1;
    COMMIT;






