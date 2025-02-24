function [newParam] = fixOffset(param,offsetThreshold)
%%
dparam = [0; diff(param)];
discontinuity_index = find(abs(dparam)>offsetThreshold);

newParam = param;
if ~isempty(discontinuity_index)
    offset = dparam(discontinuity_index);
    for i=1:length(offset)
        newParam(discontinuity_index(i):end) = newParam(discontinuity_index(i):end) - offset(i);
    end
end
end