function [runwaysData] = getAirportRunwayFromCRS(airportCode)

runwaysData.runwayID = '';
runwaysData.runwayLength = nan;
runwaysData.runwayWidth = nan;

runwaysData.baseRunwayID = '';
runwaysData.baseRunwayElevation = nan;
runwaysData.baseRunwayLat= nan;
runwaysData.baseRunwayLon= nan;
runwaysData.baseRunwayTrueAligment = nan;

runwaysData.reciprocalRunwayID = '';
runwaysData.reciprocalRunwayElevation = nan;
runwaysData.reciprcalRunwayLat = nan;
runwaysData.reciprcalRunwayLon = nan;
runwaysData.reciprocalRunwayTrueAligment = nan;


% configure CRS database connection
[conn] = CRS_config();

% define airport query
sqlQuery = ['SELECT LANDINGFCLTYSITENUM, OFCLFCLTYNAME From '...
    'NFDC_APT Where ( ICAOID = ''' upper(airportCode) ''' ) '];
airportData=fetch(conn,sqlQuery);

if ~isempty(airportData)==1
    % RWYENDALIGNMENTMAGHDNG  RWYENDTRUEALIGNMENT
    % define runway query
    rwyCols = ['RWYID, PHRWYLENGTH, PHRWYWIDTH,'...
        'BASEENDID, ELEVATPHRWYEND, '...
        'LATOFPHRWYENDFMT, LONOFPHRWYENDFMT, RWYENDTRUEALIGNMENT, ' ...
        'RECIPROCALENDID, ELEVATPHEWYEND_1, ',...
        'LATOFPHRWYENDFMT_1, LONGOFPHRWYENDFMT_1, RWYENDALIGNMENTMAGHDNG'];
    rwyQuery = ['SELECT ',rwyCols,', INFOEFFDATE From '...
        'NFDC_RWY Where ( LANDINGFCLTYSITENUM = ''' upper( airportData{1,1}) ''' ) '];
    
    rwyData=fetch(conn,rwyQuery);
    
    % get the most recent records returned by the query
    if ~isempty(rwyData)
        infoDate= rwyData(:,14);
        
        dnum=datenum(infoDate);
        [vmax, k]=max(dnum);
        I = dnum == vmax;
        mostRecentData = rwyData(I,:);
        
        runwayID = mostRecentData(:,1);
        runwayLength = str2double(mostRecentData(:,2));
        runwayWidth = str2double(mostRecentData(:,3));
        
        baseRunwayID = mostRecentData(:,4);
        baseRunwayElevation = str2double(mostRecentData(:,5));
        baseRunwayLatStr = mostRecentData(:,6);
        baseRunwayLonStr = mostRecentData(:,7);
        
        baseRunwayTrueAligment = mostRecentData(:,8);
        reciprocalRunwayID = mostRecentData(:,9);
        reciprocalRunwayEelevation = str2double(mostRecentData(:,10));
        reciprocalRunwayLatStr=mostRecentData(:,11);
        reciprocalRunwayLonStr=mostRecentData(:,12);
        reciprocalRunwayTrueAligment = mostRecentData(:,13);
    end
    
    % convert from DD MM SS '42-22-41.8466N' to decimal degrees
    baseRunwayLatSplit=regexp(baseRunwayLatStr,'-','split');
    baseRunwayLonSplit=regexp(baseRunwayLonStr,'-','split');
    reciprocalRunwayLatSplit=regexp(reciprocalRunwayLatStr,'-','split');
    reciprocalRunwayLonSplit=regexp(reciprocalRunwayLonStr,'-','split');
    
    [row,col]=size(mostRecentData);
    baseRunwayLat =  nan(row,1);
    baseRunwayLon =  nan(row,1);
    reciprcalRunwayLat =  nan(row,1);
    reciprcalRunwayLon =  nan(row,1);
    
    for i=1:row
        % base runway end
        if (size(baseRunwayLatSplit{i},2) == 3)
            % latitudes
            %     cell {1x3} 'dd'    'mm'    'ss.ssssN'
            [baseRunwayLat(i)] = convertToDec(baseRunwayLatSplit{i});
            % longitudes
            [baseRunwayLon(i)] = convertToDec(baseRunwayLonSplit{i});
        end
        % reciprocal runway end
        if (size(reciprocalRunwayLatSplit{i},2) == 3)
            % latitudes
            %     cell {1x3} 'dd'    'mm'    'ss.ssssN'
            [reciprcalRunwayLat(i)] = convertToDec(reciprocalRunwayLatSplit{i});
            % longitudes
            [reciprcalRunwayLon(i)] = convertToDec(reciprocalRunwayLonSplit{i});
        end
    end
    
    runwaysData.runwayID = runwayID;
    runwaysData.runwayLength = runwayLength;
    runwaysData.runwayWidth = runwayWidth;
    
    runwaysData.baseRunwayID = baseRunwayID;
    runwaysData.baseRunwayElevation = baseRunwayElevation;
    runwaysData.baseRunwayLat= baseRunwayLat;
    runwaysData.baseRunwayLon= baseRunwayLon;
    runwaysData.baseRunwayTrueAligment =baseRunwayTrueAligment;
    
    runwaysData.reciprocalRunwayID = reciprocalRunwayID;
    runwaysData.reciprocalRunwayElevation = reciprocalRunwayEelevation;
    runwaysData.reciprocalRunwayLat = reciprcalRunwayLat;
    runwaysData.reciprocalRunwayLon = reciprcalRunwayLon;
    runwaysData.reciprocalRunwayTrueAligment = reciprocalRunwayTrueAligment;
else
    warning(['Unable to Find ',airportCode])
end
end

%%
function [decVal] = convertToDec(ddmmss)
% ddmmss is a cell {1x3} '42'    '21'    '28.7587N'
% ddmmss is a cell {1x3} '071'    '00'    '16.2583W'

dd=str2double(ddmmss(1));
mm=str2double(ddmmss(2));
ssPos = ddmmss{3};
cardinalPos = ssPos(end);
switch cardinalPos
    case 'N'
        sss=regexprep(ddmmss(3),'N','');
        sig = 1;
    case 'S'
        sss=regexprep(ddmmss(3),'S','');
        sig = -1;
    case 'E'
        sss=regexprep(ddmmss(3),'E','');
        sig = 1;
    case 'W'
        sss=regexprep(ddmmss(3),'W','');
        sig = -1;
end

ss=str2double(sss);
decVal = sig*(dd + mm/60 + ss/3600);

end