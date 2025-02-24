function [conn] = CRS_config(CRSuser,CRSpassword)

if nargin==0
    CRSuser = 'crs_guest';
    CRSpassword = 'mycrs517';    
end

if isempty(CRSuser)
    CRSuser = 'crs_guest';
end

if isempty(CRSpassword)
    CRSpassword = 'mycrs517';
end

CRSdbName = '';
CRSjdbcString = 'jdbc:oracle:thin:@ldap://caasd-tns.mitre.org:389/CRSPROD,cn=OracleContext,dc=mitre,dc=org ldap://caasddr-tns.mitre.org:389/CRSPROD,cn=OracleContext,dc=mitre,dc=org';
CRSjdbcDriver = 'oracle.jdbc.driver.OracleDriver';
conn = database(CRSdbName, CRSuser, CRSpassword, CRSjdbcDriver, CRSjdbcString);

end