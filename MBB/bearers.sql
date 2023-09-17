--*************Bearers*****************---
-- sesiones de datos y IMS

SELECT enodeb,
       cell_id,
       called_station_id,
       round(sum(accounting_input_octets + accounting_output_octets)/1024/1024,2) AS Trafico,
       calling_party_imsi,
       calling_party_number,
       event_timestamp,
       event_hour,
       imei,
       mcc_tai,
       mnc_tai,
       qos_class_identifier,
       qos_class_identifier_value
FROM sgw.sgw_cdrs
WHERE
calling_party_imsi IN (334140143623531)  --IMSI
--calling_party_number IN (528137147550) -- DN 12 digitos
and event_month = 202309
AND event_hour BETWEEN 2023091200 and 2023091323

GROUP BY 1,2,3,5,6,7,8,9,10,11,12,13
ORDER BY event_hour DESC;
