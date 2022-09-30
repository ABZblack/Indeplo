select     enodeb, site_name,  site_latitude, site_longitude,tx_output, state_name, municipality_name
from catalog.catalog_cell
where enodeb = ${enodB} --limit 10;
