USE hrcompany;

-- 1. Pasirinkite visus darbuotojus: parašykite SQL užklausą, kuri gautų visus darbuotojų
-- įrašus iš Employees lentelės.

SELECT*
FROM employees;


-- 2. Pasirinkite tam tikrus stulpelius: parodykite visus vardus ir pavardes iš Employees lentelės.

SELECT 
FirstName AS Vardas, 
LastName AS Pavardė
FROM employees;


-- 3. Filtruokite pagal skyrius: gaukite darbuotojų sąrašą, kurie dirba HR skyriuje (department lentelė).

SELECT*
FROM departments
JOIN employees
ON departments.DepartmentID = employees.DepartmentID
WHERE DepartmentName = 'HR';


-- 4. Surikiuokite darbuotojus: gaukite darbuotojų sąrašą, surikiuotą pagal jų įdarbinimo datą didėjimo tvarka.

SELECT*
FROM employees
ORDER BY HireDate ASC;


-- 5. Suskaičiuokite darbuotojus: raskite kiek iš viso įmonėje dirba darbuotojų.

SELECT
	COUNT(*) AS Kiek_darbuotojų
FROM employees;


-- 6. Sujunkite darbuotojus su skyriais: išveskite bendrą darbuotojų sąrašą, šalia
-- kiekvieno darbuotojo nurodant skyrių kuriame dirba.

SELECT
	EmployeeID,
    FirstName,
    LastName,
    DateOfBirth,
    Gender,
    Email,
    Phone,
    Address,
    HireDate,
    DepartmentName AS Skyrius_kuriame_dirba
FROM departments
JOIN employees
ON departments.DepartmentID = employees.DepartmentID;


-- 7. Apskaičiuokite vidutinį atlyginimą: suraskite koks yra vidutinis atlyginimas
-- įmonėje tarp visų darbuotojų.

SELECT
	ROUND(AVG(salaryamount),2) AS Vidutinis_bendras_atlygis
FROM salaries;


-- Jeigu atskriai metų:

SELECT
ROUND(AVG(salaryamount),2) AS Vidutinis_bendras_atlygis_2023metu
From salaries
WHERE year(salarystartdate) = '2023';


-- 8. Išfiltruokite ir suskaičiuokite: raskite kiek darbuotojų dirba IT skyriuje.

SELECT 
	COUNT(*) AS IT_skyriaus_darbuotojai
FROM departments
JOIN employees
ON departments.DepartmentID = employees.DepartmentID
WHERE DepartmentName = 'IT';


-- 9. Išrinkite unikalias reikšmes: gaukite unikalių siūlomų darbo pozicijų sąrašą iš
-- jobpositions lentelės.

SELECT 
DISTINCT PositionTitle
FROM jobpositions;


-- 10. Išrinkite pagal datos rėžį: gaukite darbuotojus, kurie buvo nusamdyti tarp 2020-02-01 ir 2020-11-01.

SELECT*
FROM employees
WHERE HireDate BETWEEN '2020-02-01' AND '2020-11-01'
ORDER BY HireDate ASC;


-- 11. Darbuotojų amžius: gaukite kiekvieno darbuotojo amžių pagal tai kada jie yra gimę.

SELECT
	FirstName,
    LastName,
    TIMESTAMPDIFF(YEAR, DateOfBirth, CURDATE()) AS employee_age
FROM employees;


-- 12. Darbuotojų el. pašto adresų sąrašas: gaukite visų darbuotojų el. pašto adresų sąrašą
-- abėcėline tvarka.

SELECT 
email AS Darbuotojų_el_paštas
FROM employees
ORDER BY email ASC;


-- 13. Darbuotojų skaičius pagal skyrių: suraskite kiek kiekviename skyriuje dirba darbuotojų.

SELECT
	DepartmentName AS Darbo_skyrius,
	COUNT(*) AS Kiek_darbuotojų
FROM departments
JOIN employees
ON departments.DepartmentID = employees.DepartmentID
GROUP BY DepartmentName;


