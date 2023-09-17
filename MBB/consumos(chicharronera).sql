
SELECT  event_hour,
        enodeb,
        cell_id,
        calling_party_number,
        calling_party_imsi,
        sum(cast(rate_usage as real)/1024/1024) as consumo_MB,
        rating_group,
        fu_charging_offer_id,
        calling_roam_info,
        free_unit_type_1,
        apn
FROM bss.cbs_cdrs_data
WHERE 
--calling_party_imsi = 334140015292897
calling_party_number = 525534643482
and be_id= 143
and billing_month = 202309
and event_hour BETWEEN 2023091400 and 2023112223
GROUP BY 1,2,3,4,5,7,8,9,10,11
ORDER BY event_hour DESC
;

ORDER BY event_hour DESC;
