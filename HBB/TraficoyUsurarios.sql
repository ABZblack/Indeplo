select concat(cast(enodeb as string), '.', cast(cell_id as string)) as SITIO,
round(sum(accounting_input_octets + accounting_output_octets)/1024/1024,2) as Trafico,
count(distinct calling_party_imsi) as Usuarios
from sgw.sgw_cdrs --nokia
--FROM sgw.sgw_cdrs_affirmed --affirmed
where enodeb in (${enodB})
and event_month = ${mes}
and event_hour between ${Fecha_inicio} and ${Fecha_fin}
group by 1
;
