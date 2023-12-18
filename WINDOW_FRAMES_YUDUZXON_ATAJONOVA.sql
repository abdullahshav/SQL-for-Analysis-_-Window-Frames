SELECT time_id, day_name, calendar_week_number, sales_amount,
    SUM(sales_amount) OVER (PARTITION BY calendar_week_number ORDER BY time_id RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_sum,
	    CASE
        WHEN day_number_in_week = 1 THEN
            ROUND(AVG(sales_amount) OVER (ORDER BY time_id RANGE BETWEEN INTERVAL '2' DAY PRECEDING AND INTERVAL '1' DAY FOLLOWING), 2)
        WHEN day_number_in_week = 5 THEN
            ROUND(AVG(sales_amount) OVER (ORDER BY time_id RANGE BETWEEN INTERVAL '1' DAY PRECEDING AND INTERVAL '2' DAY FOLLOWING), 2)
        ELSE
            ROUND(AVG(sales_amount) OVER (ORDER BY time_id RANGE BETWEEN INTERVAL '1' DAY PRECEDING AND INTERVAL '1' DAY FOLLOWING), 2)
    END AS centered_3_day_avg
FROM (
    SELECT t.time_id, t.day_number_in_week, t.calendar_week_number, t.day_name, SUM(amount_sold) AS sales_amount
    FROM sh.sales
	JOIN sh.times t USING(time_id)
    WHERE t.calendar_week_number IN (49, 50, 51) AND EXTRACT(YEAR FROM t.time_id) = '1999'
    GROUP BY t.time_id, t.calendar_week_number, t.day_name
	ORDER BY time_id
) AS subquery;
