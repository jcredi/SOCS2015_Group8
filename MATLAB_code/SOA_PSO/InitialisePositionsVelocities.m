function [positions, velocities] = InitialisePositionsVelocities(swarmSize,...
  nCustomers, nStores, xMin, xMax, alpha, deltaT)

xRange = xMax-xMin;

positions = zeros(nCustomers, nStores, swarmSize);
velocities = zeros(nCustomers, nStores, swarmSize);

for iParticle = 1:swarmSize
    
    r = rand(nCustomers, nStores);
   	positions(:,:,iParticle) = xMin + r.*xRange;
    
    r = rand(nCustomers, nStores);
    velocities(:, :, iParticle) = alpha/deltaT*(-xRange/2 + r.*xRange);
    
end

end