-- 14. Darbštus darbuotojas: išrinkite visus darbuotojus, kurie turi daugiau nei 3 įgūdžius (skills). arba 2 

SELECT
employees.EmployeeID,
FirstName,
LastName,
COUNT(DISTINCT(employeeskills.SkillID)) AS Įgūdžių_skaičius
FROM employees
JOIN employeeskills 
ON employees.EmployeeID = employeeskills.EmployeeID
JOIN skills
ON employeeskills.SkillID = skills.SKillID
GROUP BY employees.EmployeeID
HAVING COUNT(DISTINCT(employeeskills.SkillID)) >=2;


-- 15. Vidutinė papildomos naudos kaina: apskaičiuokite vidutines papildomų naudų
-- išmokų (benefits lentelė) išlaidas darbuotojams.

SELECT 
ROUND(SUM(COST)/COUNT(cost),2) AS Vidutines_papildomos_islaidos
FROM benefits;


-- 16. Jaunausias ir vyriausias darbuotojai: suraskite jaunausią ir vyriausią darbuotoją
-- įmonėje.

SELECT*,
CASE
WHEN DateofBirth = (SELECT MIN(dateofbirth) FROM employees) THEN 'jauniausias'
WHEN DateOFBirth = (SELECT MAX(dateofbirth) FROM employees) THEN 'vyriausias'
END AS amzius
FROM employees
WHERE DateOfBirth = (SELECT MIN(dateofbirth) from employees)
 OR DateOfBirth = (SELECT MAX(dateofbirth) from employees)
 ORDER BY amzius DESC;


-- 17. Skyrius su daugiausiai darbuotojų: suraskite kuriame skyriuje dirba daugiausiai
-- darbuotojų.

SELECT
DISTINCT DepartmentName,
COUNT(*) AS Kiek_darbuotojų
FROM departments
JOIN employees
ON departments.DepartmentID = employees.DepartmentID
GROUP BY DepartmentName
HAVING COUNT(*) >= ALL (SELECT COUNT(*) AS Kiek_darbuotojų
										FROM departments
										JOIN employees
										ON departments.DepartmentID = employees.DepartmentID
										GROUP BY DepartmentName);


-- 18. Tekstinė paieška: suraskite visus darbuotojus su žodžiu “excellent” jų darbo
-- atsiliepime (performancereviews lentelė).

SELECT
*
FROM employees
JOIN performancereviews
ON employees.EmployeeID = performancereviews.EmployeeID
WHERE ReviewText LIKE '%excellent%';


-- 19. Darbuotojų telefono numeriai: išveskite visų darbuotojų ID su jų telefono numeriais.

SELECT 
	EmployeeID, 
    Phone
FROM employees;


-- 20. Darbuotojų samdymo mėnesis: suraskite kurį mėnesį buvo nusamdyta daugiausiai darbuotojų.

SELECT 
	month(HireDate) AS Samdymo_mėnesis, 
	COUNT(*) AS Nusamdyta_darbuotojų
FROM employees
GROUP BY month(HireDate)
ORDER BY Nusamdyta_darbuotojų DESC
LIMIT 1;

-- Turetu parodyti jei keletas menesiu su tokiu paciu idarbintu darbuotoju sk?:

SELECT 
	month(HireDate) AS Samdymo_mėnesis, 
	COUNT(*) AS Nusamdyta_darbuotojų
FROM employees
GROUP BY month(HireDate)
HAVING COUNT(*)>= ALL (SELECT 	COUNT(*) AS Nusamdyta_darbuotojų
								FROM employees
								GROUP BY month(HireDate));


-- 21. Darbuotojų įgūdžiai: išveskite visus darbuotojus, kurie turi įgūdį “Communication”.

SELECT*
FROM employeeskills
JOIN skills
ON employeeskills.SkillID = skills.skillID
JOIN employees
ON employeeskills.employeeID = employees.employeeID
WHERE SkillName = "Communication";


-- 22. Sub-užklausos: suraskite kuris darbuotojas įmonėje uždirba daugiausiai ir išveskite
-- visą jo informaciją.

