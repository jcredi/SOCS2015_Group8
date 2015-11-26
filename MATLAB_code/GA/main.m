clear; close all; clc;

nCustomers = 5; %number of customers
nStores = 2; % number of stores
worldSize = 10; %size of the world
radius = 4; %interaction radi

%initialization of the arrays
%distances = ones(nCustomers,nStores); %minimum distance periodic boundaries
payoffs = zeros(nCustomers,nStores); %0 and 1 for connection
demand = ones(nCustomers,1);
capacity = ones(1,nStores);

%positions in the world
customersPositions = rand(nCustomers,2) * worldSize;
storesPositions= rand(nStores,2) * worldSize;

% plot map of the world
worldHandle = figure();
hold on
plot(customersPositions(:,1), customersPositions(:,2),'bo','MarkerSize',10);
plot(storesPositions(:,1), storesPositions(:,2),'r^','MarkerSize',10);
xlim([0, worldSize]);
ylim([0, worldSize]);
hold off

% compute distances and payoff matrix
distances = pdist2(customersPositions,storesPositions);
payoffs = radius./distances;
payoffs(distances < radius) = 1;


