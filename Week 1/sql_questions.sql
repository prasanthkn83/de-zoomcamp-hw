/* Question 3: Count records *
How many taxi trips were there on January 15? */
select tpep_pickup_datetime::DATE as pickup_date, 
count(*) as trip_counts
from yellow_taxi_trips
where tpep_pickup_datetime::DATE = '2021-01-15'
group by
tpep_pickup_datetime::DATE;  
/*53024*/

/* Question 4: Largest tip for each day *
On which day it was the largest tip in January? (note: it's not a typo, it's "tip", not "trip") */
with tip_date as
(select 
 tpep_pickup_datetime::DATE as trip_date, 
 max(tip_amount) as tip_amount
from yellow_taxi_trips
group by
tpep_pickup_datetime::DATE)
select 
trip_date,
tip_amount
from tip_date
order by tip_amount desc
limit 1;  
/*2021-01-20 1140.44*/


/*Question 5: Most popular destination *
What was the most popular destination for passengers picked up in central park on January 14? Enter the zone name (not id). If the zone name is unknown (missing), write "Unknown"*/
with pickup_dropoff as
(select
dropoff."Zone" as dropoff_zone,
count(*) as trip_count
from
yellow_taxi_trips as trips
inner join taxi_zone_lookup as pickup on pickup."LocationID" = trips."PULocationID"
left join taxi_zone_lookup as dropoff on dropoff."LocationID" = trips."DOLocationID"
where pickup."Zone" = 'Central Park'
 and tpep_pickup_datetime::DATE = '2021-01-14'
group by
dropoff."Zone")
select
dropoff_zone,
trip_count
from 
pickup_dropoff
order by trip_count desc
limit 1;
/*"Upper East Side South"	97*/

/*Question 6: Most expensive route *
What's the pickup-dropoff pair with the largest average price for a ride (calculated based on total_amount)? Enter two zone names separated by a slashFor example:"Jamaica Bay / Clinton East"If any of the zone names are unknown (missing), write "Unknown". For example, "Unknown / Clinton East".*/
with trip_avg as
(select
yellow_taxi_trips."PULocationID" as pu_id,
yellow_taxi_trips."DOLocationID" as do_id,
avg(yellow_taxi_trips."total_amount") as avg_trip_amount
from
yellow_taxi_trips
group by
yellow_taxi_trips."PULocationID",
yellow_taxi_trips."DOLocationID")
select
coalesce(pickup."Zone",'Unknown')||' / '||coalesce(dropoff."Zone",'Unknown') as pickup_to_dropoff,
avg_trip_amount
from trip_avg 
left join taxi_zone_lookup as pickup on pickup."LocationID" = pu_id
left join taxi_zone_lookup as dropoff on dropoff."LocationID" = do_id
order by
avg_trip_amount desc
limit 1;
/*"Alphabet City / Unknown"	2292.4*/


