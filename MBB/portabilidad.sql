SELECT load_processing_timestamp, be_id, window_abd_date_fmt, operation, msisdn_ported, msisdn_backup, imsi, dida, dcr, rida, rcr, transaction_result, transaction_detail, comments
FROM bss.portability_logs
WHERE msisdn_ported IN (5518311460)or msisdn_backup in (5518311460)
ORDER BY load_processing_timestamp;
