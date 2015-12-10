function [facilitiesPerLayer, positions, distances] = GenerateWorld(...
    worldSize, nRetailers, nWarehouses, nManufacturers)
%% GenerateWorld

%positions in the world
retailersPositions = rand(nRetailers,2) * worldSize;
warehousesPositions = rand(nWarehouses,2) * worldSize;
manufacturersPositions = rand(nManufacturers,2) * worldSize;

positions = {retailersPositions, warehousesPositions, manufacturersPositions};

% compute distances and associated transportation-fitness matrix
distWarehousesRetailers = pdist2(warehousesPositions, retailersPositions);
distManufacturersWarehouses = pdist2(manufacturersPositions,warehousesPositions);

% for the GA
facilitiesPerLayer = [nRetailers, nWarehouses, nManufacturers];
distances = {distWarehousesRetailers; distManufacturersWarehouses};


end