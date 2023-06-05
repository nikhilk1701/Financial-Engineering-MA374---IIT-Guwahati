clear ;
clc ;

m = [0.1,0.2,0.15] ;
c = [0.005 -0.010 0.004; -0.010 0.040 -0.002; 0.004 -0.002 0.023] ;
u = [1,1,1] ;

ret = linspace(0.005,0.4,200);
[weg,sig] = get_portfolios(m,c,u,ret) ;
ret = ret' ;

retu = linspace(0.1,0.28,10) ;
[wegb,sigb] = get_portfolios(m,c,u,retu) ;
fprintf('mu\tsigma\t  w(1)\t  w(2)\t  w(3)\n')
for i=1:10
    fprintf('%.2f\t%.4f\t%.4f\t%.4f\t%.4f\n',retu(i),sigb(i),wegb(i,1),wegb(i,2),wegb(i,3));
end
fprintf('\n\n');

[~,index1] = min(abs(sig(1:25)-0.15));
[~,index2] = min(abs(sig(26:200)-0.15));
index2=index2+25;
fprintf('for 0.15 risk minimum and maximun return portfolios are as follows\n');
fprintf('mu\t w(1)\t  w(2)\t  w(3)\n');
fprintf('%.2f\t%.4f\t%.4f\t%.4f\n',ret(index1),weg(index1,1),weg(index1,2),weg(index1,3));
fprintf('%.2f\t%.4f\t%.4f\t%.4f\n',ret(index2),weg(index2,1),weg(index2,2),weg(index2,3));
fprintf('\n\n');

retd=0.18;
[wegd,sigd]=get_portfolios(m,c,u,retd);
fprintf('mu\tsigma\t  w(1)\t  w(2)\t  w(3)\n')
fprintf('%.2f\t%.4f\t%.4f\t%.4f\t%.4f\n',retd,sigd,wegd(1),wegd(2),wegd(3));
fprintf('\n\n');

retfree=0.1;
mark_weg = market_portfolio(m,c,u,retfree);
mark_ret = mark_weg*m' ;
mark_sig = sqrt(mark_weg*c*mark_weg') ;

tempx = 0.4 ;
tempy = retfree + ((mark_ret-retfree)*tempx)/mark_sig ;
x = [0 mark_sig tempx] ;
y = [retfree mark_ret tempy] ;
line(x,y,'color','red')
hold on ;
plot(sig,ret);xlabel('\sigma','Fontsize',20,'FontWeight','bold');
ylabel('\mu','Fontsize',20,'FontWeight','bold');

mfree = [0.1,0.2,0.15,0.1];
cfree = [0.005 -0.010 0.004 0; -0.010 0.040 -0.002 0; 0.004 -0.002 0.023 0;0 0 0 1e-8] ;
ufree = [1,1,1,1] ;
[wegfree,sigfree]=get_portfolios(mfree,cfree,ufree,ret) ;


fprintf('portfolios with 0.1 and 0.25 risk with risk free asset are as follows\n');
fprintf('mu\tsigma\t  w(1)\t  w(2)\t  w(3)\t w(4)-risk free\n');
fprintf('%.2f\t%.2f\t%.4g\t%.4f\t%.4f\t%.4f\n',ret(13),sigfree(13),wegfree(13,1),wegfree(13,2),wegfree(13,3),wegfree(13,4));
fprintf('%.2f\t%.2f\t%.4g\t%.4f\t%.4f\t%.4f\n',ret(85),sigfree(85),wegfree(85,1),wegfree(85,2),wegfree(85,3),wegfree(85,4));
fprintf('%.2f\t%.2f\t%.4g\t%.4f\t%.4f\t%.4f\n',ret(140),sigfree(140),wegfree(140,1),wegfree(140,2),wegfree(140,3),wegfree(140,4));
fprintf('\n\n');


function [weights,var]=get_portfolios(m,c,u,returns)
    
    weights = zeros(length(returns),length(m)) ;
    var = zeros(length(returns),1) ;
    
    t1 = u*(c\m') ;
    t2 = u*(c\u') ;
    t3 = m*(c\m') ;
    t4 = m*(c\u') ;
    
    for i=1:length(returns)
        mat1 = [1 t1;returns(i) t3] ;
        mat2 = [t2 1 ;t4 returns(i)] ;
        mat3 = [t2 t1;t4 t3] ;
        
        w = ( det(mat1)*(u/c) + det(mat2)*(m/c) ) / det(mat3) ;
        sig = sqrt(w*c*w') ;
        
        weights(i,:) = w ;
        var(i,1) = sig ;
    end    
end

function w = market_portfolio(m,c,u,retfree)
    w = (m-retfree*u)/c ;
    w = w/sum(w);
end