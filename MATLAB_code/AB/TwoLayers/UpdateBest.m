function [bestSoFar, bestFitness, bestUnfitness] = UpdateBest(population, fitness, unfitness)

viableSolutions = population(unfitness == 0, :);

if isempty(viableSolutions)
    [bestUnfitness,iBestOfTheWorst] = min(unfitness);
    bestFitness = fitness(iBestOfTheWorst);
    bestSoFar = population(iBestOfTheWorst,:);
else
    bestUnfitness = 0;
    fitness(unfitness~=0,:) = NaN;
    [~,iBestOfTheBest] = nanmax(fitness);
    bestFitness = fitness(iBestOfTheBest);
    bestSoFar = population(iBestOfTheBest,:);
end
    
end