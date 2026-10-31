# Crypto Market Data Pipeline

An end-to-end data engineering project built with Databricks, PySpark, Delta Lake, and dbt. The pipeline ingests hourly cryptocurrency market data from the Binance public REST API, processes it using Medallion Architecture, and produces analytical models for daily market performance.

## Architecture

```text
Binance REST API
       |
       v
Bronze Layer (Delta Lake)
  - Hourly OHLCV ingestion
  - API pagination
  - Idempotent MERGE
       |
       v
Silver Layer (PySpark)
  - Data type conversions
  - Filtering incomplete candles
  - Data validation
       |
       v
Gold Layer (dbt)
  - Daily price aggregation
  - Daily trading volume
  - Daily price returns
  - dbt data quality tests
```

## Technology Stack

- **Databricks:** Data processing and workflow orchestration
- **Python:** REST API ingestion and pagination
- **PySpark:** Data transformations and validation
- **Delta Lake:** ACID tables and idempotent ingestion using MERGE
- **dbt:** SQL transformations, model dependencies, and automated tests
- **Unity Catalog:** Data organization across Bronze, Silver, and Gold
- **GitHub:** Version control

## Data Pipeline

### 1. Bronze — Ingestion

The pipeline retrieves hourly OHLCV (Open, High, Low, Close, Volume) data for BTCUSDT, ETHUSDT, and SOLUSDT from the Binance public API.

Data is stored in Delta Lake. A MERGE operation matches records using the combination of symbol, interval, and candle opening timestamp, preventing duplicate inserts during repeated ingestion runs.

### 2. Silver — Transformation

PySpark transformations convert raw values into appropriate numeric and timestamp types.

Incomplete hourly candles are excluded to prevent partially formed market data from affecting downstream analytics.

The cleaned dataset is stored in a Delta table for downstream consumption.

### 3. Gold — Analytical Models

dbt models transform Silver data into daily analytical datasets.

- `daily_candles`: Daily closing prices, trading volume, and hourly candle counts
- `daily_returns`: Daily percentage price changes calculated using SQL window functions

Daily aggregates include only days containing 24 hourly candle records.

### 4. Data Quality

The pipeline includes validation of record counts, duplicate records, and incomplete candles, along with dbt tests for required fields.

Additional validation is possible for missing hourly intervals, data freshness, and source-to-target reconciliation.

## Orchestration

Databricks Jobs orchestrates the pipeline through three dependent tasks:

1. `ingest_crypto`
2. `transform_crypto`
3. `dbt_crypto`

The workflow is configured with hourly scheduling, ingestion retries, and email notifications for failed runs.

## Current Limitations

- Silver data is rewritten during each transformation run rather than updated incrementally.
- The daily completeness rule checks the number of hourly records, not every expected hourly timestamp.
- Automated deployment and CI/CD are not yet implemented.

## Future Improvements

- Incremental Silver transformations
- Automated freshness and missing-interval checks
- GitHub Actions CI/CD
- Dashboarding for cryptocurrency market trends

## Project Purpose

This project demonstrates hands-on experience building an end-to-end analytical data pipeline, including API ingestion, Delta Lake storage, PySpark transformations, dbt modeling, data quality validation, and Databricks workflow orchestration.