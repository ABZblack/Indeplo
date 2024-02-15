
WITH 

cdrs AS
(
    SELECT event_hour, event_day, msisdn, imsi, calling_roam_info,
           CASE WHEN calling_roam_info = 334140 THEN 'Huella Altán'
                WHEN calling_roam_info IN (334020,334030,33403,334050,334090) THEN 'Roaming Nacional'
           END AS red, 
           llave, cell_id, ifnull(SUM(traf_huella_mb), 0) AS consume_HA_MB,
    ifnull(SUM(traf_roaming_mb),0) AS consume_RN_MB, ifnull(SUM(traf_huella_mb+traf_roaming_mb),0) AS consume_T_MB
    FROM
    (
    
    SELECT calling_party_number AS msisdn, calling_party_imsi AS imsi, event_hour, CAST(event_hour/100 AS INT) AS event_day, calling_roam_info,
           zeroifnull(enodeb) + quotient(zeroifnull(cell_id),10)/10 AS llave, cell_id, ROUND(ifnull(SUM(rate_usage/1024/1024),0),2) AS traf_huella_mb,
           0 AS traf_roaming_mb
    FROM bss.cbs_cdrs_data
    WHERE billing_month >= CAST(from_timestamp(date_sub(now(),3),'yyyyMM') AS BIGINT)
    AND event_hour >= CAST(from_timestamp(date_sub(now(),3),'yyyyMMddHH') AS BIGINT)
    AND calling_party_number in (${msisdn_12_digitos})
    AND calling_roam_info IN (334140)
    GROUP BY 1,2,3,4,5,6,7
    
    UNION ALL
    
    SELECT calling_party_number AS msisdn, calling_party_imsi AS imsi, event_hour, CAST(event_hour/100 AS INT) AS event_day, calling_roam_info,
           CASE WHEN calling_roam_info = 33403 AND length(calling_cell_id) = 15 THEN cast(strright(calling_cell_id,10) AS BIGINT) --TEMM
                WHEN calling_roam_info = 33403 AND length(calling_cell_id) <> 15 THEN cast(concat(substr(calling_cell_id,6,10), -- TEMM
           conv(strleft(conv(strright(calling_cell_id,9),10,16),(length(conv(strright(calling_cell_id,9),10,16))-2)), 16,10), --TEMM
           conv(strright(conv(strright(calling_cell_id,9),10,16),2), 16,10)) as BIGINT) --TEMM
                WHEN length(calling_cell_id) = 16 THEN CAST(concat(CAST(cast(substr(calling_cell_id, 12, 5) AS INT) AS STRING), CAST(cast(substr(calling_cell_id,7,5) AS INT) AS STRING)) AS BIGINT)
                WHEN length(calling_cell_id) = 32 THEN CAST(concat(CAST(cast(substr(calling_cell_id, 24, 9) AS INT) AS STRING), CAST(cast(substr(calling_cell_id,7,10) AS INT) AS STRING)) AS BIGINT)
           END AS llave, cell_id,
           0 AS traf_huella_mb,
           ROUND(ifnull(sum(rate_usage/1024/1024),0),2) AS traf_roaming_mb
    FROM bss.cbs_cdrs_data
    WHERE billing_month >= CAST(from_timestamp(date_sub(now(),3),'yyyyMM') AS BIGINT)
    AND event_hour >= CAST(from_timestamp(date_sub(now(),3),'yyyyMMddHH') AS BIGINT)
    AND calling_party_number in (${msisdn_12_digitos})
    AND calling_roam_info IN (334020,334030,33403,334050,334090)
    GROUP BY 1,2,3,4,5,6,7
    ) AS a
    GROUP BY event_hour, event_day, msisdn, imsi, calling_roam_info, llave, cell_id
),

