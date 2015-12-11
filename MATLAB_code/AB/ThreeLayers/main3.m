%% main3 Main program - 3 layers

% Run this script first, then GA.m

clear; close all force; clc;

nRetailers = 50; %number of customers
nWarehouses = 10; % number of stores
nManufacturers = 5;
worldSize = 1; %size of the world
maxDistance = 3; %interaction radius (UNUSED)
alpha = 5;

retailersDemands = ones(1,nRetailers);
warehousesMaxCapacity = Inf;%(nRetailers/nWarehouses)*ones(nWarehouses,1);
manufacturersSupply = 10*ones(nManufacturers,1);

[facilitiesPerLayer, positions, distances] = GenerateWorld(...
    worldSize, nRetailers, nWarehouses, nManufacturers);
