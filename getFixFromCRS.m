function [found_fix_names, fix_lat_deg, fix_lon_deg] = getFixFromCRS(fixName)
% configure CRS database connection
[conn] = CRS_config();

% initialize variables
if iscell(fixName)
    numFixes = length(fixName);
else
    numFixes = 1;
    fixName = cellstr(fixName);
end
fix_lat_str = cell(numFixes,1);
fix_lon_str = cell(numFixes,1);
found_fix_names = cell(numFixes,1);
for f=1:numFixes
    fix_name = upper(fixName{f});
    query_def= ['SELECT RECIDFIXNAME, RECIDFIXSTATENAME, GEOLATOFFIX, GEOLONGOFFIX, infoeffdate FROM nfdc_fix1 WHERE RECIDFIXNAME= ''' fix_name ''''];
    
    fixData=fetch(conn,query_def);
    if ~isempty(fixData)
        fixDate= fixData(:,5);
        dnum=datenum(fixDate);
        [vmax, k]=max(dnum);
        mostRecentData = fixData(k,:);
        
        found_fix_names{f}=mostRecentData{1};
        fix_lat_str{f}=mostRecentData{3};
        fix_lon_str{f}=mostRecentData{4};
    end
end

fix_lat=regexp(fix_lat_str,'-','split');
fix_lon=regexp(fix_lon_str,'-','split');

fix_lon_deg = nan(numFixes,1);
fix_lat_deg = nan(numFixes,1);

for i=1:numFixes
    % latitudes
    if size(fix_lat{i},2)==3
        dd=str2double(fix_lat{i}(1));
        mm=str2double(fix_lat{i}(2));
        north_flag=~isempty(cell2mat(strfind(fix_lat{i}(3),'N')));
        if north_flag
            sss=regexprep(fix_lat{i}(3),'N','');
            sig=1;
        else
            sss=regexprep(fix_lat{i}(3),'S','');
            sig=-1;
        end
        ss=str2double(sss);
        fix_lat_deg(i) = sig*(dd + mm/60 + ss/3600);
    else
        warning(['Latitude Missing for ', fixName{i}])
    end
    % longitudes
    if size(fix_lon{i},2)==3
        dd=str2double(fix_lon{i}(1));
        mm=str2double(fix_lon{i}(2));
        east_flag=~isempty(cell2mat(strfind(fix_lon{i}(3),'E')));
        if east_flag
            sss=regexprep(fix_lon{i}(3),'E','');
            sig=1;
        else
            sss=regexprep(fix_lon{i}(3),'W','');
            sig=-1;
        end
        ss=str2double(sss);
        fix_lon_deg(i) = sig*(dd + mm/60 + ss/3600);
    else
        warning(['Longitude Missing for ', fixName{i}])
    end
end
end