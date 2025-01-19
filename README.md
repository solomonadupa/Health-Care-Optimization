# Health-Care-Optimization
## Project Overview
This project was built based on a real Data Analyst job listing on LinkedIn and is aimed at showing how I would Optimize Healthcare Utilization to reduce costs and Improve Quality at Oscar, a health Insurance company.

## Objectives 
1. Discover practical factors driving medical costs and under utilization of resources.
2. Recommend practical and domain specific means of decreasing medical costs while improving the patients' quality of life.

## Tools
SQL (Data importation and analysis )

## Data Source
Disclaimer: This data was generated from ChatGPT and is therefore synthesized data, it is for learning purposes only.
## Data Analysis
The following insights were pulled from the data set using SQL commands in the Microsoft Management Studio work bench;

1. Selecting all rows and columns to view the data for any errors and to have a better understanding of the data set
``` SQL
SELECT *
FROM Health
```
![Screenshot 2025-01-18 200720](https://github.com/user-attachments/assets/b5d660d7-b904-431d-9a57-1e9e2ab8b008)


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
![Screenshot 2025-01-18 200750](https://github.com/user-attachments/assets/7c29f219-9896-4de1-8325-611468f2742a)


4. Calculating the average cost of managing a patient suffering from a given condition. This will help us know what condition is most expensive to manage per patient.
``` SQL
SELECT Condition, AVG(Total_Cost) AS Average_cost_of_management
FROM Health
GROUP BY Condition
ORDER BY Average_cost_of_management DESC
```
![Screenshot 2025-01-18 200834](https://github.com/user-attachments/assets/f2232795-e610-4a4b-acdf-66763e79a0ff)


5. Querrying what type of admission cost the company the most money in this time period.
``` SQL
SELECT Admission_Type, SUM(Total_Cost) AS Total_cost_of_management
FROM Health
GROUP BY Admission_Type
ORDER BY Total_cost_of_management DESC
```
![Screenshot 2025-01-18 200856](https://github.com/user-attachments/assets/0327c45f-f488-4d10-98ec-fb4287e3bafc)


6. Querrying the total number of patients suffering from a given condition. The goal here is to find the pattern of disease burden among the patients.
``` SQL
SELECT Condition, COUNT(Condition) as Occurences
FROM Health
GROUP BY Condition 
ORDER BY Occurences DESC
```
![Screenshot 2025-01-18 200920](https://github.com/user-attachments/assets/05cc97ee-1051-4fa4-a43c-6d8d96df6170)


7. Creating Age groups and querrying the dataset to calculate what age groups spend most of the company's money.
``` SQL
---Creating Age groups with CASE statements and CTE 
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
![Screenshot 2025-01-18 201958](https://github.com/user-attachments/assets/4d963e63-5ae1-4604-94ce-2dd19431f5be)


8. Converting Risk_Score data_type from varchar to
``` SQL
ALTER TABLE Health
ALTER COLUMN Risk_Score decimal(10, 3)
```
9. Grouping patients into different risk groups
``` SQL
SELECT Admission_Type, Condition, Readmitted,
CASE
WHEN Risk_Score < 0.1 THEN 'No Risk'
WHEN Risk_Score BETWEEN 0.11 AND 0.39 THEN 'Low Risk'
WHEN Risk_Score BETWEEN 0.4 AND 0.79 THEN 'Medium Risk'
WHEN Risk_Score BETWEEN 0.8 AND 1.0 THEN 'High Risk'
WHEN Risk_Score > 1 THEN 'Admit'
END As Risk_Group
FROM Health
```
![Screenshot 2025-01-18 202116](https://github.com/user-attachments/assets/27667364-ec20-4da0-b871-925647c641af)


10. Using subquerries to find the number of high risk patients suffering from different conditions. The goal is to identify the condition where risk score is highest.
``` SQL
SELECT Condition, COUNT(*) AS Num_of_High_Risk_Patients
FROM (
---Risk Grouping 
SELECT Admission_Type, Condition, Readmitted,
CASE
WHEN Risk_Score < 0.1 THEN 'No Risk'
WHEN Risk_Score BETWEEN 0.11 AND 0.39 THEN 'Low Risk'
WHEN Risk_Score BETWEEN 0.4 AND 0.79 THEN 'Medium Risk'
WHEN Risk_Score BETWEEN 0.8 AND 1.0 THEN 'High Risk'
WHEN Risk_Score > 1 THEN 'Admit'
END As Risk_Group
FROM Health
) AS T
WHERE T.Risk_Group = 'High Risk' 
GROUP BY Condition
ORDER BY Num_of_High_Risk_Patients DESC
```
![Screenshot 2025-01-18 202149](https://github.com/user-attachments/assets/52795d1c-8906-4a2c-9272-2ee65678f9a8)


11. Querrying the dataset to find the average length of hospital stay of emergency patients suffering from each condition.
``` SQL
ALTER TABLE Health
ALTER COLUMN Length_of_Stay int

SELECT Condition, AVG(Length_of_stay) AS Hospital_Stay
FROM Health
WHERE Admission_Type = 'Emergency' 
GROUP BY Condition
ORDER BY Hospital_Stay
```
![Screenshot 2025-01-18 202216](https://github.com/user-attachments/assets/42b09126-b871-4771-9a7d-a9d6ce1dced9)


12. Querrying the data to see the cost of first_admissions vs readmissions.
``` SQL
SELECT Readmitted, SUM(Total_Cost) as Cost
FROM Health 
GROUP BY Readmitted
```
![Screenshot 2025-01-18 202313](https://github.com/user-attachments/assets/afe44291-be16-4eec-ab05-fad6b83f3bfd)


##INSIGHTS
1. Most of the company's resources is spent Hypertension patients. 
2. On average a patient with hypertension is the most expensive to manage.
3. Almost half of the money spent was on emergency cases.
4. Most of the clients suffer from Hypertension, follwed by Obesity, diabetes, Asthma etc respectively.
5. Majority of the company's resources caters towards the elderly(Above 65), followed by mature (46 to 65), Adults (31 to 45) then Youth (18-30) come last.
6. Majority of the high risk clients are hypertensive, in second place is obese patients, followed by diabetic patients.
7. The average number of days spent at the hospitals is the same in all conditions.
8. First_time admissions accounted for majority of the budet.

##RECOMMENDATIONS.
1. Since most of the companies resources is spent on hyertensive clients, they should;
- Be monitored closely
- Be dvised to adhere to their medication
- Be advised to implement life-style choices to reduce incidences of complications.
These will reduce their hospital visits, emergency cases and adverse events.
2. To reduce medical expenses, the number of emergencies need to reduce and that can be done by ensuring;
- Client medication Adherance.
- Routine medical check ups.
- Clients seek medical attention incase of any medical issues.
3. The older the patient, the more vulnerable they are and the more expensive they are to manage. Such patients should be given critical attention to avoid complications.
4. High risk patients should be advised on how to minimise risk factors of desease progression such as regular physical exercise, eating a diet rich in fruits and vegetables, weight management etc.
5. First time admissions were majority of the cases and were responsible for the bigger portion of the expenditure, this can be reduced by sensitizing the healthy clients on healthy life style choices to reduce their chances of falling sick.
