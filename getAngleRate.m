function angle_rate = getAngleRate(angle)
% 
% [angle_rate] = getAngleRate(angle)
% angle:  angle in degrees
% angle_rate:  angle rate in degrees
% compute the rate of change of continous angles
% the result will always be possitive

angle = angle(:);
if any(angle)>180
    angle(angle>180) = angle(angle>180)-360;    
end
delta1 = abs(diff(angle));
delta2 = 360 - delta1;

angle_rate = min(delta1,delta2);
end