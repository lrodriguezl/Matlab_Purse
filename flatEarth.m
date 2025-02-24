function [x1,y1, x, y]=flatEarth(lat,lon)
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

dx =zeros(length(lat),1);
dy =zeros(length(lat),1);

origin_lat = lat(1:m-1);
origin_lon = lon(1:m-1);

dx(2:end) = NMperDeg.*cos(origin_lat.*radPerDeg).*(lon(2:end)-origin_lon);
dy(2:end) = NMperDeg.*(lat(2:end)-origin_lat);

x = cumsum(dx); 
y = cumsum(dy);
%% Projecting an Arbitrary Latitude and Longitude onto a Tangent Plane
% MERS Technical Report # MERS 99-04 year 1999
% www.mers.byu.edu/docs/reports/MERS9904.pdf
km2NM = 0.539956803;
k_flat = 1/298.257; % earth flatness constant
Ra = 6378.1363; % km semi major axis of the earth

dx1 =zeros(length(lat),1);
dy1 =zeros(length(lat),1);

R_earth = (1 - k_flat.*(sin(lat(2:end).*radPerDeg)).^2).*Ra; % local earth radius
R_lat = R_earth.*cos(lat(2:end).*radPerDeg); % radius of local latitude line
delta_lon = (lon(2:end)-origin_lon);
delta_lat = (lat(2:end)-origin_lat);

dx1(2:end) = R_lat.*sin(delta_lon.*radPerDeg); % km
dy1(2:end) = R_earth.*sin(delta_lat.*radPerDeg) + R_lat.*(1-cos(delta_lon.*radPerDeg)).*sin(origin_lat.*radPerDeg); % km

x1 = cumsum(dx1).*km2NM; 
y1 = cumsum(dy1).*km2NM;
end