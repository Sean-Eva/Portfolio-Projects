--# Select Practice


--# 1
--# Recyclable and Low Fat Products

--# Write a solution to find the ids of products that are both low fat and recyclable.

--# Return the result table in any order.

SELECT
product_id
FROM
Products
WHERE
low_fats = 'Y' AND recyclable = 'Y'


--# 2
--# Find Customer Referee

--# Find the names of the customer that are not referred by the customer with id = 2.

--# Return the result table in any order.

SELECT
name
FROM
Customer
WHERE
referee_id != 2
or referee_id is null


--# 3
--# Big Countries

--# A country is big if:

--#     it has an area of at least three million (i.e., 3000000 km2), or
--#     it has a population of at least twenty-five million (i.e., 25000000).

--# Write a solution to find the name, population, and area of the big countries.

--# Return the result table in any order.

SELECT
name, population, area
FROM
World
WHERE
area >= 3000000
or population >= 25000000


--# 4
--# Article Views I

--# Write a solution to find all the authors that viewed at least one of their own articles.

--# Return the result table sorted by id in ascending order.

SELECT DISTINCT
author_id AS id
FROM
Views
WHERE
author_id = viewer_id
ORDER BY
author_id


--# 5
--# Invalid Tweets

--# Write a solution to find the IDs of the invalid tweets. The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.

--# Return the result table in any order.

SELECT
tweet_id
FROM
Tweets
WHERE
LENGTH(content) > 15


--# Basic Joints Practice


--# 6
--# Replace Employee ID With The Unique Identifier

--# Write a solution to show the unique ID of each user, If a user does not have a unique ID replace just show null.

--# Return the result table in any order.

SELECT
EmployeeUNI.unique_id AS unique_id, Employees.name AS name
FROM
Employees LEFT JOIN EmployeeUNI ON Employees.id = EmployeeUNI.id


--# 7
--# Product Sales Analysis I

--# Write a solution to report the product_name, year, and price for each sale_id in the Sales table.

--# Return the resulting table in any order.

SELECT
Product.product_name, Sales.year, Sales.price
FROM
Sales LEFT JOIN Product ON Sales.product_id = Product.product_id


--# 8
--# Customer Who Visited but Did Not Make Any Transactions

--# Write a solution to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.

--# Return the result table sorted in any order.

SELECT
Visits.customer_id, COUNT(Visits.visit_id) AS count_no_trans
FROM
Visits LEFT JOIN Transactions ON Visits.visit_id = Transactions.visit_id
WHERE
Transactions.transaction_id IS NULL
GROUP BY
Visits.customer_id


--# 9
--# Rising Temperature

--# Write a solution to find all dates' Id with higher temperatures compared to its previous dates (yesterday).

--# Return the result table in any order.

SELECT
Weather1.id
FROM
Weather Weather1, Weather Weather2
WHERE
DATEDIFF(Weather1.recordDate, Weather2.recordDate) = 1 AND Weather1.temperature > Weather2.temperature


--# 10
--# Average Time of Process per Machine

--# There is a factory website that has several machines each running the same number of processes. Write a solution to find the average time each machine takes to complete a process.

--# The time to complete a process is the 'end' timestamp minus the 'start' timestamp. The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.

--# The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places.

--# Return the result table in any order.

SELECT
a1.machine_id, ROUND(AVG(a2.timestamp - a1.timestamp), 3) as processing_time
FROM
Activity a1 JOIN Activity a2 ON a1.machine_id = a2.machine_id AND a1.process_id = a2.process_id AND a1.activity_type = 'start' AND a2.activity_type = 'end'
GROUP BY
a1.machine_id


--# 11
--# Employee Bonus

--# Write a solution to report the name and bonus amount of each employee with a bonus less than 1000.

--# Return the result table in any order.

SELECT
Employee.name, Bonus.bonus
FROM
Employee LEFT JOIN Bonus ON Employee.empId = Bonus.empId
WHERE
Bonus.bonus < 1000
OR Bonus.bonus IS NULL


--# 12
--# Students and Examinations

--# Write a solution to find the number of times each student attended each exam.

--# Return the result table ordered by student_id and subject_name.

SELECT
Students.student_id, Students.student_name, Subjects.subject_name, COUNT(Examinations.student_id) AS attended_exams
FROM
Students CROSS JOIN Subjects LEFT JOIN Examinations ON Students.student_id = Examinations.student_id AND Subjects.subject_name = Examinations.subject_name
GROUP BY
Students.student_id, Students.student_name, Subjects.subject_name
ORDER BY
Students.student_id, Subjects.subject_name


