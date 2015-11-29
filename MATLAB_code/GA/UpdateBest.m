function [bestSoFar, bestFitness] = UpdateBest(population, fitness, unfitness)

viableSolutions = population(unfitness == 0, :);

if isempty(viableSolutions)
    [~,iBestOfTheWorst] = min(unfitness);
    bestFitness = fitness(iBestOfTheWorst);
    bestSoFar = population(iBestOfTheWorst,:);
else
    [~,iBestOfTheBest] = max(fitness);
    bestFitness = fitness(iBestOfTheBest);
    bestSoFar = population(iBestOfTheBest,:);
end
    
end