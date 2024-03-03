with 

imeis as
(
    SELECT  tac,
            category as homologado,
            case
                when volte = '1' then 'Si'
                else 'no'
            
            end as volteCapable,
            case
                when band_28 = 1 then 'Si'
                else 'no'
            
            end as Band_28,
            gsma_model_name as model,
            gsma_brand_name as brand,
            gsma_manufacturer as manufacturer,
            gsma_device_type as device_type,
            sub_category as subcategory,
            case
                when esim = 1 then 'Si'
                else 'no'
            
            end as E_SIM,
            gsma_operating_system,
            gsma_country_code
        
        from service.device_map_integrated
),

consulta_imei as
(
    SELECT substr(cast(imei as STRING),1, 8) as tac, imei,event_hour
     FROM (
            SELECT imei, event_hour
            FROM pgw.pgw_cdrs
            where calling_party_number in (${DN_12digitos})
            and event_month >= CAST(from_timestamp(date_sub(now(),3),'yyyyMM') AS BIGINT)
            AND event_hour >= CAST(from_timestamp(date_sub(now(),2),'yyyyMMddHH') AS BIGINT)
            UNION ALL
            SELECT imei, event_hour
            FROM sgw.sgw_cdrs
            where calling_party_number in (${DN_12digitos})
            and event_month >= CAST(from_timestamp(date_sub(now(),3),'yyyyMM') AS BIGINT)
            AND event_hour >= CAST(from_timestamp(date_sub(now(),2),'yyyyMMddHH') AS BIGINT)
        ) as a
        
    where imei is not null
)

SELECT distinct
        c.event_hour,
        c.imei,
        i.homologado,
        i.volteCapable,
        i.Band_28, 
        i.model,
        i.brand,
        i.manufacturer,
        i.device_type,
        i.subcategory,
        i.e_sim,
        i.gsma_operating_system,
        i.gsma_country_code
from consulta_imei as c
left join imeis as i
ON c.tac=i.tac
order by c.event_hour desc
