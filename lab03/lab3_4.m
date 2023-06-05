clc;
clear all;

s=100; t=1; r=0.08; sig=0.2; K=100;
m=[5 10 25 50 ];

for i=1:length(m)
    V=getcallmarkov(s, K, t, r, sig, m(i));
    fprintf(' for m=%d The price of the European Call option by using Markov algorithm is %f\n', m(i), V(1, 1));
end;

fprintf('\n\n');
m_=[5 10 25];

for i=1:length(m_)
    V=get_call(s, K, t, r, sig, 1, m(i));
    fprintf('The price of the European Call option for m=%d is  %f\n', m(i), V(1, 1));
end

function V=getcallmarkov(s, K, t, r, sig, m)
    S(1, 1)=s;
    del_t=t/m;
    u=exp(sig*sqrt(del_t)+(r-(1/2)*sig*sig)*del_t);
    d=exp(-sig*sqrt(del_t)+(r-(1/2)*sig*sig)*del_t);
    if d>exp(r*del_t) || u<exp(r*del_t)
        return
    end;
    p=(exp(r*del_t)-d)/(u-d);
    q=(u-exp(r*del_t))/(u-d);

    for j=2:m+1
        for i=1:j-1
            S(i, j)=u*S(i, j-1);
        end;
        S(j, j)=d*S(j-1, j-1);
    end;

    V=zeros(m+1, m+1);
    for i=1:m+1
        V(i, m+1)=max(S(i, m+1)-K, 0);
    end;
    for j=m:-1:1
        for i=1:j
            V(i, j)=(exp(-r*del_t))*(p*V(i, j+1)+q*V(i+1, j+1));
        end;
    end;
end

function sol=get_call(s, K, t, r, sigma, i, m)
    if i==m+1
        sol=max(s-K, 0);
        return
    end;
    del_t=t/m;
    u=exp(sigma*sqrt(del_t)+(r-(1/2)*sigma*sigma)*del_t);
    d=exp(-sigma*sqrt(del_t)+(r-(1/2)*sigma*sigma)*del_t);
    p=(exp(r*del_t)-d)/(u-d);
    q=(u-exp(r*del_t))/(u-d);
    a=get_call(s*u, K, t, r, sigma, i+1, m);
    b=get_call(s*d, K, t, r, sigma, i+1, m);
    sol=(exp(-r*del_t))*(p*a+q*b);
end