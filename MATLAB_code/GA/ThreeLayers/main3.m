%% main3 Main program - 3 layers

% Run this script first, then GA.m

clear; close all force; clc;

nRetailers = 100; %number of customers
nWarehouses = 10; % number of stores
nManufacturers = 2;
worldSize = 10; %size of the world
maxDistance = 3; %interaction radi

retailersDemands = ones(1,nRetailers);
warehousesMaxCapacity = (nRetailers/nWarehouses)*ones(nWarehouses,1);
manufacturersSupply = (nRetailers/nManufacturers)*ones(nManufacturers,1);

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
alpha = 0.01;
nLayers = 3;
facilitiesPerLayer = [nRetailers, nWarehouses, nManufacturers];
nTotGenes = sum(facilitiesPerLayer);
distances = {distWarehousesRetailers; distManufacturersWarehouses};