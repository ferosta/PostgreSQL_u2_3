--создаем типы
CREATE TYPE grade_type AS ENUM ('junior', 'middle', 'senior');
CREATE TYPE score_type AS ENUM ('A','B','C','D','E');

--2. Для будущих отчетов аналитики попросили вас создать еще одну таблицу с информацией по отделам – в таблице должен быть идентификатор
-- для каждого отдела, название отдела (например. Бухгалтерский или IT отдел), ФИО руководителя и количество сотрудников.

CREATE TABLE IF NOT EXISTS departments (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    depname VARCHAR (255) NOT NULL,
    director_name VARCHAR (255),
    employee_count SMALLINT)
--1. Создать таблицу с основной информацией о сотрудниках: ФИО, дата рождения, дата начала работы, должность, уровень сотрудника (jun, middle, senior, lead),
-- уровень зарплаты, идентификатор отдела, наличие/отсутствие прав(True/False).
-- При этом в таблице обязательно должен быть уникальный номер для каждого сотрудника.
-- Создаем строго после департмент, потому что ссылается на департмент в ограничениях

CREATE TABLE IF NOT EXISTS employees (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    surname VARCHAR (255) NOT NULL,
    birthdate DATE NOT NULL,
    incomdate DATE NOT NULL,
    grade grade_type NOT NULL,
    salary INT,
    department_id INT,
    driver_licence BOOLEAN,
    CONSTRAINT department_fk
        FOREIGN KEY (department_id)
        REFERENCES departments(id)
        ON DELETE CASCADE)

--3. На кону конец года и необходимо выплачивать сотрудникам премию. Премия будет выплачиваться по совокупным оценкам, которые сотрудники получают в каждом квартале года. Создайте таблицу,
-- в которой для каждого сотрудника будут его оценки за каждый квартал. Диапазон оценок от A – самая высокая, до E – самая низкая.

CREATE TABLE IF NOT EXISTS scores (
    score_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_id INT,
    q1 score_type,
    q2 score_type,
    q3 score_type,
    q4 score_type,
    CONSTRAINT employee_fk
        FOREIGN KEY (employee_id)
        REFERENCES employees(id)
        ON DELETE CASCADE)
--4. Несколько уточнений по предыдущим заданиям – в первой таблице должны быть записи как минимум о 5 сотрудниках, которые работают как минимум в 2-х разных отделах.
-- Содержимое соответствующих атрибутов остается на совесть вашей фантазии, но, желательно соблюдать осмысленность и правильно выбирать типы данных (для зарплаты – числовой тип, для ФИО – строковый и т.д.)

INSERT INTO departments (
    depname,
    director_name,
    employee_count
)
VALUES
    ('data engineering', 'Manilov', 6),
    ('data analyst', 'Poluchalov', 4);

INSERT INTO employees (
    surname,
    birthdate,
    incomdate,
    grade,
    salary,
    department_id,
    driver_licence
)
VALUES
    ('Ivanov', '1995-02-28','2020-04-28','junior',35000,1,FALSE),
    ('Sidorov', '1996-03-11','2021-07-05','middle',55000,1,FALSE),
    ('Kozlov', '1997-04-12','2021-12-08','junior',35000,2,TRUE),
    ('Hohlov', '1985-01-31','2017-07-25','middle',65000,2,FALSE),
    ('Gryzlov', '1986-02-02','2018-12-04','middle',59000,1,FALSE),
    ('Kurchatov', '1987-03-23','2014-10-12','middle',61000,1,TRUE),
    ('Pushlov', '1988-05-20','2021-03-03', 'middle',63000,2,FALSE),
    ('Junlov', '1999-02-01','2022-11-04','junior',37000,1,FALSE),
    ('Manilov', '1975-04-17','2002-11-09','senior',97000,1,TRUE),
    ('Poluchalov', '1979-11-07','2002-12-01','senior',95000,2,FALSE);

 INSERT INTO scores (
    employee_id,
    q1,
    q2,
    q3,
    q4
)
VALUES
    (1, 'A', 'B', 'D', 'B'),
    (2, 'A', 'C', 'D', 'B'),
    (3, 'B', 'B', 'D', 'E'),
    (4, 'A', 'B', 'B', 'B'),
    (5, 'D', 'B', 'D', 'B'),
    (6, 'A', 'B', 'E', 'B'),
    (7, 'E', 'C', 'D', 'E'),
    (8, 'A', 'B', 'D', 'B'),
    (9, 'C', 'D', 'D', 'A'),
    (10, 'A', 'A', 'A', 'A');

--5. Ваша команда расширяется и руководство запланировало открыть новый отдел – отдел Интеллектуального анализа данных.
-- На начальном этапе в команду наняли одного руководителя отдела и двух сотрудников. Добавьте необходимую информацию в соответствующие таблицы.

INSERT INTO departments (
    depname,
    director_name,
    employee_count
)
VALUES
    ('data сustomer', 'Chichikov', 3);

