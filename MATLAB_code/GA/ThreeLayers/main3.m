%% main3 Main program - 3 layers

% Run this script first, then GA.m

clear; close all force; clc;

nRetailers = 50; %number of customers
nWarehouses = 10; % number of stores
nManufacturers = 5;
worldSize = 1; %size of the world
maxDistance = 3; %interaction radius (UNUSED)

retailersDemands = ones(1,nRetailers);
warehousesMaxCapacity = Inf;%(nRetailers/nWarehouses)*ones(nWarehouses,1);
manufacturersSupply = 10*ones(nManufacturers,1);

%positions in the world
retailersPositions = rand(nRetailers,2) * worldSize;
warehousesPositions = rand(nWarehouses,2) * worldSize;
manufacturersPositions = rand(nManufacturers,2) * worldSize;

% compute distances and associated transportation-fitness matrix
distWarehousesRetailers = pdist2(warehousesPositions, retailersPositions);
distManufacturersWarehouses = pdist2(manufacturersPositions,warehousesPositions);
transportFitnessWR = 1./distWarehousesRetailers;
transportFitnessMW = 1./distManufacturersWarehouses;

% for the GA
nLayers = 3;
facilitiesPerLayer = [nRetailers, nWarehouses, nManufacturers];
nTotGenes = sum(facilitiesPerLayer);
distances = {distWarehousesRetailers; distManufacturersWarehouses};