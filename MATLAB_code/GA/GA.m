%% GA A GA solver for the generalised assignment problem
% Run script main.m first, then this

% TO-DO
% understand why sometimes maximum fitness decreases!!!

%% GA parameters
populationSize = 50;
nGenerations = 50000;
crossoverProbability = 0.8;
mutationProbability = 1/nCustomers;
tournamentProbability = 0.8;
tournamentSize = 5;
plotFrequency = 1000;

%% Initialisations
fitness = zeros(populationSize,1);
unfitness = zeros(populationSize,1);
population = randi(nStores+1, populationSize, nCustomers);
population(population==nStores+1) = NaN;

%% Evaluate initial fitness and unfitness
for iChromosome = 1:populationSize
    fitness(iChromosome) = EvaluateFitness(population(iChromosome,:), nCustomers, payoffs);
    unfitness(iChromosome) = EvaluateUnfitness(population(iChromosome,:), ...
        nCustomers, capacities, demands);
end
iWorstSolution = UpdateWorst(fitness, unfitness);
[bestSoFar, bestFitness, bestUnfitness] = UpdateBest(population, fitness, unfitness);

% Fitness plot
bestFitnessFigure = InitialiseFitnessPlot(bestFitness);
% World plot
links = InitialiseWorldPlot(worldSize, customersPositions, storesPositions);


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
    offspring = Crossover(parent1, parent2);
    
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