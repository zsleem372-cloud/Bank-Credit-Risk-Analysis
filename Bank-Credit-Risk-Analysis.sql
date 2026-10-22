CREATE DATABASE Bank_Credit_Risk

USE Bank_Credit_Risk


SELECT COUNT(*) AS 'TOTAL ROW'
FROM DBO.credit_risk_dataset

SELECT TOP 10 *
FROM DBO.credit_risk_dataset



SELECT 
SUM(CASE WHEN person_age IS NULL THEN 1 ELSE 0 END) AS 'Missing_Age',
SUM(CASE WHEN person_income IS NULL THEN 1 ELSE 0 END) AS 'Missing_Income',
SUM(CASE WHEN loan_amnt IS NULL THEN 1 ELSE 0 END) AS 'loan_amnt MONEY',
SUM(CASE WHEN loan_int_rate IS NULL THEN 1 ELSE 0 END) AS 'loan_int_rate PRICE',
SUM(CASE WHEN loan_status IS NULL THEN 1 ELSE 0 END) AS 'loan_statusS'
FROM DBO.credit_risk_dataset

---#Analysis of default rates by loan classification /تحليل معدل التعثر حسب تصنيف القرض

SELECT loan_grade, COUNT(*) AS Total_Loans,
SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) AS Defaulted_Loans,
CAST(100.0 * SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,2)) AS Default_Rate
FROM DBO.credit_risk_dataset
GROUP BY loan_grade
ORDER BY loan_grade

--##Default rate by loan purpose / معدل التعثر حسب غرض القرض

SELECT loan_intent,COUNT(*) AS 'Total_Loans',AVG(CAST(loan_status AS FLOAT))*100.0 as 'Default_Rate'
FROM DBO.credit_risk_dataset
GROUP BY loan_intent
ORDER BY AVG(CAST(loan_status AS FLOAT)) DESC


--##Default rate by housing tenure/ معدل التعثر حسب ملكية السكن


select person_home_ownership,COUNT(*) AS 'Total_Loans',AVG(CAST(loan_status AS FLOAT))*100.0 as 'Default_Rate'
FROM DBO.credit_risk_dataset
GROUP BY person_home_ownership
ORDER BY AVG(CAST(loan_status AS FLOAT)) DESC

---##Default rate by income/معدل التعثر حسب الدخل


SELECT
    COUNT(*) AS Total_Loans,
    AVG(CAST(loan_status AS FLOAT)) * 100 AS Default_Rate
FROM dbo.credit_risk_dataset
WHERE person_income < 25000



---##Default by loan amount/التعثر حسب مبلغ القرض

select loan_amnt,COUNT(*) AS Total_Loans, AVG(CAST(loan_status AS FLOAT)) * 100 AS 'Default_Rate'
from dbo.credit_risk_dataset
GROUP BY loan_amnt
ORDER BY loan_amnt

---##Average interest rate by loan grade/متوسط الفائدة حسب درجة القرض

SELECT loan_grade,
       COUNT(loan_int_rate) AS Loans_With_Rate,
       AVG(loan_int_rate) AS Avg_Interest_Rate
FROM dbo.credit_risk_dataset
GROUP BY loan_grade
ORDER BY Avg_Interest_Rate DESC;


---##Top 10 loan amounts by number of default cases/أعلى 10 مبالغ قروض من حيث عدد حالات التعثر
SELECT TOP 10
    loan_amnt,
    COUNT(*) AS Defaulted_Loans
FROM dbo.credit_risk_dataset
WHERE loan_status = 1
GROUP BY loan_amnt
ORDER BY COUNT(*) DESC

---Default status based on prior credit default history/التعثر حسب وجود تعثر ائتماني سابق
SELECT cb_person_default_on_file,
       COUNT(*) AS Total_Loans,
       AVG(CAST(loan_status AS FLOAT)) * 100 AS Default_Rate
FROM dbo.credit_risk_dataset
GROUP BY cb_person_default_on_file


---##Default by income bracket/التعثر حسب شرائح الدخل

SELECT loan_percent_income, COUNT(*) AS Total_Loans,
AVG(CAST(loan_status AS FLOAT)) * 100 AS Default_Rate
FROM dbo.credit_risk_dataset
GROUP BY loan_percent_income
ORDER BY loan_percent_income

---##Ratio of non-performing loans to total loans/نسبة القروض المتعثرة من إجمالي مبلغ القروض
SELECT
    SUM(CASE WHEN loan_status = 1 THEN loan_amnt ELSE 0 END) AS Defaulted_Amount,
    SUM(loan_amnt) AS Total_Loan_Amount
FROM dbo.credit_risk_dataset

--##Total loans by default status./جمالي القروض حسب حالة التعثر.

SELECT loan_status,
       COUNT(*) AS Total_Loans,
       SUM(loan_amnt) AS Total_Amount,
       AVG(loan_amnt) AS Avg_Loan_Amount
FROM dbo.credit_risk_dataset
GROUP BY loan_status