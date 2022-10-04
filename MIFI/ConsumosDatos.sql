SELECT calling_party_imsi, calling_party_number, cust_local_start_date,
cast(rate_usage AS REAL)/1024/1024 AS
Consumo_MB, mcc_tai, mnc_tai,
calling_roam_info, enodeb, cell_id
FROM bss.cbs_cdrs_data 
WHERE 
billing_month = ${mes}
and event_hour BETWEEN ${Fecha_Inicio} and ${Fecha_Fin}
and be_id = ${BE_ID} 
and calling_party_imsi = ${IMSI}
ORDER BY event_hour DESC
