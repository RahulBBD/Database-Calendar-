USE [cal]
GO
/****** Object:  UserDefinedFunction [dbo].[EVENTRECORDS]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    FUNCTION [dbo].[EVENTRECORDS]
(
	@EVENTID int
)
RETURNS int
AS
BEGIN
	DECLARE @COUNT int

	SELECT @COUNT  = COUNT(*)  FROM EVENTS
	INNER JOIN eventCategory ON EVENTS.EVENTCATIDFK=eventCategory.eventCatIDPK
	GROUP BY EVENTS.EVENTCATIDFK

	RETURN @COUNT
END

GO
/****** Object:  UserDefinedFunction [dbo].[getEventAttendeesCount]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[getEventAttendeesCount](@eventId int) 
RETURNS int
AS 
BEGIN
  DECLARE @attendeesCount int;
  SELECT @attendeesCount = COUNT(*) FROM rsvp WHERE eventIDFK = @eventId AND response = 1;
  RETURN @attendeesCount;
END
GO
/****** Object:  Table [dbo].[user]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user](
	[userIDPK] [int] IDENTITY(1,1) NOT NULL,
	[firstName] [varchar](100) NULL,
	[lastName] [varchar](100) NULL,
	[email] [varchar](100) NOT NULL,
	[password] [varchar](100) NULL,
	[mobile] [varchar](13) NULL,
	[officeAddress] [varchar](255) NULL,
	[addressIDFK] [int] NULL,
	[date] [date] NULL,
	[isActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[userIDPK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[events]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[events](
	[eventIDPK] [int] IDENTITY(1,1) NOT NULL,
	[title] [varchar](255) NULL,
	[description] [varchar](255) NULL,
	[startTime] [datetime] NULL,
	[endTime] [datetime] NULL,
	[Mode] [varchar](255) NULL,
	[url] [varchar](255) NULL,
	[venueIDFK] [int] NOT NULL,
	[userIDFK] [int] NULL,
	[date] [date] NULL,
	[isActive] [bit] NULL,
	[EVENTCATIDFK] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[eventIDPK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[url] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[rsvp]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rsvp](
	[rsvpIDPK] [int] IDENTITY(1,1) NOT NULL,
	[status] [varchar](10) NULL,
	[response] [varchar](255) NULL,
	[comment] [varchar](255) NULL,
	[userIDFK] [int] NULL,
	[eventIDFK] [int] NULL,
	[date] [date] NULL,
	[isActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[rsvpIDPK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[user_event_view]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[user_event_view] AS
SELECT u.firstName, u.lastName, e.title, e.description, e.startTime, e.endTime
FROM [dbo].[user] u
JOIN [dbo].[rsvp] r ON u.userIDPK = r.userIDFK
JOIN [dbo].[events] e ON r.eventIDFK = e.eventIDPK;
GO
/****** Object:  View [dbo].[user_event_view1]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[user_event_view1] AS
SELECT u.firstName, u.lastName, e.title, e.description, e.startTime, e.endTime
FROM [dbo].[user] u
JOIN [dbo].[rsvp] r ON u.userIDPK = r.userIDFK
JOIN [dbo].[events] e ON r.eventIDFK = e.eventIDPK where firstname like 's%';
GO
/****** Object:  Table [dbo].[group]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[group](
	[groupIDPK] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](255) NULL,
	[Description] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[groupIDPK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[userGroupMapping]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[userGroupMapping](
	[mapIDPK] [int] IDENTITY(1,1) NOT NULL,
	[groupIDFK] [int] NULL,
	[userIDFK] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[mapIDPK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[master_view]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[master_view] AS 
SELECT U.FIRSTNAME,U.EMAIL,U.OFFICEADDRESS AS OFFICE ,E.TITLE,E.DESCRIPTION,E.MODE,
R.RESPONSE,E.DATE,GP.NAME AS GROUPNAME FROM [DBO].[USER] AS U 
INNER JOIN EVENTS E ON E.USERIDFK = U.USERIDPK 
INNER JOIN RSVP R ON R.USERIDFK = U.USERIDPK
INNER JOIN USERGROUPMAPPING G ON G.USERIDFK = U.USERIDPK 
INNER JOIN [DBO].[GROUP] GP ON G.GROUPIDFK = GP.GROUPIDPK 
GROUP BY U.FIRSTNAME,U.EMAIL,U.OFFICEADDRESS,E.TITLE,E.DESCRIPTION,E.MODE,
R.RESPONSE,E.DATE,GP.NAME 
GO
/****** Object:  Table [dbo].[eventCategory]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[eventCategory](
	[eventCatIDPK] [int] IDENTITY(1,1) NOT NULL,
	[Category] [varchar](255) NULL,
	[description] [varchar](255) NULL,
	[date] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[eventCatIDPK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[eventVenue]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[eventVenue](
	[venueIDPK] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](255) NULL,
	[Type] [varchar](255) NULL,
	[description] [varchar](255) NULL,
	[capacity] [varchar](255) NULL,
	[availability] [varchar](255) NULL,
	[addressIDFK] [int] NULL,
	[date] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[venueIDPK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[UPCOMING_EVENTS]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[UPCOMING_EVENTS] AS 
SELECT E.TITLE , EC.CATEGORY , EV.NAME , E.DESCRIPTION , E.STARTTIME , E.ENDTIME , E.MODE ,E.DATE FROM EVENTS E 
INNER JOIN EVENTCATEGORY EC ON EC.EVENTCATIDPK = E.EVENTCATIDFK 
INNER JOIN EVENTVENUE EV ON EV.VENUEIDPK = E.VENUEIDFK 
WHERE E.DATE < GETDATE()
GO
/****** Object:  View [dbo].[PAST_EVENTS]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[PAST_EVENTS] AS 
SELECT E.TITLE , EC.CATEGORY , EV.NAME , E.DESCRIPTION , E.STARTTIME , E.ENDTIME , E.MODE ,E.DATE FROM EVENTS E 
INNER JOIN EVENTCATEGORY EC ON EC.EVENTCATIDPK = E.EVENTCATIDFK 
INNER JOIN EVENTVENUE EV ON EV.VENUEIDPK = E.VENUEIDFK 
WHERE E.DATE < GETDATE()
GO
/****** Object:  UserDefinedFunction [dbo].[LISTAVAILABLE_PERSON]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[LISTAVAILABLE_PERSON](@USERNAME VARCHAR(50))
RETURNS TABLE
AS RETURN (
  SELECT  rsvpIDPK,RSVP.STATUS,RESPONSE,comment,U.firstName,E.TITLE FROM RSVP INNER JOIN EVENTS E ON E.eventIDPK=RSVP.EVENTIDFK
  INNER JOIN [DBO].[USER] U ON
  U.userIDPK=RSVP.userIDFK
  WHERE U.firstName=@USERNAME
  AND STATUS='AVALAIBLE'
  

  GROUP BY rsvpIDPK,RSVP.STATUS,RESPONSE,comment,U.FIRSTNAME,E.TITLE)
GO
/****** Object:  UserDefinedFunction [dbo].[LISTAVAILAIBLE_PERSON]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[LISTAVAILAIBLE_PERSON](@USERNAME VARCHAR(50))
RETURNS TABLE
AS RETURN (
  SELECT  rsvpIDPK,RSVP.STATUS,RESPONSE,comment,RSVP.USERIDFK FROM RSVP INNER JOIN [DBO].[USER] U ON
  U.userIDPK=RSVP.userIDFK
  WHERE U.firstName=@USERNAME
  AND STATUS='AVAILAIBLE'
  GROUP BY rsvpIDPK,RSVP.STATUS,RESPONSE,comment,RSVP.USERIDFK)
GO
/****** Object:  Table [dbo].[city]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[city](
	[cityIDPK] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](255) NULL,
	[stateIDFK] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[cityIDPK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[country]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[country](
	[countryIDPK] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[countryIDPK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[eventInvite]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[eventInvite](
	[reminderIDPK] [int] IDENTITY(1,1) NOT NULL,
	[userIDFK] [int] NULL,
	[eventIDFK] [int] NULL,
	[isRead] [bit] NULL,
	[content] [varchar](255) NULL,
	[date] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[reminderIDPK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[region]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[region](
	[stateIDPK] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](255) NULL,
	[countryIDFK] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[stateIDPK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[userAddress]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[userAddress](
	[addressIDPK] [int] IDENTITY(1,1) NOT NULL,
	[addressline1] [nvarchar](255) NULL,
	[addressline2] [nvarchar](255) NULL,
	[cityIDFK] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[addressIDPK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[city]  WITH CHECK ADD FOREIGN KEY([stateIDFK])
REFERENCES [dbo].[region] ([stateIDPK])
GO
ALTER TABLE [dbo].[eventInvite]  WITH CHECK ADD FOREIGN KEY([eventIDFK])
REFERENCES [dbo].[events] ([eventIDPK])
GO
ALTER TABLE [dbo].[eventInvite]  WITH CHECK ADD FOREIGN KEY([userIDFK])
REFERENCES [dbo].[user] ([userIDPK])
GO
ALTER TABLE [dbo].[events]  WITH CHECK ADD FOREIGN KEY([EVENTCATIDFK])
REFERENCES [dbo].[eventCategory] ([eventCatIDPK])
GO
ALTER TABLE [dbo].[events]  WITH CHECK ADD FOREIGN KEY([userIDFK])
REFERENCES [dbo].[user] ([userIDPK])
GO
ALTER TABLE [dbo].[eventVenue]  WITH CHECK ADD FOREIGN KEY([addressIDFK])
REFERENCES [dbo].[userAddress] ([addressIDPK])
GO
ALTER TABLE [dbo].[region]  WITH CHECK ADD FOREIGN KEY([countryIDFK])
REFERENCES [dbo].[country] ([countryIDPK])
GO
ALTER TABLE [dbo].[rsvp]  WITH CHECK ADD FOREIGN KEY([eventIDFK])
REFERENCES [dbo].[events] ([eventIDPK])
GO
ALTER TABLE [dbo].[rsvp]  WITH CHECK ADD FOREIGN KEY([userIDFK])
REFERENCES [dbo].[user] ([userIDPK])
GO
ALTER TABLE [dbo].[user]  WITH CHECK ADD FOREIGN KEY([addressIDFK])
REFERENCES [dbo].[userAddress] ([addressIDPK])
GO
ALTER TABLE [dbo].[userAddress]  WITH CHECK ADD FOREIGN KEY([cityIDFK])
REFERENCES [dbo].[city] ([cityIDPK])
GO
ALTER TABLE [dbo].[userGroupMapping]  WITH CHECK ADD FOREIGN KEY([groupIDFK])
REFERENCES [dbo].[group] ([groupIDPK])
GO
ALTER TABLE [dbo].[userGroupMapping]  WITH CHECK ADD FOREIGN KEY([userIDFK])
REFERENCES [dbo].[user] ([userIDPK])
GO
/****** Object:  StoredProcedure [dbo].[COUNTRESPONSE]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[COUNTRESPONSE] (@TITLE VARCHAR(50))
AS
BEGIN
SELECT  E.TITLE,COUNT(*) AS COUNT FROM RSVP R 
INNER JOIN EVENTS E ON E.EVENTIDPK=R.EVENTIDFK
INNER JOIN [DBO].[USER] U ON R.USERIDFK=U.USERIDPK
WHERE R.RESPONSE='YES' AND E.TITLE=@TITLE
GROUP BY E.TITLE
END
GO
/****** Object:  StoredProcedure [dbo].[FINDRESPONSE]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[FINDRESPONSE] (@MODE VARCHAR(10)) AS
SELECT RSVP.RSVPIDPK , RSVP.RESPONSE , RSVP.DATE ,[DBO].[USER].FIRSTNAME , [DBO].[USER].MOBILE , EVENTS.TITLE , EVENTS.DESCRIPTION
FROM RSVP 
JOIN [DBO].[USER]
ON [DBO].[USER].USERIDPK = RSVP.USERIDFK
JOIN EVENTS 
ON EVENTS.EVENTIDPK = RSVP.EVENTIDFK WHERE MODE = @MODE
GO
/****** Object:  StoredProcedure [dbo].[LISTEVENTBYDATE]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[LISTEVENTBYDATE] (@MONTH DATE)
AS
BEGIN
 SELECT U.FIRSTNAME , U.LASTNAME , V.NAME , V.AVAILABILITY, E.TITLE ,E.MODE,E.DESCRIPTION,E.STARTTIME,E.ENDTIME  FROM EVENTS E
 INNER JOIN [DBO].[USER] U ON E.USERIDFK = U.USERIDPK
 INNER JOIN EVENTVENUE V ON V.VENUEIDPK = E.VENUEIDFK 
 WHERE E.DATE <= @MONTH
END
GO
/****** Object:  StoredProcedure [dbo].[SEARCHWITHMONTH]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SEARCHWITHMONTH] (@MONTH BIGINT)
AS
BEGIN
 SELECT U.FIRSTNAME , U.LASTNAME , V.NAME , V.AVAILABILITY, E.TITLE ,E.MODE,E.DESCRIPTION,E.STARTTIME,E.ENDTIME  FROM EVENTS E
 INNER JOIN [DBO].[USER] U ON E.USERIDFK = U.USERIDPK
 INNER JOIN EVENTVENUE V ON V.VENUEIDPK = E.VENUEIDFK 
 WHERE MONTH(E.DATE) = @MONTH
END
GO
/****** Object:  StoredProcedure [dbo].[USERINSERT]    Script Date: 23-02-2023 14:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[USERINSERT]
    @USERID INT = NULL,
    @FIRSTNAME VARCHAR(100) = NULL,
    @LASTNAME VARCHAR(100) = NULL,
    @EMAIL VARCHAR(100) = NULL,
    @PASSWORD VARCHAR(100) = NULL,
    @MOBILE VARCHAR(13) = NULL,
    @OFFICEADDRESS VARCHAR(255) = NULL,
    @ADDRESSIDFK INT = NULL,
    @DATE DATE = NULL,
    @ISACTIVE BIT = NULL,
    @OPERATIONTYPE VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @OPERATIONTYPE = 'INSERT'
        INSERT INTO [USER] (FIRSTNAME, LASTNAME, EMAIL, PASSWORD, MOBILE, OFFICEADDRESS, ADDRESSIDFK, DATE, ISACTIVE)
        VALUES (@FIRSTNAME, @LASTNAME, @EMAIL, @PASSWORD, @MOBILE, @OFFICEADDRESS, @ADDRESSIDFK, @DATE, @ISACTIVE)
    ELSE IF @OPERATIONTYPE = 'UPDATE'
        UPDATE [USER]
        SET FIRSTNAME = ISNULL(@FIRSTNAME, FIRSTNAME), LASTNAME = ISNULL(@LASTNAME, LASTNAME), 
        EMAIL = ISNULL(@EMAIL, EMAIL), PASSWORD = ISNULL(@PASSWORD, PASSWORD), 
        MOBILE = ISNULL(@MOBILE, MOBILE), OFFICEADDRESS = ISNULL(@OFFICEADDRESS, OFFICEADDRESS), 
        ADDRESSIDFK = ISNULL(@ADDRESSIDFK, ADDRESSIDFK), DATE = ISNULL(@DATE, DATE), 
        ISACTIVE = ISNULL(@ISACTIVE, ISACTIVE)
        WHERE USERIDPK = @USERID
    ELSE IF @OPERATIONTYPE = 'DELETE'
        DELETE FROM [DBO].[USER] WHERE USERIDPK = @USERID
END
GO
