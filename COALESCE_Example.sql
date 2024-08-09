
/*------------------------------------------------------------------------------------------------------------------------------------------

Some CASE statements and CREATE TABLE examples might seem illogical, 
but the business problem faced at my company has been translated 
into a daily-life example, as using actual company data wasn't feasible.

The data was 1000 times larger and more complex, but to explain the solution, it was simplified significantly.

Please see the attached PPT and query for details.

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
    Region VARCHAR(50)
);

INSERT INTO CustomerPurchases (CUSTOMER_ID, AMOUNT, PRODUCT_CODE_1, PRODUCT_CODE_2, Region) VALUES
('C001', 1200, 'Product 1', 'Product A', 'Region 1'),
('C002', 1500, 'Product 2', 'Product B', 'Region 2'),
('C003', 1100, 'Product 3', 'Product C', 'Region 3'),
('C004', 900, 'Product 4', 'Product D', 'Region 4'),
('C005', 1000, 'Product 5', 'Product E', 'Region 5'),
('C006', 1300, 'Product 1', 'Product B', 'Region 4'),
('C007', 1400, 'Product 2', 'Product C', 'Region 1'),
('C008', 1600, 'Product 3', 'Product A', 'Region 2'),
('C009', 1700, 'Product 4', 'Product E', 'Region 3'),
('C010', 1800, 'Product 5', 'Product D', 'Region 5'),
('C011', 1900, 'Product 1', 'Product A', 'Region 4'),
('C012', 2000, 'Product 2', 'Product B', 'Region 1'),
('C013', 2100, 'Product 3', 'Product D', 'Region 2'),
('C014', 2200, 'Product 4', 'Product C', 'Region 3'),
('C015', 2300, 'Product 5', 'Product E', 'Region 5'),
('C016', 2400, 'Product 1', 'Product D', 'Region 4'),
('C017', 2500, 'Product 2', 'Product C', 'Region 2'),
('C018', 2600, 'Product 3', 'Product A', 'Region 1'),
('C019', 2700, 'Product 4', 'Product B', 'Region 3'),
('C020', 2800, 'Product 5', 'Product E', 'Region 5'),
('C021', 2000, 'Product 5', 'Product B', 'Region 3'),
('C022', 4000, 'Product 3', 'Product A', 'Region 3'),
('C023', 3000, NULL, 'Product E', 'Region 3'),
('C024', 5500, 'Product 2', 'Product D', 'Region 4'),
('C025', 200, NULL, NULL, 'Region 2'),
('C026', 2004, 'Product 1', NULL, 'Region 5');
------------------------------------------------------------------------------------------------------------------------------------------
-- SEE The original Table
-----------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM CustomerPurchases;

------------------------------------------------------------------------------------------------------------------------------------------
 --CASE Statement Based on Business Data (e.g., Combination of products assigned to a specific Leader)
-----------------------------------------------------------------------------------------------------------------------------------------

SELECT
    CUSTOMER_ID,
    AMOUNT,
    PRODUCT_CODE_1,
    PRODUCT_CODE_2,
    Region,
    CASE
        -- Manager A: When PRODUCT_CODE_1 is 'Product 1' or (PRODUCT_CODE_2 is 'Product B' or 'Region 4') and PRODUCT_CODE_1 is not 'Product 3' or 'Product 4'
        WHEN (PRODUCT_CODE_1 = 'Product 1' OR PRODUCT_CODE_2 IN ('Product B', 'Region 4'))
             AND PRODUCT_CODE_1 NOT IN ('Product 3', 'Product 4') AND PRODUCT_CODE_2 IS NOT NULL THEN 'Manager A'
        -- Manager B: When PRODUCT_CODE_1 is not 'Product 3' and PRODUCT_CODE_2 is 'Product D', or (PRODUCT_CODE_1 is not 'Product 1' and PRODUCT_CODE_2 is not 'Product E')
        WHEN (PRODUCT_CODE_1 NOT IN ('Product 3') AND PRODUCT_CODE_2 = 'Product D')
             OR (PRODUCT_CODE_1 NOT IN ('Product 1') AND PRODUCT_CODE_2 NOT IN ('Product E')) THEN 'Manager B'
        -- Manager C: When Region is 'Region 5' or PRODUCT_CODE_2 is 'Product A', and PRODUCT_CODE_1 is not 'Product 5'
        WHEN (Region = 'Region 5' OR PRODUCT_CODE_2 = 'Product A')
             AND PRODUCT_CODE_1 <> 'Product 5' THEN 'Manager C'
        ELSE NULL
    END AS Manager,
    
    CASE
        -- Reportee 1: All 'Product 1' or (all 'Product A' not paired with 'Product 3')
        WHEN (PRODUCT_CODE_1 = 'Product 1' OR PRODUCT_CODE_2 = 'Product A') AND PRODUCT_CODE_2 IS NOT NULL AND PRODUCT_CODE_1 <> 'Product 3' THEN 'Reportee 1'
        -- Reportee 2: All 'Product 3' given PRODUCT_CODE_2 is not 'Product A'
        WHEN PRODUCT_CODE_1 = 'Product 3' AND PRODUCT_CODE_2 <> 'Product A' THEN 'Reportee 2'
        -- Reportee 3: All 'Region 3'
        WHEN PRODUCT_CODE_1 <> 'Product 5' AND Region = 'Region 3' THEN 'Reportee 3'
        -- Reportee 4: All 'Product 4' and 'Product 2' given Region is not 'Region 5' and PRODUCT_CODE_2 is not 'Product B'
        WHEN (PRODUCT_CODE_1 IN ('Product 4', 'Product 2') AND Region <> 'Region 5') AND (PRODUCT_CODE_2 <> 'Product B') THEN 'Reportee 4'
        WHEN PRODUCT_CODE_2 IS NULL AND Region = 'Region 5' THEN 'Reportee 5'
        ELSE NULL
    END AS Reportee
    
FROM CustomerPurchases;

------------------------------------------------------------------------------------------------------------------------------------------
/* This CASE statement is insufficient as it returns NULL values in some places.
Every customer must have at least a manager or a reportee

Use COALESCE as follows: */
-----------------------------------------------------------------------------------------------------------------------------------------

