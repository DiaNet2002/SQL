/*Joining tables
Counting unique and non-unique indexes on schema tables
*/
SELECT DISTINCT u.table_name, 
                NVL(NUI1_NAME,'-') AS NUI1_NAME,
                NVL(NUI1_COL_CNT,'0') AS UI1_COL_CNT, 
                NVL(UI1_NAME,'-') AS NUI1_NAME,
                NVL(UI1_COL_CNT,'0') AS UI1_COL_CNT, 
                NVL(NUI_CNT,'0') AS NUI_CNT,
                NVL(UI_CNT,'0') AS UI_CNT
/*Specify the columns to be displayed and provide default values if NULL is encountered*/
FROM user_indexes u,
    (SELECT table_name,NUI1_NAME, COUNT(column_name) AS NUI1_COL_CNT, NUI_CNT
        FROM user_indexes 
            JOIN user_ind_columns 
/*This part of the subquery calculates the number of columns in the first non-unique index*/
                USING (table_name, index_name)
            NATURAL JOIN  (
                SELECT table_name, MIN(index_name) AS NUI1_NAME, COUNT(index_name) AS NUI_CNT
                FROM user_indexes
                WHERE uniqueness='NONUNIQUE'
                GROUP BY table_name
            )
/*The subquery calculates the first unique index and the count of non-unique indexes*/
        WHERE index_name=NUI1_NAME
        GROUP BY table_name,NUI1_NAME,index_name, NUI_CNT
    ) u3, 
/*The entire subquery searches for values for non-unique indexes*/
    (SELECT table_name,UI1_NAME, COUNT(column_name) AS UI1_COL_CNT,UI_CNT
        FROM user_indexes 
            JOIN user_ind_columns 
/*This part of the subquery calculates the number of columns in the first unique index*/
                USING (table_name, index_name)
            NATURAL JOIN (
                SELECT table_name, MIN(index_name) AS UI1_NAME, COUNT(index_name) AS UI_CNT
                FROM user_indexes
                WHERE uniqueness='UNIQUE'
                GROUP BY table_name
        )
/*The subquery calculates the first unique index and the count of unique indexes*/
        WHERE index_name=UI1_NAME
        GROUP BY table_name,UI1_NAME,index_name,UI_CNT
    ) u4
WHERE u.table_name=u3.table_name(+) AND u.table_name=u4.table_name
ORDER BY table_name;