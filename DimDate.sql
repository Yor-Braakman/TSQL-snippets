CREATE OR ALTER VIEW [dbo].[DimDate]
AS 
/*Works on Fabric!*/
SELECT
    [datekey] = CONVERT(int, CONVERT(CHAR(8), DATEADD(DAY, [value], GETDATE()), 112)),
    [Date] = CONVERT(DATE, DATEADD(DAY, [value], GETDATE())),
    [Year] = YEAR(DATEADD(DAY, [value], GETDATE())),
    [Quarter] = DATEPART(QUARTER, DATEADD(DAY, [value], GETDATE())),
    [Year Month] = CONVERT(VARCHAR(10), CONCAT(YEAR(DATEADD(DAY, [value], GETDATE())), '-', FORMAT(DATEADD(DAY, [value], GETDATE()), 'MM'))),
    [Year Month Int] = CONVERT(INT, CONCAT(YEAR(DATEADD(DAY, [value], GETDATE())), FORMAT(DATEADD(DAY, [value], GETDATE()), 'MM'))),
    [Year Quarter] = CONVERT(VARCHAR(10), CONCAT(YEAR(DATEADD(DAY, [value], GETDATE())), '-Q', DATEPART(QUARTER, DATEADD(DAY, [value], GETDATE())))),
    [Year Week] = CONVERT(VARCHAR(10), CONCAT(YEAR(DATEADD(DAY, [value], GETDATE())), '-W', DATEPART(WEEK, DATEADD(DAY, [value], GETDATE())))),
    [Month Number] = MONTH(DATEADD(DAY, [value], GETDATE())),
    [Month Name] = CONVERT(VARCHAR(20), FORMAT(DATEADD(DAY, [value], GETDATE()), 'MMMM')),
    [Last Day Of Month] = CONVERT(DATE, EOMONTH(DATEADD(DAY, [value], GETDATE()))),
    [Week Number] = DATEPART(WEEK, DATEADD(DAY, [value], GETDATE())),
    --[Day Number In Week] = DATEPART(WEEKDAY, DATEADD(DAY, [value], GETDATE())), --use this if your week starts on sunday
    [Day Number In Week] = (DATEPART(WEEKDAY, DATEADD(DAY, [value], GETDATE())) + @@DATEFIRST - 2) % 7 + 1,
    [Day Number In Month] = DAY(DATEADD(DAY, [value], GETDATE())),
    [Day Number In Year] = DATEPART(DAYOFYEAR, DATEADD(DAY, [value], GETDATE())),
    [Workday] = CONVERT(VARCHAR(20), CASE WHEN DATENAME(WEEKDAY, DATEADD(DAY, [value], GETDATE())) IN ('Saturday', 'Sunday') THEN 'No' ELSE 'Yes' END),
    [Date Last Year] = CONVERT(DATE, DATEADD(YEAR, -1, DATEADD(DAY, [value], GETDATE()))),
    [Date Period Constant] = 0
FROM GENERATE_SERIES(-1 * DATEPART(DAYOFYEAR, GETDATE()) + 1 - 0 /*january this year, just change the 0 to 365 if you want to see last year as well*/
        , 365 * 4 + (365- DATEPART(DAYOFYEAR, GETDATE()))) /* end of the year in 4 years*/
