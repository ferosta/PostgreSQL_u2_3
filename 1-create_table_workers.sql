-- 2. Для будущих отчетов аналитики попросили вас создать еще одну таблицу с информацией по отделам 
-- – в таблице должен быть 
-- идентификатор для каждого отдела, 
-- название отдела (например. Бухгалтерский или IT отдел), 
-- ФИО руководителя 
--и количество сотрудников.

CREATE TABLE IF NOT EXISTS Divisions(
	Id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	Title VARCHAR(255),
	Head_Name VARCHAR(255),
	Staff_Count NUMERIC
);

--  1. Создать таблицу с основной информацией о сотрудниках: 
--  ФИО, дата рождения, 
--  дата начала работы, 
--  должность, 
--  уровень сотрудника (jun, middle, senior, lead), 
--  уровень зарплаты, 
--  идентификатор отдела, 
--  наличие/отсутствие прав(True/False). 
--  При этом в таблице обязательно должен быть уникальный номер для каждого сотрудника.

DROP TYPE IF EXISTS Stage_Type;
CREATE TYPE Stage_Type AS ENUM ('junior', 'middle', 'senior', 'lead');

CREATE TABLE IF NOT EXISTS Workers
(
	Id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	FIO VARCHAR(255) NOT NULL,	
	Begint_Data DATE NOT NULL,
	Post VARCHAR (20) NOT NULL,
	Stage Stage_Type NOT NULL DEFAULT 'junior',
	Salary INT NOT NULL DEFAULT 20000,
	Division_Id INT,
	Drive_License BOOLEAN NOT NULL DEFAULT FALSE,
	CONSTRAINT Division_Fk
		FOREIGN KEY (Division_Id)
		REFERENCES Divisions(Id)
		ON DELETE CASCADE
);



--· 3. На кону конец года и необходимо выплачивать сотрудникам премию. 
--Премия будет выплачиваться по совокупным оценкам, которые сотрудники получают в каждом квартале года. 
--Создайте таблицу, в которой для каждого сотрудника будут его оценки за каждый квартал. 
--Диапазон оценок от A – самая высокая, до E – самая низкая.
DROP TYPE IF EXISTS Rating_Type;
CREATE TYPE Rating_Type AS ENUM ('A', 'B', 'C', 'D', 'E');

CREATE TABLE IF NOT EXISTS Rating(
	Id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	Worker_Id INT,
	Q1 Rating_Type, 
	Q2 Rating_Type, 
	Q3 Rating_Type,
	Q4 Rating_Type,
	CONSTRAINT worker_fk
		FOREIGN KEY (Worker_Id)
		REFERENCES Workers(Id)
		ON DELETE CASCADE
);

--· 4. Несколько уточнений по предыдущим заданиям – в первой таблице должны быть записи как минимум о 5 сотрудниках, 
--которые работают как минимум в 2-х разных отделах. 
--Содержимое соответствующих атрибутов остается на совесть вашей фантазии, но, 
--желательно соблюдать осмысленность и правильно выбирать типы данных (для зарплаты – числовой тип, для ФИО – строковый и т.д.)

INSERT INTO Divisions( 
	Title ,
	Head_Name ,
	Staff_Count 
)
VALUES
('лаб.№23', 'Иван Иванович Иванов', 2),
('лаб.№21', 'Василий Васильевич Васильев', 2),
('лаб.№27', 'Сергей Борисович Звездюлёв', 2);

INSERT INTO Workers (
	FIO,
	Begint_Data,
	Post,
	Stage,
	Salary,
	Division_Id,
	Drive_License
)
VALUES 
	('Иван Иванович Иванов', '2022-02-24', 'м.н.с.', 'junior', 30000, 1, TRUE),
	('Марина Петровна Петрова', '2021-01-01', 'н.с.', 'middle', 40000, 2, FALSE),
	('Василий Васильевич Васильев', '1995-10-20', 'в.н.с.', 'lead', 70000, 3, TRUE),
    ('Михаил Джекович Блэк', '2022-03-04', 'м.н.с.', 'junior', 30000, 1, TRUE),
	('Сергей Борисович Звездюлёв', '2019-12-30', 'г.н.с.', 'lead', 40000, 2, TRUE),
	('Марьяна Ибрагимовна Минскер', '2020-06-15', 'в.н.с.', 'middle', 70000, 3, TRUE);

INSERT INTO Rating(
	Worker_Id ,
	Q1 , 
	Q2 , 
	Q3 ,
	Q4 
)
VALUES
(1,'D','B','C','D'),
(2,'B','C','D','E'),
(3,'B','D','A','E'),
(4,'A','E','D','C'),
(5,'E','D','B','E'),
(6,'B','C','C','D');


--5. Ваша команда расширяется и руководство запланировало открыть новый отдел – отдел Интеллектуального анализа данных. 
--На начальном этапе в команду наняли одного руководителя отдела и двух сотрудников. 
--Добавьте необходимую информацию в соответствующие таблицы.

INSERT INTO Divisions(
	 Title
	,Head_Name
	,Staff_Count
)
VALUES
('Отдел Интеллектуального анализа данных', 'Илон Давидович Маск', 3);


