

-- Count Employee number to know how many employees we have in the company.
SELECT 
      COUNT(*) AS "total employees"
FROM [Myown].[dbo].[HR Data];

  -- Diversity and Inclusion; To assess workforce diversity
SELECT 
      COUNT(*) AS "Gender count", Gender
FROM [Myown].[dbo].[HR Data]
GROUP BY Gender;

-- Number of employees by department
SELECT 
      COUNT(*) AS "Department count", Department
FROM [Myown].[dbo].[HR Data]
GROUP BY Department;

-- Number of employees by job role
-- Sales Executive has the highest number of employees (326).
SELECT 
      [Job Role],
	  COUNT(*) AS "Job role count"
FROM [Myown].[dbo].[HR Data]
GROUP BY [Job Role]
ORDER BY "Job role count" DESC;

-- Avg age by department
SELECT 
      Department, AVG(CAST(Age AS INT))
FROM [Myown].[dbo].[HR Data]
GROUP BY Department
ORDER BY Department ASC;

-- Now lets look at the avg age for all employees
SELECT 
      AVG(CAST(Age AS INT))
FROM [Myown].[dbo].[HR Data];

-- Avg salary by job role
SELECT 
      [Job Role],
	  AVG(CAST([Monthly Income] AS INT)) AS "Monthly income"
FROM [Myown].[dbo].[HR Data]
GROUP BY [Job Role]
ORDER BY "Monthly income" DESC;

-- Avg performance rating
SELECT
      AVG(CAST([Performance Rating] AS INT))
FROM [Myown].[dbo].[HR Data];

-- Top 10 employees with the highest ratings
SELECT
      [Employee Number],
	  CAST([Performance Rating] AS INT) AS "Rating"
FROM [Myown].[dbo].[HR Data]
ORDER BY "Rating" DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;



-- Succession Planning; 
-- To identity potential future leader for each job role

WITH RankedEmployees AS (
    SELECT 
        [Employee Number],
        [Job Role],
        ROW_NUMBER() OVER (PARTITION BY [Job Role] ORDER BY (SELECT NULL)) AS RowNum
    FROM [Myown].[dbo].[HR Data]
    WHERE [Job Role] != 'Manager' AND [Job Level] = 4
)
SELECT 
     [Job Role],
	 [Employee Number]
FROM RankedEmployees
WHERE RowNum = 1;

-- Turnover rate
SELECT 
    COUNT(*) AS "total employees",
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS "resigned employee",
    CONCAT(
        ROUND(
            (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*)),
            2
        ),
        '%'
    ) AS "turnover rate"
FROM [Myown].[dbo].[HR Data]








