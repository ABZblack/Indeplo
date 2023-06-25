SELECT *
FROM bss.portability_logs
WHERE
msisdn_ported IN (7226598206)or msisdn_backup in (7226598206)
ORDER BY load_processing_timestamp desc;
