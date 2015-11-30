function iSelected = TournamentSelect(fitness, ...
    tournamentSelectionParameter, tournamentSize)

populationSize = size(fitness,1);
iPlayers = randi(populationSize, tournamentSize, 1);
fitnessOfPlayers = fitness(iPlayers,:);

while (numel(iPlayers) > 1)
  [~, iFittestTmp] = max(fitnessOfPlayers);
  iFittest = iPlayers(iFittestTmp);
  
  r = rand;
  if (r < tournamentSelectionParameter)
    iSelected = iFittest;
    break
  else
    iPlayers(iFittestTmp) = [];
    fitnessOfPlayers(iFittestTmp) = []; 
  end
end

if (numel(iPlayers) == 1)
  iSelected = iPlayers;
end

end