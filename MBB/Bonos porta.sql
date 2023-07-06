--  Valida promocion
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
SELECT * from apigee.apigee_logs
where subscriber_id in (5522709305)
and be_id = 246
and operation = "Valida Promocion"
and event_hour between 2023020200 and 2023020223
ORDER BY log_timestamp;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


-- catalogo promociones, busqueda por nombre de oferta
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
WITH catalogo
as (
    
    SELECT nombre_promocion, descripcion_promocion, id_promocion, be_id, recurrencia, evento, offer_id_adquirido, offer_id_promocion, fecha_inicio_vigencia_promocion,fecha_fin_vigencia_promocion,
    load_processing_timestamp, compra_y_elimina_oferta_actual
    FROM service.catalogo_promociones
    where offer_id_adquirido = (SELECT DISTINCT offering_id
                                FROM billing.catalog_billing_product
                                WHERE product_name = 'WALM-RM-ST 500+500Mi 7500+2500M 250+250SMS 2000RS 10000T 20D DS')
    AND evento = 'PORT-IN'
    --AND evento = 'COMPRA'

)

SELECT distinct catalogo.be_id, prom.be_name, nombre_promocion, id_promocion, descripcion_promocion, offer_id_adquirido, offer_id_promocion, prom.product_name nombre_promocion, recurrencia, evento, fecha_inicio_vigencia_promocion,fecha_fin_vigencia_promocion,
catalogo.load_processing_timestamp, compra_y_elimina_oferta_actual
FROM catalogo
JOIN billing.catalog_billing_product prom
ON cast(catalogo.offer_id_promocion as STRING) = prom.offering_id and catalogo.be_id = prom.be_id
ORDER BY fecha_fin_vigencia_promocion DESC
;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
