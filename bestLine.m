function   [m,n,resVar,rsq] = bestLine(x,y)
% 
%   [m,n,resVar,rsq] = bestLine(x,y)
%
%  fits a line  in x,y plane 
%  x,y are column vector where (x(i),y(i)) is a measured point
%
%  result is (m,n) slope and intercept of a line
%
%   y - m*x - n=0
%
% solving matrix MN from x and y vectors
% [y] + [x 1]*MN = 0
%
% where MN = [-m
%             -n]
%
% [x 1]*MN = -[y];  
% ([x 1]^-1)*[x 1]*MN = ([x 1]^-1) * (-[y])
% I * MN = ([x 1]^-1) * (-[y]) 
% I * MN = [x 1]\(-[y])  matrix division from the right
%
% ERROR
% residual = m*x+n - y 
% residual variance
% resVar = sum(residual^2)/length(residual);
% R^2
% SSresid = sum(residual.^2);
% SStotal = (length(y)-1) * var(y);
% rsq = 1 - SSresid/SStotal

   x=x(:); y=y(:);
   I= ones(size(x));
   a=[x, I]\(-y);
   m = -a(1);
   n = -a(2);
   
   yo = m.*x + n;
   residual = yo-y;
   resVar = var(residual);

% R^2
SSresid = sum(residual.^2);
% SStotal = (length(y)-1) * var(y);
SStotal = sum((y-mean(y)).^2);
rsq = 1 - SSresid/SStotal;
%% Linear Fit using element by element algebra (as opposed to matrix operations)
% Sx = sum(x);
% Sy = sum(y);
% Sxx = sum(x.*x);
% Sxy = sum(x.*y);
% N=length(x);
% 
% m1 = (N*Sxy-Sx*Sy)/(N*Sxx-Sx*Sx);
% n1 = (Sy-m*Sx)/N;
% yReg = n1+m1.*x;
