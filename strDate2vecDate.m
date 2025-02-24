function [Y,M,D,H,H0_23,MN,S,PM_AM, weekDays] = strDate2vecDate(strDate)
% Accepted dtrDate formats
% '6/1/2015  12:00:00 AM'
% '6/1/2015  12.00.00 AM'
% '6/1/2015  22:00:00'

%% Extract Dates
Y = nan(length(strDate),1);
M = nan(length(strDate),1);
D = nan(length(strDate),1);
PM_AM = cell(length(strDate),1);
H = nan(length(strDate),1); % original hour format
H0_23 = nan(length(strDate),1); % 0-23
MN = nan(length(strDate),1); % minute
S = nan(length(strDate),1); % seconds
weekDays = nan(length(strDate),1);

for i=1:length(strDate)
    s1=regexp(strDate{i},' ','split');
    % get date part
    datePart = s1{1};
    if length(s1)>1
        % get hour part
        hourPart = s1{2};
        if ~isempty(strfind(hourPart,':'))
            s2 = regexp(hourPart,':','split');
        elseif ~isempty(strfind(hourPart,'.'))
            s2 = regexp(hourPart,'\.','split');          
        end
        % get hours, minutes, seconds
        H(i) = str2double(s2{1});
        MN(i) = str2double(s2{2});
        S(i) = str2double(s2{3});   
    else
        H(i)=0;
        H0_23(i)=0;
        MN(i)=0;
        S(i)=0;
        PM_AM{i}= 'AM';        
    end
    % set the 24-hour format H1 PM_AM
    switch length(s1)
        case 2
            %FORMAT  '6/1/2015  22:00:00'            
            H0_23(i) = H(i);
            if H0_23(i)>= 12
                PM_AM{i} = 'PM';
            else
                PM_AM{i} = 'AM';
            end      
        case 3            
            % FORMATS
            % '6/1/2015  12:00:00 AM'
            % '6/1/2015  12.00.00 AM'
            PM_AM{i} = s1{3};
            if strcmpi(s1{3},'PM')
                H0_23(i) = mod(H(i) + 12,23);
            else
                H0_23(i) = H(i);
            end
    end
%     if length(s1)==3
% % FORMATS
% % '6/1/2015  12:00:00 AM'
% % '6/1/2015  12.00.00 AM'        
%         PM_AM{i} = s1{3};
%         if strcmpi(s1{3},'PM')
%             H1(i) = H(i) + 12;
%         else
%             H1(i) = H(i);
%         end        
%     elseif length(s1)==2
% %FORMAT  '6/1/2015  22:00:00'
%        
%         H1(i) = H(i);
%         if H1(i)>= 12
%             PM_AM{i} = 'PM';
%         else
%             PM_AM{i} = 'AM';
%         end
%     end
    if ~isempty(strfind(datePart,'/'))
        s3=regexp(datePart,'/','split');
        M(i) = str2double(s3{1});
        D(i) = str2double(s3{2});
        Y(i) = str2double(s3{3});
    elseif ~isempty(strfind(datePart,'-'))
        s3=regexp(datePart,'-','split');
        D(i) = str2double(s3{1});
        if length(s3{2})<3
            M(i) = str2double(s3{2});
        elseif length(s3{2})>2
%             M(i) = monthToNum(S3{2});
        end
        Y(i) = str2double(s3{3});
    end
    if Y(i) < 2000;
        Y(i)=Y(i)+2000;
    end
    if ~isnan(M(i)) & ~isnan(D(i)) & ~isnan(Y(i))
        weekDays(i) = weekday([num2str(M(i)),'/',num2str(D(i)),'/',num2str(Y(i))]);
    end
end

end