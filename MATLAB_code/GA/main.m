%% main Main program

% Run this script first, then GA.m

clear; close all; clc;

nCustomers = 100; %number of customers
nStores = 10; % number of stores
worldSize = 10; %size of the world
walkingDistance = 1; %interaction radi
demands = 1*ones(1,nCustomers);
capacities = 5*ones(nStores,1);

%positions in the world
customersPositions = rand(nCustomers,2) * worldSize;
storesPositions = rand(nStores,2) * worldSize;


% compute distances and payoff matrix
distances = pdist2(storesPositions,customersPositions);
payoffs = walkingDistance./distances;
payoffs(distances < walkingDistance) = 1;


