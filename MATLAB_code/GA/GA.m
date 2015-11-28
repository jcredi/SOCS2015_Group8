%% GA A GA solver for the generalised assignment problem

% Run script main.m first, then this

% TO-DO
% allow empty entries (no shopping!)

% GA parameters
populationSize = 50;
numberOfGenerations = 10000;
crossoverProbability = 0.8;
mutationProbability = 1/nCustomers;
tournamentProbability = 0.8;
tournamentSize = 5;

% Initialisations
fitness = zeros(populationSize,1);
unfitness = zeros(populationSize,1);
population = randi(nStores, populationSize, nCustomers);

% Evaluate fitness and unfitness
for iChromosome = 1:populationSize
    fitness(iChromosome) = EvaluateFitness(population(iChromosome,:), nCustomers, payoffs);
    unfitness(iChromosome) = EvaluateUnfitness(population(iChromosome,:), ...
        nCustomers, capacities, demands);
end
iWorstSolution = UpdateWorst(fitness, unfitness);
isViable = unfitness == 0;

% [maximumFitness, iMaxFitness] = max(fitness);
% [minimumFitness, iMinFitness] = min(fitness);
% [maximumUnfitness, iMaxUnfitness] = max(unfitness);
% if maximumUnfitness > 0
%     iWorstSolution = iMaxUnfitness;
% else
%     iWorstSolution = iMinFitness;
% end



%% Main GA loop
disp('Running GA...'); tic;
h = waitbar(0,'Please wait...');
for iGeneration = 1:numberOfGenerations
    
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
        isItReallyNew = ~any(ismember(population, newChromosome));
        if isItReallyNew
            
            % Evaluate fitness and unfitness of offspring
            newFitness = EvaluateFitness(newChromosome, nCustomers, payoffs);
            newUnfitness = EvaluateUnfitness(newChromosome, nCustomers, capacities, demands);
           
            % Replacement
            population(iWorstSolution,:) = newChromosome;
            fitness(iWorstSolution,:) = newFitness;
            unfitness(iWorstSolution,:) = newUnfitness;
            iWorstSolution = UpdateWorst(fitness, unfitness);

        end
    end
    
    % TO-DO:
    % compute max fitness and plot
    
    waitbar(iGeneration/numberOfGenerations,h);
end
close(h);
%% end of main loop

% TO-DO:
% find best viable solution and plot it
isViable = unfitness == 0;
[maxFitness, iBestViable] = max(fitness(isViable));
bestSolution = population(iBestViable,:); % WARNING: Can be not viable

% the following function doesn't work
%DrawNetwork(nCustomers, customersPositions, storesPositions, bestSolution)

fprintf('  %i generations completed in %4.3f seconds.\n',numberOfGenerations,toc);