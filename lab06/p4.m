close all
clear all
clc

bse=readtable('bsedata1.csv');
nse=readtable('nsedata1.csv');

predict(bse,1233,1);
predict(nse,1228,2);

function y=predict(data,n1,x)
    Company=(data.Properties.VariableNames(1:10));
    bse1 = price2ret(log(data{2:n1,1:10}));
    bse = data{2:n1,1:10};
    for i=1:5
        temp = bse1(:,i);
        n=size(temp);
        n=n(1);
        mu=mean(temp(1:n-365));
        sig=var(temp(1:n-365))^0.5;
        pred=zeros(1,365); 
        pred(1)=bse(n-365)^(1+mu+sig*randn); 
        for j=2:365
            pred(j)=pred(j-1)^(1+mu+sig*(randn));
        end
        figure(i+5*(x-1))
        plot(1:365,pred);
        hold on
        plot(1:365,bse(n-364:n),'r');
        suptitle([Company(i)]);
        legend('predicted values','actual values')
    end
end
