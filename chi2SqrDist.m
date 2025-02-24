function CHI2dist = chi2SqrDist(p1,p2)
% Chi2 distance
numerator = (p1-p2).^2;
denominator = p1+p2;
N=denominator > 0;
CHI2dist = sum( numerator(N) ./ denominator(N) ) / 2;
end