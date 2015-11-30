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



%% GA parameters
populationSize = 50;
nGenerations = 10000;
crossoverProbability = 0.8; % this is now for each chromosome!
mutationProbability = 1/nGenes; % see below
tournamentProbability = 0.8;
tournamentSize = 2;
plotFrequency = 1000;

%% Initialisations
fitness = zeros(populationSize,1);
unfitness = zeros(populationSize,1);
population = InitialisePopulation(populationSize, nLayers, facilitiesPerLayer); % this works!




%% Evaluate initial fitness and unfitness
for iIndividual = 1:populationSize
    genome = population{iIndividual};
    warehousesDemands = EvaluateWarehousesDemands(genome, nWarehouses, retailersDemands);
    fitness(iIndividual) = EvaluateFitness(genome, retailersDemands, warehousesDemands, distances, alpha);
    unfitness(iIndividual) = EvaluateUnfitness(genome, warehousesDemands, ...
        warehousesMaxCapacity, manufacturersSupply);
end   
iWorstSolution = UpdateWorst(fitness, unfitness);
[bestSoFar, bestFitness, bestUnfitness] = UpdateBest(population, fitness, unfitness);

% Fitness plot
bestFitnessFigure = InitialiseFitnessPlot(bestFitness);
% World plot
links = InitialiseWorldPlot(worldSize, customersPositions, storesPositions);

% TO-DO: fix everything from this point on

%% Main GA loop
disp('Running GA...'); tic;
h = waitbar(0,'Please wait...');
for iGeneration = 1:nGenerations
    
    % Selection
    iParent1 = TournamentSelect(fitness,tournamentProbability,tournamentSize);
    parent1 = population(iParent1,:);
    iParent2 = TournamentSelect(fitness,tournamentProbability,tournamentSize);
    parent2 = population(iParent2,:);
    
    % Crossover
    if rand < crossoverProbability
        offspring = Crossover(parent1, parent2);
    else
        offspring = [parent1;parent2];
    end
    
    for iOffspring = 1:2
        
        newChromosome = offspring(iOffspring,:);
        
        % Mutation
        newChromosome = Mutate(newChromosome, mutationProbability, nCustomers, nStores);
        
    
        % TO-DO: 
        % write problem-specific genetic operator(s) (see paper)
    
    
        % Check whether or not offspring is already in the population
        % (we don't want copies!)
        isItReallyNew = CheckForNew(newChromosome, population, populationSize);
        if isItReallyNew
            % Replacement
            iWorstSolution = UpdateWorst(fitness, unfitness);
            population(iWorstSolution,:) = newChromosome;
            fitness(iWorstSolution,:) = EvaluateFitness(newChromosome, nCustomers, payoffs);
            unfitness(iWorstSolution,:) = EvaluateUnfitness(newChromosome, nCustomers, capacities, demands);  
        end
    end
       
    % Update best
    
                
    
    if mod(iGeneration,plotFrequency) == 0
        [bestSoFar, bestFitness, bestUnfitness] = UpdateBest(population, fitness, unfitness);
        if bestUnfitness == 0
            UpdateFitnessPlot(bestFitnessFigure, iGeneration, bestFitness);
            DrawNetwork(links, nCustomers, customersPositions, storesPositions, bestSoFar);
        end
    end
    
    waitbar(iGeneration/nGenerations,h);
end
close(h);
%% end of main loop

fprintf('  %i generations completed in %4.3f seconds.\n',nGenerations,toc);
fprintf('  Final best fitness: %f\n',bestFitness);