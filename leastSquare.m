function [m,n] = leastSquare(x,y)
    
N=length(x);
xy=x.*y;
x2=x.^2;

m = (N*sum(xy)-sum(x)*sum(y))/(N*sum(x2) - (sum(x))^2);
n=(sum(y)-m*sum(x))/N;

end