/* Task 1

TOUR(TourName, Descriotion)
PK: TourName

EVENT(TourName, EventYear, EventMonth, EventDay, Fee)
PK: EventYear, EventMonth, EventDay, TourName
FK1: TourName references TOUR

CLIENT(ClientID, Surname, GivenName, Gender)
PK: ClientID

BOOKING(ClientID, TourName, EventYear, EventMonth, EventDay, DateBooked, Payment)
PK: ClientID, TourName, EventYear, EventMonth, EventDay
FK1: ClientID references CLIENT
FK2: TourName, EventYear, EventMonth, EventDay references EVENT
*/

/* Task 2 */

USE master
GO
IF NOT EXISTS (
    SELECT name
        FROM sys.databases
        WHERE name = N'BUILDQUERYDATABASERESIT'
)
CREATE DATABASE BUILDQUERYDATABASERESIT
GO

USE BUILDQUERYDATABASERESIT

IF OBJECT_ID('TOUR') IS NOT NULL
DROP TABLE TOUR;

IF OBJECT_ID('EVENTS') IS NOT NULL
DROP TABLE EVENTS;

IF OBJECT_ID('BOOKING') IS NOT NULL
DROP TABLE BOOKING;

IF OBJECT_ID('CLIENT') IS NOT NULL
DROP TABLE CLIENT;
GO
CREATE TABLE TOUR(
    TOURNAME NVARCHAR(100),
    TDESCRIPTION NVARCHAR(500),
    PRIMARY KEY(TOURNAME)
);

