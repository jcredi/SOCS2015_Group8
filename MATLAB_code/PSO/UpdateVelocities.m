function velocities = UpdateVelocities(velocities, positions,...
  inertiaWeight,c1,c2,particleBest,swarmBest,deltaT,maximumVelocity)

swarmSize = size(positions,3);

for iParticle = 1:swarmSize
    
    inertiaTerm = inertiaWeight*velocities(:,:,iParticle);
    particleBestTerm = c1/deltaT*rand*(particleBest(:,:,iParticle)-positions(:,:,iParticle));
    swarmBestTerm = c2/deltaT*rand*(swarmBest-positions(:,:,iParticle));

    tmpVelocity = inertiaTerm + particleBestTerm + swarmBestTerm;
    tmpVelocity(tmpVelocity > maximumVelocity) = maximumVelocity;
    tmpVelocity(tmpVelocity < -maximumVelocity) = -maximumVelocity;

    velocities(:,:,iParticle) = tmpVelocity;
end
    
end