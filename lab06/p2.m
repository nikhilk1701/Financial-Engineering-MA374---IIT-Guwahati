close all
clear all
clc

bse=readtable('bsedata1.csv');
nse=readtable('nsedata1.csv');

get_histograms(bse,1233,1);
get_histograms(nse,1229,2);

function y=get_histograms(data,n1,x)
    Company=(data.Properties.VariableNames(1:10));
    data=price2ret(data{2:n1,1:10});
    for i=1:10
        temp = data(:,i);
        temp = (temp-mean(temp))/var(temp)^0.5;
        figure(i+10*(x-1))
        histogram(temp,'Normalization','probability');
        hold on;
        func = @(x) exp(-x*x/2)/(2*pi)^0.5;
        fplot(func,[-3 3]);
        title([Company(i)]);
    end
end
