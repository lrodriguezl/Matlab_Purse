function drawRing(R)
% plot ring
plot(R*cos(0:pi/100:2*pi),R*sin(0:pi/100:2*pi),'k--',...
    'LineWidth',4)
end