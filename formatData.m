function [formatted_matrix] = formatData(data,mapper)
% data -n x m matrix with original data
% mapper - 1 x m vector specifying new column number. 0 indicates that
%          column will not map to anything in the formatted matrix
% fomatted_matrix - n x M matrix containing columns specified in mapper
% %%
% data = [1  4   5    6  7;...
% 		5  55  7567 33 33423;...
% 		0  334 0    4  2; ...
% 		45 1   3    5  6]
% 
% mapper = [0 3 1 0 2]
%%
[S1, I1]=sort(mapper);
I2=I1(S1~=0);
%%
formatted_matrix= data(:,I2);
end