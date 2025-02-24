function [q_data] = quantize_data(data,stepSize,roundingMode)
% [q_data] = quantize_data(data,stepSize,roundingMode)

if nargin==2
    % round towards zero
    rounded = fix(abs(data)./stepSize);
else
    if strcmp(roundingMode,'fix')
        rounded = fix(abs(data)./stepSize);
    elseif  strcmp(roundingMode,'ceil')
        rounded = ceil(abs(data)./stepSize);
    elseif strcmp(roundingMode,'floor')
        rounded = floor(abs(data)./stepSize);
    elseif strcmp(roundingMode,'round')
        rounded = round(abs(data)./stepSize);        
    end
end
q_data = sign(data).*stepSize.*rounded;
end