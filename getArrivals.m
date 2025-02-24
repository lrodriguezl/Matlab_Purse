function [arrTrackID] = getArrivals(tracksID,tracksX,tracksY,tracksZ,...
                                              tracksT,boxLength,boxWidth,boxHeight)
%% Arrival tracks are those that:
%     1- Contain points within a box of a given
%        width, length and height
%           AND
%     2- Not all points are leveled
%     3- Best fitted line (z,t) has negative slope. Points are descending
%     4- Best fitted line (x,t) has negative slope. This ensures that
%        points are moving towards the runway end 
%
% Iput:
%     trackID - string array of track ids
%     trackX  - column vector of double [nx1] containing x of local coordinates
%     trackY  - column vector of double [nx1] containing y of local coordinates
%     trackZ  - column vector of double [nx1] containing AGL altitudes
%     trackT  - column vector of double [nx1] containing matlab times
%               Matlab time vector is the number of days from Jan 0,0000
%     boxLength,boxWidth,boxHeight,  - dimensions of the box used to
%                                      identify tracks close to runway

% Use the minimum of the times entered as the reference
% for the rest of the points.
% For example, tracksT = [735880 7.3604e+05 7.3614e+05]
% min(tracksT) To= 735880. Subtract To from tracksT.
% newT = [260 160 0]
% otherwise the time vector will have extremely big values and the
% least square method will be performing division operations where
% the denominator will be too big and the numerator too small.
% the results would not make sense

To=(min(tracksT));
minNumPoints = 5;

withinBox1 = abs(tracksY) <= boxWidth & ...
    abs(tracksX) <= boxLength & ...
    tracksZ <= boxHeight;

trackIDWithinBox = tracksID(withinBox1);
    
uTracks = unique(trackIDWithinBox);
allArrI =  false(length(tracksID),1);
for i=1:length(uTracks)
    I = strcmp(tracksID,uTracks{i});
    
    thisTrackX = tracksX(I);
    thisTrackY = tracksY(I);
    thisTrackZ = tracksZ(I);
    thisTrackT = tracksT(I);

    [tSorted,ti] =  sort(thisTrackT,'descend');
    T = (tSorted -To)*24*60*60; %sec
        
    zSorted = thisTrackZ(ti);
    xSorted = thisTrackX(ti);
    ySorted = thisTrackY(ti);
    
%     figure(1)
%     cla
%     plot(xSorted,ySorted,'k.-')
%     hold on
    
    withinBox1 = abs(ySorted) <= boxWidth & ...
        abs(xSorted) <= boxLength & ...
        zSorted <= boxHeight;
    
    ptsWithinBox = find(withinBox1);
    
    [consecutivePts, consecutivePtsList] =groupIndices(ptsWithinBox,minNumPoints);
    
    if ~isempty(consecutivePtsList)
         arrPts = consecutivePtsList{1}(1):consecutivePtsList{1}(2);
        
        xWithinBox = xSorted(arrPts);
        yWithinBox = ySorted(arrPts);
        zWithinBox = zSorted(arrPts);
        tWithinBox = T(arrPts);
              
%         figure(1)
%         plot(xWithinBox,yWithinBox,'bo')
%         xlabel('x [nm]')
%         ylabel('y [nm]')
%         
        %     clc
%         figure(2);
%         subplot(2,1,1); 
%         cla
%         plot(tWithinBox,zWithinBox,'b.-')
%         ylabel('z [ft]')
%         hold on
%         
%         subplot(2,1,2); 
%         cla
%         plot(tWithinBox,xWithinBox,'b.-')
%         ylabel('x [nm]')
%         hold on      
        
        
        [zSlope,zIntercept] = bestLine(tWithinBox,zWithinBox);
%         disp(num2str(i))
        [xSlope,xIntercept] = bestLine(tWithinBox,xWithinBox);
        
%         figure(2)
%         subplot(2,1,1); plot(tWithinBox,zSlope.*tWithinBox+zIntercept,'g-')
%         subplot(2,1,2); plot(tWithinBox,xSlope.*tWithinBox+xIntercept,'g-')
                
        % Arrival conditions
        % points are descending
        descending = zSlope < 0;
        % points are moving towards runway end along positive axis
        movingTowardsRwyEnd = xSlope < 0;
        % there are points withing tighter box
        
        if descending && movingTowardsRwyEnd
            
            allArrI = allArrI | strcmp(tracksID,uTracks{i});
            
%             figure(1)
%             plot(xWithinBox,yWithinBox,'r.-')
%             
%             figure(3)
%             plot(xSorted,ySorted,'b.-')            
%             hold on
%             
%             figure(2)
%             subplot(2,1,1);plot(tWithinBox,zWithinBox,'ro')
%             subplot(2,1,2);plot(tWithinBox,xWithinBox,'ro')
            
        end
        
    end

% answer = input([uTracks{i},'continue?'],'s') ;
end
arrTrackID = unique(tracksID(allArrI));
