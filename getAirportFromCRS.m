function [airportData] = getAirportFromCRS(airportCode)

[conn] = CRS_config();
sqlQuery = ['SELECT LOCID, NFDCLAT, NFDCLON, APTREFPTLATFMT, APTREFPTLONGFMT,'...
             'APTELEV, OFCLFCLTYNAME, INFOEFFDATE From '...
  'NFDC_APT Where ( ICAOID = ''' upper(airportCode) ''' ) '];

% sqlQuery = ['SELECT LOCID LATITUDE, LONGITUDE, ELEVATION, NAME From '...
%   'JEPAIRPORT Where ( JEPCODE = ''' upper(airportCode) ''' ) '];

aptData=fetch(conn,sqlQuery);


infoDate= aptData(:,8);
dnum=datenum(infoDate);
[vmax, k]=max(dnum);
I = dnum == vmax;
airportData = aptData(I,:);

end