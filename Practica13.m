close all; clc;
f=10e9;
c=3e8;
n=1;
lambda=c/f;
k=n*2*pi/lambda;
P=61;
G=1.61;
PG=100;
z_min=20;
z_max=1000;
z_d=1;
z=z_min:z_d:z_max;

h=2;
x=h;

y_min=-300;
y_max=300;
y_d=1;
y=y_min:y_d:y_max;
[Z,Y]=meshgrid(z,y);
X=x*ones(size(Z));


h_dip=5;
x_dip=h_dip;
y_dip=0;
z_dip=0;


R=sqrt((x_dip-X).^2+(y_dip-Y).^2+(z_dip-Z).^2);

sin_theta=sqrt((y_dip-Y).^2+(z_dip-Z).^2)./R;

DN=sin_theta;
gamma = pi/4;
epsilon = 4;
sigma = 1e-3;

ep = epsilon + 60i*sigma*lambda;
R_imag = sqrt((x_dip + X).^2 + (y_dip - Y).^2 + (z_dip - Z).^2);
cos_theta_imag = (x_dip + X)./R_imag;
sin_theta_imag = sqrt((y_dip - Y).^2 + (z_dip - Z).^2) ./ R_imag;
DN_imag = sin_theta;
Rp = (ep.*cos_theta_imag - sqrt(ep-sin_theta_imag.^2)) ./ (ep.*cos_theta_imag + sqrt(ep-sin_theta_imag.^2));
E = DN./R.*exp(-1i*k*R)+Rp.*DN_imag./R_imag.*exp(-1i*k*R_imag);


%E=DN./R.*exp(-1i*k*R);

PPM=10*log10(PG)+20*log10(abs(E))-2;

figure(1)
hold off
mesh(Z,Y,zeros(size(R)),PPM)
hold on
contour(Z,Y,PPM,[-30,-35],'r','ShowText','on')
view(2)
colorbar
xlabel('Dalnost, m')
ylabel('Shirina, m')
title(['Raspredelenie PPM HA Bisote',num2str(h),' m']);

