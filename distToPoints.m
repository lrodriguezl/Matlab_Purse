function [minDist,I,d] = distToPoints(trackPts,RefPts,GgeometryMode)
% this function assumes a monotonous track (no loops)
% Input:
% trackPts: n x 2 vector containing lat lon of a track
% RefPoints: m x 2 vector containig lat lon of the reference points
% Output:
% minDist: 1 x m vector containing minmum distance to each of the reference
%                points
% I:       1 x m  vector containing the index of the track point closest to
%                 the reference point
% Method:
% Distance Matrix containng
% Distance from track points to reference point
%      Pt1  P2t  Pt3
%      _                _
% pt1 |d11  d12  d13     |
% pt2 |                  |
% ptM |                  |
%      -                -
nPoints = size(trackPts,1);
nRefPoints = size(RefPts,1);
d=nan(nPoints,nRefPoints);

for i=1:nRefPoints
    % compute distance from track points to end points
    if GgeometryMode==1 % geodesic
        for j=1:nPoints
            d(j,i) = vdist(trackPts(j,1),trackPts(j,2),RefPts(i,1),RefPts(i,2)); % meters
        end
    elseif GgeometryMode==2 % flat
        ptx = trackPts(:,1); pty= trackPts(:,2);
        refptx = RefPts(i,1); refpty = RefPts(i,2);
        d(:,i) = sqrt((ptx - refptx).^2  + (pty - refpty).^2);        
    end    
end
% find  minimum distance from points to each fix
[minDist, I]= min(d,[],1);
end