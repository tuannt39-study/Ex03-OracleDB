CREATE USER ITSOL IDENTIFIED BY 1234;

GRANT dba TO ITSOL WITH ADMIN OPTION;

select dbms_xdb.gethttpport as "HTTP-Port",dbms_xdb.getftpport as "FTP-Port" from dual;

exec dbms_xdb.sethttpport(8088);

begin
dbms_xdb.sethttpport('8088');
end;
/