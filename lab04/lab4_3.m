clc;
clear all;

T = readtable('data.csv');
T_matrix = T{1:61,2:11};
T_return = price2ret(T_matrix);
C = cov(T_return);
m(1:10) = mean(T_return);

u = ones(1,10);k=100000;

w_mvp = (u/C)/(u*(C\u')); u_rf = 0.05;
u_mvp = m*w_mvp'; u_v = -0.06:0.001:0.08; n = length(u_v);

for i=1:length(u_v)
    a1 = m*(C\m')-u_v(i)*(u*(C\m'));
    a2 = u_v(i)*(u*(C\u'))-m*(C\u');
    a3 = (u*(C\u'))*(m*(C\m'))-(u*(C\m'))*(m*(C\u'));
    w =  (a1*(u/C)+a2*(m/C))/(a3);
    if u_v(i) >= u_mvp
        k=min(i,k);
    end
    sig_v(i) = sqrt(w*C*w');
end

w_m = (m-u_rf*u)/(C);
w_m = w_m/sum(w_m);

%Market portfolio values
sigma_m = sqrt(w_m*C*w_m');
u_m = m*w_m';
fprintf('\nThe market portfolio values are myu=%f sigma=%f\n',u_m,sigma_m);

sig_capm = 0:0.00001:sigma_m+0.02;
for i=1:length(sig_capm)
    u_capm(i) = u_rf+ ((u_m-u_rf)*sig_capm(i))/sigma_m;
end

plot(sig_v(k:n),u_v(k:n),'r'); hold on;
plot(sig_v(1:k-1),u_v(1:k-1),'b'); hold on;
plot(sig_capm(:),u_capm(:)); hold on;
plot(sigma_m,u_m,'*');
title('Efficient Frontier');
xlabel('\sigma','Fontsize',26,'FontWeight','bold');
ylabel('\mu','Fontsize',26,'FontWeight','bold');
legend('Efficient Frontier');

figure(2);
beta(1:10) = (m(1:10)-u_rf)/(u_m-u_rf);
myu_v(1:10) = u_rf + (u_m-u_rf)*beta(1:10);
plot(beta(1:10),myu_v(1:10),'-*');
title('Security market line of 10 stocks');
