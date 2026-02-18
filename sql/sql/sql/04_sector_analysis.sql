-- Sector Employment Trends
-- Compares employment levels across major sectors over time

SELECT 
    YEAR(date) AS year,
    
    CASE
        WHEN VARIABLE_NAME ILIKE '%Manufacturing%' THEN 'Manufacturing'
        WHEN VARIABLE_NAME ILIKE '%Retail%' THEN 'Retail'
        WHEN VARIABLE_NAME ILIKE '%Construction%' THEN 'Construction'
        WHEN VARIABLE_NAME ILIKE '%Health Care%' THEN 'Health Care'
    END AS sector,
    
    AVG(value) AS avg_employment
FROM SNOWFLAKE_PUBLIC_DATA_FREE.PUBLIC_DATA_FREE.BUREAU_OF_LABOR_STATISTICS_EMPLOYMENT_TIMESERIES
WHERE 
    VARIABLE_NAME ILIKE 'State and Metro Employment: All Employees%'
    AND (
        VARIABLE_NAME ILIKE '%Manufacturing%'
        OR VARIABLE_NAME ILIKE '%Retail%'
        OR VARIABLE_NAME ILIKE '%Construction%'
        OR VARIABLE_NAME ILIKE '%Health Care%'
    )
GROUP BY year, sector
HAVING sector IS NOT NULL
ORDER BY year, sector;