cat_sites AS
(
    SELECT llave, estado, municipio, site_id, tx_output, coverage_mbb, carrier, site_name, latitude, longitude
    FROM
    (
       SELECT key_id AS llave,  lower(state) AS estado, lower(town) AS municipio, 0 site_id, 'na' AS tx_output,
              'TELCEL' AS carrier, market AS site_name, latitude, longitude, MAX(coverage_mbb) AS coverage_mbb 
        FROM catalog.national_roaming_sites 
        GROUP BY 1, 2,3,4,5,6,7,8,9
        
        UNION ALL
        
        SELECT llave_temm AS llave, estado, municipality_name AS municipio, 0 site_id, 'na' AS tx_output, 'TEMM' AS carrier, cell_name AS site_name, latitude, longitude, coverage_mbb 
        FROM
        (
            SELECT DISTINCT enodeb_id, cell_id, CASE WHEN technology ILIKE '%3g%' THEN lac_3g WHEN technology ILIKE '%lte%' THEN (tac_4g*10+3) END as tac, coverage_mbb
            , CASE WHEN technology ilike '%3g%' THEN key_id ELSE cast(concat(cast(tac_4g as STRING), enodeb_id, cell_id) as BIGINT) END as llave_temm, 
             state_name AS estado,
               lower(municipality_name) AS municipality_name, latitude , longitude, cell_name
            FROM catalog.national_roaming_temm
        ) AS TEM
        
        UNION ALL
        
        SELECT DISTINCT zeroifnull(enodeb) + quotient(zeroifnull(cell_id),10)/10 as llave, lower(state_name) AS estado, lower(municipality_name) AS municipio, site_id, tx_output,
               'ALTAN' AS carrier, site_name, site_latitude AS latitude, site_longitude AS longitude, 'Huella' AS coverage_mbb
        FROM catalog.catalog_cell
    ) AS carr
),

users2 AS
(
    SELECT msisdn, imsi, event_hour, event_day, calling_roam_info, red, llave, cell_id, consume_HA_MB, consume_RN_MB, consume_T_MB, 
           estado, municipio, site_id, tx_output, coverage_mbb, carrier, site_name, latitude, longitude
    FROM
    (
    SELECT event_hour, event_day, msisdn, imsi, calling_roam_info, red, consume_HA_MB, consume_RN_MB, consume_T_MB,
           estado, municipio, site_id, tx_output, coverage_mbb, carrier, site_name, latitude, longitude, cdrs.llave, cell_id,
           CASE WHEN red = 'Huella Altán' AND carrier = 'ALTAN' THEN 1
                WHEN red = 'Huella Altán' AND carrier IS NULL THEN 1
                WHEN red = 'Roaming Nacional' AND carrier = 'TEMM' THEN 1
                WHEN red = 'Roaming Nacional' AND carrier = 'TELCEL' THEN 1
                WHEN red = 'Roaming Nacional' AND carrier IS NULL THEN 1
                WHEN red = 'Huella Altán' AND carrier = 'TEMM' THEN 0
            END AS vali
    FROM cdrs
    LEFT OUTER JOIN cat_sites
    ON (cdrs.llave = cat_sites.llave)
    ) AS a
    WHERE vali = 1
),

busy AS
(
SELECT  `key` AS llave, service_state, ue_dl_throughput, rrc_max, blocked_day, prb_dl, event_day
FROM service.oss_sectors_busy_hour
WHERE event_month >=CAST(from_timestamp(date_sub(now(),3),'yyyyMM') AS BIGINT)
AND event_day >= CAST(from_timestamp(date_sub(now(),3),'yyyyMMdd') AS BIGINT)
),

