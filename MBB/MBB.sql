-- KI --

SELECT * FROM catalog.catalog_tripleta_sim WHERE
IMSI in (334140004408159
);



---**************************- BEARERS ***************************

SELECT enodeb,
       cell_id,
       main_node,
       origin_host,
      -- route_record,
      pdp_address,
      -- ggsn_address,
       --sgsn_address,
       called_station_id,
       round(sum(accounting_input_octets + accounting_output_octets)/1024/1024,2) AS Trafico,
       cast(calling_party_imsi as string) as IMSI,
       cast(calling_party_number as string) as DN,
       apn_aggregate_max_bitrate_dl/1000/1000 AS DL,
       apn_aggregate_max_bitrate_ul/1000/1000 AS UL,
       load_processing_timestamp,
       cast(imei as string) as IMEI
FROM sgw.sgw_cdrs
--FROM sgw.sgw_cdrs_affirmed
WHERE
calling_party_imsi IN (334140128822029)
--calling_party_number IN (528137147550)
--cast(imei as string) like "8694260419985%"
--and imei is not null
--and apn_aggregate_max_bitrate_dl is not null
--and imei is not null
--main_node = "pgwnl104"
--called_station_id like "%hbb.altan.com.oxio.mnc140.mcc334.gprs%"
--and called_station_id like "%ims%"
AND load_processing_timestamp BETWEEN '2022-09-08 00:00:00' AND '2023-08-30 23:59:00'
--and accounting_input_octets <> 0
--and accounting_output_octets <> 0
GROUP BY 1,
         2,
         3,
         4,
         5,
         6,
         --7,
         8,
         9,
         10,
         11,
         12,
         13
        -- 14,
         --15,
         --16
ORDER BY load_processing_timestamp DESC;
