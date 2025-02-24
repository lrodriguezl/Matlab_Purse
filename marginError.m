function [ME] = marginError(CI,p,n)

z_=[1.03 1.15 1.28 1.654 1.96 2.58];
CI_=[70 75 80 90 95 99];
if any(CI==CI_)
    z=z_(CI==CI_);
else
    z=[];
end
ME = z*sqrt(p*(1-p)/n);

end