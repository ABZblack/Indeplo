select distinct enodeb, cell_id, site_id, site_cell_id as sector , site_name,  site_latitude,site_longitude, technology, region,  tx_output, locality_name, state_name, municipality_name 
from catalog.catalog_cell
where enodeb in (880204)  --busqueda por nodo o enodb
--where site_id in (240017)  -- busqueda por siteID
