function [track_angle1, track_angle2] = getTrackAngle(lat,lon)


m = length(lat);

s_lat = smooth(lat,20); % deg
s_lon = smooth(lon,20); % deg

lat1 = s_lat(1:m-1).*(pi/180); % rad
lon1 = s_lon(1:m-1).*(pi/180); % rad

lat2 = s_lat(2:end).*(pi/180); % rad
lon2 = s_lon(2:end).*(pi/180); % rad

dLat = lat2 - lat1;
dLon = lon2 - lon1;

y = sin(dLon).*cos(lat2);
x =  cos(lat1).*sin(lat2) - sin(lat1).*cos(lat2).*cos(dLon);

track_angle1 = (180/pi).*atan2(y,x); % deg

[x1,y1]=flatEarth(s_lat,s_lon);
track_angle2 = (180/pi).*atan2(diff(y1),diff(x1)); % deg

end

