-- =========================================================== QUERY PARA SUSPENSION MOVILIDAD =============================================



SELECT DISTINCT last_event_hour, msisdn, delta_radius , total_usage_mb, distance_home_tf, bs_enodeb, bs_cell_id, tf_enodeb, tf_cell_id, bs_coef_dist, bs_latitude, bs_longitude, home_latitude , home_longitude ,
tf_latitude, tf_longitude,
concat
(
'Usuario con radio de: ',cast(bs_coef_dist as string),
' KM ', ' suspendido en delta de: ',cast(delta_radius as string),
' KM ' ,' Sitio que lo suspende: ',cast(tf_enodeb as string) ,
' celda : ',cast(tf_cell_id as string),
' BS asignado: ',cast(bs_enodeb as string) ,
' celda : ',cast(bs_cell_id as string)
) as Comentario, 
bs.site_id as bs_siteID,
tf.site_id as tf_siteID, tf.tx_output as tf_tx_output, tf.state_name as tf_estado, tf.municipality_name as tf_municipio

FROM service.mobility_end_users as mb

JOIN catalog.catalog_cell as bs
ON bs.site_latitude = mb.bs_latitude

JOIN catalog.catalog_cell as tf
ON tf.site_latitude = mb.tf_latitude

where mb.event_month IN (${event_month})
--and last_event_hour BETWEEN (${hour_in}) AND (${hour_fin})
and mb.msisdn in (${msisdn})
--and imsi in (${imsi})
ORDER BY mb.last_event_hour DESC;
