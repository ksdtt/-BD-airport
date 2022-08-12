-- 1) Добавить людям гражданство:
alter table People add column Nationality int references City(idCity) on delete set null;

-- 2) Показать всех людей:
select * from People;

-- 3) Показать всех сотрудников, которых приняли на работу, начиная с 2008 года:
select * from employee
where DateStart > '01-01-2008';

-- 4) Показать сотрудников, у которых зарплата принадлежит диапазону 20000-25000:
select * from Employee
where salary between 20000 and 25000;

-- 5) Показать работников, занимающих должность 1, 3 или 4:
select * from Employee
where idPost in (1,3,4);

-- 6) Показать людей, чье имя заканчивается на букву 'а':
select * from People
where name like '%а';

-- 7) Показать всех людей, у которых указан адрес электронной почты:
select * from People
where e_mail is not null;

-- 8) Работники отсортированные по номеру должности по возрастанию и по зарплате по убыванию:
select * from Employee join Post using(idPost)
order by Post asc, salary desc;

-- 9) Показать данные о работниках, включая ФИО, пол, номер телефона, 
-- адрес электронный почты, дату рождения и гражданство:
select * from People inner join Employee using(idPeople);

-- 10) Соединение работников и должностей с сохранением всех должностей:
select * from Employee right join Post using(idPost);

-- 11) Соединение работников и людей с сохранением всех людей:
select * from People left join Employee using(idPeople);

-- 12) Показать сведения о сотрудниках, включая наименование должности:
select * from Employee join Post using(idPost);

-- 13) Узнать количество работников с одинаковым семейным положением и 
-- занимаемой должностью, отсортировав по должности:
select Post, FamilyStatus, count(*) as "кол-во" from Employee join Post using(idPost)
															  join FamilyStatus using(idFamilyStatus)
group by FamilyStatus, Post
order by Post asc;

-- 14) Показать среди людей пассажиров, которые летят в Саратов:
select * from People
where idPeople in (select idPeople from Passenger
				  where idPassenger in (select idPassenger from Card
									   where idFlight in (select idFlight from Flight
														 where idDirection in (select idDirection from Direction
																			  where ArrivialAirport in (select idCity from City
																									   where City = 'Саратов')))));

-- 15) Показать расписание рейсов:
create view tablo as select FlightNumber as "Номер рейса",
							TravelTime as "Время в пути",
							DateFlight as "Дата рейса",
							A.Airport as "Аэропорт отправления",
							C.City as "Город отправления",
							F.Country as "Старана отправления",
							B.Airport as "Аэропорт прибытия",
							E.City as "Город прибытия",
							G.Country as "Страна прибытия"
							from Flight join Direction D using(idDirection)
							            left join Airport A on A.idAirport=D.DepartureAirport
										join Airport B on B.idAiport=D.ArrivialAirport
										join City C on C.idCity=A.idCity
										join City E on E.idCity=B.idCity
										join Country F on F.idCountry=C.idCountry
										join Country G on G.idCountry=E.idCountry;
select * from tablo;						