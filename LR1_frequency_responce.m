clear all;
close all;
clc;
%const E
R = 120; %om
C = 33e-12; %f
L = 100e-6; %g

A = 1;
f0 = 1/(2*pi*sqrt(L*C));
deltaT = 1/(1000*f0);
t = 0:deltaT:(150*1/f0);
lng = length(t);

% figure(1);
% plot(t * 1e9, [E; Uc]);
% xlabel('t, ns');
% ylabel('E, Uc, Volt');
% legend('E(t)', 'Uc(t)');
% grid on;
df = 5e5;
fsweep = 0:df:1e8;
length(fsweep);
FR = nan(1, length(fsweep));
for d = 1:length(fsweep)
    E = 1*cos(2*pi*df*d*t);
    Uc(1) = 0;
    ic(1) = 0;
    il(1) = 0;
    for k = 2:lng
        ic(k) = (E(k)-Uc(k-1)-il(k-1)*R) / (R);
        il(k) = il(k-1) + Uc(k-1)*deltaT / L;
        Uc(k) = Uc(k-1) + ic(k-1)*deltaT / C;
    end
    FR(d)=abs(min(Uc));
end

figure(1);
plot(fsweep / 1e6, FR);
xlabel('f, MHz');
ylabel('K(f)');
grid on;
grid minor;
