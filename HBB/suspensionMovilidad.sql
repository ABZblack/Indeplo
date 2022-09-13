-- =========================================================== QUERY PARA SUSPENSION MOVILIDAD =============================================

SELECT last_event_hour, msisdn,delta_radius , total_usage_mb, home_latitude , home_longitude , distance_home_tf, bs_enodeb, bs_cell_id, tf_enodeb, tf_cell_id, bs_coef_dist, bs_latitude, bs_longitude, tf_latitude, tf_longitude,
concat('Usuario con radio de: ',cast(bs_coef_dist as string), ' KM ', ' suspendido en delta de: ',cast(delta_radius as string),' KM ' ,' Sitio que lo suspende: ',cast(tf_enodeb as string) ) as Comentario
FROM service.mobility_end_users
where imsi in (${IMSI})
ORDER BY last_event_hour desc;
