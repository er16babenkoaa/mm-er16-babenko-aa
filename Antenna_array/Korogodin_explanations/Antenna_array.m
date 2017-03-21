clear all;
close all;
clc;

lambda = 1/2;

alpha_f = 10;
beta_f = 90;

alpha_t = 0:5:360;
beta_t = 0:5:360;

%Power = nan(length(alpha_t), length(beta_t));

for a = 1:length(alpha_t)
    for b = 1:length(beta_t)
        
        S = 1;
        ya = H(alpha_t(a), beta_t(b)) * S;
        
        K = H(alpha_f, beta_f);
        y = K' * ya;
        
        Power(b, a) = abs(y) / abs(S);
    end
end

[alpha_tm, beta_tm] = meshgrid(alpha_t, beta_t);
figure(1);
surf(alpha_tm, beta_tm, Power);