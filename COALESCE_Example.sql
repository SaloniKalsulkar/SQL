/*------------------------------------------------------------------------------------------------------------------------------------------

Some CASE statements and CREATE TABLE examples might seem illogical, 
but I attempted to translate the business problem we faced at my company 
into a daily life example, as we cannot use our company data

We had data that was 1000 times larger and 1000 times more complex, 
but to explain the solution, tried to simplify the data

This is for SNOWFLAKE -  make required changes if needed based on your environment
-----------------------------------------------------------------------------------------------------------------------------------------*/




------------------------------------------------------------------------------------------------------------------------------------------
-- CREATE TABLE
-----------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS CustomerPurchases;
CREATE OR REPLACE TEMPORARY TABLE CustomerPurchases (
    CUSTOMER_ID VARCHAR(10),
    AMOUNT INT,
    PRODUCT_CODE_1 VARCHAR(50),
    PRODUCT_CODE_2 VARCHAR(50),
    PRODUCT_CODE_3 VARCHAR(50)
                                                    );

INSERT INTO CustomerPurchases (CUSTOMER_ID, AMOUNT, PRODUCT_CODE_1, PRODUCT_CODE_2, PRODUCT_CODE_3) VALUES
('C001', 1200, 'Apple', 'Chair', 'Refrigerator'),
('C002', 1500, 'Banana', 'Sofa', 'Microwave'),
('C003', 1100, 'Orange', 'Table', 'Oven'),
('C004', 900, 'Pineapple', 'Desk', 'Blender'),
('C005', 1000, 'Cherry', 'Bed', 'Toaster'),
('C006', 1300, 'Apple', 'Sofa', 'Blender'),
('C007', 1400, 'Banana', 'Table', 'Refrigerator'),
('C008', 1600, 'Orange', 'Chair', 'Microwave'),
('C009', 1700, 'Pineapple', 'Bed', 'Oven'),
('C010', 1800, 'Cherry', 'Desk', 'Toaster'),
('C011', 1900, 'Apple', 'Chair', 'Blender'),
('C012', 2000, 'Banana', 'Sofa', 'Refrigerator'),
('C013', 2100, 'Orange', 'Desk', 'Microwave'),
('C014', 2200, 'Pineapple', 'Table', 'Oven'),
('C015', 2300, 'Cherry', 'Bed', 'Toaster'),
('C016', 2400, 'Apple', 'Desk', 'Blender'),
('C017', 2500, 'Banana', 'Table', 'Microwave'),
('C018', 2600, 'Orange', 'Chair', 'Refrigerator'),
('C019', 2700, 'Pineapple', 'Sofa', 'Oven'),
('C020', 2800, 'Cherry', 'Bed', 'Toaster'),
('C021', 2000, 'Cherry', 'Sofa', 'Oven'),
('C022', 4000, 'Orange', 'Chair', NULL),
('C023', 3000, NULL, 'Bed', 'Oven'),
('C024', 5500, 'Banana', 'Desk', 'Blender'),
('C025', 200, NULL, NULL, 'Microwave'),
('C026', 2004, 'Apple', NULL, 'Toaster')
;
------------------------------------------------------------------------------------------------------------------------------------------
-- SEE The original Table
-----------------------------------------------------------------------------------------------------------------------------------------


SELECT * FROM CustomerPurchases;

