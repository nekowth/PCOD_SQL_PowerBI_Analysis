
-- PCOD Risk Stratification SQL Script
-- Author: Neha Kowtharapu
-- Description: SQL queries for analyzing PCOD patient data using synthetic clinical records

-- -----------------------------------------------
-- Query 1: Flag High-Risk Patients
-- -----------------------------------------------
SELECT *,
  CASE 
    WHEN BMI >= 30 AND Androgen_Level_ng_dL >= 90 AND Insulin_Resistance = 'Yes' THEN 'High-Risk'
    WHEN BMI BETWEEN 25 AND 29.9 OR Androgen_Level_ng_dL >= 85 THEN 'Moderate-Risk'
    ELSE 'Low-Risk'
  END AS Risk_Category
FROM PCOD_Synthetic_Data;

-- -----------------------------------------------
-- Query 2: Missed Follow-Up Trends by OB/GYN Provider
-- -----------------------------------------------
SELECT 
  OBGYN_Provider,
  COUNT(*) AS Total_Patients,
  SUM(CASE WHEN Follow_Up_Missed = 'Yes' THEN 1 ELSE 0 END) AS Missed_FollowUps,
  ROUND(SUM(CASE WHEN Follow_Up_Missed = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Missed_Percentage
FROM PCOD_Synthetic_Data
GROUP BY OBGYN_Provider;

-- -----------------------------------------------
-- Query 3: Treatment Adherence Stratified by Risk Category
-- -----------------------------------------------
WITH Risk_Classification AS (
  SELECT *,
    CASE 
      WHEN BMI >= 30 AND Androgen_Level_ng_dL >= 90 AND Insulin_Resistance = 'Yes' THEN 'High-Risk'
      WHEN BMI BETWEEN 25 AND 29.9 OR Androgen_Level_ng_dL >= 85 THEN 'Moderate-Risk'
      ELSE 'Low-Risk'
    END AS Risk_Category
  FROM PCOD_Synthetic_Data
)
SELECT 
  Risk_Category,
  Treatment_Adherence,
  COUNT(*) AS Patient_Count
FROM Risk_Classification
GROUP BY Risk_Category, Treatment_Adherence
ORDER BY Risk_Category, Treatment_Adherence;
