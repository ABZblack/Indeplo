SELECT *
FROM
(
SELECT event_hour, enodeb, cell_id, core, enodeb_group, SUM(ctd_users) AS ctd_users, SUM(consumo_GB) AS consumo_GB
FROM
(
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
