function DrawMultiNetwork(bestSolution, linksRetailersWarehouses, ...
    linksWarehousesManufacturers, retailersPositions, warehousesPositions, ...
    manufacturersPositions, warehousesDemands)
%% DrawMultiNetwork 

% connections retailers <-> warehouses
nRetailers = size(bestSolution{1},2);
for iRetailer = 1:nRetailers
    
    retailerPos = retailersPositions(iRetailer,:);
    chosenWarehouse = bestSolution{1}(1,iRetailer);
    if isnan(chosenWarehouse)
        set(linksRetailersWarehouses(iRetailer),'XData',[NaN NaN]);
        set(linksRetailersWarehouses(iRetailer),'YData',[NaN NaN]);
    else
        warehousePos = warehousesPositions(chosenWarehouse,:);
    
        set(linksRetailersWarehouses(iRetailer),'XData',[retailerPos(1) warehousePos(1)]);
        set(linksRetailersWarehouses(iRetailer),'YData',[retailerPos(2) warehousePos(2)]);
    end
end


% connections warehouses <-> manufacturers
nWarehouses = size(bestSolution{2},2);
linesThickness = 3.*warehousesDemands./nanmax(warehousesDemands);
for iWarehouse = 1:nWarehouses
    
    warehousePos = warehousesPositions(iWarehouse,:);
    chosenManufacturer = bestSolution{2}(1,iWarehouse);
    if isnan(chosenManufacturer) || linesThickness(iWarehouse) == 0 || isnan(linesThickness(iWarehouse))
        set(linksWarehousesManufacturers(iWarehouse),'XData',[NaN NaN]);
        set(linksWarehousesManufacturers(iWarehouse),'YData',[NaN NaN]);
    else
        manufacturerPos = manufacturersPositions(chosenManufacturer,:);
    
        set(linksWarehousesManufacturers(iWarehouse),'XData',[warehousePos(1) manufacturerPos(1)]);
        set(linksWarehousesManufacturers(iWarehouse),'YData',[warehousePos(2) manufacturerPos(2)]);
        set(linksWarehousesManufacturers(iWarehouse),'LineWidth',linesThickness(iWarehouse));
    end
end


drawnow;

end