SELECT*
FROM employees
JOIN salaries
ON employees.employeeID = salaries.employeeID
WHERE SalaryAmount = (SELECT MAX(SalaryAmount) FROM salaries);


-- 23. Grupavimas ir agregacija: apskaičiuokite visas įmonės išmokų (benefits lentelė) išlaidas.

SELECT
SUM(cost) AS Išmokų_išlaidos
FROM benefits;


-- 24. Įrašų atnaujinimas: atnaujinkite telefono numerį darbuotojo, kurio id yra 1.

UPDATE employees
SET phone = '123-456-7899'
WHERE EmployeeID = 1;


-- 25. Atostogų užklausos: išveskite sąrašą atostogų prašymų (leaverequests), kurie laukia patvirtinimo.

SELECT*
FROM leaverequests
WHERE status = 'Pending';


-- 26. Darbo atsiliepimas: išveskite darbuotojus, kurie darbo atsiliepime yra gavę 5 balus.

SELECT*
FROM employees
JOIN performancereviews
ON employees.EmployeeID = performancereviews.ReviewerID
WHERE Rating = 5;


-- 27. Papildomų naudų registracijos: išveskite visus darbuotojus, kurie yra užsiregistravę
-- į “Health Insurance” papildomą naudą (benefits lentelė).

SELECT*
FROM employeebenefits
JOIN employees
ON  employees.employeeID = employeebenefits.employeeID
JOIN benefits
ON  benefits.benefitID = employeebenefits.benefitID
WHERE BenefitName = 'Health Insurance';


-- 28. Atlyginimų pakėlimas: parodykite kaip atrodytų atlyginimai darbuotojų, dirbančių
-- “Finance” skyriuje, jeigu jų atlyginimus pakeltume 10 %.

SELECT*,
SalaryAmount*1.1 AS Pakelta_alga
FROM employees
JOIN departments
ON employees.departmentID = departments.departmentID
JOIN salaries
ON employees.employeeID = salaries.employeeID
WHERE DepartmentName = 'Finance';


-- 29. Efektyviausi darbuotojai: raskite 5 darbuotojus, kurie turi didžiausią darbo
-- vertinimo (performance lentelė) reitingą.

SELECT*
FROM employees
JOIN performancereviews
ON employees.EmployeeID = performancereviews.ReviewerID
ORDER BY Rating DESC
LIMIT 5;

-- Randa visus darbuotojus su didziausiu ratingu (be LIMIT 5), jei ju daugiau nei 5
SELECT*
FROM employees
JOIN performancereviews
ON employees.EmployeeID = performancereviews.ReviewerID
WHERE rating = (SELECT MAX(rating) from performancereviews)
LIMIT 5;


-- 30. Atostogų užklausų istorija: gaukite visą atostogų užklausų istoriją (leaverequests
-- lentelė) darbuotojo, kurio id yra 1.

SELECT*
FROM leaverequests
WHERE employeeID = 1;


-- 31. Atlyginimų diapozono analizė: nustatykite atlyginimo diapazoną (minimalų ir
-- maksimalų) kiekvienai darbo pozicijai.

SELECT
DISTINCT departmentname AS Darbo_pozicija,
MIN(salaryamount) AS Minimalus_atlyginimas,
MAX(salaryamount) AS Maksimalus_atlyginimas
FROM employees
JOIN salaries
ON employees.EmployeeID = salaries.EmployeeID
JOIN departments
ON departments.DepartmentID = employees.DepartmentID
GROUP BY departmentname;


-- 32. Darbo atsiliepimo istorija: gaukite visą istoriją apie darbo atsiliepimus
-- (performancereviews lentelė), darbuotojo, kurio id yra 2.

SELECT*
FROM employees
JOIN performancereviews
ON employees.EmployeeID = performancereviews.EmployeeID
WHERE employees.employeeID = 2;


-- 33. Papildomos naudos kaina vienam darbuotojui: apskaičiuokite bendras papildomų
-- naudų išmokų išlaidas vienam darbuotojui (benefits lentelė).

