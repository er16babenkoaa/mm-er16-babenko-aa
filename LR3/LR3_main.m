clear all; 
close all; 
clc 
std_y = 8; % СКО шума выборки
Fd = 44.2e6; % Частота дискретизации, МГц 
Td = 1/Fd; 
T = 5e-3; % Интервал накопления, мс
L = T / Td; % Число суммирований
Pf = 0.001; % Вероятность ЛТ
stage = 3; % 1 - Выйти после: поиска R,
% 2 - после построения характеристики обнаружения, 
% 3 - завершения всех этапов

M = 12; % Ячеек по частоте
N = 12; % Ячеек по задержке

delta_tau = 1/2; % Шаг ячеек по задержке, символов
tau_tilda = (0:N-1)*delta_tau + delta_tau/2; % Опорные задержки
tau_max = N*delta_tau; 
delta_f = 2/3 / T; % Шаг ячеек по частоте, Гц
omega_tilda = 2*pi*((0:M-1)*delta_f + delta_f/2); % Опорные частоты
omega_max = 2*pi*M*delta_f; 

% Сетка, задающая центры ячеек 
[tau_tilda_m, omega_tilda_m] = meshgrid(tau_tilda, omega_tilda);  

std_IQ = std_y * sqrt(L/2); % СКО шума корреляционных сумм

% Число экспериментов для поиска порога и построения гистограмм
J1 = 100000;  
% Число экспериментов для расчета характеристик обнаружения
J2 = 10000; 

X2max = nan(1, J1); % Инициализация памяти
signal = 'off'; 
for j = 1:J1 
    experiment; 
    if ~mod(100*j/J1, 10) %~ = logic not
       fprintf('Task 1: Progress %.0f%%\n', 100*j/J1); 
    end 
end

R = std_IQ^2;   % Очень низкий порог
while sum(X2max > R) / J1 > Pf 
    R = R * 1.0005; % Увеличиваем на 0.002 дБ
end 

figure(1); 
d = max(X2max) - min(X2max); 
[h1, x] = hist(X2max, min(X2max):d/20:max(X2max)); 
bar(x, h1); % Строим гистограмму X2max в отсутствии сигнала
% Красная линия, изображающая порог
hold on; 
plot([R R], get(gca, 'YLim'), 'r'); 
hold off
xlabel('X^2_{max}'); 

if stage == 1 
    clc; 
    fprintf('Threshold is %f\n', R); 
    return; 
end

% Определение inline-функции ro(dtau)
ro = inline('(1 - abs(dtau)) .* (abs(dtau)<1)', 'dtau');  

qcno_dB = 25:1:45;  
X2max = nan(1, J2); % Стирание прошлых результатов
Pd = nan(1, length(qcno_dB)); 
signal = 'on'; 

for q = 1:length(qcno_dB) 
    qcno = 10^(qcno_dB(q)/10); % Перевод из дБ в разы
    A = 2*std_y * sqrt(qcno*Td); % Расчет амплитуды для данного с/ш 
    % Истинная задержка для каждого эксперимента
    tau = tau_max * rand(1, J2); 
    % Истинная частота для каждого эксперимента
    omega = omega_max * rand(1, J2);  
    % Начальная фаза в каждом эксперименте случайна
    dphi = 2*pi*rand(1, J2); 
    for j = 1:J2 
        experiment; 
        if ~mod(100*j/J2, 10) 
            fprintf('Task 2: SNR=%.0f dBHz Progress %.0f%%\n', qcno_dB(q), 100*j/J2); 
        end 
    end 
    Pd(q)  =  sum(X2max  >  R)  /  J2; %Среднее превышение порога в выборке
end

figure(2); 
plot(qcno_dB, Pd);
xlabel('q_{c/n0}, dBHz'); 
ylabel('P_d'); 
grid on;

%Ищем с/ш, при котором достигается Pd=0.9
[nul, q_09] =  min(abs(Pd - 0.9));  
qcno_dB_09 = qcno_dB(q_09);  
qcno = 10^(qcno_dB_09/10); 

%Отобразим границу на графике
figure(2); 
hold on; 
stem(qcno_dB_09, 0.9, 'r'); 
hold off;  

if stage == 2 
    clc; 
    fprintf('SNR for Pd=0.9 is %.0f dBHz\n', qcno_dB_09); 
    return; 
end

X2max = nan(1, J1);
A = 2*std_y * sqrt(qcno*Td); 
% Истинная задержка для каждого эксперимента
tau = tau_max * rand(1, J1);  
% Истинная частота для каждого эксперимента
omega = omega_max * rand(1, J1);  
% Начальная фаза в каждом эксперименте случайна 
dphi = 2*pi*rand(1, J1);  
for j = 1:J1 
    experiment; 
    if ~mod(100*j/J1, 10) % !10%5 = 1
        fprintf('Task 3: Progress %.0f%%\n', 100*j/J1); 
    end 
end 

figure(1); 
hold on
[h2, x] = hist(X2max, min(X2max):d/20:max(X2max)); 
bar(x, h2, 'g'); %Дополняем новой гистограммой при наличии сигнала
legend('\theta = 0', 'Treshold', '\theta = 1'); 
hold off

figure(3); 
surf(omega_tilda_m/2/pi, tau_tilda_m, X2); 
xlabel('f, Hz'); 
ylabel('\tau, cells'); 
zlabel('X^2');

clc; 
fprintf('Threshold is %f\n', R) 
fprintf('SNR for Pd=0.9 is %.0f dBHz\n', qcno_dB_09); 