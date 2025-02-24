function [subtendedAngle] = getArcSubtendedAngle(centerPt, startPt,endPt)
% arc subtended angle in rad 
theta1 = atan2(startPt(2)-centerPt(2),startPt(1)-centerPt(1)); %rad
theta2 = atan2(endPt(2)-centerPt(2),endPt(1)-centerPt(1)); % rad

delta1 = abs(theta1 - theta2); % rad
delta2 = 2*pi - delta1; % rad
subtendedAngle = min(delta1,delta2); %rad

end