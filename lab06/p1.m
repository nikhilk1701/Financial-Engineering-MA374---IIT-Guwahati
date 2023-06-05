clear all
close all
clc

bse = readtable('bsedata1.csv');
nse = readtable('nsedata1.csv');

plot_prices(bse,1233,1);
plot_prices(nse,1229,2);

function y = plot_prices(data,n1,x)
    Company = (data.Properties.VariableNames(1:10));
    data=data{1:n1,1:10};
    n = size(data);
    n = n(1);
    for i=1:3
        figure(i+3*(x-1))
        subplot(3,1,1)
        plot(1:n,data(:,i));
        legend('Daily')
        temp1=zeros(1,floor(n/7)+1); temp2=zeros(1,floor(n/30)+1);
        for j=1:n
            temp1(floor(j/7)+1)=temp1(floor(j/7)+1)+data(j,i);
            temp2(floor(j/30)+1)=temp2(floor(j/30)+1)+data(j,i);
        end
        temp1=temp1/7;
        temp2=temp2/30;
        subplot(3,1,2)
        plot(1:n/7+1,temp1);
        legend('Weekly')
        subplot(3,1,3)
        plot(1:n/30+1,temp2);
        legend('Monthly')
        suptitle([Company(i)]);
    end
end
