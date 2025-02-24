function xWind = getXwind(wDir,wMag,referenceHeading)
% xWind = getXwind(wDir,wMag,rwyHeading)
% wDir : wind direction in degrees. orientation: FROM
% wMag : wind magnitude in knots
% desiredHeading :  heading across which the corss wind is going to be
%                   computed

dirTO = mod(wDir + 180,360) ; % deg TO
theta1 = diffAngle(referenceHeading,dirTO);
% theta = referenceHeading - dirTO;
xWind = wMag.*sin(theta1/180*pi); % knots
end
function angleDiff = diffAngle(angle1,angle2)
% 
% [angle_rate] = diffAngle(angle)
% angle1:  angle in degrees
% angle2:  angle in degrees
% angleDiff:  difference batween angle1 and angle2
% compute the difference between two angles
% the result will always be possitive

angle1 = angle1(:);
if any(angle1>180)
    angle1(angle1>180) = angle1(angle1>180)-360;    
end

angle2 = angle2(:);
if any(angle2>180)
    angle2(angle2>180) = angle2(angle2>180)-360;    
end

delta1 = abs(angle1-angle2);
delta2 = 360 - delta1;

angleDiff = min([delta1,delta2],[],2);
end