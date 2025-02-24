function [foundNavaidNames, navaidLatDeg, navaidLonDeg] = ...
    getNAVAIDSFromCRS(navaidID)
% configure CRS database connection
[conn] = CRS_config();

% initialize variables
if iscell(navaidID)
    numNAvaids = length(navaidID);
else
    numNAvaids = 1;
    navaidID = cellstr(navaidID);
end
navIadLatStr = cell(numNAvaids,1);
navIadLonStr = cell(numNAvaids,1);
foundNavaidNames = cell(numNAvaids,1);

for f=1:numNAvaids
    NAVAIDID= upper(navaidID{f});
    
    queryDef= ['SELECT NAVAIDFCLTYID,NAMEOFNAVAID,' ...
                'NAVAIDLATFMT,NAVAIDLONGFMT,INFOEFFDATE'...
                ' FROM nfdc_nav1'...
                ' WHERE NAVAIDFCLTYID= ''' upper(NAVAIDID) ''''];
            
%     query_def= ['SELECT NAVAIDFCLTYID,NAMEOFNAVAID,' ...
%         'NAVAIDLATFMT,NAVAIDLONGFMT,INFOEFFDATE'...
%         ' FROM nfdc_nav1'...
%         ' WHERE NAVAIDFCLTYID= ''' navaid_ID ''''...
%         ' AND NAMEOFNAVAID= ''' navaid_name ''''];
    
    navAidData=fetch(conn,queryDef);
    if ~isempty(navAidData)
        fixDate= navAidData(:,5);
        dnum=datenum(fixDate);
        [vmax, k]=max(dnum);
        mostRecentData = navAidData(k,:);
        
        foundNavaidNames{f}=mostRecentData{2};
        navIadLatStr{f}=mostRecentData{3};
        navIadLonStr{f}=mostRecentData{4};
    end
end

navaid_lat=regexp(navIadLatStr,'-','split');
navaid_lon=regexp(navIadLonStr,'-','split');

navaidLonDeg = nan(numNAvaids,1);
navaidLatDeg = nan(numNAvaids,1);

for i=1:numNAvaids
    % latitudes
    if size(navaid_lat{i},2)==3
        dd=str2double(navaid_lat{i}(1));
        mm=str2double(navaid_lat{i}(2));
        north_flag=~isempty(cell2mat(strfind(navaid_lat{i}(3),'N')));
        if north_flag
            sss=regexprep(navaid_lat{i}(3),'N','');
            sig=1;
        else
            sss=regexprep(navaid_lat{i}(3),'S','');
            sig=-1;
        end
        ss=str2double(sss);
        navaidLatDeg(i) = sig*(dd + mm/60 + ss/3600);
    else
        warning(['Latitude Missing for ', navaidID{i}])
    end
    % longitudes
    if size(navaid_lon{i},2)==3
        dd=str2double(navaid_lon{i}(1));
        mm=str2double(navaid_lon{i}(2));
        east_flag=~isempty(cell2mat(strfind(navaid_lon{i}(3),'E')));
        if east_flag
            sss=regexprep(navaid_lon{i}(3),'E','');
            sig=1;
        else
            sss=regexprep(navaid_lon{i}(3),'W','');
            sig=-1;
        end
        ss=str2double(sss);
        navaidLonDeg(i) = sig*(dd + mm/60 + ss/3600);
    else
        warning(['Longitude Missing for ', navaidID{i}])
    end
end
end