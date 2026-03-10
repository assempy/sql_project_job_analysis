SELECT 
    job_title_short AS title, 
    job_location AS location, 
    job_posted_date::DATE AS date 
FROM job_postings_fact;

SELECT 
    job_title_short AS title, 
    job_location AS location, 
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date 
FROM job_postings_fact;

SELECT 
    job_title_short AS title, 
    job_location AS location, 
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date,
    EXTRACT(MONTH FROM job_posted_date) AS date_month
FROM job_postings_fact
LIMIT 5;

SELECT 
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY 
    month
ORDER BY 
    job_posted_count DESC; 


CREATE TABLE january_jobs AS
SELECT * FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
SELECT * FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
SELECT * FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

CREATE TABLE april_jobs AS
SELECT * FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 4;

CREATE TABLE may_jobs AS
SELECT * FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 5;

CREATE TABLE june_jobs AS
SELECT * FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 6;

CREATE TABLE july_jobs AS
SELECT * FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 7;

CREATE TABLE august_jobs AS
SELECT * FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 8;

CREATE TABLE september_jobs AS
SELECT * FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 9;

CREATE TABLE october_jobs AS
SELECT * FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 10;

CREATE TABLE november_jobs AS
SELECT * FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 11;

CREATE TABLE december_jobs AS
SELECT * FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 12; 

SELECT * 
FROM (
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS jabuary_jobs;


WITH january_jobs AS (
    SELECT * 
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)

SELECT *
FROM january_jobs;

SELECT 
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT 
        company_id
    FROM 
        job_postings_fact
    WHERE 
        job_no_degree_mention = true 
    ORDER BY 
        company_id           
);

WITH company_job_count AS (
    SELECT 
            company_id,
            COUNT(*) as total_jobs
    FROM 
            job_postings_fact
    GROUP BY
            company_id                
)

--SELECT *
--FROM company_job_count;

SELECT company_dim.name AS company_name, company_job_count.total_jobs
FROM company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY total_jobs DESC; 


WITH remote_job_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM 
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE 
        job_postings.job_work_from_home = True AND job_postings.job_title_short = 'Data Analyst'
    GROUP BY 
        skill_id            
)

SELECT 
    skills.skill_id,
    skills as skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
    LIMIT 5; 

SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    january_jobs

UNION -- ALL

SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    february_jobs

UNION --ALL

SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    march_jobs   



SELECT 
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date::DATE,
    quarter1_job_postings.salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
    ) AS quarter1_job_postings
WHERE    
    quarter1_job_postings.salary_year_avg > 7000 AND
    quarter1_job_postings.job_title_short = 'Data Analyst'     
ORDER BY quarter1_job_postings.salary_year_avg DESC;    