SELECT
    CUSTOMER_ID,
    AMOUNT,
    PRODUCT_CODE_1,
    PRODUCT_CODE_2,
    Region,
    
    -- Initial Case statement for Manager
    COALESCE(
        CASE
            WHEN (PRODUCT_CODE_1 = 'Product 1' OR PRODUCT_CODE_2 IN ('Product B', 'Region 4'))
                 AND PRODUCT_CODE_1 NOT IN ('Product 3', 'Product 4') AND PRODUCT_CODE_2 IS NOT NULL THEN 'Manager A'
           
            WHEN (PRODUCT_CODE_1 NOT IN ('Product 3') AND PRODUCT_CODE_2 = 'Product D')
                 OR (PRODUCT_CODE_1 NOT IN ('Product 1') AND PRODUCT_CODE_2 NOT IN ('Product E')) THEN 'Manager B'
        
            WHEN (Region = 'Region 5' OR PRODUCT_CODE_2 = 'Product A')
                 AND PRODUCT_CODE_1 <> 'Product 5' THEN 'Manager C'
           
            ELSE NULL
        END,
        CASE
            -- New conditions to assign values when Manager is NULL
            WHEN PRODUCT_CODE_1 = 'Product 5' THEN 'Manager D'
            WHEN PRODUCT_CODE_2 = 'Product C' THEN 'Manager E'
            WHEN Region IS NULL THEN 'Manager F'
            ELSE 'Manager G'
        END
    ) AS Manager,
    
    -- Initial Case statement for Reportee
    COALESCE(
        CASE
            WHEN (PRODUCT_CODE_1 = 'Product 1' OR PRODUCT_CODE_2 = 'Product A') AND PRODUCT_CODE_2 IS NOT NULL AND PRODUCT_CODE_1 <> 'Product 3' THEN 'Reportee 1'
        
            WHEN PRODUCT_CODE_1 = 'Product 3' AND PRODUCT_CODE_2 <> 'Product A' THEN 'Reportee 2'

            WHEN PRODUCT_CODE_1 <> 'Product 5'  and PRODUCT_CODE_2 <> 'Product E' AND Region = 'Region 3' THEN 'Reportee 3'
         
            WHEN (PRODUCT_CODE_1 IN ('Product 4', 'Product 2') AND Region <> 'Region 5') AND (PRODUCT_CODE_2 not in ('Product B','Product E')) THEN 'Reportee 4'

            WHEN PRODUCT_CODE_2 IS NULL AND Region = 'Region 5' THEN 'Reportee 5'
           
            ELSE NULL
        END,
        CASE
            -- New conditions to assign values when Reportee is NULL
            WHEN PRODUCT_CODE_1 IS NULL THEN 'Reportee 6'
            WHEN PRODUCT_CODE_2 IS NULL THEN 'Reportee 7'
            WHEN PRODUCT_CODE_2 = 'Product B'  and Region = 'Region 2' THEN 'Reportee 8'
            WHEN PRODUCT_CODE_2 IS NULL THEN 'Reportee 7'
            ELSE NULL -- As few product combinations are handled by managers completely and don't need reportees for that
        END
    ) AS Reportee
FROM CustomerPurchases;
