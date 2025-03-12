--- 🟢 WINDOW FUNCTIONS (Pencere Fonksiyonları) ---
-- Veri kümeleri üzerinde satır bazlı analizler yapmamızı sağlar.
USE parks_and_recreation;

-- Cinsiyete göre maaş ortalaması hesaplama (Klasik GROUP BY yöntemi)
SELECT gender, AVG(salary) AS average_salary
FROM employee_demographics AS dem  
JOIN employee_salary AS sal
  ON dem.employee_id = sal.employee_id
GROUP BY gender;

-- Genel maaş ortalamasını hesaplama (OVER() kullanarak)
SELECT gender, AVG(salary) OVER() AS overall_avg_salary
FROM employee_demographics AS dem  
JOIN employee_salary AS sal
  ON dem.employee_id = sal.employee_id;

-- Cinsiyete göre maaş ortalaması hesaplama (Window Function ile)
SELECT gender, AVG(salary) OVER(PARTITION BY gender) AS avg_salary_per_gender
FROM employee_demographics AS dem  
JOIN employee_salary AS sal
  ON dem.employee_id = sal.employee_id;

-- Çalışan bazında cinsiyet ortalamaları ile maaşları gösterme
SELECT dem.first_name, dem.last_name, gender, AVG(salary) OVER(PARTITION BY gender) AS avg_salary_per_gender
FROM employee_demographics AS dem  
JOIN employee_salary AS sal
  ON dem.employee_id = sal.employee_id;

-- Maaşların kümülatif toplamını hesaplama
SELECT dem.first_name, dem.last_name, gender, salary, 
       SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS rolling_total
FROM employee_demographics AS dem  
JOIN employee_salary AS sal
  ON dem.employee_id = sal.employee_id;

-- Çalışanlara sıralama numarası verme (ROW_NUMBER)
SELECT dem.first_name, dem.last_name, gender, salary, 
       ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num
FROM employee_demographics AS dem  
JOIN employee_salary AS sal
  ON dem.employee_id = sal.employee_id;

-- Maaş sıralamasına göre RANK() ve DENSE_RANK() kullanımı
SELECT dem.first_name, dem.last_name, gender, salary,
       RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num,
       DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank_num
FROM employee_demographics AS dem  
JOIN employee_salary AS sal
  ON dem.employee_id = sal.employee_id;


--- 🟢 CTE (Common Table Expressions - Geçici Sorgular) ---
-- Cinsiyete göre maaş istatistikleri hesaplayan CTE kullanımı
WITH CTE_EXAMPLE AS (
    SELECT gender, AVG(salary) AS avg_sal, MAX(salary) AS max_sal, 
           MIN(salary) AS min_sal, COUNT(salary) AS count_sal
    FROM employee_demographics AS dem
    JOIN employee_salary AS sal
        ON dem.employee_id = sal.employee_id 
    GROUP BY gender
)
SELECT * FROM CTE_EXAMPLE;

-- Birden fazla CTE tanımlayarak iki tabloyu birleştirme
WITH CTE_EXAMPLE AS (
    SELECT employee_id, gender, birth_date
    FROM employee_demographics 
    WHERE birth_date > '1985-01-01'
), 
CTE_EXAMPLE2 AS (
    SELECT employee_id, salary
    FROM employee_salary
    WHERE salary > 50000
)
SELECT *
FROM CTE_EXAMPLE
JOIN CTE_EXAMPLE2
    ON CTE_EXAMPLE.employee_id = CTE_EXAMPLE2.employee_id;


--- 🟢 TEMPORARY TABLES (Geçici Tablolar) ---
-- Geçici bir tablo oluşturma ve veri ekleme
CREATE TEMPORARY TABLE temp_table (
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    favorite_movie VARCHAR(100)
);

-- Tabloya veri ekleme
INSERT INTO temp_table VALUES ('ESMANUR', 'ÜCEL', 'OTEL TRANSILVANYA');

-- Geçici tabloyu görüntüleme
SELECT * FROM temp_table;

-- Maaşı 50.000'den yüksek olan çalışanları içeren geçici tablo oluşturma
CREATE TEMPORARY TABLE salary_over_50k
SELECT * FROM employee_salary 
WHERE salary >= 50000;

-- Yeni oluşturulan tabloyu görüntüleme
SELECT * FROM salary_over_50k;


--- 🟢 STORED PROCEDURES (Saklı Yordamlar) ---
-- 50.000 üzeri maaşı olan çalışanları getiren prosedür oluşturma
DELIMITER $$  
CREATE PROCEDURE large_salaries()
BEGIN 
    SELECT * FROM employee_salary
    WHERE salary > 50000;
END $$  
DELIMITER ;

-- Prosedürü çağırma
CALL large_salaries();


--- 🟢 TRIGGERS AND EVENTS (Tetikleyiciler ve Olaylar) ---
-- Çalışan ve maaş tablolarını görüntüleme
SELECT * FROM employee_demographics;
SELECT * FROM employee_salary;
