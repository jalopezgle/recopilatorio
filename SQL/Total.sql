---- SISTEMA
as of timestamp to_date('12/07/2013 12:15:00','dd/mm/yyyy HH24:mi:ss')
dbms_output.put_line('This is '||NIA);


pkg_utilidades.enviar_correo(pEmisor => 'noreply@::,ES' , pDestinatarios => 'CORREO', pAsunto =>'debug', pMensaje => 'entro donde no toca '||l_index_value);
for cin in estados_pendientes_itaca loop

select * from
owndba.log_errors_tab
where ERR_MSG LIKE '%PKG_TITULOS%' AND LOG_DATE > TO_DATE ('24/02/2015','dd/mm/yyyy')


----- errores aplicacion subval
select * from
owndba.log_errors_tab
where  LOG_DATE > TO_DATE ('09/08/2016','dd/mm/yyyy') and modulo like '%subval.exe%'
and err_nr<> 942

--- errores aplicación de títulos
select * from
owndba.log_errors_tab
where  LOG_DATE > TO_DATE ('09/08/2016','dd/mm/yyyy') and modulo like '%titulos.exe%'
and err_nr<> 942

--- errores usuarios de subval
select * from
owndba.log_errors_tab
where  LOG_DATE > TO_DATE ('09/08/2016','dd/mm/yyyy') and log_usr in (
SELECT username FROM GV$SESSION
WHERE PROGRAM like '%subval.exe'
) and err_nr <> 942


select * from 
LOG_ERRORS_LOG4J
where fecha >  TO_DATE('01/08/2016','dd/mm/yyyy')


SELECT * FROM 
USER_AUDIT_SESSION
ORDER BY TIMESTAMP DESC

SELECT * FROM USER_ERRORS

USER_ERRORS
ALL_ERRORS_AE
USER_ERRORS_AE
ALL_ERRORS




select DISTINCT TABLE_NAME from SYS.ALL_TABLES
WHERE TABLE_NAME LIKE 'MI_%'

select * from all_users where username like 'MI_%'


SELECT username,program FROM GV$SESSION
WHERE PROGRAM like '%sub'
union
SELECT username,program FROM GV$SESSION
WHERE PROGRAM like '%tit'
union
SELECT username,program FROM GV$SESSION
WHERE PROGRAM like '%aexva'
union
SELECT username,program FROM GV$SESSION
WHERE PROGRAM like '%elecons%'
order by 2,1
        



delete FROM PREF_DATAWINDOW_dwo WHERE DATAWINDOW LIKE '%empresas%' AND USUARIO = 'J'



select * from 
PB_LOG_ERR
where usuario = 'J'
and fecha > to_date('01/08/2016','dd/mm/yyyy')


select * from 
PB_LOG_ERR
where aplicacion in (27,1677) 
and fecha > to_date('01/08/2016','dd/mm/yyyy')



select * from all_SYNONYMS
WHERE SYNONYM_NAME  LIKE '%ALL_%'

AND TABLE_OWNER = 'REGPER'
ORDER BY TABLE_NAME 

where table_name like '%MESSAGE%'


SELECT * FROM ALL_TAB_COLUMNS
WHERE COLUMN_NAME LIKE '%USUA%'
AND OWNER <> 'SYS'



ALL_TABLES

PSTUBTBL

alter table TRA_ADMIN.AYU_CO_PARAM_SEPE add unid_tram varchar2(250);


---- AYUDAS PRUEBAS
 
IMPORT 20413850Q C:\temp\prueba\fichero_importe_2015_08_24_1541_1.xls 
ATUR   85080357E C:\temp\prueba\fichero_paro_2015_08_24_1540_1.xls






---- AUDITORIA DE CONEXIIONES
select name, value 
from v$parameter 
where name ='audit_trail' 


select * from 
DBA_AUDIT_SESSION
where os_username = 'j' 
AND LOGOFF_TIME > TO_DATE ('13/08/2016','dd/mm/yyyy')


----- errores
select *
from
owndba.log_errors_tab
where LOG_DATE > TO_DATE ('14/09/2015','dd/mm/yyyy')
and modulo in ( 'titulos.exe' , 'subval.exe','elecons.exe','a_exva.exe')
and err_msg not like'%942%'


------ quien bloquea a quien
select s1.username || '@' || s1.machine || ' ( SID=' || s1.sid || ' , serial = ' || s1.serial# ||' ) is blocking ' || s2.username || '@' || s2.machine || ' ( SID=' || s2.sid || ' , serial = ' || s2.serial# ||' ) ' AS blocking_status 
from v$lock l1, v$session s1, v$lock l2, v$session s2 
where s1.sid=l1.sid and s2.sid=l2.sid 
and l1.BLOCK=1 and l2.request > 0 
and l1.id1 = l2.id1 
and l2.id2 = l2.id2 ; 

3185
3273



---- eliminar bloqueo
ALTER SYSTEM KILL SESSION 'sid,serial'; 


-------------------------------------------------------------------------
------ MYSQL
--------------------------------------------------------------------------


------- excepcion de control de locks
CREATE OR REPLACE PROCEDURE upd_sal
(p_jobid IN jobs.job_id%type,
p_minsal IN jobs.min_salary%type,
p_maxsal IN jobs.max_salary%type)
IS
v_dummy VARCHAR2(1);
e_resource_busy EXCEPTION;
sal_error EXCEPTION;
PRAGMA EXCEPTION_INIT (e_resource_busy , -54);
BEGIN
IF (p_maxsal < p_minsal) THEN
DBMS_OUTPUT.PUT_LINE('ERROR. MAX SAL SHOULD BE > MIN SAL');
RAISE sal_error;
END IF;
SELECT ''
INTO v_dummy
FROM jobs
WHERE job_id = p_jobid
FOR UPDATE OF min_salary NOWAIT;
UPDATE jobs
SET min_salary = p_minsal,
max_salary = p_maxsal
WHERE job_id = p_jobid;
EXCEPTION
WHEN e_resource_busy THEN
RAISE_APPLICATION_ERROR (-20001, 'Job information is
currently locked, try later.');
WHEN NO_DATA_FOUND THEN
RAISE_APPLICATION_ERROR
(-20001, 'This job ID does not exist');
WHEN sal_error THEN
RAISE_APPLICATION_ERROR(-20001,'Data error..Max salary should
be more than min salary');
END upd_sal;






------- sacar el plan

alter session set current_schema=TACATACA;
explain plan for
SELECT *
from TACATACA.VW_ALUMNO
WHERE doc.CODCENTRO in ('03010478');
select * from table(dbms_xplan.display('sys.plan_table$'));