function [RMSD, CHI2dist, Q_Q, P_P, Hist1, Hist2] = Compare2Populations(xo,yo)
% input: two sets of quantized data

x=xo(~isnan(xo));
y= yo(~isnan(yo));

% histogram

bin = unique([x;y]);

bin_x= unique(x);
bin_y= unique(y);
xy_bin=intersect(bin_x,bin_y);

[freq_x,~] = hist(x,bin);
prob_x = freq_x/length(x);
cumProb_x = cumsum(prob_x);

[freq_y,~] = hist(y,bin);
prob_y = freq_y/length(y);
cumProb_y = cumsum(prob_y);

Hist1.prob = prob_x;
Hist1.bin= bin;
Hist1.cumProb= cumProb_x;

Hist2.prob = prob_y;
Hist2.bin= bin;
Hist2.cumProb= cumProb_y;

I1=ismember(bin,xy_bin);

P_P.x = cumProb_x(I1);
P_P.y = cumProb_y(I1);
P_P.bin = bin(I1);

px=100*prob_x;
py=100*prob_y;
RMSD = sqrt(mean((px-py).^2));
CHI2dist = sum( (px-py).^2 ./ (px+py) ) / 2;

X=sort(x); Lx=length(x)-1;
Y=sort(y); Ly=length(y)-1;

% [Ix ix]= unique(round(100*(0:Lx)/Lx),'first');
% [Iy iy]= unique(round(100*(0:Ly)/Ly),'first');
% % I = Ix(ix) and I = Iy(iy).
% [I,ia,ib]=intersect(Ix,Iy);
%
% Qx = X(ix(ia));
% Qy = Y(iy(ib));
% M=min([length(Qx),length(Qy)]);
% Q_Q.x = Qx(1:M);
% Q_Q.y = Qy(1:M);
% Q_Q.q = I;

I=0.05:0.05:99.95;
X_rank = round((I./100).*Lx+0.5);
Y_rank = round((I./100).*Ly+0.5);

Q_Q.x = X(X_rank);
Q_Q.y = Y(Y_rank);
Q_Q.q = I;
end