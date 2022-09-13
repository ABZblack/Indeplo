-- *** BUSY HOUR sitio

select site_name, service_state, municipality, state, volume_dl, ue_dl_throughput, sector, cell_sector, site_id, enodeb, latitude, longitude
from service.oss_sectors_busy_hour
where event_month = ${evetnt_month} 
and enodeb in ( ${sitio} )
--and site_id in (910200)
and event_day = ${fecha}
