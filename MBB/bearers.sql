--*************Bearers*****************---
-- sesiones de datos y IMS

----------------------------------------------- IMS-------

SELECT enodeb,
       cell_id,
       called_station_id,
       round((accounting_input_octets + accounting_output_octets)/1024.0/1024.0,2) AS Trafico,
       calling_party_imsi,
       calling_party_number,
       change_time,
       event_hour,
       event_timestamp,
       imei,
       mcc_tai,
       mnc_tai,
       qos_class_identifier,
       qos_class_identifier_value
FROM sgw.sgw_cdrs
WHERE
--calling_party_imsi IN (334140169514164)  --IMSI
calling_party_number IN (525635290990) -- DN 12 digitos
and event_month >= 202312
AND event_hour >= 2023120100
ORDER BY event_hour DESC;
