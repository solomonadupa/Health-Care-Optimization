# Health-Care-Optimization
## Project Overview
This project was built based on a real Data Analyst job listing on LinkedIn and is aimed at showing how I would Optimize Healthcare Utilization to reduce costs and Improve Quality at Oscar, a health Insurance company.

## Objectives 
1. Discover practical insights driving medical costs and under utilization of resources.
2. Recommend practical and domain specific means of decreasing medical costs while improving the patients' quality of life.

## Tools
MySQL (Data importation and analysis )

## Data Source
Disclaimer: This data was generated from ChatGPT and is therefore synthesized data. and is for learning purposes only.
## Data Analysis
The following insights were pulled from the data set using SQL commands in the Microsoft Management Studio work bench;

1. Selecting all rows and columns to view the data for any errors and to have a better understanding of the data set
``` SQL
SELECT *
FROM Health
```
1. Selecting all rows and columns to view the data for any errors and to have a better understanding of the data set
``` SQL
SELECT *
FROM Health
```
2. Changing Total_Cost column data-type from varchar(max) to integers, so as to be able to make calculations in this column
``` SQL
ALTER TABLE Health
ALTER COLUMN Total_Cost int
```
3. Querrying the dataset to calculate the Total cost of treating all the patients suffering from a given condition and identifying the condition the company spent most of their money on.
``` SQL
SELECT Condition, SUM(Total_Cost) AS Total_cost_of_management
FROM Health
GROUP BY Condition
ORDER BY Total_cost_of_management DESC
```
4. Calculating the average cost of managing a patient suffering from a given condition. This will help us know what condition is most expensive to manage per patient.
``` SQL
SELECT Condition, AVG(Total_Cost) AS Average_cost_of_management
FROM Health
GROUP BY Condition
ORDER BY Average_cost_of_management DESC
```
5. Querrying what type of admission cost the company the most money in this time period.
``` SQL
SELECT Admission_Type, SUM(Total_Cost) AS Total_cost_of_management
FROM Health
GROUP BY Admission_Type
ORDER BY Total_cost_of_management DESC
```
6. Querrying the total number of patients suffering from a given condition. The goal here is to find the pattern of disease burden among the patients.
``` SQL
SELECT Condition, COUNT(Condition) as Occurences
FROM Health
GROUP BY Condition 
ORDER BY Occurences DESC
```
7. Creating Age groups and querrying the dataset to calculate what age groups spend most of the company's money
``` SQL
WITH CTE1
AS
(SELECT Admission_Type, Length_of_Stay, Total_Cost,Risk_Score, Condition, Readmitted,
CASE
WHEN Age < 18 THEN 'Child'
WHEN Age BETWEEN 18 AND 30 THEN 'Youth'
WHEN Age BETWEEN 31 AND 45 THEN 'Adult'
WHEN Age BETWEEN 46 AND 65 THEN 'Mature'
WHEN Age > 65 THEN 'Elderly'
END As Age_Group
FROM Health)
---Cost of treatment per age group.
SELECT Age_Group, SUM(Total_Cost) as Money_spent
FROM CTE1
GROUP BY Age_Group
ORDER BY Money_spent DESC
```








