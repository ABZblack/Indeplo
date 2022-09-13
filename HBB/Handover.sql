-- ===================================================================================== QUERY HANDOVER ===================================

select distinct source_site_id, source_sector, target_site_id, target_sector
from oss.catalog_handover_huawei_sites
where source_site_id = ${eNodB}
union all
select distinct source_site_id, source_sector, target_site_id, target_sector
from oss.catalog_handover_nokia_sites
where source_site_id = ${eNodB}
