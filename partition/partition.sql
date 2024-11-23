Create table grades_org(id serial not null, g integer not null);

INSERT INTO grades_org(g) SELECT floor(random() * 100) FROM GENERATE_SERIES(0, 10 000 000);

CREATE INDEX grades_org_idx on grades_org(g);

\d grades_org



-- PARTITIONING 
CREATE TABLE grades_parts(id serial NOT NULL, g INTEGER NOT NULL) partition by range(g);


CREATE TABLE g0035 (like grades_parts including indexes);

CREATE TABLE g3560 (like grades_parts including indexes);

CREATE TABLE g6080 (like grades_parts including indexes);

CREATE TABLE g80100 (like grades_parts including indexes);


ALTER TABLE grades_parts attach partition g0035 for values from (0) to (35)

ALTER TABLE grades_parts attach partition g3560 for values from (35) to (60)

ALTER TABLE grades_parts attach partition g6080 for values from (60) to (80)

ALTER TABLE grades_parts attach partition g80100 for values from (80) to (100)



INSERT INTO grades_parts SELECT * FROM grades_org;

SELECT COUNT(*) FROM g0035;
SELECT COUNT(*) FROM g3560;
SELECT COUNT(*) FROM g6080;
SELECT COUNT(*) FROM g80100;


CREATE INDEX grades_parts_idx on grades_parts(g);


