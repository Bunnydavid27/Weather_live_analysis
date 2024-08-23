# Weather_live_analysis
This project is designed to extract weather data using the WeatherAPI, store it in DynamoDB, and set up a data pipeline that triggers data storage in an S3 bucket, which is then accessed by Snowflake for live analysis.

Dashboard: https://app.snowflake.com/cpnlyno/kl53458/#/weather_analysis-dRYYDf62F  (If you have Snowflake Account you can view my Weather Dashboard)
## Prerequisites

1. **Create a WeatherAPI Account**:
   - Visit [WeatherAPI](https://www.weatherapi.com/) and sign up for an account.
   - Access your free API key from your account dashboard.
   - Familiarize yourself with the API documentation at [WeatherAPI Docs](https://www.weatherapi.com/docs/).

2. **Set Up AWS Services**:
   - **AWS Lambda**: Create two Lambda functions.
   - **AWS IAM**: Create IAM roles with appropriate permissions.
   - **AWS DynamoDB**: Set up a DynamoDB table.
   - **AWS S3**: Create an S3 bucket and a folder within it.
   - **Snowflake**: Set up Snowflake for data analysis.

## Step 1: Extract Weather Data

1. **API URL Configuration**:
   - Replace `BASEURL+api_method` in the URL with the appropriate endpoint as per the API documentation.
   - Update the `key` variable in your code with your WeatherAPI key.

2. **Lambda Function for Data Extraction**:
   - Create a Lambda function in AWS.
   - Add the code from `weather_data_extraction.py` to your Lambda function.
   - Add a Python layer compatible with your Python version.
   - Create an IAM role with DynamoDB access and attach it to the Lambda function in the execution role section under the configuration.

## Step 2: Stream Data to S3

1. **Lambda Function for Streaming Data**:
   - Create a second Lambda function.
   - Add the code from `stream.py` to this Lambda function.
   - Replace the AWS S3 bucket name and folder in the `stream.py` file with your S3 bucket details.
   - Add the same Python layer as the previous function.
   - Create a trigger for this function using DynamoDB.
   - Create a new IAM role with S3 and DynamoDB access, and attach it to the Lambda function.

2. **S3 Bucket**:
   - Create an S3 bucket and a folder within it.
   - Ensure the IAM role has appropriate S3 access.

## Step 3: Connect Snowflake to AWS S3

1. **Create IAM Role for Snowflake**:
   - Create a new IAM role for Snowflake with S3 access.
   - In Snowflake, create a Snowflake SQL worksheet.
   - Run the commands from `weather_data_analy.sql`, following the comments to configure the connection.
   - After running `DESC INTEGRATION s3_int;`, retrieve the Snowflake AWS IAM ARN and External ID.
   - Add these values to the Trust Relationships section of the IAM role created for Snowflake.

2. **Set Up Snowpipe in Snowflake**:
   - Set up Snowpipe in Snowflake to automatically load new data from the S3 bucket into your Snowflake table.

## Execution

1. **Run the Weather Data Extraction Lambda Function**:
   - This function will extract weather data from the API and store it in DynamoDB.

2. **DynamoDB Trigger**:
   - The second Lambda function is triggered by changes in DynamoDB.
   - It extracts the updated data and stores it in the specified S3 bucket.

3. **Snowflake Data Loading**:
   - Snowpipe in Snowflake continuously monitors the S3 bucket.
   - When new data is added, it loads the data into the Snowflake table for analysis.

## Conclusion

By following the steps outlined above, you will create a fully functional data pipeline that extracts weather data, stores it in DynamoDB, triggers storage in S3, and loads it into Snowflake for real-time analysis.
