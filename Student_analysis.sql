CREATE TABLE Students (
    student_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    gender TEXT,
    age INTEGER
);

CREATE TABLE Courses (
    course_id INTEGER PRIMARY KEY,
    course_name TEXT NOT NULL
);

CREATE TABLE Enrollments (
    enrollment_id INTEGER PRIMARY KEY,
    student_id INTEGER,
    course_id INTEGER,
    grade INTEGER,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

INSERT INTO Students VALUES
(1, 'Akhil', 'Male', 20),
(2, 'Sravani', 'Female', 21),
(3, 'Karthik', 'Male', 22),
(4, 'Niharika', 'Female', 20),
(5, 'Lavanya', 'Female', 21),
(6, 'Varsha', 'Female', 20),
(7, 'Tarun', 'Male', 21),
(8, 'Ravi', 'Male', 22),
(9, 'Sunny', 'Male', 21);

INSERT INTO Courses VALUES
(101, 'SQL'),
(102, 'Python'),
(103, 'Data Analytics');

INSERT INTO Enrollments VALUES
(1, 1, 101, 85),
(2, 2, 102, 78),
(3, 3, 101, 35),
(4, 4, 103, 60),
(5, 5, 102, 92),
(6, 6, 103, 88),
(7, 7, 101, 45),
(8, 8, 102, 55),
(9, 9, 103, 30);

-- View Tables

SELECT * FROM Students;

SELECT * FROM Courses;

SELECT * FROM Enrollments;

-- Query 1: Top Student Per Course
SELECT
    c.course_name,
    s.name AS student_name,
    e.grade
FROM Enrollments e
JOIN Students s
ON e.student_id = s.student_id
JOIN Courses c
ON e.course_id = c.course_id
WHERE e.grade = (
    SELECT MAX(e2.grade)
    FROM Enrollments e2
    WHERE e2.course_id = e.course_id
);

-- Query 2: Pass Rate Per Course (Grade >= 40)
SELECT
    c.course_name,
    COUNT(CASE WHEN e.grade >= 40 THEN 1 END) AS Passed,
    COUNT(*) AS Total_Students,
    ROUND(
        COUNT(CASE WHEN e.grade >= 40 THEN 1 END) * 100.0 /
        COUNT(*), 2
    ) AS Pass_Rate_Percentage
FROM Enrollments e
JOIN Courses c
ON e.course_id = c.course_id
GROUP BY c.course_name;

-- Query 3: Overall Topper across all courses
SELECT
    s.student_id,
    s.name,
    ROUND(AVG(e.grade), 2) AS Average_Grade
FROM Students s
JOIN Enrollments e
ON s.student_id = e.student_id
GROUP BY s.student_id, s.name
ORDER BY Average_Grade DESC
LIMIT 1;

-- Query 4: Students Enrolled in Multiple Courses
SELECT
    s.student_id,
    s.name,
    COUNT(e.course_id) AS Total_Courses
FROM Students s
JOIN Enrollments e
ON s.student_id = e.student_id
GROUP BY s.student_id, s.name
HAVING COUNT(e.course_id) > 1;

-- Query 5: Average Grade Per Course
SELECT
    c.course_name,
    ROUND(AVG(e.grade), 2) AS Average_Grade
FROM Courses c
JOIN Enrollments e
ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY Average_Grade DESC;

