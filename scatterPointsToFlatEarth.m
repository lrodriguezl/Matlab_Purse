function [x,y, x_approx, y_approx]= scatterPointsToFlatEarth(lat,lon,origin)
%
% [x,y] = flatEarth(lat,lon)
% lat and lon need to contain at least 2 points
% the first point is used as the origin of the plane
% lat:  latitude in degrees
% lon:  longitude in degrees
% x:    vector of x values in NM
% y:    vector of y values in NM
%
% converts lat/lon to x and y vector tangent plane 
% approximation using the origin property.
% To minimize error the previous point is alwyas used as the origin
m = length(lat);
radPerDeg = pi/180;
NMperDeg = 60.0068669107676; %spherical

origin_lat = origin(1);
origin_lon = origin(2);

x_approx = NMperDeg*cos(origin_lat*radPerDeg).*(lon-origin_lon); % NM
y_approx = NMperDeg.*(lat - origin_lat); %NM

%% Projecting an Arbitrary Latitude and Longitude onto a Tangent Plane
% MERS Technical Report # MERS 99-04 year 1999
% www.mers.byu.edu/docs/reports/MERS9904.pdf
km2NM = 0.539956803;
k_flat = 1/298.257; % earth flatness constant
Ra = 6378.1363; % km semi major axis of the earth

R_earth = (1 - k_flat*(sin(lat*radPerDeg)).^2)*Ra; % local earth radius
R_lat = R_earth.*cos(lat.*radPerDeg); % radius of local latitude line
delta_lon = (lon - origin_lon);
delta_lat = (lat - origin_lat);

x = km2NM*(R_lat.*sin(delta_lon*radPerDeg)); % NM
y = km2NM*(R_earth.*sin(delta_lat.*radPerDeg) + R_lat.*(1-cos(delta_lon.*radPerDeg)).*sin(origin_lat.*radPerDeg)); % NM

end