CREATE TABLE EVENTS(
    TOURNAME NVARCHAR(100),
    EVENTMONTH NVARCHAR(3) CHECK (EVENTMONTH IN ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')),
    EVENTDAY INT CHECK (EVENTDAY >=1 AND EVENTDAY <=31),
    EVENTYEAR INT CHECK (LEN([EVENTYEAR]) = 4),
    EVENTFEE MONEY NOT NULL CHECK (EVENTFEE >0),
    PRIMARY KEY(TOURNAME, EVENTYEAR, EVENTMONTH, EVENTDAY),
    FOREIGN KEY(TOURNAME) REFERENCES TOUR 
);
CREATE TABLE CLIENT(
    CLIENTID INT,
    SURNAME NVARCHAR(100) NOT NULL,
    GIVENNAME NVARCHAR(100) NOT NULL,
    GENDER NVARCHAR(1) CHECK (GENDER IN ('M', 'F', 'I')) 
    PRIMARY KEY(CLIENTID)
); 

CREATE TABLE BOOKING(
    CLIENTID INT,
    TOURNAME NVARCHAR(100),
    EVENTMONTH NVARCHAR(3) CHECK (EVENTMONTH IN ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')),
    EVENTDAY INT CHECK (EVENTDAY >=1 AND EVENTDAY <=31),
    EVENTYEAR INT CHECK (LEN([EVENTYEAR]) = 4),
    PAYMENT MONEY CHECK (PAYMENT > 0),
    DATEBOOKED DATE NOT NULL,
    PRIMARY KEY(CLIENTID, TOURNAME, EVENTYEAR, EVENTMONTH, EVENTDAY),
    FOREIGN KEY(CLIENTID) REFERENCES CLIENT,
    FOREIGN KEY(TOURNAME, EVENTYEAR, EVENTMONTH, EVENTDAY) REFERENCES EVENTS
);
GO

SELECT * FROM EVENTS, CLIENT, BOOKING, TOUR

GO
/* TASK 3 */
INSERT INTO TOUR (TOURNAME, TDESCRIPTION) VALUES
('North', 'Tour of wineries and outlets of the Bendigo and Castlemaine region'),
('South', 'Tour of wineries and outlets of Mornington Peninsula'),
('West', 'Tour of wineries and outlets of the Geelong and Otways Region');

INSERT INTO CLIENT (CLIENTID, SURNAME, GIVENNAME, GENDER) VALUES
(1, 'Price', 'Taylor', 'M'),
(2, 'Gamble', 'Ellyse', 'F'),
(3, 'Tan', 'Tilley', 'F'),
(101669460, 'Dinsdale','Dylan', 'M');

INSERT INTO EVENTS (TOURNAME, EVENTMONTH, EVENTDAY, EVENTYEAR, EVENTFEE) VALUES
('North', 'Jan', 9, 2016, 200),
('North', 'Feb', 13, 2016, 225),
('South', 'Jan', 9, 2016, 200),
('South', 'Jan', 16, 2016, 200),
('West', 'Jan', 29, 2016, 225);

INSERT INTO BOOKING (CLIENTID, TOURNAME, EVENTMONTH, EVENTDAY, EVENTYEAR, PAYMENT, DATEBOOKED) VALUES
(1, 'North', 'Jan', 9, 2016, 200, CONVERT(DATETIME, '12/10/2015')),
(2, 'North', 'Jan', 9, 2016, 200, CONVERT(DATETIME, '12/16/2015')),
(1, 'North', 'Feb', 13, 2016, 225, CONVERT(DATETIME, '01/08/2016')),
(2, 'North', 'Feb', 13, 2016, 125, CONVERT(DATETIME, '01/14/2016')),
(3, 'North', 'Feb', 13, 2016, 225, CONVERT(DATETIME, '02/03/2016')),
(1, 'South', 'Jan', 9, 2016, 200, CONVERT(DATETIME, '12/10/2015')),
(2, 'South', 'Jan', 16, 2016, 200, CONVERT(DATETIME, '12/18/2015')),
(3, 'South', 'Jan', 16, 2016, 200, CONVERT(DATETIME, '01/09/2016')),
(2, 'West', 'Jan', 29, 2016, 225, CONVERT(DATETIME, '12/17/2015')),
(3, 'West', 'Jan', 29, 2016, 200, CONVERT(DATETIME, '12/18/2015'));
GO

SELECT * FROM CLIENT

GO
/* TASK 5 */
CREATE VIEW QUERY AS 
    SELECT C.GIVENNAME, C.SURNAME, T.TOURNAME, T.TDESCRIPTION, B.EVENTYEAR, B.EVENTMONTH, B.EVENTDAY, E.EVENTFEE, B.DATEBOOKED, B.PAYMENT
    FROM CLIENT C
    INNER JOIN BOOKING B
    ON C.CLIENTID = B.CLIENTID
    INNER JOIN EVENTS E
    ON E.EVENTYEAR = B.EVENTYEAR
    JOIN TOUR T
    ON T.TOURNAME = E.TOURNAME;

GO

/* TASK 4 */
/* QUERY 1 */
SELECT * FROM QUERY

GO

/* QUERY 2 */

SELECT B.EVENTMONTH, T.TOURNAME, COUNT(B.EVENTMONTH) AS TOTAL
FROM TOUR T
INNER JOIN EVENTS E
ON T.TOURNAME = E.TOURNAME
INNER JOIN BOOKING B
ON B.TOURNAME = E.TOURNAME AND B.EVENTYEAR = E.EVENTYEAR AND B.EVENTMONTH = E.EVENTMONTH AND B.EVENTDAY = E.EVENTDAY
GROUP BY B.EVENTMONTH, T.TOURNAME
ORDER BY B.EVENTMONTH DESC, T.TOURNAME ASC

GO

/* QUERY 3 */

SELECT * FROM BOOKING
WHERE PAYMENT > (SELECT AVG(PAYMENT) FROM BOOKING);

GO

/* QUERY 1 TEST */
SELECT COUNT(*) AS NUMBEROFCOLUMNS FROM information_schema.columns
WHERE table_name ='QUERY'; /* CHECKING TO SEE IF NUIIMBER OF COLUMNS MATCHES THE NUMBER OF COLUMNS EXPECTED */

GO

/*QUERY 2 TEST */
SELECT EVENTMONTH, TOURNAME FROM BOOKING /*CHECK TO SEE IF THE TOTAL LINES UP CORRECTLY */
SELECT COUNT(*) FROM BOOKING /*CHECK TO SEE IF, WHEN ADDING UP THE TOTALS, IT IS EQUAL TO THE NUMBER OF ROWS IN THE BOOKING TABLE */

GO

/*QUERY 3 TEST*/
SELECT AVG(PAYMENT) AS AVERAGE FROM BOOKING /*CHECK THE AVERAGE TO MAKE SURE THE RESULTS LISTED IN THE QUERY 3 TABLE HAVE A PAYMENT LARGER THAN THE AVERAGE */

GO