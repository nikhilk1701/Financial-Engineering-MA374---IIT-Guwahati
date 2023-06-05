clear all
close all
clc

S0 = 100;
K = 105;
T = 5;
r = 0.05;
sig = 0.3;
M = [1, 5, 10, 20, 50, 100, 200, 400];

%%%%%%%%%%%%%%CALL OPTION PRICES%%%%%%%%%%%%%
V_call = zeros(1,1);
for i = 1:8
    dt = T/M(i);
    u = exp(sig*dt^0.5 + (r-(sig^2)/2)*dt);
    d = exp(-sig*dt^0.5 + (r-(sig^2)/2)*dt);
    V = get_call_price(S0, T, K, M(i), r, sig, u, d);
    V_call(i) = V(1,1);
end

for i = 1:20
    dt = T/i;
    u = exp(sig*dt^0.5 + (r-(sig^2)/2)*dt);
    d = exp(-sig*dt^0.5 + (r-(sig^2)/2)*dt);
    V = get_call_price(S0, T, K, i, r, sig, u, d);
    V1(i) = V(1,1);
end
figure(1) 
plot(1:length(V1), V1);
title('Call Option Prices Vs #intervals');

for i = 1:20
    dt = T/(5*i);
    u = exp(sig*dt^0.5 + (r-(sig^2)/2)*dt);
    d = exp(-sig*dt^0.5 + (r-(sig^2)/2)*dt);
    V = get_call_price(S0, T, K, 5*i, r, sig, u, d);
    V2(i) = V(1,1);
end
figure(2)
plot(5:5:100, V2);
title('Call Option Prices Vs #intervals');

dt = T/20;
u = exp(sig*dt^0.5 + (r-(sig^2)/2)*dt);
d = exp(-sig*dt^0.5 + (r-(sig^2)/2)*dt);
V = get_call_price(S0, T, K, 20, r, sig, u, d);
t = [0, 0.50, 1, 1.50, 3, 4.5];
t = t*(20/T)+1;

for i=1:length(t)
    V3(i,1:length(V(1:t(i),t(i)))) = V(1:t(i),t(i));
end

%%%%%%%%%%%%%%PUT OPTION PRICES%%%%%%%%%%%%%%
V_put = zeros(1,1);
for i = 1:8
    dt = T/M(i);
    u = exp(sig*dt^0.5 + (r-(sig^2)/2)*dt);
    d = exp(-sig*dt^0.5 + (r-(sig^2)/2)*dt);
    V = get_put_price(S0, T, K, M(i), r, sig, u, d);
    V_put(i) = V(1,1);
end

for i = 1:20
    dt = T/i;
    u = exp(sig*dt^0.5 + (r-(sig^2)/2)*dt);
    d = exp(-sig*dt^0.5 + (r-(sig^2)/2)*dt);
    V = get_put_price(S0, T, K, i, r, sig, u, d);
    C1(i) = V(1,1);
end
figure(3) 
plot(1:length(C1), C1);
title('Put Option Prices Vs #intervals');

for i = 1:20
    dt = T/(5*i);
    u = exp(sig*dt^0.5 + (r-(sig^2)/2)*dt);
    d = exp(-sig*dt^0.5 + (r-(sig^2)/2)*dt);
    V = get_put_price(S0, T, K, 5*i, r, sig, u, d);
    C2(i) = V(1,1);
end
figure(4)
plot(5:5:100, C2);
title('Put Option Prices Vs #intervals');

dt = T/20;
u = exp(sig*dt^0.5 + (r-(sig^2)/2)*dt);
d = exp(-sig*dt^0.5 + (r-(sig^2)/2)*dt);
V = get_put_price(S0, T, K, 20, r, sig, u, d);
t = [0, 0.50, 1, 1.50, 3, 4.5];
t = t*(20/T)+1;

for i=1:length(t)
    C3(i,1:length(V(1:t(i),t(i)))) = V(1:t(i),t(i));
end


fprintf('S.No\t#intervals\tCall Option Prices\tPut Option Price\n');
for i=1:8
    fprintf('%d\t%d\t\t%f\t\t%f\n', i, M(i), V_call(i), V_put(i));
end
fprintf('\n');

fprintf('S.No\ttime\t\tCall Option Price\tPut Option Price\n');
for i=1:length(t)
    for j=1:t(i)
        fprintf('%d\t%f\t%f\t\t%f\n', i, (i-1)*T/20, V3(i,j), C3(i,j));
    end
end

function y = get_call_price(S0, T, K, m, r, sig, u, d)
    dt = T/m;
    % Arbitrage Check
    if d>exp(r*dt) || exp(r*dt)>u
        return
    end
    p = (exp(r*dt)-d)/(u-d);
    q = (u-exp(r*dt))/(u-d);
    V = zeros(m+1,m+1);
    V(1,m+1) = S0*(u^m);
    for j=2:m+1
        V(j,m+1) = V(j-1,m+1)*(d/u);
    end
    for j = 1:m+1
        V(j,m+1) = max(0, V(j,m+1)-K);
    end
    for j = 1:m
        for k = 1:m+1-j
            V(k,m+1-j) = (p*V(k,m+2-j)+q*V(k+1,m+2-j))/exp(r*dt);
        end
        V(m+2-j,m-j+1) = 0;
    end
    y = V;
end  

function y = get_put_price(S0, T, K, m, r, sig, u, d)
    dt = T/m;
    % Arbitrage Check
    if d>exp(r*dt) || exp(r*dt)>u
        return
    end
    
    p = (exp(r*dt)-d)/(u-d);
    q = (u-exp(r*dt))/(u-d);
    V = zeros(m+1,m+1);
    V(1,m+1) = S0*(u^m);
    for j=2:m+1
        V(j,m+1) = V(j-1,m+1)*(d/u);
    end
    for j = 1:m+1
        V(j,m+1) = max(0, K-V(j,m+1));
    end
    for j = 1:m
        for k = 1:m+1-j
            V(k,m+1-j) = (p*V(k,m+2-j)+q*V(k+1,m+2-j))/exp(r*dt);
        end
        V(m+2-j,m-j+1) = 0;
    end
    y = V;
end 