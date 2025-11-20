
/*----------------------(Employee Management System)-----------------------------*/

-- First, I created a database named 'EMS' (Employee Management System)

CREATE DATABASE EMS;

-- After that, I used this database

USE EMS;

-- Created the first table named 'JobDepartment'
CREATE TABLE JobDepartment (
    Job_ID INT PRIMARY KEY,
    jobdept VARCHAR(50),
    name VARCHAR(100),
    description TEXT,
    salaryrange VARCHAR(50)
);

-- Created the second table named 'SalaryBonus'
CREATE TABLE SalaryBonus (
    salary_ID INT PRIMARY KEY,
    Job_ID INT,
    amount DECIMAL(10,2),
    annual DECIMAL(10,2),
    bonus DECIMAL(10,2),
    CONSTRAINT fk_salary_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(Job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Created the third table named 'Employee'
CREATE TABLE Employee (
    emp_ID INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    contact_add VARCHAR(100),
    emp_email VARCHAR(100) UNIQUE,
    emp_pass VARCHAR(50),
    Job_ID INT,
    CONSTRAINT fk_employee_job FOREIGN KEY (Job_ID)
	REFERENCES JobDepartment(Job_ID)
	ON DELETE SET NULL
	ON UPDATE CASCADE
);

-- Created the fourth table named 'Qualification'
CREATE TABLE Qualification (
    QualID INT PRIMARY KEY,
    Emp_ID INT,
    Position VARCHAR(50),
    Requirements VARCHAR(255),
    Date_In DATE,
    CONSTRAINT fk_qualification_emp FOREIGN KEY (Emp_ID)
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Created the fifth table named 'Leaves'
CREATE TABLE Leaves (
    leave_ID INT PRIMARY KEY,
    emp_ID INT,
    date DATE,
    reason TEXT,
    CONSTRAINT fk_leave_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Created the sixth table named 'Payroll'
CREATE TABLE Payroll (
    payroll_ID INT PRIMARY KEY,
    emp_ID INT,
    job_ID INT,
    salary_ID INT,
    leave_ID INT,
    date DATE,
    report TEXT,
    total_amount DECIMAL(10,2),
    CONSTRAINT fk_payroll_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_salary FOREIGN KEY (salary_ID) REFERENCES SalaryBonus(salary_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_leave FOREIGN KEY (leave_ID) REFERENCES Leaves(leave_ID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- We need to determine how many tables should be created

SHOW TABLES;

select *from jobdepartment;
select *from employee;
select *from leaves;
select *from payroll;
select *from qualification;
select *from salarybonus;

-- Questions for Database Analysis

-- 1. EMPLOYEE INSIGHTS

-- 1.1 How many unique employees are currently in the system?
 SELECT COUNT(*) AS TotalEmployees FROM employee;
 select count(distinct emp_id) from employee;
 
-- 1.2 Which departments have the highest number of employees?
SELECT j.jobdept,COUNT(e.emp_ID) AS employee_count
FROM employee e
JOIN jobdepartment j ON e.job_id=j.job_id
GROUP BY j.jobdept
ORDER BY employee_count desc;

-- 1.3 What is the average salary per department?
SELECT j.jobdept, ROUND(AVG(s.amount),2) AS avg_salary
FROM salarybonus s
JOIN jobdepartment j ON s.job_id=j.job_id
GROUP BY j.jobdept;

-- 1.4 Who are the top 5 highest-paid employees?
SELECT 
    e.emp_ID,
    e.firstname AS employee_name,
    j.jobdept,
    j.name AS job_role,
    s.amount AS salary
FROM Employee e
JOIN JobDepartment j ON e.Job_ID = j.Job_ID
JOIN SalaryBonus s ON j.Job_ID = s.Job_ID
ORDER BY s.amount DESC
LIMIT 5;

-- 1.5 What is the total salary expenditure across the company?
-- total monthly salary expenditure (including bonuses):

SELECT ROUND(SUM(amount + bonus), 2) AS total_salary_expenditure
FROM SalaryBonus;
-- total annual salary expenditure (for the full year):
SELECT SUM(annual) AS total_salary_expenditure
FROM SalaryBonus;

-- 2. JOB ROLE AND DEPARTMENT ANALYSIS

-- 2.1 How many different job roles exist in each department?
SELECT jobdept,COUNT(DISTINCT name) AS Job_roles
FROM jobdepartment
GROUP BY jobdept;

-- 2.2 What is the average salary range per department?
SELECT j.jobdept,ROUND(AVG(s.amount), 2) AS avg_salary
FROM SalaryBonus s
JOIN JobDepartment j ON s.Job_ID = j.Job_ID
GROUP BY j.jobdept;

-- 2.3 Which job roles offer the highest salary?
SELECT j.name, j.jobdept, s.amount
FROM SalaryBonus s
JOIN JobDepartment j ON s.Job_ID = j.Job_ID
ORDER BY s.amount DESC;

-- 2.4 Which departments have the highest total salary allocation?
SELECT j.jobdept AS department,SUM(s.amount) AS total_salary
FROM JobDepartment j
JOIN SalaryBonus s ON j.Job_ID = s.Job_ID
GROUP BY j.jobdept
ORDER BY total_salary DESC;

-- 3. QUALIFICATION AND SKILLS ANALYSIS

-- 3.1 How many employees have at least one qualification listed?
SELECT COUNT(DISTINCT Emp_ID) AS employees_with_qualification
FROM Qualification;

-- 3.2 Which positions require the most qualifications?
SELECT q.Position, COUNT(q.Requirements) AS total_requirements
FROM Qualification q
GROUP BY q.Position
ORDER BY total_requirements DESC;

-- 3.3 Which employees have the highest number of qualifications?
SELECT e.emp_ID,COUNT(q.QualID) AS num_qualifications
FROM Employee e
JOIN Qualification q ON e.emp_ID = q.Emp_ID
GROUP BY e.emp_ID
ORDER BY num_qualifications DESC;

-- 4. LEAVE AND ABSENCE PATTERNS

-- 4.1 Which year had the most employees taking leaves?
SELECT YEAR(date) AS leave_year,COUNT(DISTINCT emp_ID) AS num_employees
FROM Leaves
GROUP BY leave_year
ORDER BY num_employees DESC;

-- 4.2 What is the average number of leave days taken by its employees per department?
WITH EmployeeLeaves AS (
    SELECT emp_ID, COUNT(*) AS leave_count
    FROM Leaves
    GROUP BY emp_ID
)
SELECT jd.jobdept AS department,AVG(el.leave_count) AS avg_leave_days
FROM JobDepartment jd
JOIN Employee e ON jd.Job_ID = e.Job_ID
LEFT JOIN EmployeeLeaves el ON e.emp_ID = el.emp_ID
GROUP BY jd.jobdept;

-- 4.3 Which employees have taken the most leaves?
WITH LeaveCounts AS (
    SELECT emp_ID, COUNT(*) AS num_leaves
    FROM Leaves
    GROUP BY emp_ID
)
SELECT e.emp_ID, e.firstname, e.lastname, lc.num_leaves
FROM Employee e
JOIN LeaveCounts lc ON e.emp_ID = lc.emp_ID
WHERE lc.num_leaves = (SELECT MAX(num_leaves) FROM LeaveCounts);

-- 4.4 What is the total number of leave days taken company-wide?
SELECT COUNT(leave_ID) AS total_leave_days
FROM Leaves;

-- 4.5 How do leave days correlate with payroll amounts?
SELECT e.emp_ID, COUNT(l.leave_ID) AS total_leaves, SUM(p.total_amount) AS payroll_total
FROM Employee e
LEFT JOIN Leaves l ON e.emp_ID = l.emp_ID
LEFT JOIN Payroll p ON e.emp_ID = p.emp_ID
GROUP BY e.emp_ID;

-- 5. PAYROLL AND COMPENSATION ANALYSIS

-- 5.1 What is the total monthly payroll processed?
SELECT YEAR(date) AS year,MONTH(date) AS month,SUM(total_amount) AS total_monthly_payroll
FROM Payroll
GROUP BY YEAR(date), MONTH(date)
ORDER BY year, month;

-- 5.2 What is the average bonus given per department?
SELECT j.jobdept,ROUND(AVG(s.bonus),2) AS Average_Bonus
FROM salarybonus s
JOIN jobdepartment j ON s.job_ID = j.job_ID
GROUP BY j.jobdept;

-- 5.3 Which department receives the highest total bonuses?
WITH DeptBonus AS (
    SELECT j.jobdept AS department,SUM(s.bonus) AS total_bonus,
	RANK() OVER (ORDER BY SUM(s.bonus) DESC) AS bonus_rank
    FROM JobDepartment j
    JOIN SalaryBonus s ON j.Job_ID = s.Job_ID
    GROUP BY j.jobdept
)
SELECT department, total_bonus
FROM DeptBonus
WHERE bonus_rank = 1;

-- 5.4 What is the average value of total_amount after considering leave deductions?
-- total_amount already accounts for leaves or any deductions.
SELECT AVG(total_amount) AS avg_total_after_deductions
FROM Payroll;

-- All tables and queries for the Employee Management System (EMS) have been created and tested successfully.
-- Project completed.