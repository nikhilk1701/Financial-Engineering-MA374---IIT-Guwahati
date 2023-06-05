clc;
clear all;

M=[5 10 15 20 25];

for i=1:length(M)
    tic;
    V_O(i)=lookback(M(i));
    toc;
    time(i)=toc;
end
fprintf('\n');

for i=1:length(M)
    fprintf('The initial price of the option for M = %d is %f\n',M(i),V_O(i));
end

figure(1);
plot(M(1:length(M)),V_O(1:length(M)));

function V=lookback(M)
    u = @(sig,dt,r) exp((sig*(dt)^0.5)+(r-0.5*sig*sig)*dt);
    d = @(sig,dt,r) exp((-sig*(dt)^0.5)+(r-0.5*sig*sig)*dt);
    S(1) = 100; S_max(1) = S(1);
    r = 0.08; sig = 0.2 ; dt=1/M; lev=M+1;
    for i=1:lev-1
        k=2^(i-1);
        for j=1:(2^(i-1))
            S(2*(k+j-1)) = u(sig,dt,r)*S((k+j-1));
            S(2*(k+j-1)+1) = d(sig,dt,r)*S((k+j-1));
            S_max(2*(k+j-1)) = max(S(2*(k+j-1)),S_max((k+j-1)));
            S_max(2*(k+j-1)+1) =  max(S(2*(k+j-1)+1),S_max((k+j-1)));
        end
        if i==lev-1
            V((2^(lev-1)):(2^(lev)-1)) = S_max((2^(lev-1)):(2^(lev)-1))-S((2^(lev-1)):(2^(lev)-1));
        end
    end
    p = (exp(r*dt)-d(sig,dt,r))/(u(sig,dt,r)-d(sig,dt,r));
    q = 1-p;

    for i=lev-1:-1:1
        k=2^(i-1);
        for j=1:(2^(i-1))
            V((k+j-1)) = (exp(-r*dt))*(p*V(2*(k+j-1))+q*V(2*(k+j-1)+1));
        end
    end
    if M==5
        fprintf('For M = 5 the values at each intermediate level are\n\n');
        for q=2:5
            fprintf('level %d : ',q);
            for h=2^(q-1):2^(q)-1
                fprintf('%f  ',V(h));
            end
            fprintf('\n');
        end
    end
    V=V(1);
end
