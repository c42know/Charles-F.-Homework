```python
from citipy import citipy
import numpy as np
import pandas as pd
import random
from config import api_key
import json
import requests
from pprint import pprint
import openweathermapy.core as owm
from urllib.error import HTTPError
import matplotlib.pyplot as plt
import seaborn as sns
```

```python
#setup lists for all data needed
city_list = []
cntry_code =[]
city_id = []
lat = []
lng= []
temp_max= []
wind_speed = []
humidity = []
date_time = []
cloudiness = []

#city counter
city_count = 1

#while loop for 500 unique cities
while city_count <501:
    #receive from randomn generator a random lat/lng
    lat_test = random.uniform(-180.000, 180.000)
    lng_test = random.uniform(-90.000, 90.000)
    #input lat/lng into citipy to receive city name
    city = (citipy.nearest_city(lat_test, lng_test)).city_name
    c_code = (citipy.nearest_city(lat_test, lng_test)).country_code
    
    try:
        #list setting for owm api wrapper
        settings = {"units": "imperial", "appid": api_key}
        # Get current weather JSON for city in loop
        current_weather = owm.get_current(city, **settings)

        #test if city name is in city_list
        if city in city_list:
            print(str(city) + ' is already in list. Trying another lat/lng')
            continue
        else:
            #add city to the list since it's not already
            print('City #' + str(city_count) + ' ' + str(city) +', ' + str(c_code) +' added to the list using OWM Wrapper, no link needed.')
            city_list.append(city)
            lat.append(lat_test)
            lng.append(lng_test)
            cntry_code.append(c_code)
            
            #create variable to input into current_weather api
            t_max = ["main.temp_max"]
            w_speed = ['wind.speed']
            humid = ['main.humidity']
            dt = ['dt']
            cloud = ['clouds.all']

            #apply current_weather function to get weather data
            temp_maxed = current_weather(*t_max)
            temp_wind = current_weather(*w_speed)
            temp_humid = current_weather(*humid)
            temp_dt = current_weather(*dt)
            temp_cloud = current_weather(*cloud)
            
            #append weather data in specified lists
            temp_max.append(temp_maxed)
            wind_speed.append(temp_wind)
            humidity.append(temp_humid)
            date_time.append(temp_dt)
            cloudiness.append(temp_cloud)
            
            #print added city to list
            
        #append counter to city_id list
        city_id.append(city_count) 
        #increment city counter
        city_count += 1
        
        
    #if error running city in owm, find a new city - go back to top of while loop
    except (KeyError, HTTPError):
        continue
print('----------------DONE COMPILING DATA---------------')
        
```

```python
#create data frame with lists
city_info = pd.DataFrame({'City ID' : city_id, 'City': city_list, 'Country' : cntry_code, 'Lat' : lat, 'Lng': lng, 'Max Temp' : temp_max, 'Wind Speed' : wind_speed, \
                          'Humidity' : humidity, 'Date': date_time, 'Cloudiness' : cloudiness}, index=None)
#place columns in order

city_info = city_info[['City ID', 'City','Country', 'Date', 'Cloudiness', 'Humidity', 'Lat', 'Lng', 'Max Temp', 'Wind Speed']]
#city_info['Lat'] = city_info['Lat'].map("{:,.3f}".format)
#city_info['Lng'] = city_info['Lng'].map("{:,.3f}".format)


city_info.to_csv('city_info_data.csv', index=False)
city_info.head(25)
```

```python
#create City Latitude vs. Max Temperature(4/3/17) scatter plot

#set seadboard style & size of plot
sns.set_style("darkgrid")
plt.figure(figsize=(12, 5))

#setup plot
urban_plot = plt.scatter(city_info['Lat'], city_info['Max Temp'],  facecolors="red", edgecolors="black",
            alpha=0.75)

plt.title("City Latitude vs. Max Temperature(4/3/17)")
plt.xlabel("Latitude")
#plt.xlim([-180,180])
plt.ylabel("Max Temperature")
plt.savefig("Lat_VS_TMax.png")
plt.show()


```

```python
#create City Latitude vs. Humidity(4/3/17) scatter plot

#set seadboard style & size of plot
sns.set_style("darkgrid")
plt.figure(figsize=(12, 5))

#setup plot
urban_plot = plt.scatter(city_info['Lat'], city_info['Humidity'],  facecolors="blue", edgecolors="black",
            alpha=0.75)

plt.title("City Latitude vs. Humidity(4/3/17)")
plt.xlabel("Latitude")
plt.ylabel("Humidity")
plt.savefig("Lat_VS_Humid.png")
plt.show()
```

```python
#create City Latitude vs. Cloudiness (4/3/17) scatter plot

#set seadboard style & size of plot
sns.set_style("darkgrid")
plt.figure(figsize=(12, 5))

#setup plot
urban_plot = plt.scatter(city_info['Lat'], city_info['Cloudiness'],  facecolors="yellow", edgecolors="black",
            alpha=0.75)

plt.title("City Latitude vs. Cloudiness (4/3/17)")
plt.xlabel("Latitude")
plt.ylabel("Cloudiness (%)")
plt.savefig("Lat_VS_Cloud.png")
plt.show()
```

```python
#create City Latitude vs. Wind Speed (4/3/17) scatter plot

#set seadboard style & size of plot
sns.set_style("darkgrid")
plt.figure(figsize=(12, 5))

#setup plot
urban_plot = plt.scatter(city_info['Lat'], city_info['Wind Speed'],  facecolors="green", edgecolors="black",
            alpha=0.75)

plt.title("City Latitude vs. Wind Speed (4/3/17)")
plt.xlabel("Latitude")
plt.ylabel("Wind Speed (%)")
plt.savefig("Lat_VS_Wind.png")
plt.show()
```
