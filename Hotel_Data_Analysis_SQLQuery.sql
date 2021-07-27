
WITH hotels as (
SELECT *
FROM Hotel_Analysis.dbo.['details_2018']
UNION
SELECT *
FROM Hotel_Analysis.dbo.['details_2019']
UNION
SELECT *
FROM Hotel_Analysis.dbo.['details_2020'])

SELECT arrival_date_year, hotel,
ROUND (SUM ((stays_in_week_nights + stays_in_weekend_nights) * adr),2) AS revenue
FROM hotels
GROUP BY arrival_date_year, hotel

SELECT *
FROM Hotel_Analysis.dbo.market_segment


WITH hotels as (
SELECT *
FROM Hotel_Analysis.dbo.['details_2018']
UNION
SELECT *
FROM Hotel_Analysis.dbo.['details_2019']
UNION
SELECT *
FROM Hotel_Analysis.dbo.['details_2020'])

SELECT * 
FROM hotels
LEFT JOIN Hotel_Analysis.dbo.market_segment
ON hotels.market_segment = Hotel_Analysis.dbo.market_segment.market_segment
LEFT JOIN Hotel_Analysis.dbo.meal_cost
ON meal_cost.meal = hotels.meal