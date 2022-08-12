-- *** CONSULTA CONSUMOS ****


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
where event_month =202207
and enodeb in ( 250118 )
--and site_id in (910200)
and event_day = 20220720
