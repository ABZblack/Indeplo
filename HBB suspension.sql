
-- =========================================================== QUERY PARA SUSPENSION MOVILIDAD =============================================

SELECT last_event_hour, msisdn,delta_radius , total_usage_mb, home_latitude , home_longitude , distance_home_tf, bs_enodeb, bs_cell_id, tf_enodeb, tf_cell_id, bs_coef_dist, bs_latitude, bs_longitude, tf_latitude, tf_longitude,
concat('Usuario con radio de: ',cast(bs_coef_dist as string), ' KM ', ' suspendido en delta de: ',cast(delta_radius as string),' KM ' ,' Sitio que lo suspende: ',cast(tf_enodeb as string) ) as Comentario
FROM service.mobility_end_users
where imsi in (${IMSI})
ORDER BY last_event_hour desc;


-- ===================================================================================== QUERY HANDOVER ===================================

select distinct source_site_id, source_sector, target_site_id, target_sector
from oss.catalog_handover_huawei_sites
where source_site_id = ${eNodB}
union all
select distinct source_site_id, source_sector, target_site_id, target_sector
from oss.catalog_handover_nokia_sites
where source_site_id = ${eNodB}


--=================================================================Reason Codes ==================================================== 
Select *
From service.user_state a
Where a.msisdn = 8138970492

--************        Reason codes       ************
--0: Notificado por cliente
--1: Notificado por cliente
--2: suspensión por movilidad
--3: suspensión por IMEI Lock
--4: Barring por No Banda 28
--5: Unbarring por No banda 28
--************       Sub-Reason codes       ************
--10: Barring por Banda28 No Compatible
--11: Unbarring por Banda28 compatible
--12: Barring por IMEI No Permitido
--13: UnBarring por IMEI Permitido
