--- 🟢 ALIASING (Takma Ad Kullanımı) ---
-- AS anahtar kelimesi ile kolonlara veya tablolara takma ad verebiliriz.
-- Daha okunaklı ve anlamlı çıktılar elde etmemizi sağlar.

SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40;


--- 🟢 JOINS (Tablo Birleştirme) ---
-- INNER JOIN: İki tablodaki eşleşen kayıtları getirir.

SELECT *
FROM employee_demographics
INNER JOIN employee_salary 
   ON employee_demographics.employee_id = employee_salary.employee_id;

-- Tablo isimlerine takma ad (alias) vererek daha okunaklı hale getirme
SELECT dem.employee_id, age, occupation
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
   ON dem.employee_id = sal.employee_id;

-- LEFT JOIN: Soldaki (ilk) tablodaki tüm verileri ve sağdaki tablodan eşleşenleri getirir.
SELECT dem.employee_id, age, occupation
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal
   ON dem.employee_id = sal.employee_id;

-- RIGHT JOIN: Sağdaki (ikinci) tablodaki tüm verileri ve soldaki tablodan eşleşenleri getirir.
SELECT dem.employee_id, age, occupation
FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal
   ON dem.employee_id = sal.employee_id;


--- 🟢 SELF JOIN (Kendi Kendine JOIN) ---
-- Aynı tabloyu iki kez birleştirerek, belirli koşullarla kıyaslama yapmamızı sağlar.

SELECT emp1.employee_id AS emp_santa,
       emp1.first_name AS first_name_santa,
       emp1.last_name AS last_name_santa,
       emp2.first_name AS first_name_emp,
       emp2.last_name AS last_name_emp
FROM employee_salary AS emp1 
JOIN employee_salary AS emp2
   ON emp1.employee_id + 1 = emp2.employee_id;


--- 🟢 MULTIPLE TABLE JOINS (Birden Fazla Tablo Birleştirme) ---
-- Birden fazla tabloyu aynı sorguda JOIN ile birleştirerek daha kapsamlı analizler yapabiliriz.

SELECT *
FROM employee_demographics AS dem 
INNER JOIN employee_salary AS sal
   ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments AS pd
   ON sal.dept_id = pd.department_id;


--- 🟢 UNION (Tabloları Birleştirme) ---
-- UNION: İki veya daha fazla sorgunun sonucunu tek bir liste halinde döndürür.
-- UNION ALL: Aynı olan kayıtları da koruyarak birleştirir.

SELECT first_name, last_name
FROM employee_demographics
UNION ALL
SELECT first_name, last_name
FROM employee_salary;

-- Çalışanları belirli yaş kriterlerine göre gruplandırma
SELECT first_name, last_name, "old man" AS label 
FROM employee_demographics
WHERE age > 40 AND gender = "male"
UNION  
SELECT first_name, last_name, "old lady" AS label 
FROM employee_demographics
WHERE age > 40 AND gender = "female"
UNION 
SELECT first_name, last_name, "highly paid employee" AS label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name;


--- 🟢 STRING FUNCTIONS (Metin Fonksiyonları) ---
-- SQL’de metinlerle çalışmak için kullanılan fonksiyonlar

-- Karakter uzunluğu bulma
SELECT LENGTH("SKYFALL");

-- Metinleri büyük/küçük harfe çevirme
SELECT UPPER("sky");
SELECT LOWER("SKY");

-- Boşlukları temizleme
SELECT TRIM("    SKY    ");

-- İsmin ilk ve son birkaç karakterini alma
SELECT first_name, LEFT(first_name, 4), RIGHT(first_name, 4)
FROM employee_demographics;

-- Belirli karakterleri değiştirme
SELECT first_name, REPLACE(first_name, "a", "z")
FROM employee_demographics;

-- Metin içinde karakter arama
SELECT first_name, LOCATE("An", first_name)
FROM employee_demographics;

-- İsim ve soyisimleri birleştirme
SELECT first_name, last_name, 
CONCAT(first_name, " ", last_name) AS full_name
FROM employee_demographics;


--- 🟢 CASE STATEMENTS (Koşullu Durumlar) ---
-- CASE, belirli koşullara göre farklı çıktılar üretmemizi sağlar.

SELECT first_name, last_name, age,
CASE
   WHEN age <= 30 THEN "YOUNG"
   WHEN age BETWEEN 31 AND 50 THEN "OLD"
   WHEN age >= 50 THEN "GO TO HOLIDAY"
END AS Age_Bracket
FROM employee_demographics;


--- 🟢 SUBQUERIES (Alt Sorgular) ---
-- Bir sorgunun içinde başka bir sorgu çalıştırmak için kullanılır.

-- Departmanı 1 olan çalışanları getir
SELECT *
FROM employee_demographics
WHERE employee_id IN 
   (SELECT employee_id
    FROM employee_salary
    WHERE dept_id = 1);

-- Ortalama maaşı gösteren bir sütun ekleyerek çalışan maaşlarını kıyasla
SELECT first_name, salary, 
   (SELECT AVG(salary) FROM employee_salary) AS average_salary
FROM employee_salary;


--- 🟢 WINDOW FUNCTIONS (Pencere Fonksiyonları) ---
-- Veri kümeleri üzerinde satır bazlı analizler yapmamızı sağlar.

SELECT first_name, salary,
       AVG(salary) OVER() AS overall_avg_salary
FROM employee_salary;
