-- National Unemployment Trend (1976–2025)

SELECT 
    YEAR(date) AS year,
    AVG(value) * 100 AS avg_unemployment_rate
FROM SNOWFLAKE_PUBLIC_DATA_FREE.PUBLIC_DATA_FREE.BUREAU_OF_LABOR_STATISTICS_EMPLOYMENT_TIMESERIES
WHERE VARIABLE_NAME = 'Local Area Unemployment: Unemployment Rate, Not seasonally adjusted, Monthly'
GROUP BY year
ORDER BY year;

