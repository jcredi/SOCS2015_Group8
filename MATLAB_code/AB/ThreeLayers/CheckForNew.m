function isItReallyNew = CheckForNew(newGenome, population, populationSize)

isItReallyNew = true;

for iGenome = 1:populationSize
    areEqual = isequaln(newGenome,population{iGenome});
    
    if areEqual
        isItReallyNew = false;
        break
    end
end

end