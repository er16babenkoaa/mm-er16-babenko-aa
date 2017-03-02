clear all;
close all;
clc;

time_range  = 60*60*12;
x = nan(1, time_range);
y = nan(1, time_range);

x(1)=1;
RE = 6400e3;
RS = RE+100e3;
cnt = 0;
f0 = 1.6e9;
C=3e8;
for i = 1:time_range
    x(i)=cos(2*pi*(1/time_range)*i) * RS;
    y(i)=sin(2*pi*(1/time_range)*i) * RS;
    %time(i) = i;
    if(y(i) > RE)
        cnt = cnt+1;
        r(cnt) = sqrt((y(i) - RE)^2 + x(i)^2);
        
        if(cnt == 1)
            Vr(1)=0;
            FD(1)=0;
            time(1) = i;
        else if(cnt > 1)
                Vr(cnt) = (r(cnt) - r(cnt-1));
                FD(cnt)=Vr(cnt)*f0/C;
                time(cnt) = i;
            end;
        end;
    end;
    
end;
FD(1) = FD(2);
figure(1);
plot(time/60/60,-FD);
grid minor;
grid on;

