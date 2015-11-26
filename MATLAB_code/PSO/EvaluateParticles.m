function functionValues = EvaluateParticles(positions, demand, capacity, muPenalty)

swarmSize = size(positions,3);
functionValues = zeros(swarmSize,1);

for iParticle = 1:swarmSize
  functionValues(iParticle) = ObjectiveFunction(positions(:,:,iParticle), demand, capacity, muPenalty);
end

end