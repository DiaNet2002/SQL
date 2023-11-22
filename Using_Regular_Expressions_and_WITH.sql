/*Using Regular Expressions and WITH*/
/*Define the table*/
WITH tabl AS(
    SELECT '1000 1100 900' AS action, '841000 841100 841111' AS code
    FROM dual 
        UNION ALL
    SELECT '700 500 400' AS action, '923400 923411' AS code
    FROM dual
    ),
/*Calculate the initial number of rows*/
    f1 AS (
        SELECT rownum as n, action, code
        FROM tabl
    )
SELECT
    CASE WHEN n_pos = 0
        THEN to_char(n)
       ELSE ' ' END 
    AS n_list,
    n_pos, action, code
FROM (
/*Set the row that represents the original values*/
       SELECT n , 0 as n_pos , action, code
       FROM f1
            UNION all
/*Generate rows with individual numbers*/
        SELECT  distinct n, level,
               nvl( regexp_substr(action, '\d+', 1, level),' '),
               nvl( regexp_substr(code, '\d+', 1, level),' ')
        FROM f1
        CONNECT BY level <= regexp_count(action, '\d+') OR level <= regexp_count(code, '\d+')
        ORDER BY 1,2)
/*Sort the result to match the desired output*/
ORDER BY rownum;