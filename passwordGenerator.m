function [password] = passwordGenerator()
lowerCase = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o',...
    'p','q','r','s','t','u','v','w','x','y','z'};
upperCase = upper(lowerCase);
numeric = {'0','1','2','3','4','5','6','7','8','9'};
special_char = {'~','`','!','@','#','$','%','^','&','*','(',')','-','=',...
                    '+','{','[','}','}','\','|',':',';','"','.',',','/','?'};
all_together = [lowerCase,numeric,upperCase,special_char];

lc_i = randi(length(lowerCase),1,1);                
uc_i = randi(length(upperCase),1,1);                
n_i = randi(length(numeric),1,1);                
sc_i = randi(length(special_char),1,1);                
all_i = randi(length(all_together),4,1);  
p = [lowerCase(lc_i),upperCase(uc_i),numeric(n_i),special_char(sc_i),...
    all_together(all_i)];
[val shuffle_i]= sort(rand(length(p),1));
password = cell2mat(p(shuffle_i));
