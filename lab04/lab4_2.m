clear all;
clc;

M = [0.1 0.2 0.15];
C = [0.005 -0.010 0.004;-0.010 0.040 -0.002;0.004 -0.002 0.023];
U = [1 1 1];

for i=1:10000
   w = rand(1,3);
   w = w/sum(w);
   ret(i) = M*w';
   sig(i) = sqrt(w*C*w');
end

scatter(sig,ret,5);
hold on;

j=1;
for i=0:0.005:0.2
    c = [C(1,1) C(1,2); C(2,1) C(2,2)];
    w = calw(i,[M(1) M(2)],c,[1 1]);
    if(w(1)<0 || w(2)<0)
        continue;
    end
    ret2(j) = i;
    sig2(j) = sqrt(w*c*w');
    j = j+1;
end

plot(sig2,ret2,'linewidth',1);
hold on;

j=1;
for i=0:0.0005:0.2
    c = [C(1,1) C(1,3); C(3,1) C(3,3)];
    w = calw(i,[M(1) M(3)],c,[1 1]);
    if(w(1)<0 || w(2)<0)
        continue;
    end
    ret3(j) = i;
    sig3(j) = sqrt(w*c*w');
    j = j+1;
end

plot(sig3,ret3,'linewidth',1);
hold on;

j=1;
for i=0:0.0005:0.2
    c = [C(2,2) C(2,3); C(3,2) C(3,3)];
    w = calw(i,[M(2) M(3)],c,[1 1]);
    if(w(1)<0 || w(2)<0)
        continue;
    end
    ret4(j) = i;
    sig4(j) = sqrt(w*c*w');
    j = j+1;
end

plot(sig4,ret4,'linewidth',1);
hold on;

j = 1;
for i=0:0.0005:0.2
    w = calw(i,M,C,U);
    if(w(1)<0 || w(2)<0 || w(3)<0)
        continue;
    end
    ret5(j) = i;
    sig5(j) = sqrt(w*C*w');
    j = j+1;
end

plot(sig5,ret5,'linewidth',1);
xlabel('\sigma','Fontsize',20,'FontWeight','bold');
ylabel('\mu','Fontsize',20,'FontWeight','bold');
title('With no short selling');


function w = calw(u, m, C,U)
    m1 = (m*inv(C)*m')-u*(U*inv(C)*m');
    m2 = u*(U*inv(C)*U')-m*inv(C)*U';
    m3 = (U*inv(C)*U')*(m*inv(C)*m')-(U*inv(C)*m')*(m*inv(C)*U');
    w = (m1*U*inv(C)+m2*m*inv(C))/m3;
end
