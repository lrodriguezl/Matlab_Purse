function [segments]= splitTracksAtFixes(track,fixes,varargin)
% track gets segmented using the location of the waypoints
% the sequence the track points should 
% match the sequence of the waypoints
% for example: 
%   p1 p2 p3 p4 p5 p6 p7 p8 p9 
%   .  .  .  .  .  .  .  .  .
%          x            x
%         F1            F2
% 
% input
% track: n x 2 vector containing lat lon pairs
% fixes: m x 2 vector containig fixes lat lon pairs
%
% output
% segments: n x 1 vector with segment number
%
% tolerance
if nargin==3
    epsilon=varargin{1}; %NM
else
    epsilon=1000; %meters
end
% Description: labels segments within track
[nPoints ~] = size(track);
[nFixes ~] = size(fixes);

segments= zeros(nPoints,1);
d=nan(nPoints,nFixes);

% distance from point to fix
%     fix1 fix2 fix3 fixN
%      _                _
% pt1 |d11 d12           |
% pt2 |                  |  
% ptM |                  |
%      -                -

% compute distance from points to fix
for i=1:nPoints
    for j=1:nFixes
        d(i,j) = vdist(track(i,1),track(i,2),fixes(j,1),fixes(j,2)); % meters
    end
end
% find  minimum distance from points to each fix
[C, I]= min(d,[],1);
% acceptable_dist = C<=epsilon;
% [row, col, v]= find(C<=epsilon);
% label first segment
segments(1:I(1),1)= 1;
if nFixes == 1
    segments((I(1)+1:end),1)= 2;
elseif nFixes>1
    % label middle segments
    for k=2:length(I)
        range = (I(k-1)+1):I(k);
        segments(range,1)=k;
    end
    % label last segment
    segments((I(k)+1:end),1)= k+1;    
end
end