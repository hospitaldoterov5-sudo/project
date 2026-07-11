#Задание 1 и 3 ---------------------------
SELECT *,
    total_sum * 1.0 / SUM(total_sum) OVER (PARTITION BY quater) AS share_in_quarter
FROM (
    SELECT  
        t.ID_client,

        DATE_FORMAT(t.date_new,'%Y-%m') as month_date,

        SUM(t.Sum_payment) as total_sum,
        AVG(t.Sum_payment) as avg_pay,
        COUNT(*) as count_operations,

        c.AGE,

        CASE  
            WHEN c.AGE BETWEEN 0 AND 10 THEN '0-10'
            WHEN c.AGE BETWEEN 11 AND 20 THEN '11-20'
            WHEN c.AGE BETWEEN 21 AND 30 THEN '21-30'
            WHEN c.AGE BETWEEN 31 AND 40 THEN '31-40'
            WHEN c.AGE BETWEEN 41 AND 50 THEN '41-50'
            WHEN c.AGE BETWEEN 51 AND 60 THEN '51-60'
            WHEN c.AGE BETWEEN 61 AND 70 THEN '61-70'
            WHEN c.AGE BETWEEN 71 AND 80 THEN '71-80'
            WHEN c.AGE BETWEEN 81 AND 90 THEN '81-90'
            WHEN c.AGE BETWEEN 91 AND 100 THEN '91-100'
            ELSE 'NA'
        END AS age_group,

        CASE
            WHEN DATE_FORMAT(t.date_new,'%m') BETWEEN 1 AND 3 THEN 'Q1'
            WHEN DATE_FORMAT(t.date_new,'%m') BETWEEN 4 AND 6 THEN 'Q2'
            WHEN DATE_FORMAT(t.date_new,'%m') BETWEEN 7 AND 9 THEN 'Q3'
            WHEN DATE_FORMAT(t.date_new,'%m') BETWEEN 10 AND 12 THEN 'Q4'
        END AS quater

    FROM transactions t
    JOIN customer c 
        ON c.Id_client = t.ID_client

    WHERE t.date_new >= '2015-06-01' 
      AND t.date_new <  '2016-06-01'

    GROUP BY 
        t.ID_client, 
        month_date, 
        age_group, 
        c.AGE, 
        quater
) base;

#Задание 2 -----------------

SELECT 
    DATE_FORMAT(t.date_new,'%Y-%m') AS month_date,
    AVG(t.Sum_payment) AS avg_check,
    COUNT(*) AS total_tx,
    COUNT(DISTINCT t.ID_client) AS clients_cnt,
    SUM(t.Sum_payment) AS total_sum,
#доля операций от года
    COUNT(*) * 1.0 / SUM(COUNT(*)) OVER () AS tx_share_year,
#доля суммы от года
    SUM(t.Sum_payment) * 1.0 / SUM(SUM(t.Sum_payment)) OVER () AS sum_share_year,
#гендер
    COALESCE(c.gender, 'NA') AS gender,
    COUNT(*) AS gender_tx,
    SUM(t.Sum_payment) AS gender_sum,
#по операциям внутри месяца
    COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (PARTITION BY DATE_FORMAT(t.date_new,'%Y-%m')) AS gender_tx_share,
#по сумме внутри месяца
    SUM(t.Sum_payment) * 1.0 / SUM(SUM(t.Sum_payment)) OVER (PARTITION BY DATE_FORMAT(t.date_new,'%Y-%m')) AS gender_sum_share
FROM transactions t
JOIN customer c 
    ON c.Id_client = t.ID_client
WHERE t.date_new >= '2015-06-01' AND t.date_new <  '2016-06-01'
GROUP BY month_date, gender
ORDER BY month_date, gender