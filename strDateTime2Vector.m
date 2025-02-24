function [Y,M,D,H,MN,S] = strDateTime2Vector(dateStr,timeStr) 
%% Takes string date and time and returns 
%  Year, Month, Days, Hours, Minutes and Seconds as double
%   dateStr format: MM/DD/YYYY ex: 01/01/2014,
%   timeStr format: HH:MN:SS.SSS ex: 00:00:00.810
M = nan(length(dateStr),1);
D = nan(length(dateStr),1);
Y = nan(length(dateStr),1);
H = nan(length(dateStr),1);
MN = nan(length(dateStr),1);
S = nan(length(dateStr),1);
for t=1:length(dateStr)
    M(t)=str2double(dateStr{t}(1:2));
    D(t)=str2double(dateStr{t}(4:5));
    Y(t)=str2double(dateStr{t}(7:end));
    H(t)=str2double(timeStr{t}(1:2));
    MN(t)=str2double(timeStr{t}(4:5));
    S(t)=str2double(timeStr{t}(7:end));
end

end