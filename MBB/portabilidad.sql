SELECT *
FROM bss.portability_logs
WHERE
msisdn_ported IN (7711977976) --buscar por úmero portado
;

SELECT *
FROM bss.portability_logs
WHERE
or msisdn_backup in (7714290717) --buscar por número transitorio
;
