use finalproject;
show tables;
--                      UNEMPLOYMENT DATA ANALYSIS AND  SKILL GAP IDENTIFICATION 

-- These queries explore various aspects such as hiring outcomes, salary patterns,applicant experience, 
-- and platform performance. By using grouping, aggregation, filtering, and window functions, this analysis
-- aims to provide a comprehensive view of hiring efficiency, salary distribution, and applicant behavior
-- across different companies and industries.

select * from ak;

show create table ak;

-- 1. Show all hired applicants
SELECT   application_id,company, jobtitle, Location, salary
FROM ak
WHERE hired = 'Yes';


-- 2. Count of applicants by company
SELECT company, COUNT(*) AS total_applicants
FROM ak
GROUP BY company
ORDER BY total_applicants DESC;


-- 3. Average salary by industry
SELECT Industry, AVG(salary) AS avg_salary
FROM ak
WHERE salary IS NOT NULL
GROUP BY Industry;


-- 4. Platforms with most applications
SELECT appliedplatform, COUNT(*) AS total_applications
FROM ak
GROUP BY appliedplatform
ORDER BY total_applications DESC;


-- 5. Average years of experience by hiring status
SELECT HiringStatus, AVG(YearsofExperience) AS avg_experience
FROM ak
GROUP BY HiringStatus;


-- 6. Find the top 5 job titles with the highest average salary
SELECT jobtitle, ROUND(AVG(salary), 2) AS avg_salary
FROM ak
WHERE salary IS NOT NULL
GROUP BY jobtitle
ORDER BY avg_salary DESC
LIMIT 5;



-- 7. Hiring rate (%) by company
SELECT 
    company,
    COUNT(*) AS total_applicants,
    SUM(CASE WHEN hired = 'Yes' THEN 1 ELSE 0 END) AS total_hired,
    ROUND(SUM(CASE WHEN hired = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS hiring_rate_percentage
FROM ak
GROUP BY company
HAVING total_applicants > 5
ORDER BY hiring_rate_percentage DESC;



-- 8. Top 3 industries with the most experienced hires
SELECT 
    Industry,
    ROUND(AVG(YearsofExperience), 2) AS avg_experience,
    COUNT(*) AS total_hired
FROM ak
WHERE hired = 'Yes'
GROUP BY Industry
HAVING COUNT(*) > 2
ORDER BY avg_experience DESC
LIMIT 3;


-- 9. Rank companies by average monthly salary using a window function
SELECT 
company,
ROUND(AVG(MonthlySalary), 2) AS avg_monthly_salary,
RANK() OVER (ORDER BY AVG(MonthlySalary) DESC) AS salary_rank
FROM ak
WHERE MonthlySalary IS NOT NULL
GROUP BY company;


-- 10. Find the company whose average salary is above the overall average
SELECT company, ROUND(AVG(salary), 2) AS avg_salary
FROM ak
GROUP BY company
HAVING AVG(salary) > (
    SELECT AVG(salary) FROM ak WHERE salary IS NOT NULL
)
ORDER BY avg_salary DESC;



-- 11. Monthly trend of job applications
SELECT 
    YEAR(STR_TO_DATE(applicationdate, '%d-%m-%Y')) AS year,
    MONTH(STR_TO_DATE(applicationdate, '%d-%m-%Y')) AS month,
    COUNT(*) AS total_applications
FROM ak
GROUP BY year, month having year and month is not null
order by year,month;


-- conclusion
-- The results show that hiring decisions are often influenced by experience levels and
 -- salary expectations, with more experienced candidates having a higher likelihood of being 
 -- hired. The average salary and hiring rateanalyses highlight the companies and sectors that 
 -- lead in compensation and recruitment efficiency.