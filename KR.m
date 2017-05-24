clear all;
close all; 
clc;

%переменные
t0 = 0;
T = 1; 
y0 = 0;
h = 0.2;
y = y0;
N = nan(1, length(t0:h:T));

%метод Эйлера
cnt = 1;
for t = t0:h:T;
    N(cnt) = y;
    y = y + h*(y/(t-2) + 2*(t-2)*exp(2*t));
    cnt = cnt + 1;
end

%метод Рунге-Кутты 4 порядка
[t, Y] = ode45('diffs', t0:h:T, y0);

%визуализация результатов
hold on;
plot(t, Y, '-');
plot(t, N, '--');
hold off;
grid on;
legend('метод Рунге-Кутты 4 порядка', 'метод Эйлера');

