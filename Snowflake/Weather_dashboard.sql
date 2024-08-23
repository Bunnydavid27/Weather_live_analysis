---1st Tile Avg Temperature Through Time
select *from de_project.public.weather_data; --de_project is your database and weather data is the table data recieved from Weather APi through AWS

---2nd Tile Temp_according_to_cities
select city, avg(FEELSLIKE_TEMP) as Feels_like_temp , avg(TEMP) as Normal_temp from de_project.public.weather_data group by city order by Normal_temp;

---3rd Tile Humidity and Pressure Via CIties
select city, avg(HUMIDITY) as Avg_Humidity , avg(PRESSURE_MB) as Avg_pressure from de_project.public.weather_data group by city order by Avg_Humidity;

--4th Tile Windspeed via city
select city, avg(WIND_SPEED) as Avg_Windspeed from de_project.public.weather_data group by city order by Avg_Windspeed;

---5th Tile Wind_dir and Windspeed
select WIND_DIR, avg(HUMIDITY) as Avg_Humidity , avg(WIND_SPEED) as Avg_windspeed from de_project.public.weather_data group by WIND_DIR order by WIND_DIR;


