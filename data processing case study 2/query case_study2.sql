-- Databricks notebook source
---Joining the two tables
select * 
from `workspace`.`default`.`brighttv_raw_data` AS A
LEFT JOIN `workspace`.`default`.`brighttv_raw_data_3`AS B
ON A.UserID = B.UserID
limit 100;


--- Analysing the number of programmes(21 programmes)  
SELECT
Channel2,
COUNT(Channel2) AS Number_of_channel2
from `workspace`.`default`.`brighttv_raw_data` AS A
LEFT JOIN `workspace`.`default`.`brighttv_raw_data_3`AS B
ON A.UserID = B.UserID
GROUP BY Channel2
ORDER BY Channel2 DESC
LIMIT 100;


---Analysing the provinces and the different race in each( 6 different races)
SELECT 
     Race,
COUNT (Race) AS User_count_by_Province
from `workspace`.`default`.`brighttv_raw_data` AS A
LEFT JOIN `workspace`.`default`.`brighttv_raw_data_3`AS B
ON A.UserID = B.UserID
GROUP BY Race
ORDER BY User_count_by_province DESC
LIMIT 100;


---Analysing the province and the number of channels( gauteng 3654,limpopo is 763)
SELECT
    Province,
     COUNT (Channel2)
    from `workspace`.`default`.`brighttv_raw_data` AS A
LEFT JOIN `workspace`.`default`.`brighttv_raw_data_3`AS B
ON A.UserID = B.UserID
GROUP BY Province
LIMIT 100;


---Analysing subription viewing using gender(male 8761,female 977)
SELECT
    B.Gender,
     COUNT (Channel2)
    from `workspace`.`default`.`brighttv_raw_data` AS A
LEFT JOIN `workspace`.`default`.`brighttv_raw_data_3`AS B
ON A.UserID = B.UserID
GROUP BY Gender
LIMIT 100;


--- Analysing the diffent  Race groups

SELECT DISTINCT B.Race
from `workspace`.`default`.`brighttv_raw_data` AS A
LEFT JOIN `workspace`.`default`.`brighttv_raw_data_3`AS B
ON A.UserID = B.UserID
LIMIT 100;


---Analysing the diffent  Gender group

SELECT DISTINCT B.Gender
from `workspace`.`default`.`brighttv_raw_data` AS A
LEFT JOIN `workspace`.`default`.`brighttv_raw_data_3`AS B
ON A.UserID = B.UserID
LIMIT 100;


---Analysing the Provinces
SELECT DISTINCT B.Province
from `workspace`.`default`.`brighttv_raw_data` AS A
LEFT JOIN `workspace`.`default`.`brighttv_raw_data_3`AS B
ON A.UserID = B.UserID
LIMIT 100;


--- Checking for NULL
SELECT* 
FROM `workspace`.`default`.`brighttv_raw_data` AS A
LEFT JOIN `workspace`.`default`.`brighttv_raw_data_3`AS B
ON A.UserID = B.UserID
WHERE B.Race IS  NULL 
LIMIT 100;


--- Counting Blank Spaces(number of blanks 10)
SELECT COUNT(*) AS blank_count
 FROM `workspace`.`default`.`brighttv_raw_data` AS A
LEFT JOIN `workspace`.`default`.`brighttv_raw_data_3`AS B
ON A.UserID = B.UserID
WHERE TRIM(Race) = ''
LIMIT 100;



-----------------------------------------------------------------------------------------------------
---Combining Functions to get a clean enhanced data set
SELECT

--- 1. Programme viewed
    A.Channel2 AS Programme_view,

--- 2. Location
    B.Province AS Location,

---3.SEX
    B.Gender AS Sexuality,

---Converting UTC time and date to SA time

 DATE(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')) AS Record_view,
  Dayname(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')) AS Day_name,
  Monthname(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')) AS Month_name,
  Dayofmonth(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')) AS Day_of_month,
  date_format(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg'), 'HH:mm:ss') AS viewing_time,
 
 ---4.Time busket

CASE
 
 WHEN date_format(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg'),'HH,mm,ss') BETWEEN '06:00:00' AND '10:59:59' THEN '01. Morning'
 WHEN date_format(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg'),'HH,mm,ss') BETWEEN '11:00:00' AND '14:59:59' THEN '02.Afternoon'
 WHEN date_format(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg'),'HH,mm,ss') BETWEEN '15:00:00' AND '19:59:59' THEN '03.Evening'
    ELSE '04.Night'
  END AS Time_classification,

---COUNTS of ID
COUNT(DISTINCT A.UserID) AS view_number,



 CASE
     WHEN Dayname(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')) IN ('Sun','Sat') THEN 'Weekend'
    ELSE 'Weekday'
    END AS day_classification,

    CASE 
        WHEN B.Age BETWEEN 01 AND 12 THEN '1.child'
        WHEN B.Age BETWEEN 13 AND 18 THEN '2.teenage'
        WHEN B.Age BETWEEN 19 AND 34 THEN '3.Youth'
        WHEN B.Age BETWEEN 35 AND 54 THEN '4.Adult'
        ELSE '5.Elder'
 END AS Age_group,
CASE
WHEN TRIM(B.Race) = '' THEN 'unknown'
ELSE B.Race
END AS Race2
FROM `workspace`.`default`.`brighttv_raw_data` AS A
LEFT JOIN `workspace`.`default`.`brighttv_raw_data_3` AS B
 ON A.UserID = B.UserID
GROUP BY  
    A.Channel2,
    B.Gender,
    B.Province,
DATE(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')),
  Dayname(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')),
  Monthname(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')),
  Dayofmonth(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')),
  date_format(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg'), 'HH:mm:ss'),

---5.Day busket
 
 CASE
 
 WHEN date_format(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg'),'HH,mm,ss') BETWEEN '06:00:00' AND '10:59:59' THEN '01. Morning'
 WHEN date_format(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg'),'HH,mm,ss') BETWEEN '11:00:00' AND '14:59:59' THEN '02.Afternoon'
 WHEN date_format(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg'),'HH,mm,ss') BETWEEN '15:00:00' AND '19:59:59' THEN '03.Evening'
    ELSE '04.Night'
  END, 

---6.AGE busket

CASE  
  WHEN B.Age BETWEEN 01 AND 12 THEN '1.child'
  WHEN B.Age BETWEEN 13 AND 18 THEN '2.teenage'
  WHEN B.Age BETWEEN 19 AND 34 THEN '3.Youth'
  WHEN B.Age BETWEEN 35 AND 54 THEN '4.Adult'
ELSE '5.Elder'
END,

CASE
WHEN TRIM(B.Race) = '' THEN 'unknown'
ELSE B.Race
END,

CASE
     WHEN Dayname(from_utc_timestamp(A.RecordDate2, 'Africa/Johannesburg')) IN ('Sun','Sat') THEN 'Weekend'
    ELSE 'Weekday'
    END;
    
