CREATE DATABASE adata_employees;

CREATE TABLE departments
(
    department_id INTEGER PRIMARY KEY,
    department_name VARCHAR(60) NOT NULL UNIQUE,
    employee_amount INTEGER NOT NULL
);

CREATE TABLE cities
(
      city_id INTEGER PRIMARY KEY,
      city_name VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE employees
(
    id INTEGER PRIMARY KEY,
    full_name VARCHAR (60) NOT NULL UNIQUE,
    salary INTEGER NOT NULL,
    position VARCHAR (40) NOT NULL,
    position_date_start TIMESTAMP NOT NULL,
    department INTEGER REFERENCES departments(department_id),
    employees_city_id INTEGER REFERENCES cities(city_id)
);

CREATE TABLE clients
(
    client_id INTEGER PRIMARY KEY,
    full_name VARCHAR(60) NOT NULL UNIQUE,
    phone_number VARCHAR(12) NOT NULL UNIQUE,
    manager_id INTEGER
);

CREATE TABLE branches
(
    branch_id INTEGER PRIMARY KEY,
    address VARCHAR(20) NOT NULL UNIQUE,
    branch_city_id INTEGER REFERENCES cities(city_id)
);
/* Заполнение таблиц, необходимых для использования выполнены вручную */
INSERT INTO departments VALUES (1, 'Development', 2), (2, 'Big Data', 3), (3, 'Management', 3), (4, 'Marketing', 1);

INSERT INTO employees VALUES (1, 'Alexander Hunold', 100000, 'Manager', TO_DATE('05-FEB-2012', 'dd-mon-yyyy'), 3, 1),
                             (2, 'Arnold Greenberg', 260000, 'Full-Stack Developer', TO_DATE('17-AUG-2020', 'dd-mon-yyyy'), 1, 1),
                             (3, 'David Manuel', 320000, 'Big Data Engineer', TO_DATE('30-SEP-2021', 'dd-mon-yyyy'), 2, 2),
                             (4, 'Luis Popp', 250000, 'Big Data Engineer', TO_DATE('30-SEP-2018', 'dd-mon-yyyy'), 2, 2),
                             (5, 'David Khoo', 180000, 'Big Data Engineer', TO_DATE('10-MAY-2022', 'dd-mon-yyyy'), 2, 3),
                             (6, 'Den Baida', 190000, 'Manager', TO_DATE('12-DEC-2015', 'dd-mon-yyyy'), 3, 3),
                             (7, 'Karen Jones', 220000, 'Manager', TO_DATE('11-FEB-2015', 'dd-mon-yyyy'), 3, 4),
                             (8, 'Kevin Everett', 250000, ' Marketing Specialist', TO_DATE('11-JUN-2022', 'dd-mon-yyyy'), 4, 4),
                             (9, 'Samuel McCain', 330000, 'Full-Stack Developer', TO_DATE('16-APR-2020', 'dd-mon-yyyy'), 1, 4);

SELECT * FROM departments;
SELECT * FROM employees;
TRUNCATE TABLE employees;

/* Заполнение остальных таблиц с помощью рандомного заполнения полей */
SELECT '+'||to_char(floor(random() * (25999888 - 10 + 1)) + 10, '9999999999');
SELECT left(random()::text, 5);

DO
    $$
        DECLARE client_i NUMERIC;
        BEGIN
            FOR client_i IN 1..20
                LOOP
                    INSERT INTO clients VALUES
                    (client_i, left(md5(random()::text), 10), '+' || to_char(floor(random() * (7599988812 - 10 + 1)) + 10, '9999999999'),
                     floor(random() * (3 - 1 + 1)) + 1);
                END LOOP;
        END
    $$
LANGUAGE 'plpgsql';


TRUNCATE TABLE clients;
SELECT * FROM clients;
SELECT '+' || to_char(floor(random() * (75999888121 - 10 + 1)) + 10, '99999999999');
SELECT left(md5(random()::text), 10);

DO
    $$
        DECLARE city_i NUMERIC;
        BEGIN
            FOR city_i IN 1..4
                LOOP
                    INSERT INTO cities VALUES
                    (city_i, left(md5(random()::text), 10));
                END LOOP;
        END
    $$
LANGUAGE 'plpgsql';

TRUNCATE TABLE cities CASCADE;
SELECT * FROM cities;


DO
    $$
        DECLARE branches_i NUMERIC;
        BEGIN
            FOR branches_i IN 1..10
                LOOP
                    INSERT INTO branches VALUES
                    (branches_i, left(md5(random()::text), 10), floor(random() * (4 - 1 + 1)) + 1);
                END LOOP;
        END
    $$
LANGUAGE 'plpgsql';

SELECT * FROM branches;
TRUNCATE TABLE branches;


/* Task 1 */
CREATE VIEW name_from_department AS
    SELECT employees.full_name, employees.salary, employees.position
    FROM employees
        INNER JOIN departments ON employees.department = departments.department_id
    WHERE departments.department_name = 'Big Data' AND employees.full_name LIKE 'David %';

INSERT INTO employees VALUES (10, 'Davidson McCain', 230000, 'Big Data Engineer', TO_DATE('01-Aug-2020', 'dd-mon-yyyy'), 2, 2);
SELECT * FROM employees;

/* Task 2 */
CREATE VIEW average_department_salary AS
    SELECT department_name, avg(salary) AS AVG_salary
    FROM departments
        LEFT JOIN employees ON departments.department_id = employees.department
    GROUP BY department_name
    ORDER BY avg(salary) DESC;

/* Task 3 */
CREATE VIEW AVG_Salary_Comparison AS
    SELECT position, avg(salary) AS AVG_salary_for_position,
                    CASE
                        WHEN avg(salary) > (SELECT avg(salary) from employees)
                            THEN 'Yes'
                        WHEN avg(salary) < (SELECT avg(salary) from employees)
                            THEN 'No'
                    END AVG_Salary_Comparison
                    FROM departments
                        LEFT JOIN employees ON departments.department_id = employees.department
    GROUP BY position;

SELECT avg(salary) from employees;

UPDATE employees SET salary = 90000 WHERE id = 6;
SELECT * FROM employees;

/* Task 4 */
INSERT INTO employees VALUES (11, 'Alexander Morris', 100000, 'Project Manager', TO_DATE('05-FEB-2021', 'dd-mon-yyyy'), 3, 2),
                             (12, 'Elizabeth Grey', 220000, 'HR Manager', TO_DATE('10-MAR-2022', 'dd-mon-yyyy'), 3, 4),
                             (13, 'Alexandra Stamm', 150000, 'Project Manager', TO_DATE('05-FEB-2020', 'dd-mon-yyyy'), 2, 2),
                             (14, 'Lee Smith', 110000, 'HR Manager', TO_DATE('12-FEB-2019', 'dd-mon-yyyy'), 3, 2),
                             (15, 'May Baum', 140000, 'HR Manager', TO_DATE('25-SEP-2022', 'dd-mon-yyyy'), 2, 1),
                             (16, 'Zak Miller', 180000, 'Project Manager', TO_DATE('12-FEB-2019', 'dd-mon-yyyy'), 2, 3),
                             (17, 'Robert White', 190000, 'Project Manager', TO_DATE('17-JUN-2021', 'dd-mon-yyyy'), 4, 4),
                             (18, 'Michel Harley', 160000, 'HR Manager', TO_DATE('05-OCT-2020', 'dd-mon-yyyy'), 4, 1)
SELECT * FROM employees;

/* Абсолютно неудачная попытка */
SELECT position,
       Array(
               CASE
                   WHEN position_date_start > '2020-12-31 00:00:00.000000'
                       THEN (departments.department_name -> employees.full_name)::json
                   END
           ),
       avg(salary) AS AVG_salary
FROM departments
    LEFT JOIN employees ON departments.department_id = employees.department
GROUP BY  GROUPING SETS (department_name), position, position_date_start
ORDER BY avg(salary) DESC;

/* Вроде как наиболее близок к истине, но работает некорректно, если даже исправить ошибки в части json_agg и json_object_agg */
-- Возможно, проблема в структуре базы данных, и необходимо добавить какие-то поля для корректной работы

SELECT position,
       avg(salary) AS Avg_salary,
       ARRAY(
           SELECT '"' || department_name || '"' FROM departments INNER JOIN employees ON departments.department_id = employees.department
           WHERE departments.department_id = employees.department GROUP BY department_name
           ) AS departments,
       json_object_agg(
           CASE
               WHEN position_date_start > '2020-12-31 00:00:00.000000'
                   THEN json_agg('"' || department_name || '"', ARRAY('"' || employees.full_name || '"'))
           END
           )
       FROM employees
    INNER JOIN departments ON departments.department_id = employees.department WHERE department_id = employees.department
GROUP BY position, department_name, employees.department
ORDER BY avg(salary) DESC;


SELECT * FROM employees INNER JOIN departments ON departments.department_id = employees.department;




