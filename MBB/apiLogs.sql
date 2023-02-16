--api ilogs

SELECT *--operation, log_timestamp,order_id, subscriber_id, apiparent
FROM apigee.apigee_logs
WHERE 
event_hour between 2022080900 and 2023042500
and be_id IN (142)
and subscriber_id in ( 5581613828) --DN a 10 digitos
ORDER BY event_hour DESC;
