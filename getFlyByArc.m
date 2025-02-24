function [arcStartPt,arcEndPt,arcRadius,turnAngle] = getFlyByArc(startFix,...
                                                        centerFix,...
                                                        endFix,Vgs,...
                                                        bankAngle)
% This function takes the start, center and end fixes of a bly by turn and
% the ground speed and bank angle to compute the radius, start and end
% point of the fly by arc according to RNAV STAR 
% FAA Order 8260.58, vol 6
% Input 
% startFix: 1 x 2 vector with the x,y coordinates of the fix in NM
% centerFix: 1 x 2 vector with the x,y coordinates of the fix in NM
% endFix: 1 x 2 vector with the x,y coordinates of the fix in NM
% bankAngle: bank angle in degrees
% Vgs: ground speed in knots 
% Output
% arcStartPt: 1 x 2 vector with the x,y coordinates of the arc start point in NM
% arcEndPt: 1 x 2 vector with the x,y coordinates of the arc end point in NM
% arcRadius: radius of the fly by arc in NM

% compute initial turn radius 
intialArcRadius = (Vgs^2)/(tan(bankAngle*pi/180)*68625.4); % NM
% compute intermediate turn radius
intermediateArcRadius = quantize_data(intialArcRadius,1/100);

% compute turn angle
m = diff([startFix(2),centerFix(2),endFix(2)])./diff([startFix(1),centerFix(1),endFix(1)]);
alpha = atan(m)/pi*180; %[deg]
turnAngle = 180 - abs(diff(alpha)); %[deg]

% compute distance of turn anticipation (DTA)
DTA = intermediateArcRadius*tan((turnAngle/(2*180))*pi); %[NM]

if DTA > 20
    DTA = 20;
    arcRadius = DTA/tan((turnAngle/(2*180))*pi);
else
    arcRadius = intermediateArcRadius;
end

% computing start and end points of fly by turn
d= arcRadius/tan((turnAngle/2)*(pi/180));
dist_in_bound_leg_x = abs(diff([startFix(1),centerFix(1)]));
dist_in_bound_legt_y = abs(diff([startFix(2),centerFix(2)]));
dist_in_bound_leg = sqrt(dist_in_bound_leg_x^2+dist_in_bound_legt_y^2);

dist_out_bound_leg_x = abs(diff([centerFix(1),endFix(1)]));
dist_out_bound_legt_y = abs(diff([centerFix(2),endFix(2)]));
dist_out_bound_leg = sqrt(dist_out_bound_leg_x^2+dist_out_bound_legt_y^2);

dx1 = dist_in_bound_leg_x*d/dist_in_bound_leg;
dy1 = dist_in_bound_legt_y*d/dist_in_bound_leg;

dx2 = dist_out_bound_leg_x*d/dist_out_bound_leg;
dy2 = dist_out_bound_legt_y*d/dist_out_bound_leg;

startPt_x  = centerFix(1) - dx1;
startPt_y  = centerFix(2) + dy1;
arcStartPt = [startPt_x, startPt_y];

endPt_x  = centerFix(1) + dx2;
endPt_y  = centerFix(2) - dy2;
arcEndPt = [endPt_x, endPt_y];
end