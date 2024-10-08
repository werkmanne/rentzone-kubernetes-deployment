#!/bin/bash

S3_URI=s3://demo-rentzone/V1__rentzone-db.sql
RDS_ENDPOINT=applicationdb.chucqcesil3r.eu-central-1.rds.amazonaws.com
RDS_DB_NAME=demodb
RDS_DB_USERNAME=bello
RDS_DB_PASSWORD=Icui4cyou

# Update all packages
sudo yum update -y

# Download and extract Flyway
sudo wget -qO- https://download.red-gate.com/maven/release/com/redgate/flyway/flyway-commandline/10.19.0/flyway-commandline-10.19.0-linux-x64.tar.gz | tar -xvz 

# Create a symbolic link to make Flyway accessible globally
sudo ln -s $(pwd)/flyway-10.19.0/flyway /usr/local/bin

# Create the SQL directory for migrations
sudo mkdir sql

# Download the migration SQL script from AWS S3
sudo aws s3 cp "$S3_URI" sql/

# Run Flyway migration
flyway -url=jdbc:mysql://"$RDS_ENDPOINT":3306/"$RDS_DB_NAME" \
  -user="$RDS_DB_USERNAME" \
  -password="$RDS_DB_PASSWORD" \
  -locations=filesystem:sql \
  migrate