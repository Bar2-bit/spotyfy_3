---advance sql project--- spotify datase
---create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
select* from spotify;
-----EDA
select count(*) from spotify;
select count(distinct album)from spotify;
select distinct album_type from spotify;
select  max (duration_min) from spotify;
select  min (duration_min) from spotify;

select* from spotify
where duration_min=0;

delete from spotify
where duration_min=0;

select* from spotify
where duration_min=0;

select distinct channel from spotify;
----------------------------------------------
--------data analysis-easy category
----------------------------------------
----q1 Retrieve  the names of all tracks that have more than 1 billion streams.

select
track,
stream
from spotify
where stream>1000000000;
------q2 list all albums along with their respective artists.
select 
artist,
album
from spotify;
-------q3  get the total number of comments for tracks where licensed=TRUE
select
sum(comments) as total_comments
from spotify
where licensed=true;
--------q4 find all tracks that belong to the album type single
select 
track
from spotify
where album_type='single';
---------q5 count the total number of tracks by each artist
select
count(track) as total_track,
artist
from spotify
group by artist
order by 1 desc;
------------------------------
--------medium level
-------------------------------
------q6 calculate the average danceability of tracks in each album

select
album,
avg(danceability)as avg_danceability
from spotify
group by 1
order by 2 desc;
------q7  find the top 5 tracks with the highest energy value
select
 track,
max(energy)
from spotify
group by 1
order by 2 desc
limit 5;
----q8 list all tracks along with their views and likes where official_video=TRUE

 select
  track,
 sum (views) as total_views,
 sum(likes) as total_likes
from spotify
where official_video ='true'
group by 1
order by 2;
-----q9 for each album, calculate the total views of all associated tracks
select
 distinct album,
 sum (views) as total_views,
 track
from spotify
group by 1,3
order by 2 desc;
------q10 retrieve the track names that have been streamed on spotify more than youtube
select* from 
( select
track,
coalesce (sum (case when most_played_on ='youtube' then stream end),0) as streamed_on_youtube,
 coalesce (sum (case when most_played_on ='spotify' then stream end ),0) as streamed_on_spotify

from spotify
group by 1) as t1
where 
       streamed_on_spotify> streamed_on_youtube;

------- q11 Find the top 3 most-viewed tracks for each artist using window function
with ranking_artist as
(
 select
 artist,
 track,
sum( views) as total_view,
dense_rank() over(partition by artist order by sum( views)desc ) as rank
from spotify
group by 1,2
order by 1, 3 desc
)

select* from ranking_artist
where rank <=3;

------q12 write a query to find tracks where the liveness score is above the average
select avg(liveness) from spotify;---0.19
select * from spotify 
where liveness >(select avg(liveness) from spotify);
-------q13 use a with cause calculate the difference between the highest and the lowest energy level of tracks in each album
with cte as(
select
album,
max(energy) as highest_energy,
min(energy) as lowest_energy
from spotify
group by 1
)
select
album,
highest_energy-lowest_energy as energy_diff
from cte
order by 2 desc;
 
	    
	      


	
		
