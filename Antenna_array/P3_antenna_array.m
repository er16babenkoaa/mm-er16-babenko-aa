clear all;
clc;
close all;

%variant 11
%lambda/4
%nsr = 10 db
%angle alpha = 45 grad
%4 antennas

lambda = 1/4;
nsr_db = 50;
nsr = 10^(nsr_db/10);

a_step = 10;
b_step = 10;

a = deg2rad(-180:a_step:180);
b = deg2rad(-90:b_step:90);

[a_mesh, b_mesh] = meshgrid(a, b);
F1 = (1 + cos(a_mesh - pi/2)).^2;
[x, y, z] = sph2cart(b_mesh, a_mesh, F1);

figure(1);
surf(x, y, z);
xlabel('X');
ylabel('Y');
zlabel('Z');
title('ДН одной антенны');
drawnow
saveas(gcf, 'pic//basic_pattern', 'png');

axis equal;
clear F;

F_square = ones(length(b), 1) * (1 + cos(a - pi/2)).^2;
figure(2);
pos = get(gcf, 'Position');
pos(3) = 800;
set(gcf, 'Position', pos);

b_j = 0;
b_s = 0;
%a_j = var
a_s = deg2rad(45);

for a_j = deg2rad(0:a_step:180)
    fv = focus_vector(a_j, b_j, lambda);
    D = nsr * fv * fv' + eye(4);
    fv_s = focus_vector(a_s, b_s, lambda);
    beta_w = D \ fv_s / (fv_s' * (D \ fv_s));
    
    for alpha = 1:length(a) 
        for beta = 1:length(b) 
            U = beta_w' * focus_vector(a(alpha), b(beta), lambda); 
            F(beta, alpha) = abs(U)^2; 
        end 
    end 

    F = F_square .* F;
    [x, y, z] = sph2cart(b_mesh, a_mesh, F);

    b0 = ceil(length(b)/2);
    Fb0 = F(b0, :);

    subplot(1, 2, 1)
    surf(x, y, z)
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    axis equal

    subplot(1,2,2)
    polar(a, Fb0);
    hold on
    polar([a_s a_s], [0 max(Fb0)], 'g');
    polar([a_j a_j], [0 max(Fb0)], 'r');
    hold off
    drawnow
    s = sprintf('pic//DN_a_j_%03.0f.png', round(rad2deg(a_j)));
    saveas(gcf, s, 'png');
end


