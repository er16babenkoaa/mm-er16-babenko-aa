clear all; clc; close all;

use_window = 1;

Fd = 44.1e6; % Hz
N = 64;
T = 1/Fd * N;
t = ( (1:N) - 1 ) / Fd;
f = ( (1:N) - 1 ) / T;
stdS = 8; % RMS of signal
JtoS_dB = 30; %dB, jammer-to-signal
JtoS_amp = 10^(JtoS_dB/20);

S = randn(1, N) * stdS; % Signal

f0 = Fd / 8; % Jammer intermediate frequency
A_jam = stdS * JtoS_amp; % Amplitude of jam
Jam = A_jam * sin(2*pi*f0*t); % Jam

y = S + Jam; % ADC output

% Graphics
figure(1);
subplot(5,2,1)
stem(t*1e6, S)
xlabel('t, \mus');
ylabel('S');

subplot(5,2,2)
stem(f/1e6, abs(fft(S)))
xlabel('f, MHz');
ylabel('fft(S)');

subplot(5,2,3)
stem(t*1e6, Jam)
xlabel('t, \mus');
ylabel('Jam');

subplot(5,2,4)
stem(f/1e6, abs(fft(Jam)))
xlabel('f, MHz');
ylabel('fft(Jam)');

subplot(5,2,5)
stem(t*1e6, y)
xlabel('t, \mus');
ylabel('y');

yf = fft(y);
subplot(5,2,6)
stem(f/1e6, abs(yf))
xlabel('f, MHz');
ylabel('fft(y)');

h = 400;
signal_clear = 0;

if use_window
    yw = y .* parzenwin(N)';
else
    yw = y;
end
yfw = fft(yw);

subplot(5,2,7)
stem(t*1e6, yw);
xlabel('t, \mus');
ylabel('y after window');

subplot(5,2,8)
stem(f/1e6, abs(yfw));
xlabel('f, MHz');
ylabel('fft(y after window)');

yf_rej = yfw;
for k = 1:N
    if abs(yf_rej(k)) > h
        yf_rej(k) = 0;
    else
        yf_rej(k) = yf_rej(k);
    end
end
y_rej = ifft(yf_rej);

subplot(5,2,9)
stem(t*1e6, real(y_rej));
xlabel('t, \mus');
ylabel('y after rejector');

subplot(5,2,10)
stem(f/1e6, abs(fft(y_rej)));
xlabel('f, MHz');
ylabel('fft(y after rejector)');