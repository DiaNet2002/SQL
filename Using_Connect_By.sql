/*
Using connect by. Determining the number of subordinates.*/
define num=100
/*Display all subordinates*/
with tab as (SELECT employee_id, manager_id
FROM employees
START WITH employee_id = &num
CONNECT BY PRIOR employee_id = manager_id)
/*Count the number of rows, but subtract 1 because one of the rows is the starting manager*/
select &num emp_id, count(*)-1  sun_cnt
from tab