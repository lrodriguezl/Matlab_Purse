function [perX]= getPercentiles(x,p) 
n=length(x);    
q=[0 100*(0.5:1:n-0.5)./n 100]';
xs=sort([x(1);x;x(end)]);

perX=interp1(q,xs,p);
end

