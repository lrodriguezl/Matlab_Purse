function [Y,M,D,H,MN,S] = unix2date(t)
% t seconds
% t is the number of seconds since unix epoc time jan 1st 1970

do=datenum([1970,1,1,0,0,0]);
d=t/(60*60*24); %days
[Y,M,D,H,MN,S]=datevec(d+do);

end
