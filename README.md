# Data Engineer Job Market Analysis (SQL Project)

## Introduction

📊 This project analyzes the **Data Engineer job market in Canada** using SQL.

The goal of the analysis is to explore job postings and identify:

* 💰 the **highest-paying Data Engineer jobs**
* 🔥 the **most in-demand technical skills**
* 📈 the skills associated with **higher salaries**

By analyzing job postings and required technologies, this project provides insights into **which skills are most valuable for Data Engineers** in the current job market.

All SQL queries used in this project can be found in the: [sql_project folder](/sql_project/).

---

# Background

This project was completed as part of a **SQL learning course**, where we worked with a dataset containing job postings from the data industry.

The dataset includes information such as:

* job titles
* company names
* job locations
* salary data
* required technical skills

Using SQL, I explored the dataset to better understand **salary trends and skill demand for Data Engineers in Canada**.

---

# Questions Explored

The analysis focuses on answering the following questions:

1. What are the **top-paying Data Engineer jobs in Canada**?
2. What **skills are required** for the highest-paying roles?
3. What skills are **most in demand** for Data Engineers?
4. Which skills are associated with **higher salaries**?
5. What are the **most optimal skills to learn** based on demand and salary?

---

# Tools Used

The following tools were used in this project:

* **SQL** – for querying and analyzing the dataset
* **PostgreSQL** – database used to store the job posting data
* **Visual Studio Code** – writing and executing SQL queries
* **Git & GitHub** – version control and project sharing

---

# Analysis

## 1. Top Paying Data Engineer Jobs

To identify the highest-paying roles, I filtered **Data Engineer job postings in Canada** with available salary data.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim 
ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Engineer' 
    AND job_location = 'Canada'
    AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10
```

### Key Insights

* The dataset shows a wide range of salaries for Data Engineers.
* The highest salaries appear in senior or specialized roles.
* Multiple companies across the tech industry are competing for data engineering talent.

---

## 2. Skills Required for Top Paying Jobs

To understand what skills are required for high-paying roles, I joined job postings with the skills dataset.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM job_postings_fact
    LEFT JOIN company_dim 
    ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short = 'Data Engineer'
        AND job_location = 'Canada'
        AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim 
ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC
```

### Key Insights

High-paying roles often require strong technical skills such as:

* SQL
* Python
* Cloud technologies
* Data processing tools

These skills are commonly used for building **data pipelines and managing large datasets**.

---

## 3. Most In-Demand Skills

To identify which skills appear most frequently in job postings, I counted the number of times each skill appears.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim 
ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Engineer'
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5
```

### Key Insights

The most frequently requested skills represent the **core technologies used in data engineering workflows**.

These typically include:

* SQL
* Python
* cloud platforms
* big data tools

---

## 4. Skills Associated with Higher Salaries

This query calculates the **average salary for each skill** to identify technologies associated with higher pay.

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 2) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim 
ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Engineer'
    AND salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY average_salary DESC
LIMIT 10
```

### Key Insights

Some specialized technologies are associated with **higher average salaries**, particularly tools used for:

* big data processing
* distributed systems
* cloud infrastructure

These skills are valuable because they support **large-scale data platforms**.

---

## 5. Most Optimal Skills to Learn

Finally, I combined **skill demand and salary information** to identify skills that are both popular and well-paid.

```sql
WITH skills_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Engineer'
        AND salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
),

average_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg)) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Engineer'
        AND salary_year_avg IS NOT NULL
    GROUP BY skills_job_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM skills_demand
INNER JOIN average_salary 
ON skills_demand.skill_id = average_salary.skill_id
WHERE demand_count > 10
ORDER BY avg_salary DESC, demand_count DESC
LIMIT 15
```

### Key Insights

The most valuable skills are those that combine **high demand and strong salary potential**.

These typically include technologies used in:

* cloud platforms
* big data infrastructure
* large-scale data processing systems

---

# What I Learned

Through this project I improved several SQL and data analysis skills:

* writing **complex SQL queries**
* using **JOINs to combine multiple tables**
* working with **CTEs (WITH clauses)**
* using **aggregation functions such as COUNT() and AVG()**
* analyzing real-world datasets

---

# Conclusion

This project provided insights into the **Data Engineer job market in Canada**.

The analysis shows that strong knowledge of **SQL, programming languages, and data infrastructure tools** is essential for building a successful career in data engineering.

Understanding which skills are both **highly demanded and well-paid** can help guide future learning and career development in the data field.

## Course

This project was completed as part of the SQL course by Luke Barousse, where we analyzed a dataset of data-related job postings using SQL. Link: [SQL Course by Luke Barousse](https://lukebarousse.com/sql)


