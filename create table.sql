create table FamilyStatus (
	idFamilyStatus int Primary Key,
	FamilyStatus varchar(15) check(FamilyStatus in ('замужем', 'не замужем', 
													'женат', 'не женат', 
													'разведен', 'разведена', 
													'вдова', 'вдовец')) not null unique
);

create table Post (
	idPost int Primary Key,
	Post varchar(20) not null unique
);

create table Crew (
	idCrew int Primary Key,
	NumberCrew int check(NumberCrew > 0) not null unique
);

create table Country (
	idCountry int Primary Key,
	Country varchar(20) not null Unique
);

create table City (
	idCity int Primary Key,
	City varchar(30) not null unique,
	idCountry int references Country(idCountry) on delete cascade,
	Unique (City, idCountry)
);

create table Airline (
	idAirline int Primary Key,
	Airline varchar(30) not null unique,
	idCity int references City(idCity) on delete cascade
);

create table Airplane (
	idAirplane int Primary Key,
	NumberAirplane varchar(15) not null unique,
	idAirline int not null references Airline(idAirline) on delete cascade,
	idCrew int not null references Crew(idCrew)  on delete cascade
);

create table Airport (
	idAirport int Primary Key,
	Airport varchar(30) not null unique,
	idCity int references City(idCity) on delete cascade
);

create table Direction (
	idDirection int Primary Key,
	DepartureAirport int references Airport(idAirport) on delete cascade,
	ArrivialAirport int references Airport(idAirport) on delete cascade,
	unique (DepartureAirport, ArrivialAirport)
);

create table Flight (
	idFlight int Primary Key,
	FlightNumber varchar(10),
	idDirection int not null references Direction(idDirection) on delete cascade,
	idAirplane int not null references Airplane(idAirplane) on delete cascade,
	TravelTime time(0) not null,
	DateFlight date check(DateFlight >= current_date) not null,
	Unique (idDirection, idAirplane, TravelTime, DateFlight)
); 

create table Class (
	idClass int Primary Key,
	Class varchar(20) check(Class in ('эконом', 'бизнес', 'первый')) not null unique
);

create table People (
	idPeople int Primary Key,
	Surname varchar(20) not null,
	Name varchar(20) not null,
	Patronymic varchar(20),
	Sex varchar(3) check(Sex in('жен', 'муж'))not null,
	PhoneNumber varchar(15) check(PhoneNumber ~ '^7[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]') not null,
	e_mail varchar(40) check(e_mail like '%@%'),
	DateOfBirth date check(DateOfBirth < current_date) not null,
	Unique (Surname, Name, Patronymic, Sex, PhoneNumber, e_mail, DateOfBirth)
);

create table Employee (
	idEmployee int Primary Key,
	idPeople int not null references People(idPeople) on delete cascade,
	Salary decimal check(salary > 0) not null,
	DateStart date check(DateStart <= current_date) not null,
	TermOfTheContract date not null, -- дата окончания срока действия контракта
	idFamilyStatus int references FamilyStatus(idFamilyStatus) on delete set null,
	idPost int not null references Post(idPost) on delete cascade,
	idCrew int not null references Crew(idCrew) on delete cascade,
	Unique (idPeople, Salary, DateStart, TermOfTheContract, idFamilyStatus, idPost, idCrew),
	check (DateStart < TermOfTheContract and TermOfTheContract > current_date)
);

create table Passenger (
	idPassenger int Primary Key,
	idPeople int unique references People(idPeople) on delete cascade,
	Passport char(11) check(Passport ~ '^[0-9][0-9][0-9][0-9] [0-9][0-9][0-9][0-9][0-9][0-9]') not null unique,
	idCity int not null references City(idCity) on delete cascade
);

create table Card (
	idCard int Primary Key,
	CardNumber varchar(13) check(CardNumber ~ '^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	idPassenger int not null references Passenger(idPassenger) on delete cascade,
	Cost decimal not null check(Cost > 0),
	idClass int not null references Class(idClass) on delete cascade,
	idFlight int not null references Flight(idFlight) on delete cascade,
	Unique (CardNumber, idPassenger, Cost, idClass, idFlight)
); 

create table Luggage (
	idLuggage int Primary Key,
	Weight float not null check(Weight > 0),
	idCard int not null unique references Card(idCard) on delete cascade
);