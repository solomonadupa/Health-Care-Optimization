
--Viewing the data-set.
SELECT *
FROM Health

--Changing Total_Cost column data-type from varchar(max) to integers.
ALTER TABLE Health
ALTER COLUMN Total_Cost int

--Total cost of treating each condition.
SELECT Condition, SUM(Total_Cost) AS Total_cost_of_management
FROM Health
GROUP BY Condition
ORDER BY Total_cost_of_management DESC

--Average cost of treating each condition.
SELECT Condition, AVG(Total_Cost) AS Average_cost_of_management
FROM Health
GROUP BY Condition
ORDER BY Average_cost_of_management DESC

--What Admission type Cost the most to manage.
SELECT Admission_Type, SUM(Total_Cost) AS Total_cost_of_management
FROM Health
GROUP BY Admission_Type
ORDER BY Total_cost_of_management DESC

--Number of patients suffering from different conditions.
SELECT Condition, COUNT(Condition) as Occurences
FROM Health
GROUP BY Condition 
ORDER BY Occurences DESC

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

---Converting Risk_Score data_type from varchar to decimal
ALTER TABLE Health
ALTER COLUMN Risk_Score decimal(10, 3)

---Using Subquerries to Find Num_of_High_Risk Patients suffering from each condition after Risk Grouping.
SELECT Condition, COUNT(*) AS Num_of_High_Risk_Patients
FROM (
---Do a Risk Grouping to Identify high risk patients and provide remedies to reduce risk factors
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

----Which Patients to stay Longest? Provide ways of reducing hospital stay, this saves money.
ALTER TABLE Health
ALTER COLUMN Length_of_Stay int

SELECT Condition, AVG(Length_of_stay) AS Hospital_Stay
FROM Health
WHERE Admission_Type = 'Emergency' 
GROUP BY Condition
ORDER BY Hospital_Stay

----Readmitted VS First_Admission
SELECT Readmitted, SUM(Total_Cost) as Cost
FROM Health 
GROUP BY Readmitted

SELECT *
FROM Health



