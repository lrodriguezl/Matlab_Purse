function [excelColNum, excelColLabels] = getExcelColNum(ColLabel)

letters={'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p',...
    'q','r','s','t','u','v','w','x','y','z'};
excelColLabel = lower(ColLabel);
excelColNum= [];
excelColLabels=[];
if iscell(excelColLabel)
%     [nRow nCol]=size(excelColLabel);
    excelColNum= [];
    excelColLabels=[];
elseif ischar(excelColLabel)
    switch length(excelColLabel)
        case 1
            excelColNum = find(strcmp(excelColLabel,letters));
            excelColLabels = letters(1:excelColNum)';
        case 2
            firstLetter = excelColLabel(1);
            this_col = twoLetterLables(firstLetter);
            excelColNum = find(strcmp(excelColLabel,this_col));
            excelColLabels = this_col;
        case 3
            firstLetter = excelColLabel(1);
            secondLetter = excelColLabel(2);
            M=find(strcmp(firstLetter,letters));
            N=find(strcmp(secondLetter,letters));            
            this_col = cell(26*(N*M+26),1);
            this_col(1:702)=twoLetterLables('z');
            m=703;
            for i=1:M
                for j=1:N
                    for k=1:length(letters)
                        this_col{m}=[letters{i},letters{j},letters{k}];
                        m=m+1;
                    end
                end
            end
            excelColNum = find(strcmp(excelColLabel,this_col));
            excelColLabels = this_col;            
    end
end
end


%% helper function
function [colLabels]= twoLetterLables(firstLetter)
letters={'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p',...
    'q','r','s','t','u','v','w','x','y','z'};
M=find(strcmp(firstLetter,letters));
colLabels = cell(26*(M+1),1);
colLabels(1:26)=letters(:);
m=27;
for i=1:M
    for j=1:length(letters)
        colLabels{m}=[letters{i},letters{j}];
        m=m+1;
    end
end
end