function iWorstSolution = UpdateWorst(fitness, unfitness)

[maximumUnfitness, iMaxUnfitness] = max(unfitness);
if maximumUnfitness > 0
    iWorstSolution = iMaxUnfitness;
else
    [~, iMinFitness] = min(fitness);
    iWorstSolution = iMinFitness;
end

end