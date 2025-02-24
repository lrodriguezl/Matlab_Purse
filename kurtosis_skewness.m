function [x_kurtosis x_skewness]= kurtosis_skewness(x)
n=length(x);
x_mean =  mean(x);
E2= mean((x - x_mean).^2);
E3= mean((x - x_mean).^3);
E4= mean((x-x_mean).^4);

k1=E4/(E2)^2;
s1= E3/(sqrt(E2))^3;

x_kurtosis = ((n-1)/((n-2)*(n-3)))*((n+1)*k1 - 3*(n-1)) + 3;
x_skewness = (sqrt(n*(n-1))/(n-2)) * s1;
end