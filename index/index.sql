-- this query explain how the req has done,  the planing time, the execution time, what kind of index it uses
explain analyze SELECT id FROM employees WHERE id = 20000; 

explain analyze SELECT name FROM employees WHERE id = 20000; 

-- this query take a lot of time, because the name colum does not hava an index. it scan the whole heap
explain analyze SELECT id FROM employees WHERE name= 'ZN'; 


--create index
create index employees_name on employees(name);

-- this request is expensive, having an index does not help me becuse we use 
-- expression not an exact value
explain analyze SELECT id, name FROM employees WHERE name like '%ZN%'; 


-- Result of explain --
--  Seq Scan on sales  (cost=0.00..29.62 rows=8 width=24) (actual time=0.390..0.396 rows=4 loops=1)
--    Filter: (price = 99.99)
--  Planning Time: 0.319 ms
--  Execution Time: 0.444 ms



-- CREATE INDEC CONCURRENLTY--
create index concurrently g on grades(g);



-----------CREATING INDEXES EXAMPLE--------------
--WE HAVE A TABLE 'test' WITH abc, all integers

CREATE INDEX on test(a);
CREATE INDEX on test(b);

EXPLAIN ANALYZE SELECT c FROM test WHERE a = 70; --  
EXPLAIN ANALYZE SELECT c FROM test WHERE b = 70; -- 
EXPLAIN ANALYZE SELECT c FROM test WHERE a = 100 and b = 200 ; -- 

-- DELETE index
DROP INDEX test_a_idx, test_b_idx;

CREATE INDEX on test(a, b) -- this index really ifficient when seaching for a, for a and  b. for b postgres does not use the index




