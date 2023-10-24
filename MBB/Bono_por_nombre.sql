WITH catalogo
as (
    
    SELECT nombre_promocion, descripcion_promocion, id_promocion, be_id, recurrencia, evento, offer_id_adquirido, offer_id_promocion, fecha_inicio_vigencia_promocion,fecha_fin_vigencia_promocion,
    load_processing_timestamp, compra_y_elimina_oferta_actual
    FROM service.catalogo_promociones
),

name
as(
    SELECT product_name, offering_id,be_name,be_id,index
    FROM(Select product_name,be_name,be_id, offering_id, ROW_NUMBER() OVER (PARTITION BY offering_id ORDER BY end_date DESC) AS index
            FROM billing.catalog_billing_product) as a
    where index = 1
)


SELECT  nombre_promocion, 
        descripcion_promocion, 
        id_promocion, 
        catalogo.be_id, 
        recurrencia, 
        evento, 
        offer_id_adquirido, 
        offer_id_promocion,
        product_name,
        fecha_inicio_vigencia_promocion,
        fecha_fin_vigencia_promocion,
        load_processing_timestamp, 
        compra_y_elimina_oferta_actual
        
FROM catalogo
JOIN name 
ON cast(offer_id_promocion as STRING) = name.offering_id
where offer_id_adquirido =  (SELECT DISTINCT offering_id
                                FROM billing.catalog_billing_product
                                WHERE product_name = 'WALM-RM-ST 500+500Mi 7500+2500M 250+250SMS 10000T 15D DS'
                                )

and evento = 'PORT-IN'
--and evento = 'COMPRA'
