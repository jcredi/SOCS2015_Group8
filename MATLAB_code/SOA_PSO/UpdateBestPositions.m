function [particleBest, particleBestEval, swarmBest, swarmBestEval] =...
    UpdateBestPositions(particleBest, particleBestEval, swarmBest, ...
    swarmBestEval, positions, functionValues)

swarmSize = size(positions,3);

for iParticle = 1:swarmSize
  if functionValues(iParticle) < particleBestEval(iParticle)
    particleBest(:,:,iParticle) = positions(:,:,iParticle);
    particleBestEval(iParticle) = functionValues(iParticle);
  end
end

[currentSwarmBestValue, iBestParticle] = min(functionValues);
if currentSwarmBestValue < swarmBestEval
  swarmBest = positions(:,:,iBestParticle);
  swarmBestEval = currentSwarmBestValue;
end

end