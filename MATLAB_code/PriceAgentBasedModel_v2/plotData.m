function plotData(prices,data)
%PLOTDATA Summary of this function goes here
%   Detailed explanation goes here


p1 = 0.25;
p2 = 0.75;

n = length(data(1,:));
Y1 = zeros(1,n);
Y2 = zeros(1,n);
Y3 = zeros(1,n);


for i = 1:length(prices)
    
    X = data(:,i);
    
    Y1(i) = quantile(X,p1);
    Y2(i) = mean(X);
    Y3(i) = quantile(X,p2);
end

hold on

% plot(prices,Y1)
plot(prices,Y2)
% plot(prices,Y3)


end

