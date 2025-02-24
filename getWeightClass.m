function [usWeightClass] = getWeightClass(acType,varargin)

switch  nargin
    case 1
        S=load('weightClasses.mat');
        if isempty(S)
            error(['Cannot find weightClasses.mat download from ',...
                'https://gitlab.mitre.org/lrodriguez/Matlab-Purse/blob/master/weightClasses.mat'])
        end
        allAc = S.AircraftType;
        allUsWc = S.USClass;
    case 2
        filepath = varargin{1};
        if ~ischar(filepath)
            error('the expected input is a filepath to weightClasses.mat')
        else
            S=load(filepath);
            allAc = S.AircraftType;
            allUsWc = S.USClass;
        end
    case 3
        allAc = varargin{1};
        allUsWc = varargin{2};
    otherwise
end

if ischar(acType)
    I=strcmp(allAc,acType);
    usWeightClass = unique(allUsWc(I));
elseif iscell(acType)
    uAc = unique(acType);
    usWeightClass = cell(length(acType),1);
    for i=1:length(uAc)
        I=strcmp(allAc,uAc{i});
        usClass = unique(allUsWc(I));
        if ~isempty(usClass) && length(usClass)==1
            acI=strcmp(acType,uAc{i});
            usWeightClass(acI)= usClass;
        end
    end
else
    error('Wrong Input Type')
end