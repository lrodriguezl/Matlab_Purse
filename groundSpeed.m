function [gs,iSorted] = groundSpeed(x,y,time)
%% computes ground speed
% Input:
% 	x [nx1] x coordinates (flat earth)
% 	time [nx1] y coordinates (flat earth)
% 	time [nx1] matlab time vector
% Output:
%	gs [nx1] ground speed
%   iSorted [nx1] index after sorting by time 
%                 each gs corresponds to x(iSorted) 

[tSorted, iSorted]= sort(time);
dt = diff(tSorted); % hour
dx = diff(x(iSorted)); % NM
dy = diff(y(iSorted)); % NM
ds = sqrt((dx).^2 + (dy).^2); %NM

gs = nan(length(dx)+1,1);
gs(2:end) = ds./dt; % knots= NM/H
end