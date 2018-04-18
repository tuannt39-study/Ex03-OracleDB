CREATE USER DEMO IDENTIFIED BY 12345;

GRANT dba TO DEMO WITH ADMIN OPTION;

DROP USER DEMO CASCADE;

select dbms_xdb.gethttpport as "HTTP-Port",dbms_xdb.getftpport as "FTP-Port" from dual;

exec dbms_xdb.sethttpport(8088);

begin
dbms_xdb.sethttpport('8088');
end;
/