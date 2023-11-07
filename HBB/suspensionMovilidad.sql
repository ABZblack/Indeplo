-- =========================================================== QUERY PARA SUSPENSION MOVILIDAD =============================================



WITH suspen AS (
    SELECT
        last_event_hour,
        msisdn,
        delta_radius,
        total_usage_mb,
        distance_home_tf,
        bs_enodeb,
        bs_cell_id,
        tf_enodeb,
        tf_cell_id,
        bs_coef_dist,
        bs_latitude,
        bs_longitude,
        home_latitude,
        home_longitude,
        tf_latitude,
        tf_longitude
        /*CONCAT(
            'Usuario con radio de: ', CAST(bs_coef_dist AS STRING),
            ' KM ', ' suspendido en delta de: ', CAST(delta_radius AS STRING),
            ' KM ', ' Sitio que lo suspende: ', CAST(tf_enodeb AS STRING),
            ' celda : ', CAST(tf_cell_id AS STRING),
            ' BS asignado: ', CAST(bs_enodeb AS STRING),
            ' celda : ', CAST(bs_cell_id AS STRING)
        ) AS comentario*/
    FROM
        service.mobility_end_users
    WHERE
        event_month >= ${event_month}
        AND msisdn IN (${DN_12digitos})
),

cell AS (
    SELECT
        DISTINCT enodeb,
        site_id,
        site_latitude,
        tx_output,
        state_name,
        municipality_name
    FROM
        catalog.catalog_cell
)

SELECT
    s.last_event_hour,
    s.msisdn,
    s.delta_radius,
    s.total_usage_mb,
    s.distance_home_tf,
    s.bs_enodeb,
    s.bs_cell_id,
    s.tf_enodeb,
    s.tf_cell_id,
    s.bs_coef_dist,
    s.bs_latitude,
    s.bs_longitude,
    s.home_latitude,
    s.home_longitude,
    s.tf_latitude,
    s.tf_longitude,
    --s.comentario,
    bs.site_id AS bs_siteID,
    tf.site_id AS tf_siteID,
    tf.tx_output AS tf_tx_output,
    tf.state_name AS tf_estado,
    tf.municipality_name AS tf_municipio
FROM
    suspen AS s
LEFT JOIN
    cell AS bs ON s.bs_latitude = bs.site_latitude
LEFT JOIN
    cell AS tf ON s.tf_latitude = tf.site_latitude;
