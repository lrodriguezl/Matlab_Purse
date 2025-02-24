function [segPtsIndex, localIndex] = getArrSegmentAlignedWithRunway(ptsIndex,...
    ptsX,ptsY,aligmentTolerance, minSegLength,slopeThreshold)
%% Aligned segment is that one where:
%   1- Satisfy minimum number of points (minSegLength)
%   2- Points heading are within tolerance
%      (nominally 15 deg, as per Order_8260.3B_CHG_26)
%   3- Earliest point is within tolerance from runway end
%   4- Best fitted line through points has a slope within tolerance
%      (nominally tan(15)

%thresholds
maxXdev = 2; %NM %3 NM
maxYdev = 0.01; %NM %3 NM
% at a sampling rate of a sample every ~ 15 seconds

% initialize output
segPtsIndex = [];
localIndex = [];

% smooth heading using moving average N=10
% smoothedPtsCourse=smooth(ptsCourse,10);
% % get the points that are aligned with the runway heading
% dAngle = diffAngle(ptsCourse,rwyHeading*ones(length(ptsCourse),1));
% ptsOnRwyHdg = diffAngle(smoothedPtsCourse,rwyHeading*ones(length(ptsCourse),1)) < aligmentTolerance;
% ptsOnRwyHdgI =  find(ptsOnRwyHdg);

ptsX = ptsX(:);
ptsY = ptsY(:);
smoothX = smooth(ptsX,10);
smoothY = smooth(ptsY,10);
xyCourse = atan2(diff(smoothY),diff(smoothX))/pi*180; % deg
ptCourse = [xyCourse(1); xyCourse];
smoothedPtCourse = smooth(ptCourse,10); % deg
ptsOnCourse = abs(smoothedPtCourse) < aligmentTolerance; %
ptsOnCourseI = find(ptsOnCourse);


% figure(1)
% cla
% plot(ptsX,ptsY,'k.-')
% hold on
% plot(smoothX,smoothY,'b.-')
% xlabel('x [nm]')
% ylabel('y [nm]')
% 
% figure(2)
% cla
% plot(ptCourse,'k.-')
% hold on
% plot(smoothedPtCourse,'b.-')
% xlabel('index')
% ylabel('course [deg]')
% 
% figure(3)
% cla
% plot(ptsX,'k.-')
% hold on
% plot(smoothX,'b.-')
% xlabel('index')
% ylabel('x [nm]')
% 
% figure(4)
% cla
% plot(ptsY,'k.-')
% hold on
% plot(smoothY,'b.-')
% xlabel('index')
% ylabel('y [nm]')



% if there are points aligned with the runway then extract the last
% segment of the arrival
keep_disregarded_idx = true;
if any(ptsOnCourse)    % get consecutive points that are found along runway heading
    
    [segIndices, listOfSegments, ~, ~] = ...
        groupIndices(ptsOnCourseI,minSegLength,keep_disregarded_idx);
    
    % get the distance along runway centerline at which the last point
    % aligned with the runway was found
    if ~isempty(segIndices)
        [lastPt, ~]= max(segIndices); % 
        
        xDistFromRwyEnd = smoothX(lastPt);
        yDistFromRwyEnd = smoothX(lastPt);
        % check that the distance from runway end  of the
        % last point found is close enough to runway end

        segmentCloseToRunway = (xDistFromRwyEnd <= maxXdev) & (yDistFromRwyEnd <= maxYdev);
        if segmentCloseToRunway
            % fit a line to the identified points that are along the runway
            % heading and close to the runway end.
            
            J =  listOfSegments{end}(1):listOfSegments{end}(2);
            
            [slope,intercept]=bestLine(smoothX(J),smoothY(J));
            
%            figure(1)
%            plot(ptsX(J),ptsX(J)*slope+intercept,'g-')
            
            % if the best line is on top of the runway centerline (within
            % tolerance) then declare a straight semgent off the runway
            isStraightSegment = abs(slope)< slopeThreshold;
            if isStraightSegment
                segPtsIndex = ptsIndex(J);
                localIndex = J';
%                 figure(1)
%                 plot(ptsX(J),ptsY(J),'ro')
%                 
%                 figure(2)
%                 plot(J,smoothedPtCourse(J),'ro')
%                 
%                 figure(3)
%                 plot(J,ptsX(J),'ro')
%                 
%                 figure(4)
%                 plot(J,ptsY(J),'ro')
                
            end
        end
    end
end
% answer = input('continue?','s') ;
end