SELECT
	employees.EmployeeID,
    Firstname,
    Lastname,
    SUM(benefits.cost) AS Išmokų_išlaidos
FROM employees
JOIN employeebenefits
ON employeebenefits.EmployeeID = employees.EmployeeID
JOIN benefits
ON employeebenefits.benefitID = benefits.BenefitID
GROUP BY employees.EmployeeID;


-- 34. Geriausi įgūdžiai pagal skyrių: išvardykite dažniausiai pasitaikančius įgūdžius
-- kiekviename skyriuje.

-- nera tokiu :(


-- 35. Atlyginimo augimas: apskaičiuokite procentinį atlyginimo padidėjimą kiekvienam
-- darbuotojui, lyginant su praėjusiais metais.



-- 36. Darbuotojų išlaikymas: raskite darbuotojus, kurie įmonėje dirba daugiau nei 5 metai
-- ir kuriems per tą laiką nebuvo pakeltas atlyginimas.

SELECT 
employees.employeeID, 
FirstName, 
LastName
FROM employees
JOIN salaries
ON employees.employeeID = salaries.employeeID
WHERE HireDate <= '2018-09-12'
GROUP BY employees.employeeID
HAVING COUNT(DISTINCT SalaryAmount) <=1;


-- 37. Darbuotojų atlyginimų analizė: suraskite kiekvieno darbuotojo atlygį (atlyginimas
-- (salaries lentelė) + išmokos už papildomas naudas (benefits lentelė)) ir surikiuokite
-- darbuotojus pagal bendrą atlyginimą mažėjimo tvarka.

SELECT 
FirstName, 
Lastname,
(SELECT SalaryAmount FROM salaries WHERE employeeID = employees.EmployeeID ORDER BY SalaryStartDate ASC Limit 1) AS Atlyginimas,
SUM(benefits.cost) AS Papildomų_naudų_išmokos,
(SELECT SalaryAmount FROM salaries WHERE employeeID = employees.EmployeeID ORDER BY SalaryStartDate ASC Limit 1)+SUM(benefits.cost) AS Bendras_atlyginimas
FROM employees
JOIN salaries
ON employees.employeeID = salaries.employeeID
JOIN employeebenefits
ON employeebenefits.employeeID = employees.employeeID
JOIN benefits
ON benefits.benefitID = employeebenefits.benefitID
WHERE year(salarystartdate) = '2023'
GROUP BY employees.EmployeeID
ORDER BY Bendras_atlyginimas DESC;


-- 38. Darbuotojų darbo atsiliepimų tendencijos: išveskite kiekvieno darbuotojo vardą ir
-- pavardę, nurodant ar jo darbo atsiliepimas (performancereviews lentelė) pagerėjo ar
-- sumažėjo.

SELECT
employees.Employeeid,
FirstName,
LastName,
(SELECT rating FROM performancereviews WHERE employeeID = employees.EmployeeID ORDER BY reviewdate DESC LIMIT 1) as 'Senas_atsiliepimas',
(SELECT rating FROM performancereviews WHERE employeeID = employees.EmployeeID ORDER BY reviewdate ASC Limit 1) as 'Naujas_atsiliepimas',
CASE
WHEN (SELECT rating FROM performancereviews WHERE employeeID = employees.EmployeeID ORDER BY reviewdate ASC Limit 1) > 
(SELECT rating from performancereviews WHERE employeeID = employees.EmployeeID ORDER BY reviewdate DESC LIMIT 1) THEN 'Pagerėjo'
WHEN (SELECT rating from performancereviews where employeeID = employees.EmployeeID order by reviewdate DESC LIMIT 1) > 
(SELECT rating FROM performancereviews where employeeID = employees.EmployeeID ORDER BY reviewdate ASC LIMIT 1) THEN 'Sumažėjo'
ELSE 'Liko_toks_pat'
END AS Atsiliepimų_kaita
FROM employees
JOIN performancereviews
ON employees.employeeID = performancereviews.employeeID
GROUP BY performancereviews.employeeid;



