function [MM,DD,YYYY,HH,mm,ss] = datevector(dateStr,timeStr)
%  Year, Month, Days, Hours, Minutes and Seconds as double
%   dateStr format: MM/DD/YYYY ex: 01/01/2014,
%   timeStr format: HH:MN:SS.SSS ex: 00:00:00.810
s1=regexp(dateStr,'/','split');
s2=regexp(timeStr,':','split');
MM=nan(length(s1),1);
DD=nan(length(s1),1);
YYYY=nan(length(s1),1);
HH=nan(length(s1),1);
mm=nan(length(s1),1);
ss=nan(length(s1),1);

for i=1:length(dateStr)
    MM(i)=str2double(s1{i}(1));
    DD(i)=str2double(s1{i}(2));
    YYYY(i)=str2double(s1{i}(3));
    MM(i)=str2double(s1{i}(1));
    HH(i)=str2double(s2{i}(1));
    mm(i)=str2double(s2{i}(2));
    ss(i)=str2double(s2{i}(3));
    
end
end