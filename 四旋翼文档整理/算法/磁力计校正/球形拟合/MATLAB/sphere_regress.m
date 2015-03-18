function [ bias ] = sphere_regress( data,num )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
mean1 = mean(data(:,1));
mean2 = mean(data(:,2));
mean3 = mean(data(:,3));

data2x = data(:,1).^2;
data2y = data(:,2).^2;
data2z = data(:,3).^2;
data2xy = data(:,1).*data(:,2);
data2yz = data(:,2).*data(:,3);
data2xz = data(:,1).*data(:,3);
s = size(data);
sdatax = sum(data(:,1))/s(1);
sdatay = sum(data(:,2))/s(1);
sdataz = sum(data(:,3))/s(1);
sdata2x = sum(data2x)/s(1);
sdata2y = sum(data2y)/s(1);
sdata2z = sum(data2z)/s(1);
%³õÊ¼Öµ
A0 = mean1;
B0 = mean2;
C0 = mean3;
R0 = sqrt(sdata2x+sdata2y+sdata2z+2*(A0*sdatax+B0*sdatay+C0*sdataz)...
    +A0^2+B0^2+C0^2);
iterative = 0;
flet_esp = 0.001;
while(iterative<num ) 
    f_orderA = 2*(sdatax+A0)*(sdata2x+sdata2y+sdata2z+2*(A0*sdatax+B0*sdatay...
        +C0*sdataz)+A0^2+B0^2+C0^2-R0^2);
    f_orderB = 2*(sdatax+B0)*(sdata2x+sdata2y+sdata2z+2*(A0*sdatax+B0*sdatay...
        +C0*sdataz)+A0^2+B0^2+C0^2-R0^2);
    f_orderC = 2*(sdatax+C0)*(sdata2x+sdata2y+sdata2z+2*(A0*sdatax+B0*sdatay...
        +C0*sdataz)+A0^2+B0^2+C0^2-R0^2);
    s_orderA = 2*(sdata2x+sdata2y+sdata2z+2*(A0*sdatax+B0*sdatay...
        +C0*sdataz)+A0^2+B0^2+C0^2-R0^2)+4*(sdata2x+A0^2+2*sdatax*A0);
    s_orderB = 2*(sdata2x+sdata2y+sdata2z+2*(A0*sdatax+B0*sdatay...
        +C0*sdataz)+A0^2+B0^2+C0^2-R0^2)+4*(sdata2x+B0^2+2*sdatax*B0);
    s_orderC = 2*(sdata2x+sdata2y+sdata2z+2*(A0*sdatax+B0*sdatay...
        +C0*sdataz)+A0^2+B0^2+C0^2-R0^2)+4*(sdata2x+C0^2+2*sdatax*C0);
    if s_orderA < flet_esp
        s_orderA = 1.0;
    end
    if s_orderB < flet_esp
         s_orderB = 1.0;
    end
    if s_orderC < flet_esp
        s_orderC = 1.0;
    end
     An = A0 + f_orderA/s_orderA;
     Bn = B0 + f_orderB/s_orderB;
     Cn = C0 + f_orderC/s_orderC;
     A0 = An;
     B0 = Bn;
     C0 = Cn;
     R0 = sqrt(sdata2x+sdata2y+sdata2z+2*(A0*sdatax+B0*sdatay+C0*sdataz)...
    +A0^2+B0^2+C0^2);
    iterative = iterative+ 1
end
bias = [A0,B0,C0,R0];
end

