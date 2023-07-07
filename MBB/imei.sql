Select 

tac,
'${IMEI}' as IMEI,
category as homologated,
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
    
end as E_SIM
--gsma_bands,
--gsma_country_code

from service.device_map_integrated

WHERE tac like substr('${IMEI}%',1, 8)
;

