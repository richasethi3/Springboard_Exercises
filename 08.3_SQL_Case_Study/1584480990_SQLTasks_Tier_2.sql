/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT `name` as facility_name
FROM Facilities
WHERE `membercost`>0;

/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT(DISTINCT `name`) as num_fac
FROM Facilities
WHERE `membercost`=0;

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT `facid` AS ID , `name` AS facility, `membercost` AS mem_cost, `monthlymaintenance` AS monthly_maintenance
FROM Facilities
WHERE `membercost`>0
AND `membercost`<(0.2 * `monthlymaintenance`);

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT *
FROM Facilities
WHERE `facid`
IN (1, 5);

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT `name` AS facility, `monthlymaintenance` ,
CASE WHEN `monthlymaintenance` <100
THEN 'CHEAP'
WHEN `monthlymaintenance` >100
THEN 'EXPENSIVE'
END AS class
FROM Facilities;

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT `joindate` , `firstname` , `surname`
FROM Members
WHERE `joindate` = (
SELECT MAX( `joindate` )
FROM Members );

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT f.name as facility, CONCAT(m.firstname, ' ',  m.surname) as member, m.memid as id
FROM Members AS m
INNER JOIN Bookings AS b ON m.memid = b.memid
INNER JOIN Facilities AS f ON b.facid = f.facid
WHERE f.facid
IN ( 0, 1 )
AND m.surname != 'GUEST'
GROUP BY id
ORDER BY member;


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT f.name as facility, CONCAT(m.firstname, ' ',  m.surname) as member, b.starttime,
CASE WHEN m.firstname = 'Guest' THEN f.guestcost * b.slots
ELSE f.membercost * b.slots END AS cost
FROM Members AS m
INNER JOIN Bookings AS b ON m.memid = b.memid
INNER JOIN Facilities AS f ON b.facid = f.facid
WHERE DATE( b.starttime ) = '2012-09-14'
AND CASE WHEN m.firstname = 'GUEST' THEN f.guestcost * b.slots ELSE f.membercost * b.slots END > 30
ORDER BY cost DESC;

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT *
FROM (
SELECT name as facility, CONCAT( firstname, ' ', surname ) AS member,
CASE WHEN firstname = 'Guest'
THEN guestcost * slots
ELSE membercost * slots
END AS cost, starttime
FROM Bookings
INNER JOIN Members
USING ( memid )
INNER JOIN Facilities
USING ( facid )
WHERE DATE( starttime ) = '2012-09-14'
) AS subquery
WHERE cost >30
ORDER By cost DESC

/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.  

QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */


/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */


/* Q12: Find the facilities with their usage by member, but not guests */


/* Q13: Find the facilities usage by month, but not guests */