users1 AS
(
SELECT msisdn, imsi, event_hour, users2.event_day, calling_roam_info, red, users2.llave, cell_id, consume_HA_MB, consume_RN_MB, consume_T_MB, 
           estado, municipio, site_id, tx_output, coverage_mbb, carrier, site_name, latitude, longitude, 
           CASE WHEN red = 'Roaming Nacional' THEN 'No Aplica' ELSE service_state END AS service_state,
           CASE WHEN red = 'Roaming Nacional' THEN 0 ELSE ue_dl_throughput END AS ue_dl_throughput,
           CASE WHEN red = 'Roaming Nacional' THEN 0 ELSE rrc_max END AS rrc_max,
           CASE WHEN red = 'Roaming Nacional' THEN 0 ELSE blocked_day END AS blocked_day,
           CASE WHEN red = 'Roaming Nacional' THEN 0 ELSE prb_dl END AS prb_dl
FROM users2
LEFT OUTER JOIN busy
ON (
      cast( concat_ws("_", cast(site_id as STRING),     CASE
      WHEN quotient(cell_id,10) = 0 AND cell_id%3 = 1 THEN  '1'
      WHEN quotient(cell_id,10) = 0 AND cell_id%3 = 2 THEN  '2'
      WHEN quotient(cell_id,10) = 0 AND cell_id%3 = 0 THEN  '3'
      WHEN quotient(cell_id,10) = 9 AND cell_id%3 = 1 THEN  '4'
      WHEN quotient(cell_id,10) = 9 AND cell_id%3 = 2 THEN  '5'
      WHEN quotient(cell_id,10) = 9 AND cell_id%3 = 0 THEN  '6'
      WHEN quotient(cell_id,10) <= 4 AND cell_id%10%3 = 1 THEN  '1' 
      WHEN quotient(cell_id,10) <= 4 AND cell_id%10%3 = 2 THEN  '2'
      WHEN quotient(cell_id,10) <= 4 AND cell_id%10%3 = 0 THEN  '3'
      WHEN quotient(cell_id,10) <= 8 AND cell_id%10%3 = 1 THEN  '4'
      WHEN quotient(cell_id,10) <= 8 AND cell_id%10%3 = 2 THEN  '5'
      WHEN quotient(cell_id,10) <= 8 AND cell_id%10%3 = 0 THEN  '6'
      ELSE '0' 
      END) AS STRING) 
      = busy.llave
   )
AND users2.event_day = busy.event_day
),

ofer AS 
(
    SELECT sub_id, offer_seq, offer_id, primary_flag, eff_date, mod_date
    FROM
    (
        SELECT sub_id, offer_seq, offer_id, primary_flag, eff_date, mod_date, row_number() OVER (PARTITION BY sub_id ORDER BY mod_date DESC) as ndesc
        FROM bss.crm_offers
        WHERE offer_id IN(1900000023, 1900000016)
    ) AS a
    WHERE ndesc = 1
),

crm AS
(
    SELECT msisdn, imsi, sub_id
    FROM
        ( 
          SELECT be_id,(520000000000+msisdn) AS msisdn,imsi,sub_id,mod_date, active_date,
                 ROW_NUMBER() OVER (PARTITION BY msisdn ORDER BY mod_date DESC) AS index
          FROM bss.crm_subscriber
        ) AS a
    WHERE index = 1
),

downs AS
(
	SELECT msisdn, ofer.mod_date AS date_downspeed, (eff_date - INTERVAL 6 HOUR) AS activation_date_top_offender,
	        CASE WHEN ofer.offer_id = 1900000023 THEN 'MBB-DS-1S Top Offenders RN 2 SS 345 kbps' 
	             WHEN ofer.offer_id = 1900000016 THEN'MBB-DS-1.5S Top Offenders RN 1 SS 1.5 mbps'
	        END AS top_offender
	FROM ofer 
	INNER JOIN crm
	ON (ofer.sub_id = crm.sub_id)
)

SELECT users1.msisdn, imsi, event_hour, event_day, calling_roam_info, red, consume_HA_MB, consume_RN_MB, consume_T_MB, 
           estado, municipio, site_id, tx_output, coverage_mbb, carrier, site_name, latitude, longitude, 
           service_state, ue_dl_throughput, rrc_max, blocked_day, prb_dl,
           CASE WHEN top_offender IS NULL THEN 'Without Offer' ELSE top_offender END AS top_offender,
           CASE WHEN activation_date_top_offender IS NULL THEN 'Without Offer' ELSE activation_date_top_offender END AS activation_date_top_offender
FROM users1
LEFT OUTER JOIN downs
ON (users1.msisdn = downs.msisdn);
