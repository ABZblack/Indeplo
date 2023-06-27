SELECT cust_local_start_date,
enodeb,
cust_local_end_date,
service_type,
calling_party_number,
result_code,
result_reason,
cast(rate_usage as real)/1024/1024 as consumo_MB,
calling_roam_info,
calling_home_country_code,
calling_roam_country_code,
calling_party_imsi,
imei,
access_network_address,
apn,
rating_group,
main_offering_id,
free_unit_id_1,
acct_balance_id_1,
free_unit_type_1
FROM bss.cbs_cdrs_data
--WHERE calling_party_imsi = 	334140143513383
where calling_party_number = 527716302574
and be_id= 251
and billing_month = 202306
and event_hour BETWEEN 2023061900 and 2023112223
order by cust_local_start_date desc;
