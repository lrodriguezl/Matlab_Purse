function [newTrackPts, I1,M] = truncateTrack(trackPts,startPt,endPt,GgeometryMode)
% this function assumes a monotonous track (no loops)
% trackPts: n x 2 vector containing lat lon of a track
% startPt: 1 x 2 vector containig lat lon of the reference point for the
%                start of the track
% endPt: 1 x 2  vector containig lat lon of the reference point for the
%                end of the track

nPoints = size(trackPts,1);
d=nan(nPoints,2);

% distance from point to fix
%      StartPt   EndPt
%      _                _
% pt1 |d11       d12     |
% pt2 |                  |  
% ptM |                  |
%      -                -

% compute distance from track points to end points
if GgeometryMode==1 % geodesic    
    for i=1:nPoints
        d(i,1) = vdist(trackPts(i,1),trackPts(i,2),startPt(1),startPt(2)); % meters
        d(i,2) = vdist(trackPts(i,1),trackPts(i,2),endPt(1),endPt(2)); % meters
    end
elseif GgeometryMode==2 % flat
    ptx = trackPts(:,1); pty= trackPts(:,2);
    spx = startPt(1); spy = startPt(2);
    epx = endPt(1); epy = endPt(2);
    d(:,1) = sqrt((ptx - spx).^2  + (pty - spy).^2);
    d(:,2) = sqrt((ptx - epx).^2  + (pty - epy).^2);
    
end

% find  minimum distance from points to each fix
[M, I]= min(d,[],1);
I1=sort(I);
newTrackPts = trackPts(I1(1):I1(2),:);
end