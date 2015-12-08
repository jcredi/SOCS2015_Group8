function offspring = Crossover(parent1, parent2, crossoverProbability)

offspring = cell(2,1);
offspring{1} = cell(2,1);
offspring{2} = cell(2,1);

for iChromosome = 1:size(parent1,1) % for each chromosome in the genome
    if rand() < crossoverProbability % crossover with probability pCross
        nGenes = size(parent1{iChromosome},2);
        crossoverPoint = randi(nGenes-1);

        offspring{1,1}{iChromosome,1} = [parent1{iChromosome}(1:crossoverPoint) ...
            parent2{iChromosome}(crossoverPoint+1:nGenes)];
        offspring{2,1}{iChromosome,1} = [parent2{iChromosome}(1:crossoverPoint) ...
            parent1{iChromosome}(crossoverPoint+1:nGenes)];
    else
        offspring{1,1}{iChromosome,1} = parent1{iChromosome};
        offspring{2,1}{iChromosome,1} = parent2{iChromosome};
    end
    
end







end