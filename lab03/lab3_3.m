clc;
clear all;

s=100; t=1; r=0.08; sig=0.2; 
m=[5 10 25 50 100];

for i=1:length(m)
    delt=t/m(i);
    u=exp(sig*sqrt(delt)+(r-(1/2)*sig*sig)*delt);
    d=exp(-sig*sqrt(delt)+(r-(1/2)*sig*sig)*delt);
    tic;
    V=call(s, t, r, m(i), u, d);
    toc;
    time(i)=toc;
    fprintf(' for m=%d the price of the lookback option is %f \n', m(i), V);
end;

function P = call(s0, T, r, m, u, d)
    global max_p
    global price
    dt = T/m;
    p = (exp(r*dt)-d)/(u-d);
    max_p = zeros(m+1,m+1,m+1);
    price = zeros(m+1,m+1,m+1);
    P = solve(s0,p,u,d,dt,s0,r,1,m,1);
end

function P =solve(s,p,u,d,dt,mx,r,c,m,tt)
    global max_p
    global price
    if tt==m+1
        P = max(max(s,mx)-s,0);
        return;
    end
    j = 1;
    for i=1:m+1
        j = i;
        if(price(tt,c,i)==0)
            break;
        end
        if(abs(max_p(tt,c,i)-mx)<1e-04)
            P = price(tt,c,i);
            return;
        end
    end
    pu = solve(s*u,p,u,d,dt,max(mx,s*u),r,c+1,m,tt+1);
    pq = solve(s*d,p,u,d,dt,max(mx,s),r,c,m,tt+1);
    P = exp(-r*dt)*(pu*p+pq*(1-p));
    max_p(tt,c,j) = mx;
    price(tt,c,j) = P;
end