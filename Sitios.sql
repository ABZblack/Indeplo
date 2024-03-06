-- *****  Busy hour todos los sitios********
------------------------------
SELECT  key,
        concat(cast(enodeb as string),'_',cast(cell_sector as string)) as key_2, 
        service_state, 
        reason_service_state, 
        serviceability_by_capacity,
        event_day,
        hora_pico,
        enodeb,
        site_id,
        cell_sector,
        sector,
        site_name,
        volume_dl,
        tx_output,
        latitude,
        longitude,
        vendor,
        hora_pico
        
        
FROM service.oss_sectors_busy_hour
WHERE event_month >= 202311 
and event_day = 20231103
and enodeb = 143788

;


-- ********   Catalog cell **********-
---------------------------------------------
--- Información de enodbes, sites ids, celdas, coordenadas
select distinct enodeb, cell_id, site_id, site_cell_id, cell_identifier, site_name,  site_latitude,site_longitude, technology, region,  tx_output, locality_name, state_name, municipality_name 
from catalog.catalog_cell
where enodeb in (143788)
--where site_id in ()
;


--************** CFE ------------------------
---- Información general de sitios CFE

SELECT *
from catalog.master_plan_cfe
where latitude = 143788
;


---********************** Master plan ALTAN
---- Información general de sitios Altán
SELECT *
from catalog.master_plan_altan
where latitude = 143788
;
