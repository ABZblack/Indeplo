--*************Berers*****************---
-- sesiones de datos y IMS

SELECT enodeb, cell_id, main_node, origin_host, pdp_address, called_station_id, 
round(sum(accounting_input_octets + accounting_output_octets)/1024/1024,2) AS Trafico, 
apn_aggregate_max_bitrate_dl/1000/1000 AS DL, 
apn_aggregate_max_bitrate_ul/1000/1000 AS UL, 
cast(calling_party_imsi as string) as IMSI, 
cast(calling_party_number as string) as DN, event_hour, cast(imei as string) as IMEI
FROM sgw.sgw_cdrs
WHERE
calling_party_imsi IN  (334140127397627) and  event_hour BETWEEN 2022091800 AND 2022092023
GROUP BY 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13
ORDER BY event_hour DESC;
