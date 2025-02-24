function [xc1, yc1, xc2, yc2] = FindCenterOfArc(pt1,pt2,r,varargin)

if nargin>3
    eps=varargin{1};
else
    eps= 0.005;
end
x1 = pt1(1);
y1 = pt1(2);

x2 = pt2(1);
y2 = pt2(2);

x3 = (x1+x2)/2;
y3 = (y1+y2)/2;

q = sqrt((x2-x1)^2 + (y2-y1)^2);
% if the length of q is equal to r (within tolerance) then
% there is only one possible circle that can be constructred
% and the line that connects pt1 and pt2 is the diameter of that circle
% and the center point is the mid point between pt1 an pt2
if abs(q/2-r)<eps
    xc1 = x3;
    yc1 = y3;
    xc2 = x3;
    yc2 = y3;
else % otherwise use auxiliary triangles and find center of arc
    h= sqrt(r^2-(q/2)^2);
    xc1 = x3 + h*(y1-y2)/q;
    yc1 = y3 + h*(x2-x1)/q;
    
    xc2 = x3 - h*(y1-y2)/q;
    yc2 = y3 - h*(x2-x1)/q;
end
end