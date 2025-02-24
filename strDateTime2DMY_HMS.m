function [Y,M,D,H,MN,S] = strDateTime2DMY_HMS(dateTimeStr) 
%% Takes string date and time and returns 
%  Year, Month, Days, Hours, Minutes and Seconds as double
%   dateStr format: MM/DD/YYYY ex: 01/01/2014,
%   timeStr format: HH:MN:SS.SSS ex: 00:00:00.810
M = nan(length(dateTimeStr),1);
D = nan(length(dateTimeStr),1);
Y = nan(length(dateTimeStr),1);
H = nan(length(dateTimeStr),1);
MN = nan(length(dateTimeStr),1);
S = nan(length(dateTimeStr),1);
for t=1:length(dateTimeStr)
    S1=regexp(dateTimeStr{t},' ' ,'split');
    dateStr = S1{1};
    timeStr = S1{2};
    dateStr_split=regexp(dateStr,'/' ,'split');
    timeStr_split=regexp(timeStr,':' ,'split');
    
    M(t)=str2double(dateStr_split{1});
    D(t)=str2double(dateStr_split{2});
    Y(t)=str2double(dateStr_split{3});
    H(t)=str2double(timeStr_split{1});
    MN(t)=str2double(timeStr_split{2});
    if length(timeStr_split)>3
        S(t)=str2double(timeStr_split{3});
    else
        S(t) = 0;
    end
end

end