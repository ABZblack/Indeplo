--•    Obtener el usuario correspondiente a un msisdn, esto porque pudo haber tenido alguna portabilidad o cambio de dn. Ejemplo:




select altan_usr_id, msisdn, be_id, activation_date, start_date, end_date
from billing.billing_altan_user_id
where be_id = 230
and msisdn = 525547144564  
order by start_date desc limit 10



--•    Obtener las ofertas que están vigentes. Ejemplo:



select altan_usr_id, msisdn, offering_id, activation_dt, start_date, expiration_date, product_name
from billing.billing_contract_history_extended
where be_id = 230
and altan_usr_id = '230000000000000221690332120220118162352'
and offer_type like '%Supplementary'
and offer_type like '%primary'
order by start_date desc limit 10;



--•    Validar que la oferta sea válida. Ejemplo:



select *
from analysis_bdl.covid_offerings
where offering_id = '    1879955000'



--*    Validar que la oferta sea válida. Ejemplo: **nueva tabla



SELECT fecha_inicio_vigencia_promocion, fecha_fin_vigencia_promocion, offer_id_promocion_porta, offer_id_promocion,be_id
FROM service.catalogo_promociones
where offer_id_adquirido ='1809901052'
ORDER BY id_promocion desc;



SELECT *
FROM service.catalogo_promociones



--•    Obtener la imei del usuario con la que haya hecho sus últimos consumos de datos. Ejemplo:



select calling_party_number, imei, cust_local_start_date
from bss.cbs_cdrs_data_free_unit_detail
where be_id = 161
and event_hour between 2022050100 and 2022051100
and pri_identity in (525631825780 )
and imei is not null
--order by cust_local_start_date desc limit 10;




--•    Validar el tac para saber si el equipo es banda 28. Ejemplo:



select  tac, gsma_model_name, gsma_brand_name, band_28
from service.device_map_integrated
where tac = substr(lpad(cast(        3567521103431415 as string), 16, '0'), 1, 8);



--•    Validar si tiene consumo de datos en Huella Altán. Ejemplo:



select distinct calling_roam_info
from bss.cbs_cdrs_data_free_unit_detail
where be_id = 154
and event_hour between 2022012000 and 2022013000
and pri_identity = 525631960455 limit 10




--•    Validar si tiene consumo de voz en Huella Altán. Ejemplo:



select distinct calling_roam_info
from bss.cbs_cdrs_voice_free_unit_detail
where be_id = 154
and event_hour between 2022012000 and 2022013000
and pri_identity = 525631960455 limit 10



***valida el valida promoción:



SELECT * from apigee.apigee_logs
where subscriber_id = 5574540782
and be_id = 230
--and operation = "Compra de Bonos Suplementarios"
and operation = "Valida Promocion"
and event_hour>=2022070800 and event_hour<2022070823
ORDER BY event_hour DESC;


-- ************************
SELECT  msisdn,delta_radius , total_usage_mb, distance_home_tf, bs_enodeb, bs_cell_id, tf_enodeb, tf_cell_id, bs_coef_dist, bs_latitude, bs_longitude,home_latitude , home_longitude , tf_latitude, tf_longitude,
concat('Usuario con radio de: ',cast(bs_coef_dist as string), ' KM ', ' suspendido en delta de: ',cast(delta_radius as string),' KM ' ,' Sitio que lo suspende: ',cast(tf_enodeb as string) ,' celda : ',cast(tf_cell_id as string),' BS asignado: ',cast(bs_enodeb as string) ,' celda : ',cast(bs_cell_id as string)  ) as Comentario,last_event_hour
FROM service.mobility_end_users
where  event_month BETWEEN 202207 AND 202208
and last_event_hour BETWEEN 2022070100 and 2022082000
and  msisdn in (525612336183  )
--and imsi in (334140004651203)
--where tf_enodeb in ( 100758)
ORDER BY last_event_hour desc;
