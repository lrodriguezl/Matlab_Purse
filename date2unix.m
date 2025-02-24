function tUnix = date2unix(y,m,d,h,mn)

do=datenum([1970,1,1,0,0,0]);
d1=datenum([y,m,d,h,mn,zeros(length(y),1)]);

d=d1-do;
tUnix=d*24*60*60;

end
