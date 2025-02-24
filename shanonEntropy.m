function Eshanon = shanonEntropy(p1,p2)
% Distance based on Shanon Entropy
Kp1p2 = p1.*log(p1./(p1/2 + p2/2));
Kp2p1 = p2.*log(p2./(p1/2 + p2/2));
v1=~isnan(Kp1p2) & ~isinf(Kp1p2);
v2=~isnan(Kp2p1) & ~isinf(Kp2p1);
Eshanon=sum(Kp1p2(v1))+sum(Kp2p1(v2));
end