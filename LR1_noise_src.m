clear all;
close all;
clc;
%white noise source
R = 120; %om
C = 33e-12; %f
L = 100e-6; %g

A = 1;
f0 = 1/(2*pi*sqrt(L*C));
deltaT = 1/(10000*f0);
t = 0:deltaT:(15*1/f0);
lng = length(t);

Uc = nan(1, lng);
il = nan(1, lng);
ic = nan(1, lng);

E = 10*randn(1, lng);%E = 10*ones(1, lng);
Uc(1) = 0;
ic(1) = 0;
il (1) = 0;

fprintf('f0 = %f MHz\n', f0/1e6);

for k = 2:lng
    ic(k) = (E(k)-Uc(k-1)-il(k-1)*R) / (R);
    il(k) = il(k-1) + Uc(k-1)*deltaT / L;
    Uc(k) = Uc(k-1) + ic(k-1)*deltaT / C;
end

figure(1);
plot(t * 1e9, [E; Uc]);
xlabel('t, ns');
ylabel('E, Uc, Volt');
legend('E(t)', 'Uc(t)');
grid on;