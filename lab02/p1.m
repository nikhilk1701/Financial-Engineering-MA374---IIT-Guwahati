clear all
close all
clc

S0 = 100;
K = 100;
T = 1;
M = 100;
r = 0.08;
sig = 0.20;
str = [string('S0'), string('K'), string('r'), string('sig'), string('M')];
U1 = @(x,y,z) exp(x*y^0.5);
D1 = @(x,y,z) exp(-x*y^0.5);
U2 = @(x,y,z) exp(x*y^0.5+(z-0.5*x^2)*y);
D2 = @(x,y,z) exp(-x*y^0.5+(z-0.5*x^2)*y);
figure(1)
for i = 1:40
    Call(1,i) = get_opt_price(S0-20+i, T, K, M, r, sig, U1, D1, 1);
    Call(2,i) = get_opt_price(S0, T, K-20+i, M, r, sig, U1, D1,1);
    Call(3,i) = get_opt_price(S0, T, K, M, r-0.02+i/1000, sig,U1, D1, 1); 
    Call(4,i) = get_opt_price(S0, T, K, M, r, sig-0.1+i/200, U1, D1,1); 
    Call(5,i) = get_opt_price(S0, T, K-5, M+200+i, r, sig, U1, D1,1); 
    Call(6,i) = get_opt_price(S0, T, K, M+200+i, r, sig, U1, D1,1); 
    Call(7,i) = get_opt_price(S0, T, K+5, M+200+i, r, sig, U1, D1,1); 
    
    Put(1,i) = get_opt_price(S0-20+i, T, K, M, r, sig, U1, D1,0);
    Put(2,i) = get_opt_price(S0, T, K-20+i, M, r, sig, U1, D1,0);
    Put(3,i) = get_opt_price(S0, T, K, M, r-0.02+i/1000, sig, U1, D1,0); 
    Put(4,i) = get_opt_price(S0, T, K, M, r, sig-0.1+i/200, U1, D1,0);
    Put(5,i) = get_opt_price(S0, T, K-5, M+200+i, r, sig, U1, D1,0); 
    Put(6,i) = get_opt_price(S0, T, K, M+200+i, r, sig, U1, D1,0); 
    Put(7,i) = get_opt_price(S0, T, K+5, M+200+i, r, sig, U1, D1,0); 
end

for i = 1:4
    subplot(2,2,i)
    plot(1:40,Call(i,:));
    title('Varying '+str(i));
end
suptitle('Set1: Call Option');
figure(2)
for i = 5:7
    subplot(3,1,i-4)
    plot(1:40, Call(i,:));
    title('Varying'+str(5)+'at K='+string(100+5*(i-6)));
end
suptitle('Set1: Call Option');
figure(3)
for i = 1:4
    subplot(2,2,i)
    plot(1:40,Put(i,:));
    title('Varying '+str(i));
end
suptitle('Set1: Put Option');
figure(4)
for i = 5:7
    subplot(3,1,i-4)
    plot(1:40, Put(i,:));
    title('Varying'+str(5)+'at K='+string(100+5*(i-6)));
end
suptitle('Set1: Put Option');

for i = 1:40
    Call(1,i) = get_opt_price(S0-20+i, T, K, M, r, sig, U2, D2, 1);
    Call(2,i) = get_opt_price(S0, T, K-20+i, M, r, sig, U2, D2,1);
    Call(3,i) = get_opt_price(S0, T, K, M, r-0.02+i/1000, sig,U2, D2, 1); 
    Call(4,i) = get_opt_price(S0, T, K, M, r, sig-0.1+i/200, U2, D2,1); 
    Call(5,i) = get_opt_price(S0, T, K-5, M+200+i, r, sig, U2, D2,1); 
    Call(6,i) = get_opt_price(S0, T, K, M+200+i, r, sig, U2, D2,1); 
    Call(7,i) = get_opt_price(S0, T, K+5, M+200+i, r, sig, U2, D2,1); 
    
    Put(1,i) = get_opt_price(S0-20+i, T, K, M, r, sig, U2, D2,0);
    Put(2,i) = get_opt_price(S0, T, K-20+i, M, r, sig, U2, D2,0);
    Put(3,i) = get_opt_price(S0, T, K, M, r-0.02+i/1000, sig, U2, D2,0); 
    Put(4,i) = get_opt_price(S0, T, K, M, r, sig-0.1+i/200, U2, D2,0);
    Put(5,i) = get_opt_price(S0, T, K-5, M+200+i, r, sig, U2, D2,0); 
    Put(6,i) = get_opt_price(S0, T, K, M+200+i, r, sig, U2, D2,0); 
    Put(7,i) = get_opt_price(S0, T, K+5, M+200+i, r, sig, U2, D2,0); 
end
figure(5)
for i = 1:4
    subplot(2,2,i)
    plot(1:40,Call(i,:));
    title('Varying '+str(i));
end
suptitle('Set2: Call Option');
figure(6)
for i = 5:7
    subplot(3,1,i-4)
    plot(1:40, Call(i,:));
    title('Varying'+str(5)+'at K='+string(100+5*(i-6)));
end
suptitle('Set2: Call Option');
figure(7)
for i = 1:4
    subplot(2,2,i)
    plot(1:40,Put(i,:));
    title('Varying '+str(i));
end
suptitle('Set2: Put Option');
figure(8)
for i = 5:7
    subplot(3,1,i-4)
    plot(1:40, Put(i,:));
    title('Varying'+str(5)+'at K='+string(100+5*(i-6)));
end
suptitle('Set2: Put Option');
function y = get_opt_price(S0, T, K, m, r, sig, U, D, flag)
    dt = T/m;
    u = U(sig,dt,r);
    d = D(sig,dt,r);
    % Arbitrage Check
    if d>exp(r*dt) || exp(r*dt)>u
        return
    end
    p = (exp(r*dt)-d)/(u-d);
    q = (u-exp(r*dt))/(u-d);
    V = zeros(m+1,1);
    V(1,1) = S0*(u^m);
    for j=2:m+1
        V(j,1) = V(j-1,1)*(d/u);
    end
    for j = 1:m+1
        if flag==1
            V(j,1) = max(0, V(j,1)-K);
        elseif flag==0
            V(j,1) = max(0, K-V(j,1));
        end
    end
    for j = 1:m
        for k = 1:m+1-j
            V(k,1) = (p*V(k,1)+q*V(k+1,1))/exp(r*dt);
        end
        V(m+2-j,1) = 0;
    end
    y = V(1,1);
end 