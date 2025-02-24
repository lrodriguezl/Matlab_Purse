function [minVal, maxVal, Q1, Q2, Q3] = fiveNumSummary(y)
%%
N= length(y);

minVal = min(y);
maxVal = max(y);

if N>1
    sorted_y = sort(y);
    
    n_q1 = N/4;
    n_q2 = N/2;
    n_q3 = 3*N/4;
    
    if mod(N,4)==0
        Q1 = (sorted_y(n_q1) + sorted_y(n_q1+1))/2;
        Q3 = (sorted_y(n_q3) + sorted_y(n_q3+1))/2;
    else
        Q1=sorted_y(round(n_q1));
        Q3=sorted_y(round(n_q3));
    end
    
    if mod(N,2)==0
        Q2 = (sorted_y(n_q2) + sorted_y(n_q2+1))/2;
    else
        Q2=sorted_y(round(n_q2));
    end
else
    Q1=y; Q2=y; Q3=y;
end
end