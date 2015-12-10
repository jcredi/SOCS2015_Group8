!synclient HorizTwoFingerScroll=0
radius = 100; %interaction radius
width = 1.5;
zero_prob = 1e-3; %prob if no connection
gain = 0.01; %gain due profitable shopping
training_runs = 100; 
shopping_runs = 1e4; %shopping runs
plotFrequency = 1e1;
%initialization of the arrays
probabilities = zeros(nStores,nCustomers);
history = zeros(nStores,nCustomers);
spinning_wheel = ones(nStores,nCustomers);
demands_temp = ones(nCustomers,1);
capacities_temp = ones(nStores,1) * nCustomers/nStores;
output = ones(shopping_runs,1);
tradesMatrix = zeros(nStores,nCustomers);
%help variables
b = 0;
index_loop = 0;
bla_koa_lust = randperm(nCustomers);
fitness = 0;
maxFitness = 0;

% World plot
links = InitialiseWorldPlot(worldSize, customersPositions, storesPositions);

%define the initial probabilities
for k = 1:nStores
    for j = 1:nCustomers
        b = distances(k,j);
        if b > radius
            probabilities(k,j) = zero_prob;
        else
            probabilities(k,j) = exp( - b^2 / width^2);
        end
    end
end

%perform n shopping runs
range = shopping_runs + training_runs;
for p = 1:range
    tradesMatrix = zeros(nStores,nCustomers);
    %disp(p)
    %at every iteration the demand is reset and the capacity is filled up
    summe = 0;
    demands_temp = demands;
    capacities_temp = capacities;
    if p == training_runs + 1
        probabilities = probabilities .* history;
    end
    
    %create a spinning wheel to select a shop with probability p
    if or(p > training_runs, p == 1)
        for l = 1:nCustomers
            summe = 0;
            for n = 1:nStores
                summe = summe + probabilities(n,l);
                spinning_wheel(n,l) = summe;
            end
            spinning_wheel(1:nStores,l) = spinning_wheel(1:nStores,l) / summe;
            probabilities(1:nStores,l) = probabilities(1:nStores,l) / summe;
        end
    end
    
    %initialize indices for choosing randomly customers and shops with
    %prob. p
   
    
    %iterates randomly over all customers and choose store with probability p
    bla_koa_lust = randperm(nCustomers);
    for o = 1:nCustomers
        random = rand;
        index_loop = bla_koa_lust(o); 
        index_S = find(random < spinning_wheel(1:nStores,index_loop),1);%find his shop with spinning the wheel
       
        if capacities_temp(index_S) > demands(index_loop) - 1 %In stock?
            capacities_temp(index_S) = capacities_temp(index_S) - demands(index_loop);
            demands_temp(index_loop) = demands_temp(index_loop) - demands(index_loop);
            tradesMatrix(index_S, index_loop) = demands(index_loop);
            
            %profit from successful shopping
            if p > training_runs
                probabilities(index_S, index_loop) = probabilities(index_S, index_loop) + gain;
            else
                history(index_S, index_loop) = history(index_S, index_loop) +1;
            end
        else
            if p > training_runs
                probabilities(index_S, index_loop) = probabilities(index_S, index_loop);
            else
                history(index_S, index_loop) = history(index_S, index_loop) +1;
            end

        end
    end
    if fitness > maxFitness 
        maxFitness = fitness;
    end
    fitness = EvaluateFitnessAgent(tradesMatrix, nCustomers, demands, distances, alpha);
    if p == 1
        % Fitness plot
        bestFitnessFigure = InitialiseFitnessPlot(fitness);
    end
    if mod(p,plotFrequency) == 0
        UpdateFitnessPlot(bestFitnessFigure, p, fitness);
    end
end
[best_solution, best_index] = max(probabilities);
DrawNetwork(links, nCustomers, customersPositions, storesPositions, best_index);
disp(maxFitness);
