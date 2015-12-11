%% main3 Main program - 3 layers

% Run this script first, then GA.m

clear; close all force; clc;

nRetailers = 5; %number of customers
nWarehouses = 2; % number of stores
nManufacturers = 2;
worldSize = 1; %size of the world
maxDistance = 3; %interaction radius (UNUSED)
<<<<<<< HEAD
alpha = 0.5;
probabilityGain = 0.01;
=======
alpha = 5;
>>>>>>> c5610a0cb7002f52d3177861ae61e4be436cfbeb

retailersDemands = ones(1,nRetailers);
warehousesMaxCapacity = Inf;%(nRetailers/nWarehouses)*ones(nWarehouses,1);
manufacturersSupply = 10*ones(nManufacturers,1);

[facilitiesPerLayer, positions, distances] = GenerateWorld(...
    worldSize, nRetailers, nWarehouses, nManufacturers);