INSERT INTO Workers(
	 FIO
	,Begint_Data
	,Post
	,Stage
	,Salary
	,Division_Id
	,Drive_License
)
VALUES
 ('Илон Давидович Маск', '2022-11-11','главный инноватор', 'lead', 100500, 4, TRUE)
,('Бил Николаевич Ёлкин', '2022-11-11','программист', 'senior', 19450, 4, FALSE)
,('Иннесса Матвеевна Дюймина', '2022-11-11','секретарь', 'middle', 50945, 4, FALSE);


--· 6. Теперь пришла пора анализировать наши данные – 
--напишите запросы для получения следующей информации:
--o Уникальный номер сотрудника, его ФИО и стаж работы – для всех сотрудников компании
--SELECT Id as "Таб.№", FIO as "ФИО", ( NOW() - Begint_Data) / 365 as "Стаж" FROM Workers w; 
SELECT Id as "Таб.№", FIO as "ФИО", 0.1*round(10*( current_date - Begint_Data)/365.0)  as "Стаж, лет" FROM Workers w; 

--o Уникальный номер сотрудника, его ФИО и стаж работы – только первых 3-х сотрудников
SELECT Id as "Таб.№", FIO as "ФИО", 0.1*round(10*( current_date - Begint_Data)/365.0)  as "Стаж, лет" FROM Workers w LIMIT 3; 

--o Уникальный номер сотрудников - водителей
SELECT Id as "Таб.№" FROM Workers w WHERE w.Drive_License ; 

--o Выведите номера сотрудников, которые хотя бы за 1 квартал получили оценку D или E
SELECT Id as "Таб.№" FROM Rating r WHERE r.Q1 = 'D' OR r.Q1 = 'E' 
									  or r.Q2 = 'D' OR r.Q2 = 'E'
									  or r.Q3 = 'D' OR r.Q3 = 'E'
									  or r.Q4 = 'D' OR r.Q4 = 'E' ; 

--o Выведите самую высокую зарплату в компании.
SELECT max(salary) as "Заработная плата" FROM Workers w; 

--o * Выведите название самого крупного отдела
SELECT Title as "Название" FROM Divisions d WHERE d.staff_count = (SELECT max(staff_count) FROM Divisions) ; 

--o * Выведите номера сотрудников от самых опытных до вновь прибывших
SELECT Id as "Таб.№" FROM Workers w ORDER BY w.begint_data DESC;

--o* Рассчитайте среднюю зарплату для каждого уровня сотрудников
SELECT Stage, AVG(Salary) FROM Workers GROUP BY Stage order by avg(salary) DESC;

--o* Добавьте столбец с информацией о коэффициенте годовой премии к основной таблице. 
--Коэффициент рассчитывается по такой схеме: базовое значение коэффициента – 1, 
--каждая оценка действует на коэффициент так:
--Е – минус 20%
--D – минус 10%
--С – без изменений
--B – плюс 10%
--A – плюс 20%
--Соответственно, сотрудник с оценками А, В, С, D – должен получить коэффициент 1.2.

SELECT * FROM Workers w LEFT JOIN 
(SELECT Id, 1+K1+K2+K3+K4 AS "Коэффициент" FROM 
(SELECT Id, Q1, Q2, Q3, Q4 
,CASE 
	WHEN Q1 = 'A' THEN 0.2
	WHEN Q1 = 'B' THEN 0.1
	WHEN Q1 = 'C' THEN 0.0
	WHEN Q1 = 'D' THEN -0.1
	WHEN Q1 = 'E' THEN -0.2
END K1
,CASE 
	WHEN Q2 = 'A' THEN 0.2
	WHEN Q2 = 'B' THEN 0.1
	WHEN Q2 = 'C' THEN 0.0
	WHEN Q2 = 'D' THEN -0.1
	WHEN Q2 = 'E' THEN -0.2
END K2
,CASE 
	WHEN Q3 = 'A' THEN 0.2
	WHEN Q3 = 'B' THEN 0.1
	WHEN Q3 = 'C' THEN 0.0
	WHEN Q3 = 'D' THEN -0.1
	WHEN Q3 = 'E' THEN -0.2
END K3
,CASE 
	WHEN Q4 = 'A' THEN 0.2
	WHEN Q4 = 'B' THEN 0.1
	WHEN Q4 = 'C' THEN 0.0
	WHEN Q4 = 'D' THEN -0.1
	WHEN Q4 = 'E' THEN -0.2
END K4
FROM rating r ) as K) as KK
ON w.Id = KK.Id
ORDER BY "Коэффициент" DESC;


-- экспериментальный вариант расчета коэффициента
SELECT * FROM Workers w 
LEFT JOIN
		(SELECT Id  
			,0.1*(-ASCII(CAST(r.Q1 AS char(1)))+67)
			+0.1*(-ASCII(CAST(r.Q2 AS char(1)))+67)
			+0.1*(-ASCII(CAST(r.Q3 AS char(1)))+67)
			+0.1*(-ASCII(CAST(r.Q4 AS char(1)))+67) + 1  AS "Коэффициент"
		FROM rating r) as rk 
ON w.Id = rk.Id
ORDER BY "Коэффициент" DESC;






