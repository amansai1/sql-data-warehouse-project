# Data Warehouse & Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository

This portfolio project showcases a complete end-to-end data warehousing and analytics solution, from ingesting raw data to delivering actionable insights. It follows industry-standard data engineering and analytics practices.

---

## Data Architecture

This project implements the **Medallion Architecture** consisting of **Bronze, Silver, and Gold** layers:
<img width="894" height="527" alt="image" src="https://github.com/user-attachments/assets/2eb56a8e-c4a4-42cd-9b59-5618ec130e74" />


### Bronze Layer

* Stores raw, unprocessed data directly from source systems.
* Data is ingested from CSV files into a SQL Server database.

###  Silver Layer

* Performs data cleansing, standardization, validation, and normalization.
* Prepares structured data ready for business transformation.

###  Gold Layer**

* Contains business-ready data modeled using a **star schema**.
* Optimized for reporting, dashboards, and analytical queries.

---

##  Project Overview

This project includes the following components:

* **Data Architecture:** Designing a modern warehouse using Medallion layers.
* **ETL Pipelines:** Extracting, transforming, and loading data from multiple sources.
* **Data Modeling:** Developing fact and dimension tables for analytics.
* **Analytics & Reporting:** Creating SQL-based dashboards and insights.

This repository is ideal for showcasing skills in:

* SQL Development
* Data Architecture
* Data Engineering
* ETL Pipeline Development
* Data Modeling
* Data Analytics

---

##  Tools & Resources 

* **Datasets:** CSV files used throughout the project
* **Docker (macOS):** Runs the SQL Server container for database hosting
* **Azure Data Studio:** Cross-platform GUI for managing and querying SQL Server
* **GitHub:** Version control, documentation, and project collaboration
* **Draw.io:** Used to design architecture diagrams, data models, and ETL flows
* **Notion:** Project template, planning, and step-by-step workflow management

---

##  Project Requirements

### 1. Data Engineering – Build the Data Warehouse

Objective:
Create a modern SQL Server–based data warehouse that consolidates sales data into a unified analytical model.

**Specifications:**

* Import datasets from **ERP** and **CRM** CSV files
* Clean and validate data before analysis
* Integrate both sources into a unified star schema
* Only the latest dataset is required (no historization)
* Provide documentation for analytics and business teams

---

### 2. Data Analysis – BI & Analytics

**Objective:**
Deliver data-driven insights using SQL-based analytics focusing on:

* Customer behavior
* Product performance
* Sales trends

These insights support informed, strategic decision-making.

 For full details, see: **docs/requirements.md**

---

##  Repository Structure

```
data-warehouse-project/
│
├── datasets/                     # Raw ERP and CRM datasets
│
├── docs/                         # Documentation & architecture diagrams
│   ├── etl.drawio                # ETL process diagrams
│   ├── data_architecture.drawio  # System & architecture design
│   ├── data_catalog.md           # Dataset descriptions & metadata
│   ├── data_flow.drawio          # End-to-end data flow diagram
│   ├── data_models.drawio        # Star schema data models
│   ├── naming-conventions.md     # Naming standards for tables & files
│
├── scripts/                      # SQL scripts for all ETL layers
│   ├── bronze/                   # Raw data load scripts
│   ├── silver/                   # Cleansing & transformation scripts
│   ├── gold/                     # Analytical model scripts
│
├── tests/                        # Data quality checks & validation tests
└── README.md                     # Project documentation

```
