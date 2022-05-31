/*
Electricity Costs Data Exploration
Skills used: Joins, CTE's, Aggregate Functions, Creating Views
*/


-- Complete Data that we are going to be working with.

SELECT e.*, a.*, an.*
  FROM electricity_costs_table e
  JOIN building_table b
    ON b.building_name = e.building_name
  JOIN adress_table a
    ON a.adress = b.adress
  JOIN area_name_table an
    ON an.area_name = b.area_name
 ORDER BY date;

-- Which building had the highest total electricity cost?

  SELECT building_name, sum(electricity_costs_usd) as total_electricity_cost
    FROM electricity_costs_table
GROUP BY building_name
ORDER BY total_electricity_cost DESC
   LIMIT 1;

-- Which building had the lowest total electricity cost?

  SELECT building_name, sum(electricity_costs_usd) as total_electricity_cost
    FROM electricity_costs_table
GROUP BY building_name
ORDER BY total_electricity_cost
   LIMIT 1;
   
-- How many buildings are there in total?

  SELECT count(b.building_name) as total_number_of_buildings
    FROM building_table b;

-- How many buildings are there per borough?

  SELECT a.borough, count(b.building_name) as number_of_buildings
    FROM building_table b
    JOIN area_name_table a
      ON a.area_name = b.area_name
GROUP BY a.borough;

-- What is the percent distribution with buildings per borough?

  SELECT a.borough, count(b.building_name) as number_of_buildings, round(CAST(count(b.building_name) as REAL)/36, 4)*100 as percent
    FROM building_table b
    JOIN area_name_table a
      ON a.area_name = b.area_name
GROUP BY a.borough;

-- Listing all the borough's average monthly electricity bill, from biggest to smallest.

  SELECT round(avg(electricity_costs_usd), 2) as average_monthly_electricity_bill, a.borough as borough
    FROM electricity_costs_table e
    JOIN building_table b
      ON b.building_name = e.building_name
    JOIN area_name_table a
      ON a.area_name = b.area_name
GROUP BY a.borough
ORDER BY average_monthly_electricity_bill DESC;

-- Listing all the different months total average monthly electricity bill, from biggest to smallest.

  SELECT 
	     CASE
		     WHEN strftime("%m", date) == '01' THEN 'january'
		     WHEN strftime("%m", date) == '02' THEN 'february'
		     WHEN strftime("%m", date) == '03' THEN 'march'
		     WHEN strftime("%m", date) == '04' THEN 'april'
		     WHEN strftime("%m", date) == '05' THEN 'may'
		     WHEN strftime("%m", date) == '06' THEN 'june'
		     WHEN strftime("%m", date) == '07' THEN 'july'
		     WHEN strftime("%m", date) == '08' THEN 'august'
		     WHEN strftime("%m", date) == '09' THEN 'september'
             WHEN strftime("%m", date) == '10' THEN 'october'
		     WHEN strftime("%m", date) == '11' THEN 'november'
		     WHEN strftime("%m", date) == '12' THEN 'december'
	     END as month, 
	     round(avg(electricity_costs_usd), 1) as average_monthly_electricity_bill
    FROM electricity_costs_table 
GROUP BY strftime("%m", date)
ORDER BY average_monthly_electricity_bill DESC;

-- monthly electricity cost vs average monthly cost for the building George Washington High School.

  SELECT strftime("%Y-%m", date) as year_month, electricity_costs_usd, AVG(electricity_costs_usd) OVER (PARTITION BY strftime("%m", date)) as average_monthly_cost
    FROM electricity_costs_table
   WHERE building_name == 'George Washington High School'
ORDER BY date;

-- What is the most expensive month for each of the different boroughs in average?

WITH tmp AS(
  SELECT a.borough as borough,
	     CASE
		     WHEN strftime("%m", date) == '01' THEN 'january'
		     WHEN strftime("%m", date) == '02' THEN 'february'
		     WHEN strftime("%m", date) == '03' THEN 'march'
		     WHEN strftime("%m", date) == '04' THEN 'april'
		     WHEN strftime("%m", date) == '05' THEN 'may'
		     WHEN strftime("%m", date) == '06' THEN 'june'
		     WHEN strftime("%m", date) == '07' THEN 'july'
		     WHEN strftime("%m", date) == '08' THEN 'august'
		     WHEN strftime("%m", date) == '09' THEN 'september'
             WHEN strftime("%m", date) == '10' THEN 'october'
		     WHEN strftime("%m", date) == '11' THEN 'november'
		     WHEN strftime("%m", date) == '12' THEN 'december'
	     END as month, 
	     round(avg(electricity_costs_usd), 1) as average_monthly_electricity_bill
    FROM electricity_costs_table e
    JOIN building_table b
      ON b.building_name = e.building_name
    JOIN area_name_table a
      ON a.area_name = b.area_name
GROUP BY strftime("%m", date), a.borough
ORDER BY average_monthly_electricity_bill DESC)

  SELECT borough, month, max(average_monthly_electricity_bill) as most_expensive_month_bill
    FROM tmp
GROUP BY borough;

-- What is the average yearly energy bill (between 2009 and 2011), adress, postcode, latitude, longitude, area name and borough for all the buildings?

WITH tmp AS(
	SELECT e.building_name, strftime("%Y", date) as year, sum(electricity_costs_usd) as yearly_cost, a.adress, a.postcode, a.latitude, a.longitude, an.area_name, an.borough
	FROM electricity_costs_table e
	JOIN building_table b
	  ON b.building_name = e.building_name
	JOIN adress_table a
	  ON a.adress = b.adress
	JOIN area_name_table an
	  ON an.area_name = b.area_name
	GROUP BY e.building_name, strftime("%Y", date)
	HAVING strftime("%Y", date) IN('2009', '2010', '2011'))
	
SELECT t.building_name, round(avg(t.yearly_cost), 2) as average_yearly_energy_bill, t.adress, t.postcode, t.latitude, t.longitude, t.area_name, t.borough
FROM tmp t
GROUP BY building_name
ORDER BY average_yearly_energy_bill DESC;

/* Saving it as a view */

CREATE VIEW average_yearly_energy_bill_per_building AS
WITH tmp AS(
	SELECT e.building_name, strftime("%Y", date) as year, sum(electricity_costs_usd) as yearly_cost, a.adress, a.postcode, a.latitude, a.longitude, an.area_name, an.borough
	FROM electricity_costs_table e
	JOIN building_table b
	  ON b.building_name = e.building_name
	JOIN adress_table a
	  ON a.adress = b.adress
	JOIN area_name_table an
	  ON an.area_name = b.area_name
	GROUP BY e.building_name, strftime("%Y", date)
	HAVING strftime("%Y", date) IN('2009', '2010', '2011'))
	
SELECT t.building_name, round(avg(t.yearly_cost), 2) as average_yearly_energy_bill, t.adress, t.postcode, t.latitude, t.longitude, t.area_name, t.borough
FROM tmp t
GROUP BY building_name
ORDER BY average_yearly_energy_bill DESC;











