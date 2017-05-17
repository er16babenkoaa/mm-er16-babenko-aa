clear all;
clc;
T = 0.05;
Tmax = 3600;
t = T:T:Tmax;
N = length(t);
G = [0 0;
    0 T];
F = [1 T
    0 1];

Dksi = 8*1;
Deta = 9*1;

Band =  0.1:0.1:3
Band_for_plot = 2;
RMS_Omega = nan(1, length(Band));

for i = 1:length(Band);
    K = nan(2, 1);
    K(1) = 8/3 * Band(i) * T;
    K(2) = 32/9 * Band(i)^2 * T;
    
    ksi = sqrt(Dksi) * randn(1, N);
    eta = sqrt(Deta) * randn(1, N);
    
    Xest = [0; 0];      %0; 0 = 0
    Xextr = F * Xest;   %       0
    Xist = [0; 0];
    
    ErrOmega = nan(1, N);
    Omega = nan(1, N);
    for k = 1:N
        Xist = F * Xist + G * [0; ksi(k)];
        omega_meas = Xist(1) + eta(k);
        Xest = Xextr + K * (omega_meas - Xextr(1));
        Xextr = F * Xest;
        ErrOmega(k) = Xest(1) - Xist(1);
        Omega(k) = Xist(1);
    end;
    
    if Band(i) == Band_for_plot
        figure(1);
        plot(t, ErrOmega/2/pi);
        xlabel('t, s');
        ylabel('\Delta \omega, Hz');
        title(['Bandwidth = ' num2str(Band(i)) 'Hz']);
        
        figure(2);
        plot(t, [Omega; Omega + ErrOmega]/2/pi);
        xlabel('t, s');
        ylabel('\omega, Hz');
        title(['Bandwidth = ' num2str(Band(i)) 'Hz']);
    end;
    RMS_Omega(i) = sqrt(mean(ErrOmega.^2));
end;

if Dksi == 0
    Col = [1 0 0];
elseif Deta == 0
    Col = [0 0.5 0];
else
    Col = [0 0 1];
end;

figure(3)
hold on
plot(Band, RMS_Omega, 'Color', Col);
hold off
xlabel('Bandwidth, Hz');
ylabel('RMS \omega, Hz');
