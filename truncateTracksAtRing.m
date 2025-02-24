function [Iinner10,x10,y10,t10] = truncateTracksAtRing(MaxRadius,trackData)
%% Truncate Tracks at 10 NM

x = trackData.x;
y = trackData.y;
t = trackData.t;
[ts,Is]= sort(t);
xs=x(Is);
ys=y(Is);

% Conver to Polar [Theta, Rho]
% [theta1,r1] = cordiccart2pol(newX,newY);
[theta,r] = cart2pol(xs,ys);
Iinner10 = r <= MaxRadius;
Iouter10 = r > MaxRadius;

Idxt1 = find(Iinner10,1,'first');
Idxt2 = find(Iouter10,1,'last');
x1 = xs(Idxt1);
y1 = ys(Idxt1);
t1 = ts(Idxt1);

x2 = xs(Idxt2);
y2 = ys(Idxt2);
t2 = ts(Idxt2);

slope = (y2-y1)/(x2-x1);
intercpt = y1 - slope*x1;
[xout,yout] = linecirc(slope,intercpt,0,0,MaxRadius);

I10 = ((min(x1,x2)<= xout)  & (xout <= max(x1,x2))) & ((min(y1,y2)<= yout)  & (yout <= max(y1,y2)));
x10 = xout(I10);
y10 = yout(I10);

d = sqrt((x1-x2)^2+(y1-y2)^2);
d1 = sqrt((x1-x10)^2+(y1-y10)^2);
dt = seconds(t1-t2);
dt1=dt*d1/d;
t10 = t1 - seconds(dt1);

% figure(2)
% polar(theta,r)
% figure(1)
% plot(xs(Idxt1),ys(Idxt1),'rd')
% plot(xs(Idxt2),ys(Idxt2),'rd')
% plot(x10,y10,'g*')
end