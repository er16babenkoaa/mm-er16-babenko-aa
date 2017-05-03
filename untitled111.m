clear all;close all; clc
t0=-pi/2;
T=1-pi/2;
y0=-(pi*pi)/2;
h=0.2;
y=y0;
N=0;
i=1;
for t=t0:h:T;
    N(i)=y;
    y=y+h*(y*cot(t)+4*t*sin(t));
    
    i=i+1;
end
%plot(t0:h:T,N);

T = 0.2; tmin = -pi/2; tmax = 1-pi/2;
Y0 = -(pi*pi)/2;
% Начальные условия
[t, Y] = ode45('diffs', tmin:T:tmax, Y0);
plot(t, Y,t,N); grid on
legend('Runge-Kyt4 = y','Eler = N');


