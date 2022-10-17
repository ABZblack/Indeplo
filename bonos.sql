SELECT nombre_promocion, offer_id_adquirido, offer_id_promocion, fecha_inicio_vigencia_promocion,fecha_fin_vigencia_promocion,
load_processing_timestamp
FROM service.catalogo_promociones
where be_id = ${BE_ID}
;
