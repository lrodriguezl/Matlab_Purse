function   [xc,yc,R,a,residual,resVar,rsq] = bestCircle(x,y)
% 
%   [xc,yc,R,a,resVar,rsq] = bestCircle(x,y)
%
%  fits a circle  in x,y plane 
%  x,y are column vector where (x(i),y(i)) is a measured point
%
%  result is center point (yc,xc) and radius R
%  an optional output is the vector of coeficient a
% describing the circle's equation
%
%   x^2+y^2+a1*x+a2*y+a3=0
%
%  based on code By:  Izhak bucher 25/oct /1991, 
% modified by Laura Rodriguez 11/30/2011
% 20 years later!!! wow!!
% xc = -a1/2
% yc = -a2/2
% R  = sqrt((A^2+B^2)/4-C)
% solving matrix A from x and y vectors
% [x^2+y^2] + [x y 1]*A = 0
% where A = [a1
%            a2
%            a3]
% A = -[x^2+y^2]*[x y 1]^-1
% ERROR
% residual = ((x-xc).^2+(y-yc).^2)^0.5 - r 
% residual variance
% resVar = sum(residual^2)/length(residual);
% R^2
% SSresid = sum(residual.^2);
% SStotal = (length(y)-1) * var(y);
% rsq = 1 - SSresid/SStotal

    x=x(:); y=y(:);
   a=[x y ones(size(x))]\(-(x.^2+y.^2));
   xc = -.5*a(1);
   yc = -.5*a(2);
   R  =  sqrt((a(1)^2+a(2)^2)/4-a(3));
   
   residual = ((x-xc).^2+(y-yc).^2).^0.5-R;
   resVar = var(residual);
   
% R^2
SSresid = sum(residual.^2);
SStotal = (length(y)-1) * var(y);
rsq = 1 - SSresid/SStotal;
