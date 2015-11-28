function iWorstSolution = UpdateWorst(fitness, unfitness)

[~, iMinFitness] = min(fitness);
[maximumUnfitness, iMaxUnfitness] = max(unfitness);
if maximumUnfitness > 0
    iWorstSolution = iMaxUnfitness;
else
    iWorstSolution = iMinFitness;
end

end