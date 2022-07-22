SELECT last_event_hour, msisdn,delta_radius , total_usage_mb, home_latitude , home_longitude , distance_home_tf, bs_enodeb, bs_cell_id, tf_enodeb, tf_cell_id, bs_coef_dist, bs_latitude, bs_longitude, tf_latitude, tf_longitude,
concat('Usuario con radio de: ',cast(bs_coef_dist as string), ' KM ', ' suspendido en delta de: ',cast(delta_radius as string),' KM ' ,' Sitio que lo suspende: ',cast(tf_enodeb as string) ) as Comentario
FROM service.mobility_end_users
--WHERE msisdn in (525638644502)
where imsi in (334140124041721 )
--where tf_enodeb = 290416
--and last_event_hour BETWEEN 2021050100 and 2021101823
ORDER BY last_event_hour desc;