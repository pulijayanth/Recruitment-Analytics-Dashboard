-- RECRUITMENT ANALYTICS PROJECT

CREATE DATABASE IF NOT EXISTS recruitment_analytics;
USE recruitment_analytics;

-- 1. Initial data checks
SHOW DATABASES;

SELECT COUNT(*) AS total_records
FROM recruitment_applications;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT application_id) AS unique_applications
FROM recruitment_applications;

SELECT
    MIN(application_id) AS first_application,
    MAX(application_id) AS last_application,
    COUNT(DISTINCT application_id) AS unique_ids
FROM recruitment_applications;

-- Assumes expected IDs range from APP0001 to APP0600.
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 600
)
SELECT CONCAT('APP', LPAD(n, 4, '0')) AS missing_application_id
FROM numbers
LEFT JOIN recruitment_applications AS r
    ON r.application_id = CONCAT('APP', LPAD(n, 4, '0'))
WHERE r.application_id IS NULL
ORDER BY n;

SELECT application_id, COUNT(*) AS occurrences
FROM recruitment_applications
GROUP BY application_id
HAVING COUNT(*) > 1
ORDER BY application_id;

DESCRIBE recruitment_applications;

SELECT
    SUM(NULLIF(TRIM(CAST(experience_years AS CHAR)), '') IS NULL) AS missing_experience,
    SUM(NULLIF(TRIM(CAST(ai_screening_score AS CHAR)), '') IS NULL) AS missing_ai_scores,
    SUM(NULLIF(TRIM(CAST(hire_date AS CHAR)), '') IS NULL) AS missing_hire_dates,
    SUM(NULLIF(TRIM(CAST(time_to_hire_days AS CHAR)), '') IS NULL) AS missing_time_to_hire
FROM recruitment_applications;

-- 2. Deduplication

DROP TABLE IF EXISTS recruitment_applications_final;

CREATE TABLE recruitment_applications_final AS
SELECT
    application_id,
    candidate_id,
    job_title,
    department,
    application_source,
    application_date,
    experience_years,
    ai_screening_score,
    application_status,
    hire_date,
    time_to_hire_days
FROM (
    SELECT
        application_id,
        candidate_id,
        job_title,
        department,
        application_source,
        application_date,
        experience_years,
        ai_screening_score,
        application_status,
        hire_date,
        time_to_hire_days,
        ROW_NUMBER() OVER (
            PARTITION BY application_id
            ORDER BY application_id
        ) AS row_num
    FROM recruitment_applications
    WHERE application_id IS NOT NULL
      AND TRIM(application_id) <> ''
) AS ranked
WHERE row_num = 1;

SELECT COUNT(*) AS cleaned_records
FROM recruitment_applications_final;

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT application_id) AS unique_applications
FROM recruitment_applications_final;

SELECT application_id, COUNT(*) AS occurrences
FROM recruitment_applications_final
GROUP BY application_id
HAVING COUNT(*) > 1;

-- 3. Applications by job title and source
SELECT job_title, COUNT(*) AS total_applicants
FROM recruitment_applications_final
GROUP BY job_title
ORDER BY total_applicants DESC;

SELECT application_source, COUNT(*) AS total_applicants
FROM recruitment_applications_final
GROUP BY application_source
ORDER BY total_applicants DESC;

-- 4. Hiring performance by source
SELECT
    application_source,
    COUNT(*) AS total_applications,
    SUM(CASE WHEN application_status = 'Hired' THEN 1 ELSE 0 END) AS total_hires
FROM recruitment_applications_final
GROUP BY application_source
ORDER BY total_hires DESC;

SELECT
    application_source,
    COUNT(*) AS total_applications,
    SUM(CASE WHEN application_status = 'Hired' THEN 1 ELSE 0 END) AS total_hires,
    ROUND(
        100.0 * SUM(CASE WHEN application_status = 'Hired' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS hiring_rate_percentage
FROM recruitment_applications_final
GROUP BY application_source
ORDER BY hiring_rate_percentage DESC;

-- 5. Time-to-hire analysis
SELECT DATEDIFF('2026-01-21', '2026-01-01') AS example_days_difference;

SELECT
    COUNT(time_to_hire_days) AS hired_records_with_duration,
    ROUND(AVG(time_to_hire_days), 2) AS average_time_to_hire_days
FROM recruitment_applications_final
WHERE application_status = 'Hired';

-- Alternative calculation from dates (expects YYYY-MM-DD values).
SELECT
    COUNT(*) AS total_hired_candidates,
    ROUND(
        AVG(
            DATEDIFF(
                STR_TO_DATE(NULLIF(TRIM(hire_date), ''), '%Y-%m-%d'),
                STR_TO_DATE(NULLIF(TRIM(application_date), ''), '%Y-%m-%d')
            )
        ),
        2
    ) AS average_time_to_hire_days
FROM recruitment_applications_final
WHERE application_status = 'Hired'
  AND NULLIF(TRIM(hire_date), '') IS NOT NULL
  AND NULLIF(TRIM(application_date), '') IS NOT NULL;

-- 6. AI screening score by application status
SELECT
    application_status,
    COUNT(*) AS total_applicants,
    COUNT(CAST(NULLIF(TRIM(ai_screening_score), '') AS DECIMAL(6,2))) AS scored_applications,
    ROUND(
        AVG(CAST(NULLIF(TRIM(ai_screening_score), '') AS DECIMAL(6,2))),
        2
    ) AS average_ai_screening_score
FROM recruitment_applications_final
GROUP BY application_status
ORDER BY average_ai_screening_score DESC;

-- 7. Overall recruitment KPIs
SELECT
    COUNT(*) AS total_applications,
    SUM(CASE WHEN application_status = 'Hired' THEN 1 ELSE 0 END) AS total_hires,
    ROUND(
        100.0 * SUM(CASE WHEN application_status = 'Hired' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS overall_hiring_rate,
    ROUND(
        AVG(
            CASE
                WHEN application_status = 'Hired'
                 AND NULLIF(TRIM(hire_date), '') IS NOT NULL
                 AND NULLIF(TRIM(application_date), '') IS NOT NULL
                THEN DATEDIFF(
                    STR_TO_DATE(NULLIF(TRIM(hire_date), ''), '%Y-%m-%d'),
                    STR_TO_DATE(NULLIF(TRIM(application_date), ''), '%Y-%m-%d')
                )
            END
        ),
        2
    ) AS average_time_to_hire_days,
    COUNT(CAST(NULLIF(TRIM(ai_screening_score), '') AS DECIMAL(6,2))) AS scored_applications,
    ROUND(
        AVG(CAST(NULLIF(TRIM(ai_screening_score), '') AS DECIMAL(6,2))),
        2
    ) AS average_ai_screening_score
FROM recruitment_applications_final;

-- 8. Application status distribution
SELECT
    application_status,
    COUNT(*) AS total_applications,
    ROUND(
        100.0 * COUNT(*) / (SELECT COUNT(*) FROM recruitment_applications_final),
        2
    ) AS percentage_of_applications
FROM recruitment_applications_final
GROUP BY application_status
ORDER BY total_applications DESC;
