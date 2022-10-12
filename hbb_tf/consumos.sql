SELECT (downlink/1024)/1024 AS Trafico_Bajada, (uplink/1024)/1024 AS Trafico_subida, calling_party_imsi, calling_party_number, enodeb, cell_id, event_hour,
concat(cast(enodeb as string), '.', cast(cell_id as string)) as SITIO
fROM sgw.sgw_cdrs_aggregates
--frOM sgw.sgw_cdrs_affirmed_aggregates
WHERE calling_party_imsi in(334140001529454		)
AND event_hour between 2022101100 and 2023123000
ORDER BY event_hour DESC;
