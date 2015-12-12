%% main3 Main program - 3 layers

% Run this script first, then GA.m

clear; close all force; clc;

nRetailers = 50; %number of customers
nWarehouses = 5; % number of stores
nManufacturers = 3;
worldSize = 1; %size of the world
maxDistance = 3; %interaction radius (UNUSED)
alpha = 0.5;

retailersDemands = ones(1,nRetailers);
warehousesMaxCapacity = Inf;%(nRetailers/nWarehouses)*ones(nWarehouses,1);
manufacturersSupply = ceil(nRetailers/nManufacturers)*ones(nManufacturers,1);

[facilitiesPerLayer, positions, distances] = GenerateWorld(...
    worldSize, nRetailers, nWarehouses, nManufacturers);

visibility = {1./distances{1}; 1./distances{2}};