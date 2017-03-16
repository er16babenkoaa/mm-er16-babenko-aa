clear all;
clc;
close all;

f0 = 10e9;
c = 3*10e8;
lambda = c/f0;

alpha = deg2rad(-180:2:180);
beta = deg2rad(-90:2:90);

[alpha_m, beta_m] = meshgrid(alpha, beta);

F = abs(cos(alpha_m) .* 1);%ones(length(beta), 1) * (1 + cos(alpha - pi/2)).^2; 
[x, y, z] = sph2cart(beta_m, alpha_m, F);


figure(1);
surf(x,y,z);
xlabel('x'); 
ylabel('y'); 
zlabel('z');
minc = min([min(min(x)) min(min(y)) min(min(z))]);
maxc = max([max(max(x)) max(max(y)) max(max(z))]);
xlim([minc maxc]);
ylim([minc maxc]);
zlim([minc maxc]);
