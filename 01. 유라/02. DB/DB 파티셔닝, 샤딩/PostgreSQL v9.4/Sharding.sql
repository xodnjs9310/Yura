CREATE TABLE Shard_1_test
(
  name character(30),
  age int,
  gender character(10)
);

-- db link
CREATE EXTENSION dblink;
--select dblink_disconnect('Shard_1_dblink');

SELECT dblink_connect('Shard_1_dblink','hostaddr=127.0.0.1 port=5432 dbname=Shard_1 user=postgres password=postgres');
SELECT dblink_connect('Shard_2_dblink','hostaddr=127.0.0.1 port=5432 dbname=Shard_2 user=postgres password=postgres');
SELECT dblink_connect('Shard_3_dblink','hostaddr=127.0.0.1 port=5432 dbname=Shard_3 user=postgres password=postgres');
SELECT dblink_connect('Shard_4_dblink','hostaddr=127.0.0.1 port=5432 dbname=Shard_4 user=postgres password=postgres');


CREATE OR REPLACE FUNCTION func_Shard_1_insert_trigger()
RETURNS TRIGGER AS $$
    DECLARE name varchar(30);
    DECLARE age int;
    DECLARE gender varchar(5);
BEGIN
    name := '';
    age := 0;
    gender := '';

    name := new.name;
    age := new.age;
    gender := new.gender;
    
    IF ( NEW.age < 30) THEN   
	RETURN NULL;
    ELSIF ( NEW.age >= 30 and NEW.age < 40) THEN
	select dblink('Shard_2_dblink', 'insert into Shard_2(name,age,gender) values('''||name||''','||age||','''||gender||''')');
	RETURN NULL;        
    ELSIF ( NEW.age >= 40 and NEW.age < 50) THEN
        select dblink('Shard_3_dblink', 'insert into Shard_3(name,age,gender) values('''||name||''','||age||','''||gender||''')');
        RETURN NULL;
    ELSIF ( NEW.age >= 50) THEN
        select dblink('Shard_4_dblink', 'insert into Shard_4(name,age,gender) values('''||name||''','||age||','''||gender||''')');
	RETURN NULL;	
    END IF;

END;
$$
LANGUAGE plpgsql;

--DROP FUNCTION func_Horizontal_insert_trigger() CASCADE;

CREATE TRIGGER trigger_Shard_1_insert
   AFTER INSERT on Shard_1
   FOR EACH ROW EXECUTE PROCEDURE func_Shard_1_insert_trigger();


INSERT INTO Shard_1(name, age, gender) VALUES('한XX', 32, '여');

select * from shard_1

/*
select * from dblink('Shard_2_dblink', 'select name, age, gender from Shard_2') 
    AS t1 (name character(30), age int, gender character(10));
    
select * from dblink('Shard_3_dblink', 'select name, age, gender from Shard_3') 
    AS t1 (name character(30), age int, gender character(10));

select  dblink('Shard_4_dblink', 'insert into Shard_4 values(5,1,4)');
--select dblink('Shard_4_dblink', 'insert into Shard_4(name,age,gender) values('''||name||''','||age||','''||gender||''')');
*/
