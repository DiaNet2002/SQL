/*Creating an external table based on a file and using it to count control files
*/
drop table tab_init;
/*Drop the table if it already exists*/

CREATE TABLE tab_init
("Parameter" VARCHAR2(255), "Value" VARCHAR2(255))
/*Define the columns*/

ORGANIZATION EXTERNAL
(TYPE oracle_loader
DEFAULT DIRECTORY stud 
ACCESS PARAMETERS (
    RECORDS DELIMITED BY '#'
/*Set the row delimiter by creating a single-column version of the table*/
    BADFILE stud:'init_bad_file.bad'
    LOGFILE stud:'init_log_file.log'
    FIELDS TERMINATED BY '=' OPTIONALLY ENCLOSED BY '"' AND '"'LRTRIM
/*Create the column delimiter*/
    MISSING FIELD VALUES ARE NULL
    REJECT ROWS WITH ALL NULL
    FIELDS ("Parameter" CHAR(255), "Value" CHAR(255))
    )
LOCATION ('init.ora')
)
reject limit 1000;

select count("Parameter") "Ctl_files_cnt"
From tab_init
where lower("Parameter")='control_files' AND "Value" is not null;
/*Count the rows in the "Parameter" column that match the specified condition and have a non-null "Value"*/