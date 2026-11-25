# Recruitment Analytics Dashboard

## Project Overview

The Recruitment Analytics Dashboard is a Data Analytics portfolio project designed to analyze recruitment application data and identify insights into hiring performance, recruitment sources, candidate screening scores, and time to hire.

The project uses SQL, Python, Pandas, and Power BI to demonstrate an end-to-end data analytics workflow.

**Note:** This project uses a synthetic dataset created for learning and demonstration purposes. It does not contain actual company recruitment records.

## Project Objectives

- Analyze recruitment application trends.
- Evaluate hiring performance across recruitment sources.
- Compare hiring rates across job titles.
- Understand application status distribution.
- Analyze AI screening scores across application statuses.
- Measure average time to hire.
- Build an interactive Power BI dashboard.

## Tools and Technologies

- **SQL:** Data querying, aggregation, and recruitment analysis.
- **Python:** Data cleaning and exploratory data analysis.
- **Pandas:** Data manipulation and analysis.
- **Matplotlib & Seaborn:** Data visualization.
- **Power BI:** Interactive dashboard development.
- **Jupyter Notebook / Google Colab:** Python development environment.
- **MySQL Workbench:** SQL development environment.

## Dataset Overview

The cleaned dataset contains 600 unique application records and 11 columns.

Important fields include:

- Application ID
- Candidate ID
- Job Title
- Department
- Application Source
- Application Date
- Experience Years
- AI Screening Score
- Application Status
- Hire Date
- Time to Hire (Days)

## Data Cleaning

The data preparation process included:

1. Identifying duplicate application records.
2. Removing duplicate application IDs.
3. Converting columns into appropriate data types.
4. Identifying missing values.
5. Exporting the cleaned dataset.

**Final dataset:** 600 records and 11 columns.

## Key Performance Indicators

| KPI | Result |
|---|---:|
| Total Applications | 600 |
| Total Hires | 105 |
| Hiring Rate | 17.50% |
| Average Time to Hire | 43.65 days |
| Average AI Screening Score | 65.71 |
| Applications with AI Scores | 592 |

## Key Business Insights

1. LinkedIn generated the highest application volume with 170 applications.
2. Company Website achieved the highest hiring rate at 20.62%.
3. Software Engineer had the highest hiring rate among job titles at 20.15%.
4. Hired candidates had the highest average AI screening score at 74.45.
5. The overall average time to hire was 43.65 days.

## Power BI Dashboard Features

- Recruitment KPI cards.
- Applications by job title.
- Applications by recruitment source.
- Hiring rate by recruitment source.
- Application status distribution.
- Average AI screening score by status.
- Average time to hire by job title.
- Interactive department, source, and status slicers.

## Project Structure

```text
Recruitment-Analytics-Dashboard/
│
├── recruitment_applications_cleaned.csv
├── recruitment_analysis.sql
├── recruitment_analysis.ipynb
├── Recruitment_Analytics_Dashboard.pbix
├── dashboard_screenshot.png
└── README.md
```

## Skills Demonstrated

- Data Cleaning
- Exploratory Data Analysis (EDA)
- SQL Queries
- Data Aggregation
- Data Visualization
- KPI Development
- Power BI Dashboard Development
- Business Insights and Reporting

## Conclusion
This project demonstrates an end-to-end recruitment analytics workflow, from raw data preparation and SQL analysis to Python-based exploration and interactive Power BI reporting.

It showcases practical data analytics skills and the ability to translate recruitment data into meaningful business insights.
This project demonstrates an end-to-end recruitment analytics workflow, from raw data preparation and SQL analysis to Python-based exploration and interactive Power BI reporting.

It showcases practical data analytics skills and the ability to translate recruitment data into meaningful business insights.
