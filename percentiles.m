function [xp] = percentiles(x,p)

L=length(x);
if L>1
    pLoc = max(ceil(L*p/100),1);
    xSorted = sort(x);
    xp = xSorted(pLoc);
else
    xp = nan(1,length(p));
end
end