function offspring = Crossover(parent1, parent2)


nGenes = size(parent1,2); % Both chromosomes must have the same length!
crossoverPoint = randi(nGenes-1);

offspring(1,:) = [parent1(1:crossoverPoint) parent2(crossoverPoint+1:nGenes)];
offspring(2,:) = [parent2(1:crossoverPoint) parent1(crossoverPoint+1:nGenes)];

end