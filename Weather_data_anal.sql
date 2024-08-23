set wedatabase ='DE_PROJECT';
set wetable ='weather_data';
set mypipe ='mypipe';


-- Create a new database 
CREATE DATABASE if not exists identifier($database);

-- Switch to the newly created database
USE DATABASE DE_PROJECT;

-- Create table to load CSV data
CREATE or replace TABLE identifier($wetable)(
    feelslike_temp  NUMBER(20,0),
    temp       NUMBER(20,0),
    CITY          VARCHAR(128),
    humidity   NUMBER(20,5),    
    wind_speed      NUMBER(20,5),
    time             VARCHAR(128),
    wind_dir        VARCHAR(128),
    pressure_mb    NUMBER(20,5)
);


--Create integration object for external stage
create or replace storage integration s3_int
  type = external_stage
  storage_provider = s3
  enabled = true
  storage_aws_role_arn = 'arn:aws:iam::7777737772246:role/Aw' ---your aws iam ARN value you get after creating iam role in AWS
  storage_allowed_locations = ('s3://yours3bucket/yours3folder/'); ---your s3 bucket location that can found after you created your bucket in the bucket section select the Folder then Copy S3 URL

  
--Describe integration object to fetch external_id and to be used in s3
DESC INTEGRATION s3_int; --- you will get snowflake AWS IAM ARNand External ID to use it and paste it in the IAM role you created for the project in the Trust relationships and add condition and paste the external ID
---Give appropriate access like S3 bucket to the IAM 
create or replace file format csv_format
                    type = csv
                    field_delimiter = ','
                    skip_header = 1
                    null_if = ('NULL', 'null')
                    empty_field_as_null = true;
                    
create or replace stage ext_csv_stage
  URL = 's3://yours3bucket/yours3folder/'      ---Same as 31st Line Copy From the S3 bucket you created by selecting the folder the a option copys3URL to copy your folder location
  STORAGE_INTEGRATION = s3_int
  file_format = csv_format;

--create pipe to automate data ingestion from s3 to snowflake
create or replace pipe identifier($mypipe) auto_ingest=true as
copy into weather_data
from @ext_csv_stage
on_error = CONTINUE;

show pipes;

select * from weather_data;