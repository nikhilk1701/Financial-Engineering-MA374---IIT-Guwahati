clc;
clear all;

s0=100; K=100; t=1; r=0.08; sig=0.2; m=100;

a=americancall(s0, K, t, r, sig, m);
b=americanput(s0, K, t, r, sig, m);

fprintf('%f is the initial price of Call option for the given values \n', a(1,1));
fprintf('%f is the iinitial price of Put option for the given values \n', b(1,1));

fignum=1;

s1=60:5:130;

for j=1:length(s1)
    sol_call=americancall(s1(j), K, t, r, sig, m);
    sol_put=americanput(s1(j), K, t, r, sig, m);
    s1_call(j)=sol_call(1, 1);
    s1_put(j)=sol_put(1, 1);
end;

figure(fignum);
plot(s1, s1_call(:)); hold on; plot(s1, s1_put(:));
title('Option Price as S(0) varies');
legend('Call', 'put'); xlabel('S(0)'); ylabel('Price');
fignum=fignum+1;


K1=80:5:130;
for j=1:length(K1)
    sol_call=americancall(s0, K1(j), t, r, sig, m);
    sol_put=americanput(s0, K1(j), t, r, sig, m);
    K_call(j)=sol_call(1, 1);
    K_put(j)=sol_put(1, 1);
end;

figure(fignum);
plot(K1, K_call(:)); hold on; plot(K1, K_put(:));
title('Option Price as  K varies');
legend('Call', 'Put'); xlabel('K'); ylabel('Price');
fignum=fignum+1;

r1=0.05:0.01:0.2;
for j=1:length(r1)
    sol_call=americancall(s0, K, t, r1(j), sig, m);
    sol_put=americanput(s0, K, t, r1(j), sig, m);
    r1call(j)=sol_call(1, 1);
    r1put(j)=sol_put(1, 1);
end;

figure(fignum)
plot(r1, r1call(:)); hold on; plot(r1, r1put(:));
title('Option Price as  r varies');
legend('Call', 'Put'); xlabel('r'); ylabel('Price');
fignum=fignum+1;

sig_=0.2:0.02:0.6;
for j=1:length(sig_)
    sol_call=americancall(s0, K, t, r, sig_(j), m);
    sol_put=americanput(s0, K, t, r, sig_(j), m);
    Vsig_call(j)=sol_call(1, 1);
    Vsig_put(j)=sol_put(1, 1);
end;

figure(fignum)
plot(sig_, Vsig_call(:)); hold on; plot(sig_, Vsig_put(:));
title('Option Price as  Sigma varies');
legend('Call', 'Put'); xlabel('Sigma'); ylabel('Price');
fignum=fignum+1;



m_=50:1:300;
Km=[95 100 105];
VKm_call=zeros(length(m_), length(Km));
VKm_put=zeros(length(m_), length(Km));
for j=1:length(m_)
    for k=1:length(Km)
        sol_call=americancall(s0, Km(k), t, r, sig, m_(j));
        sol_put=americanput(s0, Km(k), t, r, sig, m_(j));
        VKm_call(j, k)=sol_call(1, 1);
        VKm_put(j, k)=sol_put(1, 1);
    end;
end;

figure(fignum)
for i=1:3
    subplot(3, 1, i)
    plot(m_, VKm_call(:, i));
    title(['K=', num2str(Km(i))]);
    ylabel('Price');
end;

function V=americanput(s, K, t, r, sigma, m)
    S(1, 1)=s;
    delt=t/m;
    u=exp(sigma*sqrt(delt)+(r-(1/2)*sigma*sigma)*delt);
    d=exp(-sigma*sqrt(delt)+(r-(1/2)*sigma*sigma)*delt);
    if d>exp(r*delt) || u<exp(r*delt)
        return
    end;
    p=(exp(r*delt)-d)/(u-d);
    q=(u-exp(r*delt))/(u-d);

    for j=2:m+1
        for i=1:j-1
            S(i, j)=u*S(i, j-1);
        end;
        S(j, j)=d*S(j-1, j-1);
    end;

    V=zeros(m+1, m+1);
    for i=1:m+1
        V(i, m+1)=max(K-S(i, m+1), 0);
    end;
    for j=m:-1:1
        for i=1:j
            V(i, j)=max((exp(-r*delt))*(p*V(i, j+1)+q*V(i+1, j+1)), K-S(i, j));
        end;
    end;
end

function V=americancall(so, K, t, r, sigma, m)
    s(1, 1)=so;
    delt=t/m;
    u=exp(sigma*sqrt(delt)+(r-(1/2)*sigma*sigma)*delt);
    d=exp(-sigma*sqrt(delt)+(r-(1/2)*sigma*sigma)*delt);
    if d>exp(r*delt) || u<exp(r*delt)
        return
    end;
    p=(exp(r*delt)-d)/(u-d);
    q=(u-exp(r*delt))/(u-d);

    for j=2:m+1
        for i=1:j-1
            s(i, j)=u*s(i, j-1);
        end;
        s(j, j)=d*s(j-1, j-1);
    end;

    V=zeros(m+1, m+1);
    for i=1:m+1
        V(i, m+1)=max(s(i, m+1)-K, 0);
    end;
    for j=m:-1:1
        for i=1:j
            V(i, j)=max((exp(-r*delt))*(p*V(i, j+1)+q*V(i+1, j+1)), s(i, j)-K);
        end;
    end;
end