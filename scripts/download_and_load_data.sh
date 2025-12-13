#!/bin/bash

# Define directories
RAW_DATA_DIR="/home/mahdi/Documents/Real-Time-Revenue-Market-Balance-Optimization-System/data/raw"
CLICKHOUSE_DB="nyc_taxi"

# Create directories if they don't exist
mkdir -p "$RAW_DATA_DIR"

# Download raw data
#wget -i config/raw_data_urls.txt -P "$RAW_DATA_DIR" -w 2

# Load Parquet files directly into ClickHouse
for file in "$RAW_DATA_DIR"/*.parquet; do
  # Load Parquet file into ClickHouse
  clickhouse-client --query="CREATE DATABASE IF NOT EXISTS $CLICKHOUSE_DB;"
  clickhouse-client --query="CREATE TABLE IF NOT EXISTS $CLICKHOUSE_DB.yellow_green_taxi (
    VendorID UInt8,
    tpep_pickup_datetime DateTime,
    tpep_dropoff_datetime DateTime,
    passenger_count UInt8,
    trip_distance Float32,
    pickup_longitude Float64,
    pickup_latitude Float64,
    dropoff_longitude Float64,
    dropoff_latitude Float64,
    RatecodeID UInt8,
    store_and_fwd_flag String,
    payment_type UInt8,
    fare_amount Float32,
    extra Float32,
    mta_tax Float32,
    tip_amount Float32,
    tolls_amount Float32,
    improvement_surcharge Float32,
    total_amount Float32,
    congestion_surcharge Float32
  ) ENGINE = MergeTree()
  ORDER BY (tpep_pickup_datetime, pickup_longitude, pickup_latitude);"

  clickhouse-client --query="INSERT INTO $CLICKHOUSE_DB.yellow_green_taxi FORMAT Parquet" < "$file"
done

# Print completion message
echo "Data download and loading into ClickHouse completed."