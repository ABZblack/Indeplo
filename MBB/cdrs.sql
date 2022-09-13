-Voz

select cust_local_start_date, cust_local_end_date, service_type, service_flow, calling_party_number, called_party_number, result_code, result_reason, actual_usage, rate_usage, calling_roam_info,
calling_home_country_code, called_home_country_code, calling_party_imsi, imei, access_prefix, main_offering_id, free_unit_id_1,acct_balance_id_1
from bss.cbs_cdrs_voice
where calling_party_number = 525515614005
and be_id= 156
and billing_month in (202209)
order by cust_local_start_date asc;


--SMS

select cust_local_start_date, cust_local_end_date, service_type, service_flow, calling_party_number, called_party_number, result_reason, result_code, sms_id,actual_usage, rate_usage, calling_roam_info,
calling_party_imsi, imei, main_offering_id, free_unit_id_1, acct_balance_id_1
from bss.cbs_cdrs_sms
where calling_party_number = 527296336888 
and be_id= 175 
and billing_month in (202204)
order by cust_local_start_date asc;



--Datos

select cust_local_start_date, cust_local_end_date, service_type, calling_party_number, result_code, result_reason, actual_usage, rate_usage, calling_roam_info, calling_home_country_code, calling_roam_country_code,
calling_party_imsi,imei, access_network_address, apn, rating_group, main_offering_id, free_unit_id_1, acct_balance_id_1
from bss.cbs_cdrs_data
where calling_party_number = 526567658361
and be_id= 246
and billing_month in ( 202111,202112)
order by cust_local_start_date asc;
