function matrixOut = struct2mat(structIn,desiredFields)
% All contents of the input
% cell array must be of the
% same data type.
S=(struct2cell(structIn))';
tempCell = cell(1,length(desiredFields));
for i=1:length(desiredFields)    
    tempCell(i) = S(desiredFields(i));
end
matrixOut = cell2mat(tempCell);
end