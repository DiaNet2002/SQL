/*Salary rank output*/
SELECT  e.department_id, e.last_name, e.salary, 
/*Outputs the salary rank*/
    COUNT(DISTINCT e1.salary) AS salary_rank
FROM employees e, 
/*Create another view of the employees table*/
        (SELECT  department_id, salary
        FROM employees
            ) e1
/*Specify the condition for calculating the rank*/
WHERE e.salary <= e1.salary AND e.department_id = e1.department_id
GROUP BY e.department_id, e.salary, e.last_name
/*Sort in the desired order*/
ORDER BY e.department_id, e.salary DESC;