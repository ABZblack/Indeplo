--voz

select cust_local_start_date, cust_local_end_date, service_type, service_flow, calling_party_number, called_party_number, result_code, result_reason, actual_usage, rate_usage, calling_roam_info,
calling_home_country_code, called_home_country_code, calling_party_imsi, imei, access_prefix, main_offering_id, free_unit_id_1,acct_balance_id_1
from bss.cbs_cdrs_voice
where calling_party_number = ${DN12} --12digitos
and be_id= ${BE_ID}
and event_hour between ${Fecha_inicio} and ${Fecha_fin}
order by cust_local_start_date asc;


--SMS

select cust_local_start_date, cust_local_end_date, service_type, service_flow, calling_party_number, called_party_number, result_reason, result_code, sms_id,actual_usage, rate_usage, calling_roam_info,
calling_party_imsi, imei, main_offering_id, free_unit_id_1, acct_balance_id_1
from bss.cbs_cdrs_sms
where calling_party_number = ${DN12} --12 digitos
and be_id=${BE_ID}
and event_hour between ${Fecha_inicio} and ${Fecha_fin}
order by cust_local_start_date asc;



--Datos

select cust_local_start_date, cust_local_end_date, service_type, calling_party_number, result_code, result_reason, actual_usage, rate_usage, calling_roam_info, calling_home_country_code, calling_roam_country_code,
calling_party_imsi,imei, access_network_address, apn, rating_group, main_offering_id, free_unit_id_1, acct_balance_id_1
from bss.cbs_cdrs_data
where calling_party_number = ${DN12} --12 digitos
and be_id= ${BE_ID}
and event_hour between ${Fecha_inicio} and ${Fecha_fin}
order by cust_local_start_date asc;
