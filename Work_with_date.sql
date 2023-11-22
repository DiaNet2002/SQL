/*Working with dates based on a task:
In 1845, the United States established a tradition according to which presidential elections are held on Tuesday.
after the first Monday in November in a year divisible by 4 without a remainder.
Determine the date of the closest presidential election in the United States to a given date.
*/
SELECT '&&date' AS "Given Date",
        CASE 
            WHEN SUBSTR('&date',7)>=-4712 THEN  
/*Check if the date is within the acceptable range, from -4712 to 9996 (elections are not held after this year)*/
                 CASE 
                    WHEN TO_DATE('&date','DD-MM-YYYY')<='05.11.9996' THEN 
                        CASE
/*Check if the entered date is before 1845 or after*/
                            WHEN EXTRACT(YEAR FROM TO_DATE('&date','DD-MM-YYYY'))>1845 THEN
/*If the year of the entered date is the same as the election year*/
                                CASE MOD(EXTRACT(YEAR FROM TO_DATE('&date','DD-MM-YYYY')),4)
                                    WHEN 0 THEN
                                        CASE
/*If the entered date matches the election date, output the given date*/
                                            WHEN TO_DATE('&date','DD-MM-YYYY')-NEXT_DAY(TO_DATE('01.11'||SUBSTR('&date',7,4),'DD.MM.YYYY'),2)=0 
/*If the given date is after the election date in that year, then output the date of the next election (i.e., after 4 years)*/
                                                THEN '&date' 
                                            WHEN TO_DATE('&date','DD-MM-YYYY')-NEXT_DAY(TO_DATE('01.11'||SUBSTR('&date',7,4),'DD.MM.YYYY'),2)>0 
                                                THEN TO_CHAR(NEXT_DAY(TO_DATE('01.11'||TO_NUMBER(SUBSTR('&date',7,4)+4),'DD.MM.YYYY'),2),'DD.MM.YYYY')
                                            ELSE 
/*If the given date is before the election date in that year, find the date of the election*/
                                                TO_CHAR(NEXT_DAY(TO_DATE('01.11'||TO_NUMBER(SUBSTR('&date',7,4)),'DD.MM.YYYY'),2),'DD.MM.YYYY')
                                        END
                                    ELSE 
/*If the entered year is not divisible by 4, output the date of the next election after that year*/
                                        TO_CHAR(NEXT_DAY(TO_DATE('01.11'||TO_NUMBER(SUBSTR('&date',7,4)+4-MOD(SUBSTR('&date',7,4),4)),'DD.MM.YYYY'),2),'DD.MM.YYYY')
                                END
                            ELSE 
/*If the entered date is before 1845, always output one date*/
                                TO_CHAR(NEXT_DAY(TO_DATE('01.11.1848','DD.MM.YYYY'),2),'DD.MM.YYYY')
                        END
/*If the entered date is after 9996*/
                    ELSE 'Elections are not held after 9996'
                END
/*If the entered date is before -4712*/
            ELSE 'Select a date from -4712 to 9996'
        END AS "Election date"
FROM dual;
UNDEFINE date