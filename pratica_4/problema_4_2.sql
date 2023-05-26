CREATE SCHEMA problema_4_2;
GO

Create Table problema_4_2.AIRPORT(
	airport_code	int					NOT NULL,
	city			varchar(30),
	state_			varchar(30),
	name_			varchar(30),
	primary key(airport_code)
);

Create Table problema_4_2.AIRPLANE_TYPE(
	type_name_			varchar(30)		NOT NULL,
	max_seats			smallint,
	company				varchar(30),
	primary key(type_name_)
);

Create Table problema_4_2.AIRPLANE(
	airplane_id				int			NOT NULL,
	total_no_of_seats		smallint,
	type_name_				varchar(30)	NOT NULL,
	primary key(airplane_id),
	foreign key(type_name_)	references problema_4_2.AIRPLANE_TYPE(type_name_)
);

Create Table problema_4_2.CAN_LAND(
	type_name_			varchar(30)		NOT NULL,
	airport_code		int				NOT NULL,
	primary key(type_name_,airport_code),
	foreign key(type_name_) references problema_4_2.AIRPLANE_TYPE(type_name_),
	foreign key(airport_code) references problema_4_2.AIRPORT(airport_code)
);

Create Table problema_4_2.FLIGHT(
	number				int				NOT NULL,
	airline				varchar(30),
	weekdays			varchar(16),
	primary key(number)
);

Create Table problema_4_2.FARE(
	restrictions		int,
	amount				money,
	code				int				NOT NULL,
	number				int				NOT NULL,
	primary key(number,code),
	foreign key(number) references problema_4_2.FLIGHT(number)
);

Create Table problema_4_2.FLIGHT_LEG(
	leg_no				int				NOT NULL,
	schedule_dep_time	date,
	schedule_arr_time	date,
	number				int				NOT NULL,
	departure_airport	int				NOT NULL,
	arrival_airport		int				NOT NULL,
	primary key(number,departure_airport,arrival_airport,leg_no),
	foreign key(number) references problema_4_2.FLIGHT(number),
	foreign key(departure_airport) references problema_4_2.AIRPORT(airport_code),
	foreign key(arrival_airport) references problema_4_2.AIRPORT(airport_code)
);

Create Table problema_4_2.LEG_INSTANCE(
	leg_no				int				NOT NULL,
	date_				date			NOT NULL,
	airplane_id			int				NOT NULL,
	number				int				NOT NULL,
	no_of_avail_seats	smallint		default 0,
	dep_time			datetimeoffset,
	arr_time			datetimeoffset,
	departure_airport	int				NOT NULL,
	arrival_airport		int				NOT NULL,
	primary key(leg_no,date_,airplane_id,number,departure_airport,arrival_airport) ,
	foreign key(number,departure_airport,arrival_airport,leg_no) references problema_4_2.FLIGHT_LEG(number,departure_airport,arrival_airport,leg_no),
	foreign key(airplane_id) references problema_4_2.AIRPLANE(airplane_id)
);

Create Table problema_4_2.SEAT(
	seat_no				varchar(4)		NOT NULL,
	date_				date			NOT NULL,
	leg_no				int				NOT NULL,
	number				int				NOT NULL,
	costumer_name		varchar(30),
	cphone				varchar(15),
	departure_airport	int				NOT NULL,
	arrival_airport		int				NOT NULL,
	airplane_id         int				NOT NULL,
	primary key(seat_no,date_,leg_no,number,departure_airport,arrival_airport),
	foreign key(leg_no,date_,airplane_id,number,departure_airport,arrival_airport) references problema_4_2.LEG_INSTANCE(leg_no,date_,airplane_id,number,departure_airport,arrival_airport)
);