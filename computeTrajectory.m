function [new_x,new_y] = computeTrajectory(t,track_angle,gs)
%
% [new_x,new_y] = computeTrajectory(t,track_angle,gs)
% t:  time in seconds
% track_angle:  course angle with respect to north [degrees]
% gs:   ground speed [knots] (NM per Hours)
% new_x:    vector of x values [NM]
% new_y:    vector of y values [NM]
% calculate trajectory from track angle and ground speed

m=length(track_angle)-1;
dt = diff(t)./3600; % hours
ds = dt.*gs(1:m); % NM
beta = (pi./180).*(track_angle(1:m)); % rad
dx = ds.*sin(beta); % NM
dy = ds.*cos(beta); % NM

new_x = cumsum([0; dx]); % NM
new_y = cumsum([0; dy]); % NM

end