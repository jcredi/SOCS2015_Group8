%% Comparison of different algorithms

clear; close all force; clc;

% ============================================== %
% PARAMETERS

% Common
alpha = 0.5;
nMaps = 20; 

nRetailers = 45; 
nWarehouses = 5; 
nManufacturers = 3; 
worldSize = 1; %size of the world

% GA
% ---> Parameters hard-coded in GA3.m !!! <---

% Agent-based (greedy and with fidelity)
fidelityReinforcement = 0.01;
fidelityDecayRate = 0.01;
beta = 1;
nRunsAB = 25000;
nRunsForAverage = 500;

% Agent-based price
nPriceUpdates = 2000;
nRunsForAveragePriceModel = 1;


% ============================================== %

addpath('../AB/ThreeLayers/');
addpath('../GA/ThreeLayers/');
addpath('../PriceAgentBasedModel_v2/');

retailersDemands = ones(1,nRetailers);
warehousesMaxCapacity = Inf; % needed by the GA, but set to Inf (no constraint)
manufacturersSupply = ceil(nRetailers/nManufacturers)*ones(nManufacturers,1);

fitness_GA = zeros(1,nMaps);
fitness_AB_greedy = zeros(1,nMaps);
fitness_AB_fidelity = zeros(1,nMaps);
fitness_AB_price = zeros(1,nMaps);

parfor iMap = 1:nMaps
    
    % Generate a new map
    [facilitiesPerLayer, positions, distances] = GenerateWorld(...
        worldSize, nRetailers, nWarehouses, nManufacturers);
    visibility = {1./distances{1}; 1./distances{2}};
    fprintf('Solving map %i of %i', iMap, nMaps);
    
    
    % Solve with AB price model
    'Start AB price model'
    fitness_AB_price(iMap) = PriceABSolver(alpha,nRetailers,nWarehouses,nManufacturers,retailersDemands,...
    manufacturersSupply,positions,nPriceUpdates,nRunsForAveragePriceModel);
    'End AB price model'
    fprintf('fitness: %f\n\n',fitness_AB_price(iMap))
    
    
    % Solve with GA
    'Start GA'
    [~, fitness_GA(iMap)] = GA3_solver(alpha, facilitiesPerLayer, ...
        distances, retailersDemands, manufacturersSupply );
    'End GA'
    fprintf('fitness: %f\n\n',fitness_GA(iMap))
    
    % Solve with AB greedy
    'Start AB greedy model'
    [fitness_AB_greedy(iMap), ~] = AgentBasedSolver_greedy(fidelityReinforcement, fidelityDecayRate, ...
        beta, alpha, nRunsAB, nRetailers, nWarehouses, nManufacturers, retailersDemands, ...
        manufacturersSupply, distances, visibility, nRunsForAverage);
    'End AB greedy model'
    fprintf('fitness: %f\n\n',fitness_AB_greedy(iMap))
    
    
    % Solve with AB fidelity
    'Start AB fidelity model'
    [fitness_AB_fidelity(iMap), ~] = AgentBasedSolver_fidelity(fidelityReinforcement, fidelityDecayRate, ...
        beta, alpha, nRunsAB, nRetailers, nWarehouses, nManufacturers, retailersDemands, ...
        manufacturersSupply, distances, visibility, nRunsForAverage);
    'End AB fidelity model'
    fprintf('fitness: %f\n\n',fitness_AB_fidelity(iMap))
    
end

profit_GA = mean(fitness_GA);
profit_AB_greedy = mean(fitness_AB_greedy);
profit_AB_fidelity = mean(fitness_AB_fidelity);
profit_AB_price = mean(fitness_AB_price);

std_profit_GA = std(fitness_GA);
std_profit_AB_greedy = std(fitness_AB_greedy);
std_profit_AB_fidelity = std(fitness_AB_fidelity);
std_profit_AB_price = std(fitness_AB_price);


bar(1:4,[profit_GA, profit_AB_greedy, profit_AB_fidelity, profit_AB_price]);
hold on
errorbar([1,2,3,4], [profit_GA, profit_AB_greedy, profit_AB_fidelity, profit_AB_price], ...
    [std_profit_GA, std_profit_AB_greedy, std_profit_AB_fidelity, std_profit_AB_price]);


