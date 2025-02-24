function [timeRounded] = roundTime(timeNum,units,roundingMode)

switch units
    case 'h' % nearest hour
        switch roundingMode
            case 'r'
                timeRounded = round(timeNum*24)/24;
            case 'f'
                timeRounded = floor(timeNum*24)/24;
            case 'c'
                timeRounded = ceil(timeNum*24)/24;
            otherwise
                timeRounded = round(timeNum*24)/24;                    
        end
    case 'm' % nearest minute
        switch roundingMode
            case 'r'
                timeRounded = round(timeNum*24*60)/(24*60);
            case 'f'
                timeRounded =  round(timeNum*24*60)/(24*60);
            case 'c'
                timeRounded =  round(timeNum*24*60)/(24*60);
            otherwise
                timeRounded =  round(timeNum*24*60)/(24*60);                    
        end        
    case 's' % nearest second
        switch roundingMode
            case 'r'
                timeRounded =  round(timeNum*24*60*60)/(24*60*60);
            case 'f'
                timeRounded =   round(timeNum*24*60*60)/(24*60*60);
            case 'c'
                timeRounded =   round(timeNum*24*60*60)/(24*60*60);
            otherwise
                timeRounded =   round(timeNum*24*60*60)/(24*60*60);                  
        end          
end

end