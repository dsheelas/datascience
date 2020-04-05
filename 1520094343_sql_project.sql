/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT name
FROM `Facilities`
WHERE membercost =0
LIMIT 0 , 30


/* Q2: How many facilities do not charge a fee to members? */

    SELECT count (*)
    FROM `Facilities`
    WHERE membercost = 0
    LIMIT 0 , 30


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

    SELECT `facid` , `name` , `membercost` , `monthlymaintenance`
    FROM `Facilities`
    WHERE membercost < (0.2 * monthlymaintenance)
    LIMIT 0 , 30

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

    SELECT * FROM `Facilities` WHERE facid in (1,5)


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

    SELECT  `name`,
            `monthlymaintenance`,
            (case 
             when monthlymaintenance <= 100 then
                'cheap'
             when monthlymaintenance > 100 then
                'expensive'
             end)  
    FROM `Facilities`
    ORDER BY (case 
              when monthlymaintenance <= 100 then
                'cheap'
              when monthlymaintenance > 100 then
                'expensive'
              end) ASC

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

    SELECT   `firstname` AS firstname,
             `surname` AS lastname,
             `joindate` as joindate

    FROM Members
    WHERE joindate =
                    (SELECT max(m.joindate)
                     FROM Members m
                     ORDER BY 1)


/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

    SELECT distinct f.name AS court_name, 
                    concat( m.firstname, " ", m.surname ) AS member_name
    FROM Bookings b, Members m, Facilities f
    WHERE b.memid = m.memid
    AND b.facid = f.facid
    AND m.memid <> 0

    ORDER BY concat(m.firstname, " ", m.surname)
    LIMIT 0 , 30;

    OR USING INNER JOIN Keyword 

    SELECT distinct f.name AS court_name, 
                    concat( m.firstname, " ", m.surname ) AS member_name
    FROM Bookings b
        INNER JOIN Members m
    ON b.memid = m.memid
        INNER JOIN Facilities f
    ON b.facid = f.facid
    AND m.memid <> 0
    ORDER BY concat(m.firstname, " ", m.surname)
    LIMIT 0 , 2000;


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

    SELECT distinct f.name AS court_name, 
        concat( m.firstname, " ", m.surname ) AS member_name,
        (CASE 
         WHEN m.memid <> 0 THEN
            f.membercost * 48
         WHEN m.memid = 0 THEN
            f.guestcost * 48
         END) AS cost

    FROM Bookings b 
        INNER JOIN Members m
    ON b.memid = m.memid
        INNER JOIN Facilities f
    ON b.facid = f.facid

    AND (b.starttime >= DATE("2012-09-14") AND
         b.starttime < DATE("2012-09-15"))
    AND (CASE 
    WHEN m.memid <> 0 THEN
    (f.membercost * 48) > 30
    WHEN m.memid = 0 THEN
    (f.guestcost * 48) > 30
    END)

    ORDER BY f.membercost desc

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

    Select f.name AS court_name, 
           Inner_Table.member_name,
           (CASE 
            WHEN Inner_Table.memid <> 0 THEN
                f.membercost * 48
            WHEN Inner_Table.memid = 0 THEN
                f.guestcost * 48
            END) AS cost

    FROM Facilities f INNER JOIN
        (SELECT distinct concat( m.firstname, " ", m.surname ) AS member_name,
                    m.memid AS memid,
                    b.facid AS facid
             FROM Bookings b 
                INNER JOIN Members m
             ON b.memid = m.memid 
             AND (b.starttime >= DATE("2012-09-14") AND
                    b.starttime < DATE("2012-09-15")))Inner_Table

    ON f.facid = Inner_Table.facid
    AND (CASE 
         WHEN Inner_Table.memid <> 0 THEN
            (f.membercost * 48) > 30
         WHEN Inner_Table.memid = 0 THEN
            (f.guestcost * 48) > 30
         END)

    ORDER BY f.membercost desc

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */ not complete

    select Inner_3.facid,
           Inner_3.name,
           Inner_3.membercost,
           Inner_3.guestcost
    FROM (Select Inner_2.facid as facid,
                 Inner_2.name as name,
                 Inner_2.membercost as membercost, 
                 NULL AS guestcost
        FROM(Select f.facid as facid, 
            f.name as name,
            sum(f.membercost) as membercost
        FROM Facilities f INNER JOIN
            (SELECT b.memid,
                    b.facid
             FROM Bookings b 
                 INNER JOIN Members m
             ON b.memid = m.memid
             WHERE b.memid <> 0)Inner_table
        ON f.facid = Inner_table.facid
        GROUP BY f.facid, f.name)Inner_2
    WHERE Inner_2.membercost < 1000

    UNION

    Select Inner_2.facid as facid, Inner_2.name as name, NULL AS membercost, Inner_2.guestcost as guestcost
        FROM(Select f.facid as facid, 
            f.name as name,
            sum(f.guestcost) as guestcost
        FROM Facilities f INNER JOIN
            (SELECT b.memid,
                    b.facid
             FROM Bookings b 
                 INNER JOIN Members m
             ON b.memid = m.memid
             WHERE b.memid = 0)Inner_table
        ON f.facid = Inner_table.facid
        GROUP BY f.facid, f.name)Inner_2
    WHERE Inner_2.guestcost < 1000)Inner_3 ORDER BY Inner_3.membercost DESC,
           Inner_3.guestcost