------------------------------------------------------------------------------------------------------------------------------------------
 --CASE Statement Based on Business Data (e.g., Combination of products assigned to a specific Leader
-----------------------------------------------------------------------------------------------------------------------------------------

SELECT
    CUSTOMER_ID,
    AMOUNT,
    PRODUCT_CODE_1,
    PRODUCT_CODE_2,
    PRODUCT_CODE_3,
    CASE
        -- Manager A: When Product_Code_1 is 'Apple' or (Product_Code_2 is 'Sofa' or 'Blender') and Product_Code_1 is not 'Orange' or 'Pineapple'
        WHEN (PRODUCT_CODE_1 = 'Apple' OR PRODUCT_CODE_2 IN ('Sofa', 'Blender'))
             AND PRODUCT_CODE_1 NOT IN ('Orange', 'Pineapple') AND PRODUCT_CODE_2 is not null THEN 'Manager A'
        -- Manager B: When Product_Code_1 is not 'Orange' and Product_Code_2 is 'Desk', or (Product_Code_1 is not 'Apple' and Product_Code_2 is not 'Bed')
        WHEN (PRODUCT_CODE_1 NOT IN ('Orange') AND PRODUCT_CODE_2 = 'Desk')
             OR (PRODUCT_CODE_1 NOT IN ('Apple') AND PRODUCT_CODE_2 NOT IN ('Bed')) THEN 'Manager B'
        -- Manager C: When Product_Code_3 is 'Toaster' or Product_Code_2 is 'Chair', and Product_Code_1 is not 'Cherry'
        WHEN (PRODUCT_CODE_3 = 'Toaster' OR PRODUCT_CODE_2 = 'Chair')
             AND PRODUCT_CODE_1 <> 'Cherry' THEN 'Manager C' ELSE NULL
    END AS Manager,
    
    CASE
        -- Reportee 1: All 'Apple' or ( all 'Chair' not paired with  'Oranges')
        WHEN (PRODUCT_CODE_1 = 'Apple' OR PRODUCT_CODE_2 = 'Chair') and PRODUCT_CODE_2 is not null and PRODUCT_CODE_1 <> 'Orange' THEN 'Reportee 1'
        -- Reportee 2: All 'Orange' given Product_Code_2 is not 'Chair'
        WHEN PRODUCT_CODE_1 = 'Orange' AND PRODUCT_CODE_2 <> 'Chair' THEN 'Reportee 2'
        -- Reportee 3: All 'Oven'
        WHEN PRODUCT_CODE_1 <> 'Cherry'and  PRODUCT_CODE_3 = 'Oven' THEN 'Reportee 3'
        -- Reportee 4: All 'Pineapple' and 'Banana' given Product_Code_3 is not 'Toaster' and PRODUCT_CODE_2 is not  'Sofa'
        WHEN (PRODUCT_CODE_1 IN ('Pineapple', 'Banana') AND PRODUCT_CODE_3 <> 'Toaster')  AND (PRODUCT_CODE_2 <> 'Sofa') THEN 'Reportee 4'
        WHEN PRODUCT_CODE_2 is NULL and PRODUCT_CODE_3 = 'Toaster' then 'Reportee 5'
        ELSE NULL
    END AS Reportee
    
FROM CustomerPurchases;



------------------------------------------------------------------------------------------------------------------------------------------
/* This CASE statement is insufficient as it returns NULL values in some places.
Use COALESCE as follows: */
-----------------------------------------------------------------------------------------------------------------------------------------

SELECT
    CUSTOMER_ID,
    AMOUNT,
    PRODUCT_CODE_1,
    PRODUCT_CODE_2,
    PRODUCT_CODE_3,
    
    -- Initial Case statement for Manager
    COALESCE(
        CASE
            
            WHEN (PRODUCT_CODE_1 = 'Apple' OR PRODUCT_CODE_2 IN ('Sofa', 'Blender'))
                 AND PRODUCT_CODE_1 NOT IN ('Orange', 'Pineapple') AND PRODUCT_CODE_2 IS NOT NULL THEN 'Manager A'
           
            WHEN (PRODUCT_CODE_1 NOT IN ('Orange') AND PRODUCT_CODE_2 = 'Desk')
                 OR (PRODUCT_CODE_1 NOT IN ('Apple') AND PRODUCT_CODE_2 NOT IN ('Bed')) THEN 'Manager B'
        
            WHEN (PRODUCT_CODE_3 = 'Toaster' OR PRODUCT_CODE_2 = 'Chair')
                 AND PRODUCT_CODE_1 <> 'Cherry' THEN 'Manager C'
           
            ELSE NULL
        END,
        CASE
 -- New conditions to assign values when Manager is NULL
            WHEN PRODUCT_CODE_1 = 'Cherry' THEN 'Manager D'
            WHEN PRODUCT_CODE_2 = 'Table' THEN 'Manager E'
            WHEN PRODUCT_CODE_3 IS NULL THEN 'Manager F'
            ELSE 'Manager G'
        END
                ) AS Manager,
    
    -- Initial Case statement for Reportee
    COALESCE(
        CASE
            
            WHEN (PRODUCT_CODE_1 = 'Apple' OR PRODUCT_CODE_2 = 'Chair') AND PRODUCT_CODE_2 IS NOT NULL AND PRODUCT_CODE_1 <> 'Orange' THEN 'Reportee 1'
        
            WHEN PRODUCT_CODE_1 = 'Orange' AND PRODUCT_CODE_2 <> 'Chair' THEN 'Reportee 2'

            WHEN PRODUCT_CODE_1 <> 'Cherry' AND PRODUCT_CODE_3 = 'Oven' THEN 'Reportee 3'
         
            WHEN (PRODUCT_CODE_1 IN ('Pineapple', 'Banana') AND PRODUCT_CODE_3 <> 'Toaster') AND (PRODUCT_CODE_2 <> 'Sofa') THEN 'Reportee 4'

            WHEN PRODUCT_CODE_2 IS NULL AND PRODUCT_CODE_3 = 'Toaster' THEN 'Reportee 5'
           
            ELSE NULL
        END,
        CASE
            -- New conditions to assign values when Reportee is NULL

            WHEN PRODUCT_CODE_1 IS NULL THEN 'Reportee 6'
            WHEN PRODUCT_CODE_2 IS NULL THEN 'Reportee 7'
            WHEN PRODUCT_CODE_3 IS NULL THEN 'Reportee 8'
            ELSE 'Reportee 9'
        END
            ) AS Reportee
FROM CustomerPurchases;



