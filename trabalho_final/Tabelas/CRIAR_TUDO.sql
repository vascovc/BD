USE [master]
GO
/****** Object:  Database [Rent_buy_car]    Script Date: 23/06/2022 15:49:33 ******/
CREATE DATABASE [Rent_buy_car]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Rent_buy_car', FILENAME = N'C:\ProgramData\SOLIDWORKS Electrical\MSSQL12.TEW_SQLEXPRESS\MSSQL\DATA\Rent_buy_car.mdf' , SIZE = 4288KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Rent_buy_car_log', FILENAME = N'C:\ProgramData\SOLIDWORKS Electrical\MSSQL12.TEW_SQLEXPRESS\MSSQL\DATA\Rent_buy_car_log.ldf' , SIZE = 1088KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Rent_buy_car] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Rent_buy_car].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Rent_buy_car] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Rent_buy_car] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Rent_buy_car] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Rent_buy_car] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Rent_buy_car] SET ARITHABORT OFF 
GO
ALTER DATABASE [Rent_buy_car] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Rent_buy_car] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Rent_buy_car] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Rent_buy_car] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Rent_buy_car] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Rent_buy_car] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Rent_buy_car] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Rent_buy_car] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Rent_buy_car] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Rent_buy_car] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Rent_buy_car] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Rent_buy_car] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Rent_buy_car] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Rent_buy_car] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Rent_buy_car] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Rent_buy_car] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Rent_buy_car] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Rent_buy_car] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Rent_buy_car] SET  MULTI_USER 
GO
ALTER DATABASE [Rent_buy_car] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Rent_buy_car] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Rent_buy_car] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Rent_buy_car] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Rent_buy_car] SET DELAYED_DURABILITY = DISABLED 
GO
USE [Rent_buy_car]
GO

