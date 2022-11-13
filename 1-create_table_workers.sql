--  1. Создать таблицу с основной информацией о сотрудниках: 
--  ФИО, дата рождения, 
--  дата начала работы, 
--  должность, 
--  уровень сотрудника (jun, middle, senior, lead), 
--  уровень зарплаты, 
--  идентификатор отдела, 
--  наличие/отсутствие прав(True/False). 
--  При этом в таблице обязательно должен быть уникальный номер для каждого сотрудника.

CREATE TYPE IF NOT EXISTS T_Stage AS ENUM ('jun', 'middle', 'senior', 'lead');

CREATE TABLE IF NOT EXISTS Workers
(
	Id SERIAL PRIMARY KEY,
	FIO CHARACTER VARYING (150) NOT NULL UNIQUE,	
	Begint_Data DATE NOT NULL,
	Post CHARACTER VARYING (20) NOT NULL,
	Stage T_Stage NOT NULL DEFAULT 'jun',
	Salary INT NOT NULL DEFAULT 20000,
	Division VARCHAR(10) NOT NULL,
	Drive_License BOOLEAN NOT NULL DEFAULT FALSE
);

INSERT INTO Workers (
	FIO,
	Begint_Data,
	Post,
	Stage,
	Salary,
	Division,
	Drive_License
)
VALUES 
	('Иван Иванович Иванов', '2022-02-24', 'м.н.с.', 'jun', 30000, 'лаб.№23', TRUE),
	('Марина Петровна Петрова', '2021-01-01', 'н.с.', 'middle', 40000, 'лаб.№27', FALSE),
	('Василий Васильевич Васильев', '1995-10-20', 'в.н.с.', 'lead', 70000, 'лаб.№21', TRUE);