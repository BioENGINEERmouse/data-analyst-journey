-- Veri tabanındaki tüm çalışan bilgilerini getirir
SELECT *
FROM parks_and_recreation.employee_demographics;

-- Çalışanların ad, soyad ve doğum tarihini getirir, yaşlarına 10 ekler
SELECT first_name, last_name, birth_date, age + 10
FROM parks_and_recreation.employee_demographics;

-- Çalışanların benzersiz (farklı) isimlerini ve cinsiyetlerini getirir
SELECT DISTINCT first_name, gender
FROM parks_and_recreation.employee_demographics;

-- Cinsiyete göre gruplandırarak yaş ortalamalarını hesaplar
SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender;

-- Meslek ve maaşa göre gruplandırma yapar (gereksiz olabilir çünkü her maaş bireysel olabilir)
SELECT occupation, salary
FROM employee_salary
GROUP BY occupation, salary;

-- Çalışanları isim sırasına göre sıralar (A-Z artan sıra)
SELECT * 
FROM employee_demographics
ORDER BY first_name ASC;

-- Çalışanları isim sırasına göre tersten sıralar (Z-A azalan sıra)
SELECT * 
FROM employee_demographics
ORDER BY first_name DESC;

-- Çalışanları cinsiyete göre sıralar
SELECT * 
FROM employee_demographics
ORDER BY gender;

-- Çalışanları önce cinsiyete, sonra yaşa göre sıralar (yaş azalan sıra)
SELECT * 
FROM employee_demographics
ORDER BY gender, age DESC;

-- 1985 yılından sonra doğan erkek çalışanları getirir
SELECT *
FROM employee_demographics
WHERE birth_date > '1985-01-01' 
AND gender = 'male';

-- Çalışan adında "jer" ile başlayanları getirir
SELECT *
FROM employee_demographics
WHERE first_name LIKE 'jer%';

-- Çalışan adında "er" geçenleri getirir
SELECT *
FROM employee_demographics
WHERE first_name LIKE '%er%';

-- Çalışan adının üçüncü harfinden sonrası herhangi bir karakter olabilir
SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a__%';

-- Cinsiyete göre gruplandırılmış yaş ortalamaları 40’tan büyük olanları getirir
SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40;

-- Yönetici (Manager) unvanına sahip çalışanların maaş ortalamasını hesaplar, 75.000'den büyük olanları getirir
SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%MANAGER%'
GROUP BY occupation
HAVING AVG(salary) > 75000;

-- En yaşlı 3 çalışanı getirir
SELECT *
FROM employee_demographics
ORDER BY age DESC 
LIMIT 3;

