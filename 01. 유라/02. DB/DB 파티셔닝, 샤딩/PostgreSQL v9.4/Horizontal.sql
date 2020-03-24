CREATE TABLE Partition_Horizontal
(
  name character(30),
  age integer,
  gender character(10),

  constraint Horizontal_pk  primary key (age)
);
--alter table Horizontal drop constraint Horizontal_pk;

CREATE TABLE Horizontal_20 (
CHECK (age < 30)
) INHERITS (Partition_Horizontal);

CREATE TABLE Horizontal_30 (
CHECK (age >= 30 AND age < 40)
) INHERITS (Partition_Horizontal);

CREATE TABLE Horizontal_40 (
CHECK (age >= 40 AND age < 50)
) INHERITS (Partition_Horizontal);

CREATE TABLE Horizontal_50 (
CHECK (age >= 50)
) INHERITS (Partition_Horizontal);

alter table Horizontal_20 add constraint Horizontal_20_pk primary key (age);
alter table Horizontal_30 add constraint Horizontal_30_pk primary key (age);
alter table Horizontal_40 add constraint Horizontal_40_pk primary key (age);
alter table Horizontal_50 add constraint Horizontal_50_pk primary key (age);

/*
alter table Horizontal_20 drop constraint Horizontal_20_pk;
alter table Horizontal_30 drop constraint Horizontal_30_pk;
alter table Horizontal_40 drop constraint Horizontal_40_pk;
alter table Horizontal_50 drop constraint Horizontal_50_pk;
*/

create index Horizontal_20_index on Horizontal_20 (age);
create index Horizontal_30_index on Horizontal_30 (age);
create index Horizontal_40_index on Horizontal_40 (age);
create index Horizontal_50_index on Horizontal_50 (age);


CREATE OR REPLACE FUNCTION func_Horizontal_insert_trigger()
RETURNS TRIGGER AS $$
BEGIN
    
    IF ( NEW.age < 30) THEN
        INSERT INTO Horizontal_20 VALUES (NEW.*);
    ELSIF ( NEW.age >= 30 and NEW.age < 40) THEN
        INSERT INTO Horizontal_30 VALUES (NEW.*);
    ELSIF ( NEW.age >= 40 and NEW.age < 50) THEN
        INSERT INTO Horizontal_40 VALUES (NEW.*);
    ELSIF ( NEW.age >= 50) THEN
        INSERT INTO Horizontal_50 VALUES (NEW.*);
    END IF;
    
    RETURN NULL;

END;
$$
LANGUAGE plpgsql;

--DROP FUNCTION func_Horizontal_insert_trigger() CASCADE;

CREATE TRIGGER trigger_voc_item_insert
   BEFORE INSERT on Partition_Horizontal
   FOR EACH ROW EXECUTE PROCEDURE func_Horizontal_insert_trigger();



/*
** constraint_exclusion = on; 사용시 제약조건 배제로 필요 파티션만 스캔,
** constraint_exclusion을 사용하지 않으면 모든 파티션을 스캔하여 파티션 테이블 이점이 없다
*/
SET CONSTRAINT_EXCLUSION = ON;
explain select * from Partition_Horizontal where age < 30;

SET CONSTRAINT_EXCLUSION = OFF;
explain select * from Partition_Horizontal where age < 30;


/*조회 Function 만들기*/
CREATE TYPE public.type_tr22760 AS (
  name character(30),
  age integer,
  gender character(10));
ALTER TYPE public.type_tr22760
  OWNER TO mesplus;

CREATE OR REPLACE FUNCTION public.tr22760(
    i_age integer)
  RETURNS SETOF type_tr22760 AS
$BODY$   
DECLARE
BEGIN

    SET CONSTRAINT_EXCLUSION = ON;
        
    RETURN QUERY        
    SELECT name,
           age,
           gender
    FROM  Partition_Horizontal 
    WHERE age = i_age;
         
  IF NOT FOUND THEN
      PERFORM RAISERROR (50001, 16, 1, 50001);
      RETURN;
  END IF;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.tr22760(integer)
  OWNER TO mesplus;









INSERT INTO Partition_Horizontal VALUES('조XX', 22, '여');
INSERT INTO Partition_Horizontal VALUES('한XX', 17, '남');
INSERT INTO Partition_Horizontal VALUES('김XX', 36, '남');
INSERT INTO Partition_Horizontal VALUES('김XX', 54, '여');
INSERT INTO Partition_Horizontal VALUES('주XX', 42, '여');
INSERT INTO Partition_Horizontal VALUES('호XX', 48, '여');
INSERT INTO Partition_Horizontal VALUES('장XX', 55, '남');
INSERT INTO Partition_Horizontal VALUES('혁XX', 60, '남');   