close all
clear all
clc

bse = readtable('bsedata1.csv');
nse = readtable('nsedata1.csv');
predict_weekly(bse,1233,1);
predict_monthly(bse,1233,2);
predict_weekly(nse,1229,3);
predict_monthly(nse,1229,4)


function y=predict_weekly(data,n1,x)
    Company = (data.Properties.VariableNames(1:10));
    bse = data{2:n1,1:10};
    for i=1:5
        n=size(bse);
        n=n(1);
        temp1=zeros(1,floor((n-365)/7)+1);
        for j=1:n-365
            temp1(floor(j/7)+1)=temp1(floor(j/7)+1)+bse(j,i);
        end
        temp1=temp1/7;
        n=size(temp1);  n=n(2);
        temp2=price2ret(log(temp1));
        mu=mean(temp2(1:n-53));
        sig=var(temp2(1:n-53))^0.5;
        pred=zeros(1,53); 
        pred(1)=temp1(n-53)^(1+mu+sig*randn); 
        for j=2:53
            pred(j)=pred(j-1)^(1+mu+sig*(randn));
        end
        figure(i+5*(x-1))
        plot(1:53,pred);
        hold on
        plot(1:53,temp1(n-52:n),'r');
        title([Company(i)]);
        legend('predicted values','actual values')
    end
end

function y=predict_monthly(data,n1,x)
    Company = (data.Properties.VariableNames(1:10));
    bse = data{2:n1,1:10};
    for i=1:5
        n=size(bse);
        n=n(1);
        temp1=zeros(1,floor((n-365)/30)+1);
        for j=1:n-365
            temp1(floor(j/30)+1)=temp1(floor(j/30)+1)+bse(j,i);
        end
        temp1=temp1/30;
        n=size(temp1);  n=n(2);
        temp2=price2ret(log(temp1));
        mu=mean(temp2(1:n-12));
        sig=var(temp2(1:n-12))^0.5;
        pred=zeros(1,12); 
        pred(1)=temp1(n-12)^(1+mu+sig*randn); 
        for j=2:12
            pred(j)=pred(j-1)^(1+mu+sig*(randn));
        end
        figure(i+5*(x-1))
        plot(1:12,pred);
        hold on
        plot(1:12,temp1(n-11:n),'r');
        title([Company(i)]);
        legend('predicted values','actual values')
    end
end

