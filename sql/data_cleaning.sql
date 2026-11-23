-- Data Cleaning

-- -------------
-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Remove any columns or rows that we dont need
-- 4. Edit Column and Data types
-- 5. Null Values or Blank Values
-- -------------

-- ** Setup for Staging Table

SELECT *
FROM trading_journal;

CREATE TABLE journal_staging2
LIKE trading_journal;

SELECT *
FROM journal_staging2;

INSERT journal_staging2
SELECT *
FROM trading_journal;


-- ---------------
-- 1. Remove Duplicates

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY Date, `Net Profit`, Duration) AS row_num 
FROM journal_staging2
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1; -- No Duplicate

-- ---------------
-- 2. Standardize the data

SELECT *
FROM journal_staging2;

-- a. No
WITH duplicate_no AS
(
SELECT No, ROW_NUMBER() OVER(PARTITION BY No) AS row_num
FROM journal_staging2
)
SELECT *
FROM duplicate_no
WHERE row_num >1;

-- b. Date

SELECT
    STR_TO_DATE(`Date`, '%W, %M %e, %Y') AS trade_date, Date
FROM journal_staging2;


UPDATE journal_staging2
SET Date = STR_TO_DATE(`Date`, '%W, %M %e, %Y');


-- c. Session

SELECT DISTINCT TRIM(SUBSTRING_INDEX(`Session Open position`, '. ', -1))
FROM journal_staging2;

UPDATE journal_staging2
SET `Session Open position` = TRIM(SUBSTRING_INDEX(`Session Open position`, '. ', -1));


SELECT DISTINCT `Session Open position`,
CASE 
	WHEN `Session Open position` =  'London Overlap New York' THEN 'New York Open'
    WHEN `Session Open position` =  'New York' THEN 'New York Afternoon'
    WHEN `Session Open position` =  'Tokyo' THEN 'Asia'
    ELSE `Session Open position`
END
FROM journal_staging2;

UPDATE journal_staging2
SET `Session Open position` = 
CASE 
	WHEN `Session Open position` =  'London Overlap New York' THEN 'New York Open'
    WHEN `Session Open position` =  'New York' THEN 'New York Afternoon'
    WHEN `Session Open position` =  'Tokyo' THEN 'Asia'
    ELSE `Session Open position`
END;

-- d. Symbol
SELECT DISTINCT Symbol
FROM journal_staging2;

UPDATE journal_staging2
SET Symbol = 'USTEC'
WHERE Symbol = 'Nasdaq';

-- d. Fees, Commission, Profit, Net Profit
SELECT *
FROM journal_staging2;

SELECT 
`Fees`, 
`Commission`, 
`Profit`, 
`Net Profit`,
TRIM(SUBSTRING_INDEX(`Fees`, '$',-1)), 
TRIM(SUBSTRING_INDEX(`Commission`, '$',-1)), 
TRIM(SUBSTRING_INDEX(`Profit`, '$',-1)), 
TRIM(SUBSTRING_INDEX(`Net Profit`, '$',-1))
FROM journal_staging2;

UPDATE journal_staging2
SET
    `Fees` = TRIM(SUBSTRING_INDEX(`Fees`, '$', -1)),
    `Commission` = TRIM(SUBSTRING_INDEX(`Commission`, '$', -1)),
    `Profit` = TRIM(SUBSTRING_INDEX(`Profit`, '$', -1)),
    `Net Profit` = TRIM(SUBSTRING_INDEX(`Net Profit`, '$', -1));
    

-- e. TF
SELECT DISTINCT TF
FROM journal_staging2;

UPDATE journal_staging2
SET TF = '1m'
WHERE TF = '1M';


UPDATE journal_staging2
SET TF = '5Min'
WHERE TF = '5M';

-- f. Duration

SELECT duration, TIME_TO_SEC(duration) AS duration_seconds
FROM journal_staging2;

ALTER TABLE journal_staging2
ADD COLUMN duration_seconds INT;

-- -----------------------
-- 3. Remove Column and Rows we dont need

SELECT  *
FROM journal_staging2;

-- a. Remove Columns
ALTER TABLE journal_staging2
DROP COLUMN `Swap`,
DROP COLUMN `Risk`,
DROP COLUMN `Chart`,
DROP COLUMN `Notes`;

-- b. Remove Rows
DELETE FROM journal_staging2
WHERE No = 2;


-- -----------------------
-- 4. Edit Column and Data Types

SELECT  *
FROM journal_staging2;

ALTER TABLE journal_staging2
CHANGE COLUMN `No` trade_id INT,
CHANGE COLUMN `Date` trade_date DATE,
CHANGE COLUMN `Month` trade_month VARCHAR(20),
CHANGE COLUMN `Day` weekday VARCHAR(20),
CHANGE COLUMN `Duration` duration VARCHAR(20),
CHANGE COLUMN `Session Open position` session VARCHAR(30),
CHANGE COLUMN `Symbol` symbol  VARCHAR(20),
CHANGE COLUMN `Fees` fees DECIMAL(12,2),
CHANGE COLUMN `Commission` commission DECIMAL(12,2),
CHANGE COLUMN `Profit` profit DECIMAL(12,2),
CHANGE COLUMN `Net Profit`  net_profit DECIMAL(12,2),
CHANGE COLUMN `Outcome` outcome VARCHAR(20),
CHANGE COLUMN `Confluence` confluence VARCHAR(200),
CHANGE COLUMN `TF` time_frame VARCHAR(20),
CHANGE COLUMN `Score` score DECIMAL(12,2),
CHANGE COLUMN `Setup` setup_grade VARCHAR(20),
CHANGE COLUMN `RR` risk_reward DECIMAL(12,2),
CHANGE COLUMN `Remarks` remarks VARCHAR(30),
CHANGE COLUMN `Closed by` closed_by VARCHAR(20),
CHANGE COLUMN `Type` posision_type VARCHAR(20);



-- -------------------------








