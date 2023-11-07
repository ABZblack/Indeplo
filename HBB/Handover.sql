-- ===================================================================================== QUERY HANDOVER ===================================

-------------------------- ENODEB -------------------------
SELECT DISTINCT source_enodeb, source_site_id, source_sector, target_enodeb, target_site_id, target_sector, carrier
FROM
(
select distinct source_enodeb, source_site_id, source_sector, target_enodeb, target_site_id, target_sector, 'nokia' AS carrier
from oss.catalog_handover_nokia_sites
-- Para cuando se tiene solo los nodos:
where source_enodeb = ${BS} -- Best Server nod
AND target_enodeb = ${TF} -- nodo que suspende

--Para cuando se tiene los site_id:
--where source_site_id = ${BS} -- Best Server site id
--AND target_site_id = ${TF} --  site id que suspende


UNION ALL

select distinct source_enodeb, source_site_id, source_sector, target_enodeb, target_site_id, target_sector, 'huawei' AS carrier
from oss.catalog_handover_huawei_sites
--Para cuando se tiene solo los nodos:
where source_enodeb = ${BS} -- Best Server
AND target_enodeb = ${TF}  -- Sitio que suspende

--Para cuando se tiene los site_id:
--where source_site_id = ${BS} -- Best Server site id
--AND target_site_id = ${TF} --  site id que suspende
) AS a;

