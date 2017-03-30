clear all;
close all;
clc;

Fd = 40e3;
Td = 1/Fd;
Tmod = 0.3;%0.01;
t = 0:Td:Tmod;

df = 100;
S = cos(2*pi*(500+df*rand(1,1)) * t);

W = S .* parzenwin(length(S))';
S = fft(S);
W = fft(W);
figure(1);
%f = 0:Fd:1/Tmod;
%axis(0 10e4);
f = 0:(length(t)-1);
%window(@hamming, 64)
%plot(f/Td, 10*log(abs(S)), f/Td, 10*log(abs(W)));
plot(f/Td, 10*log(abs(S)), f/Td, 10*log(abs(W)));
%lot(10*log10(abs(W)));
%plot(S);
%hold on;
%plot(W);
%plot(f, 10*log(abs(S)), f, 10*log(abs(W)));
legend('show');
hold on;
%plot(10*log(abs(S)));
%axis([0 300 -10 90]);
grid on;
%loglog(t/Td, abs(S));