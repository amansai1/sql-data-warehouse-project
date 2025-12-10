/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

It acts as the first step of the ETL pipeline, ingesting all source system data (CRM + ERP files) into the data warehouse in raw form.

Environment Used: macOS + Docker Setup

Since SQL Server does not run natively on macOS, the entire workflow was implemented inside a Docker container.

Data Loading Setup on macOS

To enable SQL Server to read external CSV files, the following steps were performed:

1. Created a Parent Folder for Source Datasets

Example:

/Users/yourusername/Desktop/datasets
    ├── source_crm
    └── source_erp

2. Mounted the Folder Inside Docker

During container creation:

docker run -e ACCEPT_EULA=Y -e SA_PASSWORD=YourPassword \
 -p 1435:1433 --name sqlserver \
 -v /Users/yourusername/sql_data:/var/opt/mssql \
 -v /Users/yourusername/Desktop/datasets:/datafiles \
 -d mcr.microsoft.com/mssql/server:2022-latest


This allowed SQL Server to access Mac files at:

/datafiles/source_crm
/datafiles/source_erp

3. Verified Docker Mount

Using:

docker exec -it sqlserver ls -R /datafiles


This step ensures SQL Server can SEE the files before executing BULK INSERT.

4. File-Case Sensitivity (Important on Linux Containers)

SQL Server inside Docker runs on Linux, which is case-sensitive.

Example:

LOC_A101.csv ≠ loc_a101.csv


The procedure uses filenames exactly as they appear in the dataset.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    SET NOCOUNT ON;

    --------------------------------------------------------------------
    -- Start Timer
    --------------------------------------------------------------------
    DECLARE @StartTime DATETIME = GETDATE();
    PRINT '============================================================';
    PRINT 'Starting Bronze Layer Load Process...';
    PRINT 'Start Time: ' + CONVERT(NVARCHAR(30), @StartTime, 120);
    PRINT '============================================================';
    PRINT '';

    BEGIN TRY
        ---------------------------------------------------------------
        --                    CRM TABLES LOADING
        ---------------------------------------------------------------
        PRINT '------------------------------------------------------------';
        PRINT 'Loading CRM Tables (Customer, Product, Sales)';
        PRINT '------------------------------------------------------------';
        PRINT '';

        -------------------------------
        -- Load CRM Customer Info
        -------------------------------
        PRINT 'Truncating table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT 'Inserting data into bronze.crm_cust_info from cust_info.csv';
        BULK INSERT bronze.crm_cust_info
        FROM '/datafiles/source_crm/cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK 
        );
        PRINT 'Completed loading: bronze.crm_cust_info';
        PRINT '';

        -------------------------------
        -- Load CRM Product Info
        -------------------------------
        PRINT 'Truncating table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT 'Inserting data into bronze.crm_prd_info from prd_info.csv';
        BULK INSERT bronze.crm_prd_info
        FROM '/datafiles/source_crm/prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        PRINT 'Completed loading: bronze.crm_prd_info';
        PRINT '';

        -------------------------------
        -- Load CRM Sales Details
        -------------------------------
        PRINT 'Truncating table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT 'Inserting data into bronze.crm_sales_details from sales_details.csv';
        BULK INSERT bronze.crm_sales_details
        FROM '/datafiles/source_crm/sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        PRINT 'Completed loading: bronze.crm_sales_details';
        PRINT '';

        ---------------------------------------------------------------
        --                    ERP TABLES LOADING
        ---------------------------------------------------------------
        PRINT '------------------------------------------------------------';
        PRINT 'Loading ERP Tables (Location, Customer, Product Category)';
        PRINT '------------------------------------------------------------';
        PRINT '';

        -------------------------------
        -- Load ERP Location File
        -------------------------------
        PRINT 'Truncating table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT 'Inserting data into bronze.erp_loc_a101 from LOC_A101.csv';
        BULK INSERT bronze.erp_loc_a101
        FROM '/datafiles/source_erp/LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        PRINT 'Completed loading: bronze.erp_loc_a101';
        PRINT '';

        -------------------------------
        -- Load ERP Customer File
        -------------------------------
        PRINT 'Truncating table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT 'Inserting data into bronze.erp_cust_az12 from CUST_AZ12.csv';
        BULK INSERT bronze.erp_cust_az12
        FROM '/datafiles/source_erp/CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        PRINT 'Completed loading: bronze.erp_cust_az12';
        PRINT '';

        -------------------------------
        -- Load ERP Product Category File
        -------------------------------
        PRINT 'Truncating table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT 'Inserting data into bronze.erp_px_cat_g1v2 from PX_CAT_G1V2.csv';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM '/datafiles/source_erp/PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        PRINT 'Completed loading: bronze.erp_px_cat_g1v2';
        PRINT '';

        ---------------------------------------------------------------
        -- Successfully Finished
        ---------------------------------------------------------------
        DECLARE @EndTime DATETIME = GETDATE();
        DECLARE @DurationInSeconds INT = DATEDIFF(SECOND, @StartTime, @EndTime);

        PRINT '============================================================';
        PRINT 'Bronze Layer Load Completed Successfully!';
        PRINT 'End Time: ' + CONVERT(NVARCHAR(30), @EndTime, 120);
        PRINT '⏱ Total Duration: ' + CAST(@DurationInSeconds AS NVARCHAR(10)) + ' seconds';
        PRINT '============================================================';

    END TRY

    BEGIN CATCH
        PRINT '';
        PRINT '============================================================';
        PRINT 'ERROR OCCURRED DURING BRONZE LAYER LOADING';
        PRINT '============================================================';

        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number : ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'Error State  : ' + CAST(ERROR_STATE() AS NVARCHAR(10));
        PRINT 'Error Line   : ' + CAST(ERROR_LINE() AS NVARCHAR(10));
        PRINT 'Error Proc   : ' + ISNULL(ERROR_PROCEDURE(), 'N/A');

        PRINT '============================================================';
        PRINT 'Bronze Layer Load FAILED!';
        PRINT '============================================================';

        THROW; -- rethrow the error for logging systems
    END CATCH

END;
GO
