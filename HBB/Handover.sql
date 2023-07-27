-- ===================================================================================== QUERY HANDOVER ===================================

SELECT DISTINCT source_enodeb, source_site_id, source_sector, target_enodeb, target_site_id, target_sector, carrier
FROM
(
select distinct source_enodeb, source_site_id, source_sector, target_enodeb, target_site_id, target_sector, 'nokia' AS carrier
from oss.catalog_handover_nokia_sites
where source_site_id = ${BS} -- Best Server
AND target_site_id = ${TF} -- Sitio que suspende

UNION ALL

select distinct source_enodeb, source_site_id, source_sector, target_enodeb, target_site_id, target_sector, 'huawei' AS carrier
from oss.catalog_handover_huawei_sites
where source_site_id = ${BS} -- Best Server
AND target_site_id = ${TF}  -- Sitio que suspende
) AS a;
