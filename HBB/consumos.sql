-- *** CONSULTA CONSUMOS DE LA LÍNEA  ****


SELECT (downlink/1024)/1024 AS Trafico_Bajada, (uplink/1024)/1024 AS Trafico_subida, calling_party_imsi, calling_party_number, enodeb, cell_id, event_hour,
concat(cast(enodeb as string), '.', cast(cell_id as string)) as SITIO, imei
--fROM sgw.sgw_cdrs_aggregates --Nokia
frOM sgw.sgw_cdrs_affirmed_aggregates --Affirmed
WHERE calling_party_imsi in(${IMSI})
AND event_hour between ${fecha_incio} and ${fecha_fin}
ORDER BY event_hour DESC;
