function isItReallyNew = CheckForNew(newChromosome, population, populationSize)

isItReallyNew = true;

for iChromosome = 1:populationSize
    areEqual = isequaln(newChromosome,population(iChromosome,:));
    
    if areEqual
        isItReallyNew = false;
        break
    end
end

end