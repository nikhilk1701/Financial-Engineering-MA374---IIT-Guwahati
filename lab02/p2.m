clear all
close all
clc

S0 = 100;
K = 100;
T = 1;
M = 10;
r = 0.08;
sig = 0.20;
str = [string('S0'), string('K'), string('r'), string('sig'), string('M')];
U1 = @(x,y,z) exp(x*y^0.5);
D1 = @(x,y,z) exp(-x*y^0.5);
U2 = @(x,y,z) exp(x*y^0.5+(z-0.5*x^2)*y);
D2 = @(x,y,z) exp(-x*y^0.5+(z-0.5*x^2)*y);

figure(1)
for i = 1:10
    Call(1,i) = get_opt_price(S0-5+i, T, K, M, r, sig, U1, D1, 1, 0, 0);
    Call(2,i) = get_opt_price(S0, T, K-5+i, M, r, sig, U1, D1,1, 0, 0);
    Call(3,i) = get_opt_price(S0, T, K, M, r-0.004+i/1000, sig,U1, D1, 1, 0, 0); 
    Call(4,i) = get_opt_price(S0, T, K, M, r, sig-0.05+i/100, U1, D1,1, 0, 0); 
    Call(5,i) = get_opt_price(S0, T, K-5, 5+i, r, sig, U1, D1,1, 0, 0); 
    Call(6,i) = get_opt_price(S0, T, K, 5+i, r, sig, U1, D1,1, 0, 0); 
    Call(7,i) = get_opt_price(S0, T, K+5, 5+i, r, sig, U1, D1,1, 0, 0); 
    
    Put(1,i) = get_opt_price(S0-5+i, T, K, M, r, sig, U1, D1,0, 0, 0);
    Put(2,i) = get_opt_price(S0, T, K-5+i, M, r, sig, U1, D1,0, 0, 0);
    Put(3,i) = get_opt_price(S0, T, K, M, r-0.004+i/1000, sig, U1, D1,0, 0, 0); 
    Put(4,i) = get_opt_price(S0, T, K, M, r, sig-0.1+i/200, U1, D1,0, 0, 0);
    Put(5,i) = get_opt_price(S0, T, K-5, 5+i, r, sig, U1, D1,0, 0, 0); 
    Put(6,i) = get_opt_price(S0, T, K, 5+i, r, sig, U1, D1,0, 0, 0);
    Put(7,i) = get_opt_price(S0, T, K+5, 5+i, r, sig, U1, D1,0, 0, 0); 
end

for i = 1:4
    subplot(2,2,i)
    plot(1:10,Call(i,:));
    title('Varying '+str(i));
end
suptitle('Set1: Call Option');
figure(2)
for i = 5:7
    subplot(3,1,i-4)
    plot(1:10, Call(i,:));
    title('Varying '+str(5)+' at K='+string(100+5*(i-6)));
end
suptitle('Set1: Call Option');
figure(3)
for i = 1:4
    subplot(2,2,i)
    plot(1:10,Put(i,:));
    title('Varying '+str(i));
end
suptitle('Set1: Put Option');
figure(4)
for i = 5:7
    subplot(3,1,i-4)
    plot(1:10, Put(i,:));
    title('Varying '+str(5)+' at K='+string(100+5*(i-6)));
end
suptitle('Set1: Put Option');

function y = get_opt_price(S0, T, K, m, r, sig, U, D, flag, cnt, mtn)
    if cnt==m
        y = (S0+mtn)/(m+1);
        if flag==1
            y = max(0,y-K);
        else
            y = max(0,K-y);
        end
        return
    end
    dt = T/m;
    u = U(sig,dt,r);
    d = D(sig,dt,r);
    % Arbitrage Check
    if d>exp(r*dt) || exp(r*dt)>u
        return
    end
    p = (exp(r*dt)-d)/(u-d);
    q = (u-exp(r*dt))/(u-d);
    mtn = mtn+S0;
    y = p*get_opt_price(S0*u,T,K,m,r,sig,U,D,flag,cnt+1,mtn)+q*get_opt_price(S0*d,T,K,m,r,sig,U,D,flag,cnt+1,mtn);
    y = y/exp(r*dt);
end 