INSERT INTO employees (
    surname,
    birthdate,
    incomdate,
    grade,
    salary,
    department_id,
    driver_licence
)
VALUES
    ('Prodavanov', '1993-02-28','2022-11-01','junior',37000,3,FALSE),
    ('Fasovanov', '1995-05-03','2022-11-02','middle',57000,3,FALSE),
    ('Chichicov', '1980-10-07','2022-11-03','senior',105000,3,TRUE);



INSERT INTO scores (
    employee_id,
    q1,
    q2,
    q3,
    q4
)
VALUES
    (11, 'C', 'C', 'C', 'B'),
    (12, 'C', 'C', 'C', 'B'),
    (13, 'C', 'C', 'C', 'E');
--   6. Теперь пришла пора анализировать наши данные – напишите запросы для получения следующей информации:
--o   Уникальный номер сотрудника, его ФИО и стаж работы – для всех сотрудников компании
select id, surname, (current_date-incomdate)/365 from employees e;
--o   Уникальный номер сотрудника, его ФИО и стаж работы – только первых 3-х сотрудников
select id, surname, (current_date-incomdate)/365 from employees e limit 3;
--o   Уникальный номер сотрудников - водителей
select id, surname from employees e where driver_licence=true;
--o   Выведите номера сотрудников, которые хотя бы за 1 квартал получили оценку D или E
select employee_id from scores where q1='E' or q1='D';
-- а можно с фамилией
select employee_id, surname from scores left join employees e on e.id=employee_id where (q1='E' or q1='D');
--o   Выведите самую высокую зарплату в компании. Заодно рассекретим человека/ов)
select surname,salary from employees where salary=(select max(salary) from employees);
-- o   * Выведите название самого крупного отдела
select depname, employee_count from departments where employee_count=(select max(employee_count) from departments);
-- o   * Выведите номера сотрудников от самых опытных до вновь прибывших (ну и заодно фамилии и даты прихода в компанию))
select id, surname, incomdate  from employees order by incomdate;
-- o   * Рассчитайте среднюю зарплату для каждого уровня сотрудников (и сортирнем по средней зп)
select grade, avg(salary) from employees group by grade order by avg(salary);
-- Добавьте столбец с информацией о коэффициенте годовой премии к основной таблице. Коэффициент рассчитывается по такой схеме: базовое значение коэффициента – 1, каждая оценка действует на коэффициент так:
-- Е – минус 20%, D – минус 10%, С – без изменений, B – плюс 10%, A – плюс 20%,
-- Соответственно, сотрудник с оценками А, В, С, D – должен получить коэффициент 1.2.
-- Запрос, формирующий столбец bonus_score, спасибо Султанмурад!
select *, q1_score*q2_score*q3_score*q4_score as bonus_score from (
select *, case when q1='A' then 1.2
              when q1='B' then 1.1
              when q1='C' then 1
              when q1='D' then 0.9
              when q1='E' then 0.8
              else 1 end as q1_score,
        case when q2='A' then 1.2
              when q2='B' then 1.1
              when q2='C' then 1
              when q2='D' then 0.9
              when q2='E' then 0.8
              else 1 end as q2_score,
        case when q3='A' then 1.2
              when q3='B' then 1.1
              when q3='C' then 1
              when q3='D' then 0.9
              when q3='E' then 0.8
              else 1 end as q3_score,
        case when q4='A' then 1.2
              when q4='B' then 1.1
              when q4='C' then 1
              when q4='D' then 0.9
              when q4='E' then 0.8
              else 1 end as q4_score
                from scores ) q_s
-- а так хотелось сделать вычисляемый столбец, типа такого как ниже, но так ума и не хватило, поэтому не работает, говорит подзапрос не может использоваться в случае генерируемого столбца
ALTER TABLE employees
    ADD year_sal_rate float(4) GENERATED ALWAYS AS ((select *, q1_score*q2_score*q3_score*q4_score as bonus_score from (
                                                      select *, case when q1='A' then 1.2
                                                                    when q1='B' then 1.1
                                                                    when q1='C' then 1
                                                                    when q1='D' then 0.9
                                                                    when q1='E' then 0.8
                                                                    else 1 end as q1_score,
                                                              case when q2='A' then 1.2
                                                                    when q2='B' then 1.1
                                                                    when q2='C' then 1
                                                                    when q2='D' then 0.9
                                                                    when q2='E' then 0.8
                                                                    else 1 end as q2_score,
                                                              case when q3='A' then 1.2
                                                                    when q3='B' then 1.1
                                                                    when q3='C' then 1
                                                                    when q3='D' then 0.9
                                                                    when q3='E' then 0.8
                                                                    else 1 end as q3_score,
                                                              case when q4='A' then 1.2
                                                                    when q4='B' then 1.1
                                                                    when q4='C' then 1
                                                                    when q4='D' then 0.9
                                                                    when q4='E' then 0.8
                                                                    else 1 end as q4_score
                                                                      from scores ) q_s )) STORED;


