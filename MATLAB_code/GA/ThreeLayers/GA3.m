%% GA3 A GA solver for the (3 layers) generalised assignment problem
% Run script main3.m first, then this

% Here each individual in the population has 2 chromosomes (in general, N-1
% chromosomes, where N is the number of layers). Each chromosome is a
% vector whose index is the "client" and entry is the "supplier" that the
% "client" buys from. So in layer 1 retailers are the clients and
% warehouses are the suppliers, in layer 2 warehouses are the clients and
% manufacturers are the suppliers (and so on, in theory). I'll first write
% a program for a 3-layer supply chain and then hopefully generalise it
% with minimum effort.


function [bestSoFar, bestFitness] = GA3(alpha, worldSize, facilitiesPerLayer, ...
    positions, distances, retailersDemands, manufacturersSupply )

close all;

%% Unpack input data
nLayers = numel(facilitiesPerLayer);
nTotGenes = sum(facilitiesPerLayer);
nRetailers = facilitiesPerLayer(1);
nWarehouses = facilitiesPerLayer(2);
nManufacturers = facilitiesPerLayer(3);
retailersPositions = positions{1};
warehousesPositions = positions{2};
manufacturersPositions = positions{3};

%% GA parameters
populationSize = 50;
nGenerations = 50000;
crossoverProbability = 0.75; % this is now for each chromosome!
mutationProbability = 1/nTotGenes; % see below
tournamentProbability = 0.8;
tournamentSize = 2;
plotFrequency = 1000;

%% Initialisations
fitness = zeros(populationSize,1);
unfitness = zeros(populationSize,1);
population = InitialisePopulation(populationSize, nLayers, facilitiesPerLayer); % this works!




%% Evaluate initial fitness and unfitness
for iGenome = 1:populationSize
    genome = population{iGenome};
    warehousesDemands = hist(genome{1}, nWarehouses); % can only use hist if all retailers demands == 1, otherwise use function below
    % warehousesDemands = EvaluateWarehousesDemands(genome, nWarehouses, retailersDemands);
    fitness(iGenome) = EvaluateFitness(genome, retailersDemands, warehousesDemands, distances, alpha);
    unfitness(iGenome) = EvaluateUnfitness(genome, warehousesDemands, manufacturersSupply);
end   
iWorstSolution = UpdateWorst(fitness, unfitness);
[bestSoFar, bestFitness, bestUnfitness] = UpdateBest(population, fitness, unfitness);

% Fitness plot
bestFitnessFigure = InitialiseFitnessPlot(bestFitness);
% World plot
[linksRetailersWarehouses, linksWarehousesManufacturers] = InitialiseWorldPlot(...
    worldSize, retailersPositions, warehousesPositions, manufacturersPositions);

%% Main GA loop
disp('Running GA...'); tic;
for iGeneration = 1:nGenerations
    
    % Selection
    iParent1 = TournamentSelect(fitness,tournamentProbability,tournamentSize);
    parent1 = population{iParent1};
    iParent2 = TournamentSelect(fitness,tournamentProbability,tournamentSize);
    parent2 = population{iParent2};
    
    % Crossover
    offspring = Crossover(parent1, parent2, crossoverProbability);
    
    for iOffspring = 1:2
        
        newGenome = offspring{iOffspring};
        
        % Mutation
        newGenome = Mutate(newGenome, mutationProbability, nRetailers, ...
            nWarehouses, nManufacturers);
    
        % Check whether or not offspring is already in the population
        % (we don't want copies!)
        isItReallyNew = CheckForNew(newGenome, population, populationSize);
        if isItReallyNew
            % Replacement
            iWorstSolution = UpdateWorst(fitness, unfitness);
            population{iWorstSolution} = newGenome;
            % Update fitness and unfitness
            newWarehousesDemands = hist(newGenome{1}, nWarehouses); % can only use hist if all retailers demands == 1, otherwise use function below
            %newWarehousesDemands = EvaluateWarehousesDemands(newGenome, nWarehouses, retailersDemands);
            fitness(iWorstSolution) = EvaluateFitness(newGenome, ...
                retailersDemands, newWarehousesDemands, distances, alpha);
            unfitness(iWorstSolution) = EvaluateUnfitness(newGenome, ...
                newWarehousesDemands, manufacturersSupply);
        end
    end
       
    % Update plots and best
    if mod(iGeneration,plotFrequency) == 0
        [bestSoFar, bestFitness, bestUnfitness] = UpdateBest(population, fitness, unfitness);
        if bestUnfitness == 0
            UpdateFitnessPlot(bestFitnessFigure, iGeneration, bestFitness);
            warehousesDemands = hist(bestSoFar{1}, nWarehouses);
            DrawMultiNetwork(bestSoFar, linksRetailersWarehouses, ...
                linksWarehousesManufacturers, retailersPositions, ...
                warehousesPositions, manufacturersPositions, warehousesDemands);
        end
    end
    
end
%% end of main loop

fprintf('  %i generations completed in %4.3f seconds.\n',nGenerations,toc);
fprintf('  Final best fitness: %f\n',bestFitness);

end