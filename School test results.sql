-- Select the dataset
SELECT *
  FROM [Students].[dbo].[student test];

-- Average scores by program:
-- Calculate the average scores for general management and domain-specific exams for each academic program.
SELECT 
    [PROGRAM NAME],
    CAST(AVG(CAST([GENERAL MANAGEMENT SCORE (OUT of 50)] AS INT)) AS DECIMAL(10, 2)) AS [AVG GENERAL MANAGEMENT SCORE],
    CAST(AVG(CAST([DOMAIN SPECIFIC SCORE (OUT 50)] AS INT)) AS DECIMAL(10, 2)) AS [AVG DOMAIN SPECIFIC SCORE]
FROM 
    [Students].[dbo].[student test]
GROUP BY 
    [PROGRAM NAME];

	-- Top performing students
SELECT 
      TOP 10 
      [NAME OF THE STUDENT] AS [STUDENT NAME],
	  CAST([TOTAL SCORE (OUT of 100)] AS INT) AS [TOTAL SCORE]
FROM [Students].[dbo].[student test]
ORDER BY [TOTAL SCORE] DESC;

-- Student ranks and percentiles
SELECT 
    [NAME OF THE STUDENT] AS [STUDENT NAME],
    CAST([TOTAL SCORE (OUT of 100)] AS INT) AS [TOTAL SCORE],
    RANK() OVER (ORDER BY CAST([TOTAL SCORE (OUT of 100)] AS INT) DESC) AS [RANK],
    ROUND(PERCENT_RANK() OVER (ORDER BY CAST([TOTAL SCORE (OUT of 100)] AS INT)), 2) AS [PERCENTILE]
FROM 
    [Students].[dbo].[student test]
ORDER BY [TOTAL SCORE] DESC, [PERCENTILE] DESC;

--Program pass rate
-- Calculate the pass rates for each program by counting the number of students who scored above a certain threshold (e.g., a passing score of 60 out of 100).
SELECT
    [PROGRAM NAME],
    SUM(CASE WHEN [TOTAL SCORE (OUT of 100)] >= 60 THEN 1 ELSE 0 END) AS PASS_COUNT,
    COUNT(*) AS TOTAL_STUDENTS,
    ROUND((SUM(CASE WHEN [TOTAL SCORE (OUT of 100)] >= 60 THEN 1 ELSE 0 END) / CAST(COUNT(*) AS DECIMAL(10, 2))) * 100,2) AS PASS_RATE
FROM
    [Students].[dbo].[student test]
GROUP BY [PROGRAM NAME];

-- Average scores by Semester
SELECT 
      [SEMESTER],
	  CAST(AVG(CAST([GENERAL MANAGEMENT SCORE (OUT of 50)] AS INT)) AS DECIMAL(10, 2)) AS [AVG GENERAL MANAGEMENT SCORE],
    CAST(AVG(CAST([DOMAIN SPECIFIC SCORE (OUT 50)] AS INT)) AS DECIMAL(10, 2)) AS [AVG DOMAIN SPECIFIC SCORE]
FROM 
    [Students].[dbo].[student test]
GROUP BY 
        [SEMESTER];

-- Specialization performance
SELECT 
      [SPECIALIZATION],
	  CAST(AVG(CAST([GENERAL MANAGEMENT SCORE (OUT of 50)] AS INT)) AS DECIMAL(10, 2)) AS [AVG GENERAL MANAGEMENT SCORE],
    CAST(AVG(CAST([DOMAIN SPECIFIC SCORE (OUT 50)] AS INT)) AS DECIMAL(10, 2)) AS [AVG DOMAIN SPECIFIC SCORE]
FROM 
    [Students].[dbo].[student test]
WHERE [SPECIALIZATION] IS NOT NULL
GROUP BY 
        [SPECIALIZATION];

