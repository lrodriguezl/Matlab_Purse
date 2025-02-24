function [L,RMSD,CHI2dist,V] = histogramDiff(data1,data2,bins)

  
    % histograms
%     ud1=unique(data1);
%     ud2=unique(data2);
%     b=union(ud1,ud2);
    b=bins;
    [f1,~]=hist(data1,b);
    p1=f1/length(data1);
    
    [f2,~]=hist(data2,b);
    p2=f2/length(data2);
    
    % Distance based on Shanon Entropy
    Kp1p2 = p1.*log(p1./(p1/2 + p2/2));
    Kp2p1 = p2.*log(p2./(p1/2 + p2/2));
    v1=~isnan(Kp1p2);
    v2=~isnan(Kp2p1);
    L=sum(Kp1p2(v1))+sum(Kp2p1(v2));
    
    % root mean square distance
    RMSD = sqrt(mean((p1-p2).^2));
    % Chi2 distance
    numerator = (p1-p2).^2;
    denominator = p1+p2;
    N=denominator > 0;
    CHI2dist = sum( numerator(N) ./ denominator(N) ) / 2;

%     CHI2dist = sum( (p1-p2).^2 ./ (p1+p2) ) / 2;
    % variational distance
    V = sum(abs(p1-p2));
end