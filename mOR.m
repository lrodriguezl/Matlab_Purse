function [LV] = mOR(V,O)
% LV = mOR(V,O)
% performs EQUAL operation between V and each value of O
% performs OR Operation m times, where m = length(O)
% using the results of the EQUAL operations
% Example:
%   V = [1;1;4;5;6;6;5;5;4]    
%   O = [1;5] 
%   LV = mOR(V,O)
%   LV 
%   [1;1;0;1;0;0;1;1;0]
% Works the same way as ismember.
% It's just simpler and quicker
% Input: 
%   V: nx1 vector of doubles
%   O: mx1 vector of doubles
% Ouput:
%   LV: nx1 Logical vector

LV = false(length(V),1);
for i=1:length(O)
    LV = LV | V==O(i);
end
end