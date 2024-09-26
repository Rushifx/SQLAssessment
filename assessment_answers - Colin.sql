USE db;

-- 1. Analyse the data
-- Hint: use a SELECT statement via a JOIN to sample the data
-- ****************************************************************
SELECT u.*, p.learn_cpp, p.learn_sql, p.learn_html, p.learn_javascript, p.learn_java
FROM progress p
JOIN users u
ON p.user_id = u.user_id;

-- 2. What are the Top 25 schools (.edu domains)?
-- Hint: use an aggregate function to COUNT() schools with most students
-- ****************************************************************
SELECT u.email_domain, COUNT(u.user_id) AS `studentCount`
FROM users u
WHERE u.email_domain LIKE '%.edu'
GROUP BY u.email_domain
ORDER BY `studentCount` DESC LIMIT 25;



-- 3. How many .edu learners are located in New York?
-- Hint: use an aggregate function to COUNT() students in New York
-- ****************************************************************
SELECT SUM(`studentCount`) AS "Total Students in New York"
FROM (
	SELECT u.city, COUNT(u.user_id) AS "studentCount"
	FROM users u
	WHERE u.city LIKE "%New York%"
	GROUP BY u.city
	ORDER BY `studentCount`
) AS TotalSum;

-- 4. The mobile_app column contains either mobile-user or NULL. 
-- How many of these learners are using the mobile app?
-- Hint: COUNT()...WHERE...IN()...GROUP BY...
-- Hint: Alternate answers are accepted.
-- ****************************************************************
SELECT COUNT(CASE WHEN u.mobile_app = 'mobile-user' THEN 1 END) AS "Mobile Users"
FROM users u;

-- 5. Query for the sign up counts for each hour.
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/date-and-time-functions.html#function_date-format 
-- ****************************************************************
SELECT DATE_FORMAT(sign_up_at, '%H') AS 'Hour', COUNT(*) AS 'SignUpCount'
FROM users
GROUP BY `Hour`
ORDER BY `Hour`;

-- 6. What courses are the New Yorker Students taking?
-- Hint: SUM(CASE WHEN learn_cpp NOT IN('') THEN 1 ELSE 0 END) AS "New Yorker learners taking C++"
-- ****************************************************************
SELECT SUM(`C++ TAKEN`) AS "Students Taking C++", SUM(`SQL TAKEN`) AS "Students Taking SQL", SUM(`HTML TAKEN`) AS "Students Taking HTML", SUM(`JavaScript TAKEN`) AS "Students Taking JavaScript", SUM(`Java TAKEN`) AS "Students Taking Java"
FROM(
	SELECT u.user_id, SUM(CASE WHEN p.learn_cpp IN ('started', 'Completed') THEN 1 ELSE 0 END) AS "C++ Taken", SUM(CASE WHEN p.learn_sql IN ('started', 'Completed') THEN 1 ELSE 0 END) AS "SQL Taken", SUM(CASE WHEN p.learn_html IN ('started', 'Completed') THEN 1 ELSE 0 END) AS "HTML Taken", SUM(CASE WHEN p.learn_javascript IN ('started', 'Completed') THEN 1 ELSE 0 END) AS "JavaScript Taken", SUM(CASE WHEN p.learn_java IN ('started', 'Completed') THEN 1 ELSE 0 END) AS "Java Taken"
	FROM users u
	JOIN progress p
	ON u.user_id = p.user_id
	WHERE u.city LIKE "%New York%"
	GROUP BY u.user_id
)AS Total;
-- 7. What courses are the Chicago Students taking?
-- Hint: SUM(CASE WHEN learn_cpp NOT IN('') THEN 1 ELSE 0 END) AS "Chicago learners taking C++"
-- ****************************************************************
SELECT SUM(`C++ TAKEN`) AS "Students Taking C++", SUM(`SQL TAKEN`) AS "Students Taking SQL", SUM(`HTML TAKEN`) AS "Students Taking HTML", SUM(`JavaScript TAKEN`) AS "Students Taking JavaScript", SUM(`Java TAKEN`) AS "Students Taking Java"
FROM(
	SELECT u.user_id, SUM(CASE WHEN p.learn_cpp IN ('started', 'Completed') THEN 1 ELSE 0 END) AS "C++ Taken", SUM(CASE WHEN p.learn_sql IN ('started', 'Completed') THEN 1 ELSE 0 END) AS "SQL Taken", SUM(CASE WHEN p.learn_html IN ('started', 'Completed') THEN 1 ELSE 0 END) AS "HTML Taken", SUM(CASE WHEN p.learn_javascript IN ('started', 'Completed') THEN 1 ELSE 0 END) AS "JavaScript Taken", SUM(CASE WHEN p.learn_java IN ('started', 'Completed') THEN 1 ELSE 0 END) AS "Java Taken"
	FROM users u
	JOIN progress p
	ON u.user_id = p.user_id
	WHERE u.city LIKE "%Chicago%"
	GROUP BY u.user_id
)AS Total;

-- There seems to be a West Chicago and West New York which i noticed from an earlier mistake which may explain different numbers than if you were to directly do a WHERE u.city = "New York" or "Chicago" which is why i used LIKE