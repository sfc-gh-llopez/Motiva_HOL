/*--
• Database, schema, warehouse, and stage creation
--*/

USE ROLE SECURITYADMIN;

CREATE ROLE cortex_user_role;
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE cortex_user_role;

GRANT ROLE cortex_user_role TO USER <user>;

USE ROLE sysadmin;

-- Create warehouse
CREATE OR REPLACE WAREHOUSE cortex_analyst_wh
    WAREHOUSE_SIZE = 'large'
    WAREHOUSE_TYPE = 'standard'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
COMMENT = 'Warehouse for Cortex Analyst demo';

GRANT USAGE ON WAREHOUSE cortex_analyst_wh TO ROLE cortex_user_role;
GRANT OPERATE ON WAREHOUSE cortex_analyst_wh TO ROLE cortex_user_role;

SELECT 
    database_name, database_owner
FROM 
    information_schema.databases
WHERE 
    database_name LIKE '<MOTIVA_database>'; --(all caps), note here <database_owner>

GRANT OWNERSHIP ON SCHEMA <MOTIVA_database>.<MOTIVA_schema> TO ROLE cortex_user_role;
GRANT OWNERSHIP ON DATABASE <MOTIVA_database> TO ROLE cortex_user_role;


USE ROLE cortex_user_role;

-- Use the created warehouse
USE WAREHOUSE cortex_analyst_wh;

USE DATABASE <MOTIVA_database>;
USE SCHEMA <MOTIVA_database>.<MOTIVA_schema>;

-- Create stage for yaml file
CREATE OR REPLACE STAGE MOTIVA_yaml_stage DIRECTORY = (ENABLE = TRUE);

-- Switch to Cortex Studio
-- Note: We recommend not exceeding 3-5 tables, 10-20 columns each table to start.

--Clean Up
GRANT OWNERSHIP ON SCHEMA <MOTIVA_database>.<MOTIVA_schema> TO ROLE <database_owner>;
GRANT OWNERSHIP ON DATABASE <MOTIVA_database> TO ROLE <database_owner>;