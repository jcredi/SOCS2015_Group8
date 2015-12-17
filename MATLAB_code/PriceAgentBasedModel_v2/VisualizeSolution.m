function VisualizeSolution( layer )
%VISUALIZESOLUTION Summary of this function goes here
%   Detailed explanation goes here


bestSolution
nbrOfRetailers = length(layer(1).prices);
nbrOfWarehouses = length(layer(2).prices);
nbrOfManufacturers = length(layer(3).prices);

linksRetailersWarehouses = zeros(1,nbrOfRetailers);
for iRetailer = 1:nbrOfRetailers
    for jWarehouse = 1:nbrOfWarehouses
        if layer(1).influx(iRetailer,jWareHouse) > 0
            linksRetailersWarehouses(iRetailer) = jWarehouse;
        end
    end
end

linksWarehousesManufacturers = zeros(1,nbrOfWarehouses);
for iWarehouse = 1:nbrOfWarehouses
    for jManufacturer = 1:nbrOfManufacturers:
        if layer(2).influx(iWarehouse,jManufacturer) > 0
            linksWarehousesManufacturers(iWarehouse) = jManufacturer;
        end
    end
end

retailersPositions = layer(1).locations;
warehousesPositions = layer(2).locations;
manufacturersPositions = layer(3).locations;

warehousesDemands = zeros(1,nbrOfWarehouses);
for iWarehouse = 1:nbrOfWarehouses
    jManufacturer = linksWarehousesManufacturers(iWarehouse);
    warehousesDemands(iWarehouse) = layer(2).influx(iWarehouse,jManufacturer);
end

DrawMultiNetwork(bestSolution, linksRetailersWarehouses, ...
    linksWarehousesManufacturers, retailersPositions, warehousesPositions, ...
    manufacturersPositions, warehousesDemands)


end