--# 13
--# Managers with at Least 5 Direct Reports

--# Write a solution to find managers with at least five direct reports.

--# Return the result table in any order.

SELECT
e1.name
FROM
Employee e1 INNER JOIN Employee e2 ON e1.id = e2.managerId
GROUP BY
e2.managerId
HAVING
COUNT(e2.managerId) >= 5


--# 14
--# Confirmation Rate

--# The confirmation rate of a user is the number of 'confirmed' messages divided by the total number of requested confirmation messages. The confirmation rate of a user that did not request any confirmation messages is 0. Round the confirmation rate to two decimal places.

--# Write a solution to find the confirmation rate of each user.

--# Return the result table in any order.

SELECT
Signups.user_id, ROUND(AVG(if(Confirmations.action="confirmed", 1, 0)), 2) AS confirmation_rate
FROM
Signups LEFT JOIN Confirmations ON Signups.user_id = Confirmations.user_id
GROUP BY
Signups.user_id


--# Basic Aggregate Functions Practice


--# 15
--# Not Boring Movies

--# Write a solution to report the movies with an odd-numbered ID and a description that is not "boring".

--# Return the result table ordered by rating in descending order.

SELECT
id, movie, description, rating
FROM
Cinema
WHERE
id % 2 = 1
AND description not like "%boring%"
ORDER BY
rating DESC


--# 16
--# Average Selling Price

--# Write a solution to find the average selling price for each product. average_price should be rounded to 2 decimal places.

--# Return the result table in any order.

SELECT
Prices.product_id, IFNULL(ROUND(SUM(Prices.price * UnitsSold.units) / SUM(UnitsSold.units), 2), 0) as average_price
FROM
Prices LEFT JOIN UnitsSold ON Prices.product_id = UnitsSold.product_id AND UnitsSold.purchase_date BETWEEN Prices.start_date and Prices.end_date
GROUP BY
Prices.product_id


--# 17
--# Project Employees I

--# Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.

--# Return the result table in any order.

SELECT
Project.project_id, IFNULL(ROUND(AVG(Employee.experience_years), 2), 0) as average_years
FROM
Project LEFT JOIN Employee ON Project.employee_id = Employee.employee_id
GROUP BY
Project.project_id


--# 18
--# Percentage of Users Attended a Contest

--# Write a solution to find the percentage of the users registered in each contest rounded to two decimals.

--# Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.

SELECT
contest_id, IFNULL(ROUND(COUNT(user_id) * 100 / (SELECT COUNT(user_id) FROM Users), 2), 0) AS percentage
FROM
Register
GROUP BY
contest_id
ORDER BY
percentage DESC, contest_id


--# 19
--# Queries Quality and Percentage

--# We define query quality as:

--#     The average of the ratio between query rating and its position.

--# We also define poor query percentage as:

--#     The percentage of all queries with rating less than 3.

--# Write a solution to find each query_name, the quality and poor_query_percentage.

--# Both quality and poor_query_percentage should be rounded to 2 decimal places.

--# Return the result table in any order.

SELECT
query_name,
ROUND(AVG(rating / position), 2) AS quality,
ROUND(AVG(IF(rating < 3, 1, 0)) * 100, 2) AS poor_query_percentage
FROM
Queries
GROUP BY
query_name
HAVING
query_name IS NOT null


--# 20
--# Monthly Transactions I

--# Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.

--# Return the result table in any order.

SELECT
SUBSTR(trans_date, 1, 7) AS month,
country,
COUNT(id) AS trans_count,
SUM(CASE WHEN state = 'approved' then 1 else 0 END) AS approved_count,
SUM(amount) AS trans_total_amount,
SUM(CASE WHEN state = 'approved' then amount else 0 END) AS approved_total_amount
FROM
Transactions
GROUP BY
month, country 


--# 21
--# Immediate Food Delivery II

--# If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.

--# The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer has precisely one first order.

--# Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.

SELECT
ROUND(AVG(order_date = customer_pref_delivery_date) * 100, 2) AS immediate_percentage
FROM
Delivery
WHERE
(customer_id, order_date) IN (
    SELECT
    customer_id, min(order_date)
    FROM
    Delivery
    GROUP BY
    customer_id
)