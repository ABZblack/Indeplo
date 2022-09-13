-- *** CONSULTA CONSUMOS DE LA LÍNEA  ****


SELECT (downlink/1024)/1024 AS Trafico_Bajada, (uplink/1024)/1024 AS Trafico_subida, calling_party_imsi, calling_party_number, enodeb, cell_id, event_hour,
concat(cast(enodeb as string), '.', cast(cell_id as string)) as SITIO
--fROM sgw.sgw_cdrs_aggregates
frOM sgw.sgw_cdrs_affirmed_aggregates
WHERE calling_party_imsi in(${IMSI})
AND event_hour between ${fecha_incio} and ${fecha_fin}
ORDER BY event_hour DESC;


-- *** COMNSULTA INFORMACIÓN DEL SITIO (BUSY HOUR)

select site_name, service_state, municipality, state, volume_dl, ue_dl_throughput, sector, cell_sector, site_id, enodeb, latitude, longitude
from service.oss_sectors_busy_hour
where event_month = ${evetnt_month} 
and enodeb in ( ${sitio} )
--and site_id in (910200)
and event_day = ${fecha}



-- *** CONSUMOS DE UN SITIO, EN AFFIRMED Y NOKIA ***


SELECT * FROM ( SELECT event_hour, enodeb, cell_id, core, enodeb_group, SUM(ctd_users) AS ctd_users, SUM(consumo_GB) AS consumo_GB
FROM (
  
SELECT event_hour, enodeb, cell_id,
zeroifnull(enodeb) + quotient(zeroifnull(cell_id),10)/10 as 'enodeb_group',
'nokia'AS core, COUNT(DISTINCT calling_party_imsi) AS ctd_users,
SUM((accounting_input_octets+accounting_output_octets)/1024/1024/1024) AS consumo_GB
FROM sgw.sgw_cdrs
WHERE event_month IN(${mes})
AND event_hour BETWEEN ${Hora_inicio} AND ${Hora_fin}
AND enodeb IN (${enodeb})
GROUP BY 1,2,3,4,5
UNION ALL
SELECT event_hour, enodeb, cell_id,
zeroifnull(enodeb) + quotient(zeroifnull(cell_id),10)/10 as 'enodeb_group',
'affirmed'AS core, COUNT(DISTINCT calling_party_imsi) AS ctd_users,
SUM((accounting_input_octets+accounting_output_octets)/1024/1024/1024) AS consumo_GB
FROM sgw.sgw_cdrs_affirmed
WHERE event_month IN(${mes})
AND event_hour BETWEEN ${Hora_inicio} AND ${Hora_fin}
AND enodeb IN (${enodeb})
GROUP BY 1,2,3,4,5
) AS sgw_cdrd
GROUP BY 1,2,3,4,5
) AS scdrs
LEFT OUTER JOIN
(
SELECT DISTINCT site_id, zeroifnull(enodeb) + quotient(zeroifnull(cell_id),10)/10 as 'enodeb_group', site_name,
site_latitude, site_longitude, state_name, region, municipality_name, site_type, tx_output
FROM catalog.catalog_cell
) AS cat
ON scdrs.enodeb_group = cat.enodeb_group;
