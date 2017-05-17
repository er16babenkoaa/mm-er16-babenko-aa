R = 120;%120; %om
C = 33e-12; %f
L = 100e-6; %g

%w = logspace(1, 5);
figure(1);
freqs([L 0], [R*L L R])
