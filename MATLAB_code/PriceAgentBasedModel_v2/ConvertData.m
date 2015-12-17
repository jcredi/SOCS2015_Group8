function [ bestSolution,linksRetailersWarehouses,...
    linksWarehousesManufacturers, retailerPositions, ...
    warehousesPositions, ...
    manufacturersPositions, warehousesDemands] = ConvertData( layer )
%CONVERTDATA Summary of this function goes here
%   Detailed explanation goes here



nbrOfRetailers = length(layer(1).prices);
nbrOfWarehouses = length(layer(2).prices);
nbrOfManufacturers = length(layer(3).prices);

linksRetailersWarehouses = NaN(1,nbrOfRetailers);
for iRetailer = 1:nbrOfRetailers
    for jWarehouse = 1:nbrOfWarehouses
        if layer(1).influx(iRetailer,jWarehouse) > 0
            linksRetailersWarehouses(iRetailer) = jWarehouse;
        end
    end
end

linksWarehousesManufacturers = NaN(1,nbrOfWarehouses);
for iWarehouse = 1:nbrOfRetailers
    for jManufacturer = 1:nbrOfManufacturers
        if layer(1).influx(iWarehouse,jManufacturer) > 0
            linksWarehousesManufacturers(iWarehouse) = jManufacturer;
        end
    end
end


bestSolution = cell(2,1);
bestSolution{1} = linksRetailersWarehouses;
bestSolution{2} = linksWarehousesManufacturers;


retailerPositions = layer(1).locations;
warehousesPositions = layer(2).locations;
manufacturersPositions = layer(3).locations;

warehousesDemands = zeros(1,nbrOfWarehouses);

for iWarehouse = 1:nbrOfWarehouses
    jManufacturer = linksWarehousesManufacturers(iWarehouse);
    if (~isnan(jManufacturer))
        warehousesDemands(iWarehouse) = layer(2).influx(iWarehouse,jManufacturer);
    end
%     warehousesDemands(iWarehouse) = layer(2).influx(iWarehouse,jManufacturer);
%     layer(2).influx
%     size(layer(2).influx)
%     iWarehouse
%     jManufacturer


end


end

