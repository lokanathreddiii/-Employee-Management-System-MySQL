💼 Employee Management System using MySQL
This project is a complete Employee Management System (EMS) built using MySQL. It aims to efficiently manage employee details, job roles, departments, payroll, and leave records through a relational database system.
🎯 Problem Statement
Organizations often struggle with fragmented employee data and manual processing of salary, department assignments, and leave records.
This project solves these challenges by designing a centralized relational database for managing all HR operations.

🥅 Project Objectives
Design a normalized relational database for HR data management.
Maintain relationships between employees, departments, and salaries.
Automate payroll processing with leave deductions.
Generate HR insights using SQL joins, subqueries, and CTEs.
Enforce data integrity using primary and foreign key constraints.
🧱 Database Structure
Tables Created
JobDepartment – Stores job roles, departments, and salary ranges.
SalaryBonus – Contains salary, bonus, and annual pay linked to job roles.
Employee – Stores employee personal and contact details.
Qualification – Tracks employee qualifications and skill requirements.
Leaves – Records employee leave history with reasons and dates.
Payroll – Combines employee, job, salary, and leave data for net payment calculation.
Constraints Used
Primary Keys
Foreign Keys (with CASCADE and SET NULL)
Unique Constraints on emp_email
Cascading Delete/Update Actions
SQL Concepts Applied
Joins (INNER, LEFT, RIGHT)
Subqueries and CTEs
Aggregate Functions (COUNT, SUM, AVG)
GROUP BY and HAVING Clauses
Window Functions for ranking and insights
I’ve also designed an ER Diagram to visualize the database structure.

EMS - EMPLOYEMEE MANAGMENT SYSTEM
📊 Insights & Observations
The Sales department has the highest total salary allocation.
The IT department provides the highest average salary.
Over 20% of employees exceed their allowed leave limit.
Some employees hold multiple qualifications, increasing role eligibility.
The total annual salary expenditure can be derived through query-based reports.
💡 Conclusion
The Employee Management System improves HR efficiency, ensures payroll accuracy, and provides data-driven insights for better decision-making.
It demonstrates practical knowledge of database normalization, foreign key constraints, joins, and advanced SQL queries.

🧰 Tools & Technologies Used
MySQL
MySQL Workbench
Excel (for sample data preparation)


🏷️ Hashtags
#MySQLProject #SQLPortfolio #DatabaseProject #SQLCaseStudy #DataDrivenSolutions #SQLDevelopment #MySQL #RelationalDatabase #SQLQueries #EmployeeManagementSystem
