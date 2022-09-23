--Reason codes

Select *
From service.user_state a
Where a.msisdn = ${DN10}
ORDER BY a.start_timestamp desc


--************        Reason codes       ************
--0: Notificado por cliente
--1: Notificado por cliente
--2: suspensión por movilidad
--3: suspensión por IMEI Lock
--4: Barring por No Banda 28
--5: Unbarring por No banda 28
--************       Sub-Reason codes       ************
--10: Barring por Banda28 No Compatible
--11: Unbarring por Banda28 compatible
--12: Barring por IMEI No Permitido
--13: UnBarring por IMEI Permitido