/****** Object:  UserDefinedDataType [dbo].[empid]    Script Date: 23/06/2022 15:49:33 ******/
CREATE TYPE [dbo].[empid] FROM [char](9) NOT NULL
GO
/****** Object:  UserDefinedDataType [dbo].[id]    Script Date: 23/06/2022 15:49:33 ******/
CREATE TYPE [dbo].[id] FROM [varchar](11) NOT NULL
GO
/****** Object:  UserDefinedDataType [dbo].[tid]    Script Date: 23/06/2022 15:49:33 ******/
CREATE TYPE [dbo].[tid] FROM [varchar](6) NOT NULL
GO
/****** Object:  UserDefinedFunction [dbo].[func_price_to_pay]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[func_price_to_pay] (@num_aluguer int) returns @table table(preco_total int)-- func para calcular o preco final
as
begin
	declare @num_dias_extra int;
	declare @taxa_de_dias as int;
	declare @preco_total as money;
	declare @taxa_km as int;
	declare @km as int;
	declare @preco_dia as int;

	select @num_dias_extra = DATEDIFF(DAY,data_fim, GETDATE()), @km = km_feitos --km do log
	from aluguer join log on num_aluguer=log.aluguer
	where num_aluguer=@num_aluguer

	set @taxa_de_dias = 0
	if @num_dias_extra > 0 --retornou mais tarde
		set @taxa_de_dias = 1.2
	
	-- preco = taxa + preco_dia*(num_dias_feitos + num_dias_extra*taxa_de_dias), taxa -> danos feitos; 
 
	select @preco_total = taxa + preco_dia*(DATEDIFF(DAY,data_registo, GETDATE()) + @num_dias_extra*@taxa_de_dias), @preco_dia=preco_dia,@taxa_km=DATEDIFF(DAY,data_registo, GETDATE())*limit_km_dia
	from aluguer join log on aluguer.num_aluguer=log.aluguer
					join veiculo_de_aluguer on veiculo_de_aluguer.vin=aluguer.veiculo
	where @num_aluguer=num_aluguer

	
	if @taxa_km < @km -- se ele fez mais km do que o que devia, numero_de_dias_feitos*limit_km_por_dia < km_feitos
		set @taxa_km = 0.02*@preco_dia*(@taxa_km-@km) -- 2% do valor diario por cada km extra
	else
		set @taxa_km = 0

	set @preco_total = @preco_total + @taxa_km
	insert into @table values (@preco_total);
	return;
end
GO
/****** Object:  Table [dbo].[aluguer]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aluguer](
	[num_aluguer] [int] IDENTITY(1,1) NOT NULL,
	[data_registo] [datetimeoffset](7) NOT NULL,
	[data_fim] [date] NULL,
	[cliente] [int] NOT NULL,
	[alug_balc] [int] NOT NULL,
	[funcionario] [int] NOT NULL,
	[veiculo] [char](17) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[num_aluguer] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[balcao]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[balcao](
	[numero] [int] IDENTITY(1,1) NOT NULL,
	[gerente] [int] NULL,
	[localizacao] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cliente]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cliente](
	[nif] [char](9) NOT NULL,
	[email] [varchar](30) NULL,
	[num_cliente] [int] IDENTITY(1,1) NOT NULL,
	[num_carta] [char](9) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[num_cliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[comp_veic]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[comp_veic](
	[num_compra] [int] NOT NULL,
	[vin] [char](17) NOT NULL,
	[valor_pago] [money] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[num_compra] ASC,
	[vin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[compra]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[compra](
	[num_compra] [int] IDENTITY(1,1) NOT NULL,
	[data] [datetimeoffset](7) NOT NULL,
	[client_vend] [int] NOT NULL,
	[balcao] [int] NOT NULL,
	[funcionario] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[num_compra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[funcionario]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[funcionario](
	[nif] [char](9) NOT NULL,
	[email_empresa] [varchar](30) NOT NULL,
	[num_empregado] [int] IDENTITY(1,1) NOT NULL,
	[num_carta] [char](9) NULL,
	[balcao] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[num_empregado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[funcs_fired]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[funcs_fired](
	[nif] [char](9) NOT NULL,
	[email_empresa] [varchar](30) NOT NULL,
	[num_empregado] [int] NOT NULL,
	[num_carta] [char](9) NULL,
	[balcao] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[num_empregado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log](
	[danos] [varchar](300) NULL,
	[data] [datetimeoffset](7) NOT NULL,
	[taxa] [money] NULL,
	[aluguer] [int] NOT NULL,
	[km_feitos] [int] NOT NULL,
	[drop_off] [int] NOT NULL,
	[funcionario] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[aluguer] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pessoa]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pessoa](
	[nif] [char](9) NOT NULL,
	[nome] [varchar](30) NOT NULL,
	[morada] [varchar](50) NOT NULL,
	[data_nascimento] [date] NOT NULL,
	[phone] [char](9) NULL,
PRIMARY KEY CLUSTERED 
(
	[nif] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pessoas_deleted]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pessoas_deleted](
	[nif] [char](9) NOT NULL,
	[nome] [varchar](30) NOT NULL,
	[morada] [varchar](50) NOT NULL,
	[data_nascimento] [date] NOT NULL,
	[phone] [char](9) NULL,
PRIMARY KEY CLUSTERED 
(
	[nif] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[veiculo]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[veiculo](
	[vin] [char](17) NOT NULL,
	[marca] [varchar](20) NULL,
	[modelo] [varchar](20) NULL,
	[matricula] [char](8) NOT NULL,
	[seguro] [varchar](17) NOT NULL,
	[km] [int] NULL,
	[ano] [smallint] NULL,
	[combustivel] [tinyint] NOT NULL,
	[hp] [smallint] NULL,
	[localizacao] [int] NOT NULL,
	[transmissao] [tinyint] NULL,
	[estado] [tinyint] NULL,
PRIMARY KEY CLUSTERED 
(
	[vin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[veiculo_de_aluguer]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[veiculo_de_aluguer](
	[vin] [char](17) NOT NULL,
	[limit_km_dia] [int] NULL,
	[preco_dia] [smallmoney] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[vin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[veiculo_de_venda]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[veiculo_de_venda](
	[vin] [char](17) NOT NULL,
	[valor_comerc] [money] NULL,
PRIMARY KEY CLUSTERED 
(
	[vin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vend_veic]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vend_veic](
	[num_venda] [int] NOT NULL,
	[veiculo] [char](17) NOT NULL,
	[valor_venda] [money] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[num_venda] ASC,
	[veiculo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[venda]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[venda](
	[num_venda] [int] IDENTITY(1,1) NOT NULL,
	[metodo_pagamento] [tinyint] NULL,
	[data_registo] [datetimeoffset](7) NOT NULL,
	[cliente] [int] NOT NULL,
	[balcao] [int] NOT NULL,
	[funcionario] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[num_venda] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[aluguer] ON 

INSERT [dbo].[aluguer] ([num_aluguer], [data_registo], [data_fim], [cliente], [alug_balc], [funcionario], [veiculo]) VALUES (1, CAST(N'2022-06-23T15:41:40.6942438+01:00' AS DateTimeOffset), CAST(N'2022-06-23' AS Date), 1, 1, 1, N'1HGCP263X8A035447')
SET IDENTITY_INSERT [dbo].[aluguer] OFF
GO
SET IDENTITY_INSERT [dbo].[balcao] ON 

INSERT [dbo].[balcao] ([numero], [gerente], [localizacao]) VALUES (1, 1, N'Rua da Capela,23,Aveiro,Portugal')
INSERT [dbo].[balcao] ([numero], [gerente], [localizacao]) VALUES (2, 2, N'Rua do Vinho,18,Porto,Portugal')
INSERT [dbo].[balcao] ([numero], [gerente], [localizacao]) VALUES (3, NULL, N'Rua dos Anjos,40,Faro,Portugal')
SET IDENTITY_INSERT [dbo].[balcao] OFF
GO
SET IDENTITY_INSERT [dbo].[cliente] ON 

INSERT [dbo].[cliente] ([nif], [email], [num_cliente], [num_carta]) VALUES (N'846445645', N'Zoe.Hinton@gmail.com', 1, N'345890874')
INSERT [dbo].[cliente] ([nif], [email], [num_cliente], [num_carta]) VALUES (N'998475867', N'Garth.Beard@gmail.com', 2, N'896321457')
INSERT [dbo].[cliente] ([nif], [email], [num_cliente], [num_carta]) VALUES (N'100937459', N'Gwendolyn.Kline@gmail.com', 3, N'908754679')
INSERT [dbo].[cliente] ([nif], [email], [num_cliente], [num_carta]) VALUES (N'947494570', N'Brynne.Hardin@gmail.com', 4, N'109624681')
INSERT [dbo].[cliente] ([nif], [email], [num_cliente], [num_carta]) VALUES (N'709658123', N'Amanda.Vance@gmail.com', 5, N'100986908')
INSERT [dbo].[cliente] ([nif], [email], [num_cliente], [num_carta]) VALUES (N'809612568', N'Chava.Wilder@gmail.com', 6, N'567467098')
INSERT [dbo].[cliente] ([nif], [email], [num_cliente], [num_carta]) VALUES (N'103857094', N'Brennan.Holloway@gmail.com', 7, N'780124521')
INSERT [dbo].[cliente] ([nif], [email], [num_cliente], [num_carta]) VALUES (N'300690796', N'Amery.Vargas@gmail.com', 8, N'895446894')
INSERT [dbo].[cliente] ([nif], [email], [num_cliente], [num_carta]) VALUES (N'936893073', N'Kelly.Holcomb@gmail.com', 9, N'780098412')
INSERT [dbo].[cliente] ([nif], [email], [num_cliente], [num_carta]) VALUES (N'906324580', N'Beverly.Green@gmail.com', 10, N'111231442')
INSERT [dbo].[cliente] ([nif], [email], [num_cliente], [num_carta]) VALUES (N'123456789', N'asfs@gmail.com', 11, N'123456789')
SET IDENTITY_INSERT [dbo].[cliente] OFF
GO
INSERT [dbo].[comp_veic] ([num_compra], [vin], [valor_pago]) VALUES (1, N'1218422          ', 65000.0000)
GO
SET IDENTITY_INSERT [dbo].[compra] ON 

INSERT [dbo].[compra] ([num_compra], [data], [client_vend], [balcao], [funcionario]) VALUES (1, CAST(N'2022-06-23T15:42:58.1334590+01:00' AS DateTimeOffset), 1, 2, 1)
SET IDENTITY_INSERT [dbo].[compra] OFF
GO
SET IDENTITY_INSERT [dbo].[funcionario] ON 

INSERT [dbo].[funcionario] ([nif], [email_empresa], [num_empregado], [num_carta], [balcao]) VALUES (N'106349672', N'Harrison.Maddox@r_car.com', 1, N'145676787', 1)
INSERT [dbo].[funcionario] ([nif], [email_empresa], [num_empregado], [num_carta], [balcao]) VALUES (N'184098874', N'Lev.Fletcher@r_car.com', 2, N'156789098', 2)
INSERT [dbo].[funcionario] ([nif], [email_empresa], [num_empregado], [num_carta], [balcao]) VALUES (N'780075478', N'Olivia.Luna@r_car.com', 4, N'909990856', 1)
INSERT [dbo].[funcionario] ([nif], [email_empresa], [num_empregado], [num_carta], [balcao]) VALUES (N'847585764', N'Judah.Dixon@r_car.com', 5, N'120984566', 2)
SET IDENTITY_INSERT [dbo].[funcionario] OFF
GO
INSERT [dbo].[funcs_fired] ([nif], [email_empresa], [num_empregado], [num_carta], [balcao]) VALUES (N'199373983', N'Adena.Carey@r_car.com', 3, N'445678567', 3)
GO
INSERT [dbo].[log] ([danos], [data], [taxa], [aluguer], [km_feitos], [drop_off], [funcionario]) VALUES (N'Nada', CAST(N'2022-06-23T15:41:52.0272133+01:00' AS DateTimeOffset), 0.0000, 1, 9800, 1, 1)
GO
INSERT [dbo].[pessoa] ([nif], [nome], [morada], [data_nascimento], [phone]) VALUES (N'100937459', N'Gwendolyn Kline', N'Rua da Constituição,55;Porto;Portugal', CAST(N'1940-08-22' AS Date), N'912331260')
INSERT [dbo].[pessoa] ([nif], [nome], [morada], [data_nascimento], [phone]) VALUES (N'103857094', N'Brennan Holloway', N'Rua da Madalena,94;Lisboa;Portugal', CAST(N'1952-06-29' AS Date), N'962738311')
INSERT [dbo].[pessoa] ([nif], [nome], [morada], [data_nascimento], [phone]) VALUES (N'106349672', N'Harrison Maddox', N'Rua Dom Diogo De Sousa,9;Braga;Portugal', CAST(N'1965-12-31' AS Date), N'960543278')
INSERT [dbo].[pessoa] ([nif], [nome], [morada], [data_nascimento], [phone]) VALUES (N'123456789', N'Antonio', N'Atras do lago;Lisboa;Portugal', CAST(N'1994-06-23' AS Date), N'915706552')
INSERT [dbo].[pessoa] ([nif], [nome], [morada], [data_nascimento], [phone]) VALUES (N'184098874', N'Lev Fletcher', N'Rua do Souto,102;Braga;Portugal', CAST(N'1980-03-10' AS Date), N'919445346')
INSERT [dbo].[pessoa] ([nif], [nome], [morada], [data_nascimento], [phone]) VALUES (N'199373983', N'Adena Carey', N'Rua de Aveiro,12;Ilhavo;Portugal', CAST(N'1994-11-24' AS Date), N'910973498')
INSERT [dbo].[pessoa] ([nif], [nome], [morada], [data_nascimento], [phone]) VALUES (N'300690796', N'Amery Vargas', N'Rua dos Fanqueiros,30;Lisboa;Portugal', CAST(N'1984-08-16' AS Date), N'918788731')
INSERT [dbo].[pessoa] ([nif], [nome], [morada], [data_nascimento], [phone]) VALUES (N'709658123', N'Amanda Vance', N'Rua Cega,977;Aveiro;Portugal', CAST(N'1985-08-05' AS Date), N'930644789')
INSERT [dbo].[pessoa] ([nif], [nome], [morada], [data_nascimento], [phone]) VALUES (N'780075478', N'Olivia Luna', N'Rua do Comercio,34;Lisboa;Portugal', CAST(N'1969-02-18' AS Date), N'960127549')
INSERT [dbo].[pessoa] ([nif], [nome], [morada], [data_nascimento], [phone]) VALUES (N'809612568', N'Chava Wilder', N'Rua das Flores,10;Porto;Portugal', CAST(N'1963-11-05' AS Date), N'968121209')
INSERT [dbo].[pessoa] ([nif], [nome], [morada], [data_nascimento], [phone]) VALUES (N'846445645', N'Zoe Hinton', N'Rua do Loureiro,2;Porto;Portugal', CAST(N'1931-08-30' AS Date), N'936687887')
INSERT [dbo].[pessoa] ([nif], [nome], [morada], [data_nascimento], [phone]) VALUES (N'847585764', N'Judah Dixon', N'Rua da Capela,23;Aveiro;Portugal', CAST(N'1998-12-01' AS Date), N'919753483')
INSERT [dbo].[pessoa] ([nif], [nome], [morada], [data_nascimento], [phone]) VALUES (N'906324580', N'Beverly Green', N'Avenida dos Banhos,24;Póvoa de Varzim;Portugal', CAST(N'1934-09-30' AS Date), N'962839212')
INSERT [dbo].[pessoa] ([nif], [nome], [morada], [data_nascimento], [phone]) VALUES (N'936893073', N'Kelly Holcomb', N'Rua da Praia;Ilhavo;Portugal', CAST(N'1995-01-10' AS Date), N'910098361')
INSERT [dbo].[pessoa] ([nif], [nome], [morada], [data_nascimento], [phone]) VALUES (N'947494570', N'Brynne Hardin', N'Rua dos Bacalhoeiros,234;Lisboa;Portugal', CAST(N'1933-09-16' AS Date), N'930040601')
INSERT [dbo].[pessoa] ([nif], [nome], [morada], [data_nascimento], [phone]) VALUES (N'998475867', N'Garth Beard', N'Rua Garrett,456;Lisboa;Portugal', CAST(N'2000-06-14' AS Date), N'960904571')
GO
INSERT [dbo].[pessoas_deleted] ([nif], [nome], [morada], [data_nascimento], [phone]) VALUES (N'199373983', N'Adena Carey', N'Rua de Aveiro,12;Ilhavo;Portugal', CAST(N'1994-11-24' AS Date), N'910973498')
GO
INSERT [dbo].[veiculo] ([vin], [marca], [modelo], [matricula], [seguro], [km], [ano], [combustivel], [hp], [localizacao], [transmissao], [estado]) VALUES (N'1218422          ', N'Audi', N'A6', N'AA-66-BB', N'asfas', 0, 2022, 5, 200, 2, 2, 0)
INSERT [dbo].[veiculo] ([vin], [marca], [modelo], [matricula], [seguro], [km], [ano], [combustivel], [hp], [localizacao], [transmissao], [estado]) VALUES (N'1FDWE35SX5HA40825', N'Ford', N'E 350', N'IJ-65-65', N'ASFGH71', 10000, 2005, 2, 202, 2, 2, 0)
INSERT [dbo].[veiculo] ([vin], [marca], [modelo], [matricula], [seguro], [km], [ano], [combustivel], [hp], [localizacao], [transmissao], [estado]) VALUES (N'1FMCU14T6JU400773', N'Ford', N'Bronco II', N'FX-05-95', N'ASFGH68', 1000, 1988, 4, 200, 1, 2, 3)
INSERT [dbo].[veiculo] ([vin], [marca], [modelo], [matricula], [seguro], [km], [ano], [combustivel], [hp], [localizacao], [transmissao], [estado]) VALUES (N'1HGCP263X8A035447', N'Honda', N'Accord', N'AA-01-AA', N'ASFGH67', 10000, 2008, 1, 150, 1, 1, 0)
INSERT [dbo].[veiculo] ([vin], [marca], [modelo], [matricula], [seguro], [km], [ano], [combustivel], [hp], [localizacao], [transmissao], [estado]) VALUES (N'1N4AB41DXWC732852', N'Nissan', N'Sentra', N'FF-56-97', N'ASFGH70', 55000, 1998, 5, 160, 1, 1, 0)
INSERT [dbo].[veiculo] ([vin], [marca], [modelo], [matricula], [seguro], [km], [ano], [combustivel], [hp], [localizacao], [transmissao], [estado]) VALUES (N'2G1WL54T4R9165225', N'Chevrolet', N'Lumina', N'ZZ-33-67', N'ASFGH69', 50000, 1994, 2, 250, 1, 2, 0)
INSERT [dbo].[veiculo] ([vin], [marca], [modelo], [matricula], [seguro], [km], [ano], [combustivel], [hp], [localizacao], [transmissao], [estado]) VALUES (N'JH4KA3260LC000123', N'Acura', N'Legend', N'GH-33-70', N'ASFGH72', 5000, 1990, 1, 400, 2, 1, 1)
GO
INSERT [dbo].[veiculo_de_aluguer] ([vin], [limit_km_dia], [preco_dia]) VALUES (N'1218422          ', 500, 200.0000)
INSERT [dbo].[veiculo_de_aluguer] ([vin], [limit_km_dia], [preco_dia]) VALUES (N'1FDWE35SX5HA40825', NULL, 60.0000)
INSERT [dbo].[veiculo_de_aluguer] ([vin], [limit_km_dia], [preco_dia]) VALUES (N'1HGCP263X8A035447', 500, 20.0000)
INSERT [dbo].[veiculo_de_aluguer] ([vin], [limit_km_dia], [preco_dia]) VALUES (N'1N4AB41DXWC732852', NULL, 52.0000)
INSERT [dbo].[veiculo_de_aluguer] ([vin], [limit_km_dia], [preco_dia]) VALUES (N'2G1WL54T4R9165225', NULL, 40.0000)
GO
INSERT [dbo].[veiculo_de_venda] ([vin], [valor_comerc]) VALUES (N'1218422          ', 70000.0000)
INSERT [dbo].[veiculo_de_venda] ([vin], [valor_comerc]) VALUES (N'1FDWE35SX5HA40825', 20000.0000)
INSERT [dbo].[veiculo_de_venda] ([vin], [valor_comerc]) VALUES (N'1FMCU14T6JU400773', 17000.0000)
INSERT [dbo].[veiculo_de_venda] ([vin], [valor_comerc]) VALUES (N'1HGCP263X8A035447', 15000.0000)
INSERT [dbo].[veiculo_de_venda] ([vin], [valor_comerc]) VALUES (N'1N4AB41DXWC732852', 5000.0000)
INSERT [dbo].[veiculo_de_venda] ([vin], [valor_comerc]) VALUES (N'2G1WL54T4R9165225', 16000.0000)
INSERT [dbo].[veiculo_de_venda] ([vin], [valor_comerc]) VALUES (N'JH4KA3260LC000123', 40000.0000)
GO
INSERT [dbo].[vend_veic] ([num_venda], [veiculo], [valor_venda]) VALUES (1, N'1FMCU14T6JU400773', 19550.0000)
GO
SET IDENTITY_INSERT [dbo].[venda] ON 

INSERT [dbo].[venda] ([num_venda], [metodo_pagamento], [data_registo], [cliente], [balcao], [funcionario]) VALUES (1, 1, CAST(N'2022-06-23T15:42:07.8728701+01:00' AS DateTimeOffset), 1, 1, 1)
SET IDENTITY_INSERT [dbo].[venda] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__balcao__601F3596DC2A6DF6]    Script Date: 23/06/2022 15:49:33 ******/
ALTER TABLE [dbo].[balcao] ADD UNIQUE NONCLUSTERED 
(
	[localizacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__cliente__46F5F71EE4A70C33]    Script Date: 23/06/2022 15:49:33 ******/
ALTER TABLE [dbo].[cliente] ADD UNIQUE NONCLUSTERED 
(
	[num_carta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__funciona__46F5F71EC0781F7E]    Script Date: 23/06/2022 15:49:33 ******/
ALTER TABLE [dbo].[funcionario] ADD UNIQUE NONCLUSTERED 
(
	[num_carta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__funciona__76F78DADED59A2E4]    Script Date: 23/06/2022 15:49:33 ******/
ALTER TABLE [dbo].[funcionario] ADD UNIQUE NONCLUSTERED 
(
	[nif] ASC,
	[num_empregado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UQ__funciona__9605D5FAA2D81174]    Script Date: 23/06/2022 15:49:33 ******/
ALTER TABLE [dbo].[funcionario] ADD UNIQUE NONCLUSTERED 
(
	[num_empregado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__funciona__EFC2C9F73AB93A6E]    Script Date: 23/06/2022 15:49:33 ******/
ALTER TABLE [dbo].[funcionario] ADD UNIQUE NONCLUSTERED 
(
	[email_empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__funcs_fi__46F5F71E8B5280D8]    Script Date: 23/06/2022 15:49:33 ******/
ALTER TABLE [dbo].[funcs_fired] ADD UNIQUE NONCLUSTERED 
(
	[num_carta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__funcs_fi__EFC2C9F7CD35AA99]    Script Date: 23/06/2022 15:49:33 ******/
ALTER TABLE [dbo].[funcs_fired] ADD UNIQUE NONCLUSTERED 
(
	[email_empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__veiculo__DDB00C666E009FAD]    Script Date: 23/06/2022 15:49:33 ******/
ALTER TABLE [dbo].[veiculo] ADD UNIQUE NONCLUSTERED 
(
	[vin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__veiculo___DDB00C660F91DB8A]    Script Date: 23/06/2022 15:49:33 ******/
ALTER TABLE [dbo].[veiculo_de_aluguer] ADD UNIQUE NONCLUSTERED 
(
	[vin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__veiculo___DDB00C667B9F8680]    Script Date: 23/06/2022 15:49:33 ******/
ALTER TABLE [dbo].[veiculo_de_venda] ADD UNIQUE NONCLUSTERED 
(
	[vin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[veiculo] ADD  DEFAULT ((0)) FOR [km]
GO
ALTER TABLE [dbo].[veiculo] ADD  DEFAULT ((1)) FOR [transmissao]
GO
ALTER TABLE [dbo].[veiculo] ADD  DEFAULT ((0)) FOR [estado]
GO
ALTER TABLE [dbo].[veiculo_de_aluguer] ADD  DEFAULT ((1000)) FOR [limit_km_dia]
GO
ALTER TABLE [dbo].[aluguer]  WITH CHECK ADD FOREIGN KEY([alug_balc])
REFERENCES [dbo].[balcao] ([numero])
GO
ALTER TABLE [dbo].[aluguer]  WITH CHECK ADD FOREIGN KEY([cliente])
REFERENCES [dbo].[cliente] ([num_cliente])
GO
ALTER TABLE [dbo].[aluguer]  WITH CHECK ADD FOREIGN KEY([funcionario])
REFERENCES [dbo].[funcionario] ([num_empregado])
GO
ALTER TABLE [dbo].[aluguer]  WITH CHECK ADD FOREIGN KEY([veiculo])
REFERENCES [dbo].[veiculo] ([vin])
GO
ALTER TABLE [dbo].[balcao]  WITH CHECK ADD FOREIGN KEY([gerente])
REFERENCES [dbo].[funcionario] ([num_empregado])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[cliente]  WITH CHECK ADD FOREIGN KEY([nif])
REFERENCES [dbo].[pessoa] ([nif])
GO
ALTER TABLE [dbo].[comp_veic]  WITH CHECK ADD FOREIGN KEY([num_compra])
REFERENCES [dbo].[compra] ([num_compra])
GO
ALTER TABLE [dbo].[comp_veic]  WITH CHECK ADD FOREIGN KEY([vin])
REFERENCES [dbo].[veiculo] ([vin])
GO
ALTER TABLE [dbo].[compra]  WITH CHECK ADD FOREIGN KEY([balcao])
REFERENCES [dbo].[balcao] ([numero])
GO
ALTER TABLE [dbo].[compra]  WITH CHECK ADD FOREIGN KEY([client_vend])
REFERENCES [dbo].[cliente] ([num_cliente])
GO
ALTER TABLE [dbo].[compra]  WITH CHECK ADD FOREIGN KEY([funcionario])
REFERENCES [dbo].[funcionario] ([num_empregado])
GO
ALTER TABLE [dbo].[funcionario]  WITH CHECK ADD FOREIGN KEY([nif])
REFERENCES [dbo].[pessoa] ([nif])
GO
ALTER TABLE [dbo].[funcionario]  WITH CHECK ADD  CONSTRAINT [func_balcao] FOREIGN KEY([balcao])
REFERENCES [dbo].[balcao] ([numero])
GO
ALTER TABLE [dbo].[funcionario] CHECK CONSTRAINT [func_balcao]
GO
ALTER TABLE [dbo].[funcs_fired]  WITH CHECK ADD FOREIGN KEY([nif])
REFERENCES [dbo].[pessoas_deleted] ([nif])
GO
ALTER TABLE [dbo].[log]  WITH CHECK ADD FOREIGN KEY([aluguer])
REFERENCES [dbo].[aluguer] ([num_aluguer])
GO
ALTER TABLE [dbo].[log]  WITH CHECK ADD FOREIGN KEY([drop_off])
REFERENCES [dbo].[balcao] ([numero])
GO
ALTER TABLE [dbo].[log]  WITH CHECK ADD FOREIGN KEY([funcionario])
REFERENCES [dbo].[funcionario] ([num_empregado])
GO
ALTER TABLE [dbo].[veiculo]  WITH CHECK ADD FOREIGN KEY([localizacao])
REFERENCES [dbo].[balcao] ([numero])
GO
ALTER TABLE [dbo].[veiculo_de_aluguer]  WITH CHECK ADD FOREIGN KEY([vin])
REFERENCES [dbo].[veiculo] ([vin])
GO
ALTER TABLE [dbo].[veiculo_de_venda]  WITH CHECK ADD FOREIGN KEY([vin])
REFERENCES [dbo].[veiculo] ([vin])
GO
ALTER TABLE [dbo].[vend_veic]  WITH CHECK ADD FOREIGN KEY([num_venda])
REFERENCES [dbo].[venda] ([num_venda])
GO
ALTER TABLE [dbo].[vend_veic]  WITH CHECK ADD FOREIGN KEY([veiculo])
REFERENCES [dbo].[veiculo] ([vin])
GO
ALTER TABLE [dbo].[venda]  WITH CHECK ADD FOREIGN KEY([balcao])
REFERENCES [dbo].[balcao] ([numero])
GO
ALTER TABLE [dbo].[venda]  WITH CHECK ADD FOREIGN KEY([cliente])
REFERENCES [dbo].[cliente] ([num_cliente])
GO
ALTER TABLE [dbo].[venda]  WITH CHECK ADD FOREIGN KEY([funcionario])
REFERENCES [dbo].[funcionario] ([num_empregado])
GO
/****** Object:  StoredProcedure [dbo].[p_anos]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_anos] @marca varchar(20), @modelo varchar(20), @combs tinyint, @transmissao tinyint
as
begin
	if @marca = ''
		set @marca = null
	if @modelo = ''
		set @modelo = null
	if @combs = ''
		set @combs = null
	if @transmissao = ''
		set @transmissao = null

	select distinct ano
	from veiculo join veiculo_de_aluguer on veiculo_de_aluguer.vin=veiculo.vin
	where estado = 0 and (@marca is null or marca = @marca)
						and (@modelo is null or modelo = @modelo)
						and (@combs is null or combustivel = @combs)
						and (@transmissao is null or transmissao = @transmissao)
end
GO
/****** Object:  StoredProcedure [dbo].[p_anos_venda]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_anos_venda] @marca varchar(20), @modelo varchar(20), @combs tinyint, @transmissao tinyint
as
begin
	if @marca = ''
		set @marca = null
	if @modelo = ''
		set @modelo = null
	if @combs = ''
		set @combs = null
	if @transmissao = ''
		set @transmissao = null

	select distinct ano
	from veiculo join veiculo_de_venda on veiculo_de_venda.vin=veiculo.vin
	where (estado = 0 or estado = 1) and (@marca is null or marca = @marca)
						and (@modelo is null or modelo = @modelo)
						and (@combs is null or combustivel = @combs)
						and (@transmissao is null or transmissao = @transmissao)
end
GO
/****** Object:  StoredProcedure [dbo].[p_balcao]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_balcao]
as
begin
	select *
	from balcao
end
GO
/****** Object:  StoredProcedure [dbo].[p_balcao_veiculo_alug]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_balcao_veiculo_alug]
as
begin
	select balcao.numero as balcao, marca, modelo, count(num_aluguer) as numero_alugueres, avg(Datediff(DAY,data_fim,data_registo)) as avg_dias
	from balcao join aluguer on balcao.numero = aluguer.alug_balc join veiculo on aluguer.veiculo=veiculo.vin
	group by balcao.numero,marca,modelo
end
GO
/****** Object:  StoredProcedure [dbo].[p_combustivel]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[p_combustivel] @modelo varchar(20), @marca varchar(20), @ano smallint, @transmissao tinyint
as
begin
	if @marca = ''
		set @marca = null
	if @ano = ''
		set @ano = null
	if @modelo = ''
		set @modelo = null
	if @transmissao = ''
		set @transmissao = null

	select distinct combustivel
	from veiculo join veiculo_de_aluguer on veiculo_de_aluguer.vin=veiculo.vin
	where estado = 0 and (@marca is null or marca = @marca)
						and (@ano is null or ano = @ano)
						and (@modelo is null or modelo = @modelo)
						and (@transmissao is null or transmissao = @transmissao)
end
GO
/****** Object:  StoredProcedure [dbo].[p_combustivel_venda]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_combustivel_venda] @modelo varchar(20), @marca varchar(20), @ano smallint, @transmissao tinyint
as
begin
	if @marca = ''
		set @marca = null
	if @ano = ''
		set @ano = null
	if @modelo = ''
		set @modelo = null
	if @transmissao = ''
		set @transmissao = null

	select distinct combustivel
	from veiculo join veiculo_de_venda on veiculo_de_venda.vin=veiculo.vin
	where (estado = 0 or estado = 1) and (@marca is null or marca = @marca)
						and (@ano is null or ano = @ano)
						and (@modelo is null or modelo = @modelo)
						and (@transmissao is null or transmissao = @transmissao)
end
GO
/****** Object:  StoredProcedure [dbo].[p_demitir_func]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_demitir_func] @num_empregado as int
as
begin
	if(not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'pessoas_deleted'))
		create table pessoas_deleted(nif char(9) not null primary key, nome varchar(30) not null, morada varchar(50) not null, data_nascimento date	not null, phone	char(9));
	if(not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'funcs_fired'))
		create table funcs_fired(nif char(9) not null foreign key references pessoas_deleted(nif), email_empresa varchar(30) unique not null, num_empregado	int primary key, num_carta char(9) unique, balcao int);

	insert into pessoas_deleted
	select pessoa.nif, nome, morada, data_nascimento, phone
	from pessoa join funcionario on pessoa.nif=funcionario.nif
	where num_empregado=@num_empregado

	insert into funcs_fired
	select nif, email_empresa, @num_empregado, num_carta, balcao
	from funcionario
	where num_empregado=@num_empregado

	delete from funcionario where num_empregado = @num_empregado
	delete from pessoa where pessoa.nif = (select nif from funcionario where num_empregado=@num_empregado)

end
GO
/****** Object:  StoredProcedure [dbo].[p_func_vendas]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- funcionario nas vendas ver numero de vendas e lucro delas, ano e mes tambem 
create proc [dbo].[p_func_vendas] @balcao int
as
begin
	if @balcao = ''
		set @balcao = null

	select YEAR(venda.data_registo) as ano, MONTH(venda.data_registo) as mes,num_empregado, count(venda.num_venda) as num_vendas, (sum(valor_venda) - sum(veiculo_de_venda.valor_comerc) ) as lucro_das_vendas
	from funcionario join venda on venda.funcionario=num_empregado join vend_veic on vend_veic.num_venda=venda.num_venda join veiculo_de_venda on vend_veic.veiculo=veiculo_de_venda.vin
	where (@balcao is null or funcionario.balcao = @balcao)
	group by num_empregado, YEAR(venda.data_registo), MONTH(venda.data_registo)
	order by ano, mes, lucro_das_vendas desc
end
GO
/****** Object:  StoredProcedure [dbo].[p_get_alug]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_get_alug]-- os alugueres ativos ou seja nao tem log
as
begin	
	select num_aluguer, vin
	from aluguer join veiculo on aluguer.veiculo = veiculo.vin
	where num_aluguer not in(select num_aluguer from aluguer join log on num_aluguer = log.aluguer)
	order by aluguer.data_fim asc
end
GO
/****** Object:  StoredProcedure [dbo].[p_get_func]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_get_func] @num_emp as int
as
begin
	select *
	from funcionario join pessoa on funcionario.nif=pessoa.nif
	where @num_emp=num_empregado
end
GO
/****** Object:  StoredProcedure [dbo].[p_get_log]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_get_log] @vin as char(17)
as
begin
	select  num_aluguer, danos
	from log join aluguer on log.aluguer = aluguer.num_aluguer join veiculo on aluguer.veiculo=veiculo.vin
	where veiculo.vin=@vin
end
GO
/****** Object:  StoredProcedure [dbo].[p_get_num_cliente]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_get_num_cliente] @nif as char(9), @carta as char(9), @num_cliente as int
as
begin
	if @nif = ''
		set @nif = null
	if @carta = ''
		set @carta = null
	if @num_cliente = ''
		set @num_cliente = null

	select num_cliente, nome, num_carta, pessoa.nif
	from cliente join pessoa on pessoa.nif=cliente.nif
	where (@nif is null or pessoa.nif = @nif) and
			(@carta is null or num_carta = @carta) and
			(@num_cliente is null or num_cliente = @num_cliente)
end
GO
/****** Object:  StoredProcedure [dbo].[p_get_num_emp]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[p_get_num_emp] @nif as char(9)
as
begin
	select num_empregado
	from funcionario
	where nif=@nif
end
GO
/****** Object:  StoredProcedure [dbo].[p_lucro_cliente]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_lucro_cliente]
as
begin
	
	select num_cliente, sum(taxa) as valor	  
	from (
		select num_cliente, taxa --dinheiro dos alugueres
		from cliente join aluguer on cliente.num_cliente=aluguer.cliente join log on log.aluguer=aluguer.num_aluguer 
		
		union all 
		
		select num_cliente, valor_venda as taxa --passa se o valor da venda como nome da taxa para se poder somar facilmente
		from cliente join venda on num_cliente=venda.cliente join vend_veic on vend_veic.num_venda=venda.num_venda
	) t
	group by num_cliente
	order by valor desc
end
GO
/****** Object:  StoredProcedure [dbo].[p_marcas]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_marcas] @modelo varchar(20), @ano smallint, @combs tinyint, @transmissao tinyint
as
begin
	if @modelo = ''
		set @modelo = null
	if @ano = ''
		set @ano = null
	if @combs = ''
		set @combs = null
	if @transmissao = ''
		set @transmissao = null

	select distinct marca
	from veiculo join veiculo_de_aluguer on veiculo_de_aluguer.vin=veiculo.vin
	where estado = 0 	and (@modelo is null or modelo = @modelo)
						and (@ano is null or ano = @ano)
						and (@combs is null or combustivel = @combs)
						and (@transmissao is null or transmissao = @transmissao)
end
GO
/****** Object:  StoredProcedure [dbo].[p_marcas_Venda]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_marcas_Venda] @modelo varchar(20), @ano smallint, @combs tinyint, @transmissao tinyint
as
begin
	if @modelo = ''
		set @modelo = null
	if @ano = ''
		set @ano = null
	if @combs = ''
		set @combs = null
	if @transmissao = ''
		set @transmissao = null

	select distinct marca
	from veiculo join veiculo_de_venda on veiculo_de_venda.vin=veiculo.vin
	where (estado = 0 or estado = 1) 	and (@modelo is null or modelo = @modelo)
						and (@ano is null or ano = @ano)
						and (@combs is null or combustivel = @combs)
						and (@transmissao is null or transmissao = @transmissao)
end
GO
/****** Object:  StoredProcedure [dbo].[p_modelos]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_modelos] @marca varchar(20), @ano smallint, @combs tinyint, @transmissao tinyint
as
begin
	if @marca = ''
		set @marca = null
	if @ano = ''
		set @ano = null
	if @combs = ''
		set @combs = null
	if @transmissao = ''
		set @transmissao = null

	select distinct modelo
	from veiculo join veiculo_de_aluguer on veiculo_de_aluguer.vin=veiculo.vin
	where estado = 0 and (@marca is null or marca = @marca)
						and (@ano is null or ano = @ano)
						and (@combs is null or combustivel = @combs)
						and (@transmissao is null or transmissao = @transmissao)
end
GO
/****** Object:  StoredProcedure [dbo].[p_modelos_venda]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_modelos_venda] @marca varchar(20), @ano smallint, @combs tinyint, @transmissao tinyint
as
begin
	if @marca = ''
		set @marca = null
	if @ano = ''
		set @ano = null
	if @combs = ''
		set @combs = null
	if @transmissao = ''
		set @transmissao = null

	select distinct modelo
	from veiculo join veiculo_de_venda on veiculo_de_venda.vin=veiculo.vin
	where (estado = 0 or estado = 1) and (@marca is null or marca = @marca)
						and (@ano is null or ano = @ano)
						and (@combs is null or combustivel = @combs)
						and (@transmissao is null or transmissao = @transmissao)
end
GO
/****** Object:  StoredProcedure [dbo].[p_new_cliente]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_new_cliente] @nif as char(9), @nome as varchar(30), @morada as varchar(50), @data_nascimento as date, @phone as char(9),
							@email as varchar(30), @num_carta as char(9)
as
begin
	if not exists(select nif from pessoa where @nif = nif) --ou seja ainda nao esta registada
	begin
		if(exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'pessoas_deleted'))
			delete from pessoas_deleted where pessoas_deleted.nif = @nif
		
		insert into pessoa values
		(@nif, @nome, @morada, @data_nascimento, @phone);
	end
	insert into cliente values
	(@nif,@email,@num_carta);

end
GO
/****** Object:  StoredProcedure [dbo].[p_new_func]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_new_func] @nif as char(9), @nome as varchar(30), @morada as varchar(50), @data_nascimento as date, @phone as char(9),
							@email as varchar(30), @num_carta as char(9), @balcao as int
as
begin
	if not exists(select nif from pessoa where @nif = nif) --ou seja ainda nao esta registada
	begin	
		if(exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'funcs_fired'))
			delete from funcs_fired where funcs_fired.nif = @nif		
		if(exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'pessoas_deleted'))
			delete from pessoas_deleted where pessoas_deleted.nif = @nif
		
		insert into pessoa values
		(@nif, @nome, @morada, @data_nascimento, @phone);
	end
	insert into funcionario values
	(@nif,@email,@num_carta,@balcao);
end
GO
/****** Object:  StoredProcedure [dbo].[p_num_alug_clientes]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--numero de alugueres por cliente
create proc [dbo].[p_num_alug_clientes]
as
begin
	select num_cliente, count(num_aluguer) as num_total_alug
	from cliente join aluguer on cliente.num_cliente=aluguer.cliente
	group by num_cliente
	order by num_total_alug desc
end
GO
/****** Object:  StoredProcedure [dbo].[p_submit_aluguer]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_submit_aluguer] @data_fim as date, @cliente as int, @alug_balc as int, @veiculo as char(17), @funcionario as int
as
begin
	insert aluguer (data_registo, data_fim, cliente, alug_balc, veiculo, funcionario)  values 
			(SYSDATETIMEOFFSET(), @data_fim, @cliente, @alug_balc, @veiculo, @funcionario)
end
GO
/****** Object:  StoredProcedure [dbo].[p_submit_compra]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_submit_compra] @vin char(17), @marca varchar(20), @modelo varchar(20), @matricula char(8),
							@seguro	varchar(17), @km int, @ano char(4), @combustivel tinyint,
							@hp	smallint, @transmissao tinyint, @estado tinyint, -- veiculo

							@limit_km_dia int, @preco_dia int,--veiculo_aluguer
							@valor_comerc int,--veiculo_venda

							@client_vend int, @balcao int, @funcionario	int,
							@valor_pago int -- para o comp_veic
as
begin
	if not exists(select * from veiculo where vin=@vin) -- se nao foi comprado anteriormente
	begin
		insert into veiculo (vin,marca,modelo,matricula,seguro,km,ano,combustivel,hp,localizacao,transmissao,estado)values
							(@vin,@marca,@modelo,@matricula,@seguro,@km,@ano,@combustivel,@hp,@balcao,@transmissao,@estado);
	
		if @estado = 0 --e de aluguer
		begin
			insert into veiculo_de_aluguer (vin,limit_km_dia,preco_dia) values
											(@vin,@limit_km_dia,@preco_dia);
		end
	
		insert into veiculo_de_venda(vin,valor_comerc) values (@vin,@valor_comerc);
	end
	else -- se ja estava na base de dados, muda se o estado e atualizam-se parametros
	begin
		update veiculo
		set seguro=@seguro, km=@km, combustivel=@combustivel, hp=@hp, localizacao = @balcao, estado=@estado
		where vin = @vin

		if @estado = 0
		begin
			if not exists(select * from veiculo_de_aluguer where vin=@vin) --pode se ter tornado agr em veiculo de aluguer
			begin
			insert into veiculo_de_aluguer (vin,limit_km_dia,preco_dia) values (@vin,@limit_km_dia,@preco_dia);
			end
			else
			begin
			update veiculo_de_aluguer
			set limit_km_dia = @limit_km_dia, preco_dia=@preco_dia
			where vin = @vin
			end
		end

		update veiculo_de_venda
		set valor_comerc = @valor_comerc
		where vin=@vin
	end

	declare @data as datetimeoffset
	set @data = SYSDATETIMEOFFSET()
	declare @num_compra as int

	insert into compra (data, client_vend, balcao, funcionario) values
			(@data, @client_vend, @balcao, @funcionario);
	
	select @num_compra = num_compra
	from compra
	where data=@data and client_vend=@client_vend and balcao=@balcao and funcionario = @funcionario
	--nao havia outra forma de ir buscar o numero da compra, mas como se usa o sysdatetimeoffset e capaz de nao dar grande asneira

	insert into comp_veic(num_compra,vin,valor_pago) values (@num_compra,@vin,@valor_pago);

end
GO
/****** Object:  StoredProcedure [dbo].[p_submit_log]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_submit_log] @danos as varchar(300), @num_aluguer as int, @taxa as money, @km_feitos as int, @drop_off as int, @funcionario as int
as
begin
	declare @quil_prev as int;

	select @quil_prev = km --no log metem se os km feitos nesta instancia
	from veiculo join aluguer on veiculo.vin = aluguer.veiculo
	where aluguer.num_aluguer = @num_aluguer

	set @km_feitos = @km_feitos - @quil_prev

	insert log (danos, data, taxa, aluguer, km_feitos, drop_off, funcionario) values
			(@danos,SYSDATETIMEOFFSET(), @taxa, @num_aluguer, @km_feitos, @drop_off, @funcionario)
	
	declare @preco_total as int
	select @preco_total
	from dbo.func_price_to_pay(@num_aluguer)

	update log
	set taxa = 0
	where aluguer=@num_aluguer

	update veiculo
	set estado=0, localizacao = @drop_off
	where vin = (select veiculo from aluguer where aluguer.num_aluguer=@num_aluguer)
end
GO
/****** Object:  StoredProcedure [dbo].[p_submit_venda]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_submit_venda] @vin char(17), 
							@metodo_pagamento tinyint, @cliente int, @balcao int, @funcionario int,
							@valor_venda money
as	
begin
	-- altera se o estado
	update veiculo 
	set estado=3
	where vin=@vin

	--seria possivel apagar mas pode nao se justificar, ja depende da utilizacao
	/*
	delete from veiculo_de_aluguer
	where veiculo_de_aluguer.vin = @vin
	delete from veiculo_de_venda
	where veiculo_de_venda.vin = @vin
	*/
	-- inserir em venda
	declare @data as datetimeoffset
	set @data = SYSDATETIMEOFFSET()
	insert into venda(metodo_pagamento,data_registo,cliente,balcao,funcionario) values
				(@metodo_pagamento, @data, @cliente, @balcao, @funcionario);
	
	-- ir buscar num_venda
	declare @num_venda as int

	select @num_venda = num_venda
	from venda
	where metodo_pagamento=@metodo_pagamento and data_registo=@data and cliente=@cliente and balcao=@balcao and 
							funcionario=@funcionario

	-- inserir em vend_veic
	insert into vend_veic(num_venda,veiculo,valor_venda) values
				(@num_venda, @vin, @valor_venda)
end
GO
/****** Object:  StoredProcedure [dbo].[p_transmissao]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[p_transmissao] @modelo varchar(20), @marca varchar(20), @ano smallint, @combustivel tinyint
as
begin
	if @marca = ''
		set @marca = null
	if @ano = ''
		set @ano = null
	if @modelo = ''
		set @modelo = null
	if @combustivel = ''
		set @combustivel = null

	select distinct transmissao
	from veiculo join veiculo_de_aluguer on veiculo_de_aluguer.vin=veiculo.vin
	where estado = 0 and (@marca is null or marca = @marca)
						and (@ano is null or ano = @ano)
						and (@modelo is null or modelo = @modelo)
						and (@combustivel is null or combustivel = @combustivel)
end
GO
/****** Object:  StoredProcedure [dbo].[p_transmissao_venda]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_transmissao_venda] @modelo varchar(20), @marca varchar(20), @ano smallint, @combustivel tinyint
as
begin
	if @marca = ''
		set @marca = null
	if @ano = ''
		set @ano = null
	if @modelo = ''
		set @modelo = null
	if @combustivel = ''
		set @combustivel = null

	select distinct transmissao
	from veiculo join veiculo_de_venda on veiculo_de_venda.vin=veiculo.vin
	where (estado = 0 or estado = 1) and (@marca is null or marca = @marca)
						and (@ano is null or ano = @ano)
						and (@modelo is null or modelo = @modelo)
						and (@combustivel is null or combustivel = @combustivel)
end
GO
/****** Object:  StoredProcedure [dbo].[p_update_func]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[p_update_func] @nif as char(9), @nome as varchar(30), @morada as varchar(50), @phone as char(9),
							@num_carta as char(9), @balcao as int
as
begin
	update pessoa
	set nome=@nome, morada=@morada, phone=@phone
	where nif=@nif

	update funcionario
	set num_carta = @num_carta, balcao=@balcao
	where nif=@nif
end
GO
/****** Object:  StoredProcedure [dbo].[p_veiculos_aluguer]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_veiculos_aluguer] @marca as varchar(20), @modelo varchar(20), @ano smallint, @combs tinyint, @transmissao tinyint, @localizacao int
as
begin
	if @marca = ''
		set @marca = null
	if @modelo = ''
		set @modelo = null
	if @ano = ''
		set @ano = null
	if @combs = ''
		set @combs = null
	if @transmissao = ''
		set @transmissao = null
	if @localizacao = ''
		set @localizacao = null

	select veiculo.vin, marca, modelo, matricula, km, ano, combustivel, hp, localizacao, transmissao, limit_km_dia, preco_dia
	from veiculo join veiculo_de_aluguer on veiculo_de_aluguer.vin=veiculo.vin 
	where estado = 0 and (@marca is null or marca = @marca)
						and (@modelo is null or modelo = @modelo)
						and (@ano is null or ano = @ano)
						and (@combs is null or combustivel = @combs)
						and (@transmissao is null or transmissao = @transmissao)
						and (@localizacao is null or veiculo.localizacao = @localizacao)
end
GO
/****** Object:  StoredProcedure [dbo].[p_veiculos_venda]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[p_veiculos_venda] @marca as varchar(20), @modelo varchar(20), @ano smallint, @combs tinyint, @transmissao tinyint, @balcao int
as
begin
	if @marca = ''
		set @marca = null
	if @modelo = ''
		set @modelo = null
	if @ano = ''
		set @ano = null
	if @combs = ''
		set @combs = null
	if @transmissao = ''
		set @transmissao = null
	if @balcao = ''
		set @balcao = null

	select veiculo.vin, marca, modelo, matricula, km, ano, combustivel, hp, localizacao, transmissao, valor_comerc --podia ter sido um all
	from veiculo join veiculo_de_venda on veiculo_de_venda.vin=veiculo.vin 
	where (estado = 0 or estado = 1) and (@marca is null or marca = @marca)
						and (@modelo is null or modelo = @modelo)
						and (@ano is null or ano = @ano)
						and (@combs is null or combustivel = @combs)
						and (@transmissao is null or transmissao = @transmissao)
						and (@balcao is null or veiculo.localizacao = @balcao)
end
GO
/****** Object:  Trigger [dbo].[t_aluguer]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create trigger [dbo].[t_aluguer] on [dbo].[aluguer] -- quando se faz aluguer muda se o estado do veiculo
after insert
as
begin

	declare @data_fim as date
	declare @data_registo as date
	select @data_fim=data_fim, @data_registo=data_registo
	from inserted

	if DATEDIFF(DAY,@data_fim, @data_registo)>0
	begin
		raiserror('Data de fim nao pode ser antes de data de registo',16,1);
		rollback tran
	end

	update veiculo
	set estado = 2 --usar convencao do criar_base
	from inserted join veiculo_de_aluguer on inserted.veiculo = veiculo_de_aluguer.vin
					join veiculo on veiculo_de_aluguer.vin = veiculo.vin
end
GO
ALTER TABLE [dbo].[aluguer] ENABLE TRIGGER [t_aluguer]
GO
/****** Object:  Trigger [dbo].[t_funcionario]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create trigger [dbo].[t_funcionario] on [dbo].[funcionario]
after insert, update
as 
begin
	declare @balcao as int
	select @balcao = balcao
	from inserted

	if not (@balcao = null or exists(select numero from funcionario join balcao on funcionario.balcao=balcao.numero))
	begin
		raiserror('Balcao inexistente',16,1)
		rollback tran
	end
end
GO
ALTER TABLE [dbo].[funcionario] ENABLE TRIGGER [t_funcionario]
GO
/****** Object:  Trigger [dbo].[t_log]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create trigger [dbo].[t_log] on [dbo].[log] -- para atualizar o carro, usando o log
after insert 
as
begin
	
	declare @quil_inserted as int;
	declare @vin as char(17);
	declare @quil_prev as int;

	select @quil_prev = km, @vin=veiculo.vin
	from log join aluguer on aluguer=num_aluguer
			join veiculo_de_aluguer on veiculo=vin
			join veiculo on veiculo_de_aluguer.vin=veiculo.vin
			join inserted on inserted.aluguer = num_aluguer

	
	select @quil_inserted = inserted.km_feitos 
	from inserted

	if @quil_inserted < 0
	begin
		raiserror('Quilometros anteriores superiores a agora',16,1);
		rollback tran;
	end
	else
	begin
		update veiculo
		set km = @quil_prev + @quil_inserted, estado=0
		from inserted
		where vin=@vin
	end
end
GO
ALTER TABLE [dbo].[log] ENABLE TRIGGER [t_log]
GO
/****** Object:  Trigger [dbo].[t_idade]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create trigger [dbo].[t_idade] on [dbo].[pessoa] -- para verificar se a pessoa tem 18 anos
after insert, update
as 
begin
	declare @idade as int;

	select @idade = DATEDIFF(YEAR, inserted.data_nascimento, GETDATE())
	from inserted

	if @idade < 18
	begin
		raiserror('Idade menor a 18 anos, nao possivel de registar',16,3);
		rollback tran;
	end
end
GO
ALTER TABLE [dbo].[pessoa] ENABLE TRIGGER [t_idade]
GO
/****** Object:  Trigger [dbo].[t_transmicao_combustivel]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create trigger [dbo].[t_transmicao_combustivel] on [dbo].[veiculo]
after insert
as
begin
	declare @transmissao as tinyint;
	declare @combustivel as tinyint;

	select @transmissao = transmissao, @combustivel = combustivel 
	from inserted 
				  

	if (@transmissao = 1 and @combustivel = 3) or (@transmissao = 1 and @combustivel = 5)
	begin
		raiserror('Transmição passada para automatica. Carros eletricos ou hybrids usam apenas transmição automatica.',15,1);
		update veiculo
		set transmissao = 2
		from inserted join veiculo on inserted.vin = veiculo.vin
	end
end
GO
ALTER TABLE [dbo].[veiculo] ENABLE TRIGGER [t_transmicao_combustivel]
GO
/****** Object:  Trigger [dbo].[t_veiculo_alug]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create trigger [dbo].[t_veiculo_alug] on [dbo].[veiculo_de_aluguer] -- para se verficar que nao se insere um veiculo so de venda no alugue
after insert
as
begin
	declare @estado as tinyint;

	select @estado=estado
	from inserted join veiculo on inserted.vin=veiculo.vin

	if @estado = 1 --usar convencao do criar_base
	begin
		raiserror('Veiculo so para venda',16,1);
		rollback tran;
	end

end
GO
ALTER TABLE [dbo].[veiculo_de_aluguer] ENABLE TRIGGER [t_veiculo_alug]
GO
/****** Object:  Trigger [dbo].[t_venda]    Script Date: 23/06/2022 15:49:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--nao testado 
create trigger [dbo].[t_venda] on [dbo].[venda] -- quando se faz venda muda se o estado do veiculo
after insert
as
begin
	
	update veiculo
	set estado = 3 --usar convencao do criar_base
	from inserted join vend_veic on vend_veic.num_venda=inserted.num_venda
				join veiculo on veiculo=vin
end
GO
ALTER TABLE [dbo].[venda] ENABLE TRIGGER [t_venda]
GO
USE [master]
GO
ALTER DATABASE [Rent_buy_car] SET  READ_WRITE 
GO
