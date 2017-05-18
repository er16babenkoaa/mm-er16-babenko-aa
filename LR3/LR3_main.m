clear all; 
close all; 
clc 
std_y = 8; % ��� ���� �������
Fd = 44.2e6; % ������� �������������, ��� 
Td = 1/Fd; 
T = 5e-3; % �������� ����������, ��
L = T / Td; % ����� ������������
Pf = 0.001; % ����������� ��
stage = 3; % 1 - ����� �����: ������ R,
% 2 - ����� ���������� �������������� �����������, 
% 3 - ���������� ���� ������

M = 12; % ����� �� �������
N = 12; % ����� �� ��������

delta_tau = 1/2; % ��� ����� �� ��������, ��������
tau_tilda = (0:N-1)*delta_tau + delta_tau/2; % ������� ��������
tau_max = N*delta_tau; 
delta_f = 2/3 / T; % ��� ����� �� �������, ��
omega_tilda = 2*pi*((0:M-1)*delta_f + delta_f/2); % ������� �������
omega_max = 2*pi*M*delta_f; 

% �����, �������� ������ ����� 
[tau_tilda_m, omega_tilda_m] = meshgrid(tau_tilda, omega_tilda);  

std_IQ = std_y * sqrt(L/2); % ��� ���� �������������� ����

% ����� ������������� ��� ������ ������ � ���������� ����������
J1 = 100000;  
% ����� ������������� ��� ������� ������������� �����������
J2 = 10000; 

X2max = nan(1, J1); % ������������� ������
signal = 'off'; 
for j = 1:J1 
    experiment; 
    if ~mod(100*j/J1, 10) %~ = logic not
       fprintf('Task 1: Progress %.0f%%\n', 100*j/J1); 
    end 
end

R = std_IQ^2;   % ����� ������ �����
while sum(X2max > R) / J1 > Pf 
    R = R * 1.0005; % ����������� �� 0.002 ��
end 

figure(1); 
d = max(X2max) - min(X2max); 
[h1, x] = hist(X2max, min(X2max):d/20:max(X2max)); 
bar(x, h1); % ������ ����������� X2max � ���������� �������
% ������� �����, ������������ �����
hold on; 
plot([R R], get(gca, 'YLim'), 'r'); 
hold off
xlabel('X^2_{max}'); 

if stage == 1 
    clc; 
    fprintf('Threshold is %f\n', R); 
    return; 
end

% ����������� inline-������� ro(dtau)
ro = inline('(1 - abs(dtau)) .* (abs(dtau)<1)', 'dtau');  

qcno_dB = 25:1:45;  
X2max = nan(1, J2); % �������� ������� �����������
Pd = nan(1, length(qcno_dB)); 
signal = 'on'; 

for q = 1:length(qcno_dB) 
    qcno = 10^(qcno_dB(q)/10); % ������� �� �� � ����
    A = 2*std_y * sqrt(qcno*Td); % ������ ��������� ��� ������� �/� 
    % �������� �������� ��� ������� ������������
    tau = tau_max * rand(1, J2); 
    % �������� ������� ��� ������� ������������
    omega = omega_max * rand(1, J2);  
    % ��������� ���� � ������ ������������ ��������
    dphi = 2*pi*rand(1, J2); 
    for j = 1:J2 
        experiment; 
        if ~mod(100*j/J2, 10) 
            fprintf('Task 2: SNR=%.0f dBHz Progress %.0f%%\n', qcno_dB(q), 100*j/J2); 
        end 
    end 
    Pd(q)  =  sum(X2max  >  R)  /  J2; %������� ���������� ������ � �������
end

figure(2); 
plot(qcno_dB, Pd);
xlabel('q_{c/n0}, dBHz'); 
ylabel('P_d'); 
grid on;

%���� �/�, ��� ������� ����������� Pd=0.9
[nul, q_09] =  min(abs(Pd - 0.9));  
qcno_dB_09 = qcno_dB(q_09);  
qcno = 10^(qcno_dB_09/10); 

%��������� ������� �� �������
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
% �������� �������� ��� ������� ������������
tau = tau_max * rand(1, J1);  
% �������� ������� ��� ������� ������������
omega = omega_max * rand(1, J1);  
% ��������� ���� � ������ ������������ �������� 
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
bar(x, h2, 'g'); %��������� ����� ������������ ��� ������� �������
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