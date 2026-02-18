-- State-Level Unemployment Analysis (Last 12 Months)
-- Calculates average unemployment rate by state using the most recent 12 months of data

WITH state_lookup AS (
    SELECT * FROM VALUES
    ('01','Alabama'),('02','Alaska'),('04','Arizona'),('05','Arkansas'),('06','California'),
    ('08','Colorado'),('09','Connecticut'),('10','Delaware'),('12','Florida'),('13','Georgia'),
    ('15','Hawaii'),('16','Idaho'),('17','Illinois'),('18','Indiana'),('19','Iowa'),
    ('20','Kansas'),('21','Kentucky'),('22','Louisiana'),('23','Maine'),('24','Maryland'),
    ('25','Massachusetts'),('26','Michigan'),('27','Minnesota'),('28','Mississippi'),('29','Missouri'),
    ('30','Montana'),('31','Nebraska'),('32','Nevada'),('33','New Hampshire'),('34','New Jersey'),
    ('35','New Mexico'),('36','New York'),('37','North Carolina'),('38','North Dakota'),('39','Ohio'),
    ('40','Oklahoma'),('41','Oregon'),('42','Pennsylvania'),('44','Rhode Island'),('45','South Carolina'),
    ('46','South Dakota'),('47','Tennessee'),('48','Texas'),('49','Utah'),('50','Vermont'),
    ('51','Virginia'),('53','Washington'),('54','West Virginia'),('55','Wisconsin'),('56','Wyoming')
    AS t(state_code, state_name)
),

latest_date AS (
    SELECT MAX(date) AS max_date
    FROM SNOWFLAKE_PUBLIC_DATA_FREE.PUBLIC_DATA_FREE.BUREAU_OF_LABOR_STATISTICS_EMPLOYMENT_TIMESERIES
    WHERE VARIABLE_NAME = 'Local Area Unemployment: Unemployment Rate, Not seasonally adjusted, Monthly'
)

SELECT
    s.state_name,
    AVG(b.value) * 100 AS avg_unemployment_rate_pct
FROM SNOWFLAKE_PUBLIC_DATA_FREE.PUBLIC_DATA_FREE.BUREAU_OF_LABOR_STATISTICS_EMPLOYMENT_TIMESERIES b
JOIN state_lookup s
    ON LPAD(SPLIT_PART(b.GEO_ID, '/', 2), 2, '0') = s.state_code
CROSS JOIN latest_date ld
WHERE b.VARIABLE_NAME = 'Local Area Unemployment: Unemployment Rate, Not seasonally adjusted, Monthly'
AND b.date >= DATEADD(month, -11, ld.max_date)
AND LENGTH(b.GEO_ID) <= 9   -- Keeps state-level data only (excludes metro)
GROUP BY s.state_name
ORDER BY avg_unemployment_rate_pct DESC;

