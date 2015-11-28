%% main Main program

% Run this script first, then GA.m

clear; close all; clc;

nCustomers = 10; %number of customers
nStores = 4; % number of stores
worldSize = 10; %size of the world
walkingDistance = 4; %interaction radi
demands = 1*ones(1,nCustomers);
capacities = 5*ones(nStores,1);

%positions in the world
customersPositions = rand(nCustomers,2) * worldSize;
storesPositions= rand(nStores,2) * worldSize;

% plot map of the world
worldHandle = figure();
set(gcf,'Color','w');
xlim([0, worldSize]);
ylim([0, worldSize]);
hold on
% customers
scatter(customersPositions(:,1), customersPositions(:,2),40,'bo','filled');
customerLabels = num2str((1:nCustomers)','%d');
text(customersPositions(:,1), customersPositions(:,2), customerLabels, ...
    'horizontal','left', 'vertical','bottom');
% stores
scatter(storesPositions(:,1), storesPositions(:,2),100,'r^','filled');
storeLabels = num2str((1:nStores)','%d');
text(storesPositions(:,1), storesPositions(:,2), storeLabels, ...
    'horizontal','left', 'vertical','bottom');
box on;
%hold off

% compute distances and payoff matrix
distances = pdist2(storesPositions,customersPositions);
payoffs = walkingDistance./distances;
payoffs(distances < walkingDistance) = 1;


