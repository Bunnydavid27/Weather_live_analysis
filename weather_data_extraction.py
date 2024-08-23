import json
from datetime import datetime
import requests
import boto3
from decimal import Decimal


# Initialize DynamoDB resource and specify the table
dynamoDB = boto3.resource('dynamodb')
table = dynamoDB.Table('weather_data') #your table name which you created in your AWS in Dynamo DB


def extract_weather_data(city):
    api_url = 'http://api.weatherapi.com/v1/current.json'
    params = {
        'q': city,
        'key': 'your weather api key'
    }
    response = requests.get(api_url, params=params)
    data = response.json()
    return data


def decimal_default(obj):
    if isinstance(obj, Decimal):
        return float(obj)
    raise TypeError


def lambda_handler(event, context):
    city = 'Visakhapatnam'
    # Extract weather data
    weather_data = extract_weather_data(city)
    
    # Extract necessary fields and convert them to Decimal
    temp = Decimal(str(weather_data['current']['temp_c']))
    wind_speed = Decimal(str(weather_data['current']['wind_kph']))
    wind_dir = weather_data['current']['wind_dir']
    pressure_mb = Decimal(str(weather_data['current']['pressure_mb']))
    humidity = Decimal(str(weather_data['current']['humidity']))
    feelslike_temp = Decimal(str(weather_data['current']['feelslike_c']))
    
    print(city, temp, feelslike_temp, wind_speed, wind_dir, pressure_mb, humidity)
    
    # Get the current timestamp
    current_timestamp = datetime.utcnow().isoformat()

    # Prepare the data to be inserted into DynamoDB
    City_Weather_info = {
        'city': city,
        'time': current_timestamp,
        'temp': temp,
        'wind_speed': wind_speed,
        'wind_dir': wind_dir,
        'pressure_mb': pressure_mb,
        'humidity': humidity,
        'feelslike_temp': feelslike_temp
    }
    
    item = json.loads(json.dumps(City_Weather_info, default=decimal_default), parse_float=Decimal)

    # Insert the data into DynamoDB
    table.put_item(Item=City_Weather_info)
