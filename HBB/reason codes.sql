--Reason code

select  be_id,
        msisdn,
        imsi,
        status,
        operation_start,
        operation_end,
        start_timestamp,
        end_timestamp,
        CASE 
            when reason_code = 0 then 'Notificado por cliente'
            when reason_code = 1 then 'Notificado por cliente'
            when reason_code = 2 then 'suspensión por movilidad'
            when reason_code = 3 then 'suspensión por IMEI Lock'
            when reason_code = 4 then 'Barring por No Banda 28'
            when reason_code = 5 then 'Unbarring por No banda 28'
            else '0'
        end as 'Reason',
        sub_rc,
        transaction_id
From service.user_state

    Where msisdn = 5631888980
    
ORDER BY start_timestamp desc
