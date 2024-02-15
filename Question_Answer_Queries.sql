-- Project Name is Diabetes Prediction Dataset. Given by Psyliq Internship


-- 1. Retrieve the Patient_id and ages of all patients.
SELECT Patient_id, age
FROM
diabetes_prediction;



-- 2. Select all female patients who are older than 40.
SELECT * 
FROM 
diabetes_prediction
WHERE gender = 'Female' AND age > 40;



-- 3. Calculate the average BMI of patients.
SELECT AVG(bmi) AS Average_BMI
FROM
diabetes_prediction;



-- 4. List patients in descending order of blood glucose levels.
SELECT *
FROM
diabetes_prediction
ORDER BY blood_glucose_level DESC;



-- 5. Find patients who have hypertension and diabetes.
SELECT *
FROM
diabetes_prediction
WHERE hypertension = 1 AND diabetes = 1;



-- 6. Determine the number of patients with heart disease
SELECT COUNT(Patient_id) AS total_patients_with_heart_disease
FROM
diabetes_prediction
WHERE heart_disease = 1;



-- 7. Group patients by smoking history and count how many smokers and nonsmokers there are.
WITH CountSubquery AS (
		SELECT 
			COUNT(
				CASE 
					WHEN smoking_history = 'current' THEN 1
					WHEN smoking_history = 'ever' THEN 1
					WHEN smoking_history = 'former' THEN 1
					WHEN smoking_history = 'not current' THEN 1
				END
			) AS smoker, 
			COUNT(CASE WHEN smoking_history = 'never' THEN 1 END) AS non_smoker
		FROM 
		diabetes_prediction
)
SELECT smoker, non_smoker
FROM CountSubquery;



-- 8. Retrieve the Patient_ids of patients who have a BMI greater than the average BMI.
SELECT Patient_id
FROM
diabetes_prediction
WHERE bmi > (SELECT AVG(bmi) FROM diabetes_prediction);	




-- 9. Find the patient with the highest HbA1c level and the patient with the lowest HbA1clevel.

-- Highest HbA1c level.
SELECT Top 1 *
FROM
diabetes_prediction
WHERE HbA1c_level = (SELECT MAX(HbA1C_level) FROM diabetes_prediction);



-- Lowest HbA1c level.
SELECT Top 1 *
FROM
diabetes_prediction
WHERE HbA1c_level = (SELECT MIN(HbA1C_level) FROM diabetes_prediction);



-- 10. Calculate the age of patients in years (assuming the current date as of now).
SELECT Patient_id, age AS Age, YEAR(GETDATE()) - age AS BirthYear
FROM
diabetes_prediction;



-- 11. Rank patients by blood glucose level within each gender group.
WITH RankedBloodGlucose AS (
    SELECT
        Patient_id,
        gender,
        blood_glucose_level,
        RANK() OVER (PARTITION BY gender ORDER BY blood_glucose_level) AS blood_glucose_rank
    FROM
        diabetes_prediction
)
SELECT *
FROM RankedBloodGlucose
ORDER BY gender, blood_glucose_rank;



--12. Update the smoking history of patients who are older than 50 to "Ex-smoker."
UPDATE diabetes_prediction SET smoking_history = 'Ex-smoker'
WHERE age > 50;



-- 13. Insert a new patient into the database with sample data.
INSERT INTO diabetes_prediction (EmployeeName, Patient_id, gender, age, hypertension, heart_disease, smoking_history, bmi, HbA1c_level, blood_glucose_level, diabetes)
VALUES('Bob The Builder', 'PT100101', 'Male', '45', '1', '1', 'current', '35', '6', '300', '1');




-- 14. Delete all patients with heart disease from the database.
DELETE
FROM diabetes_prediction
WHERE
heart_disease = 1;



-- 15. Find patients who have hypertension but not diabetes using the EXCEPT operator.
-- Patients with hypertension.
SELECT * 
FROM
diabetes_prediction
WHERE hypertension = 1

EXCEPT

-- Patients without diabetes.
SELECT * 
FROM
diabetes_prediction
WHERE diabetes = 1;



-- 16. Define a unique constraint on the "patient_id" column to ensure its values are unique.
-- Add a unique constraint to the "patient_id" column
ALTER TABLE diabetes_prediction
ADD CONSTRAINT UQ_patient_id UNIQUE (patient_id);



-- 17. Create a view that displays the Patient_ids, ages, and BMI of patients.
-- Step 1: Create the view
CREATE VIEW Patient_Information AS
SELECT Patient_id, age, bmi
FROM diabetes_prediction;

-- Query the view
SELECT * FROM Patient_Information;







