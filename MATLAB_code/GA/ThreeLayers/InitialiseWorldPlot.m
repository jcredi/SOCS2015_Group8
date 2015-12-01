function [linksRetailersWarehouses, linksWarehousesManufacturers] = ...
    InitialiseWorldPlot(worldSize, retailersPositions, warehousesPositions, manufacturersPositions)
% InitialiseWorldPlot

figure();
set(gcf,'DoubleBuffer','on');
set(gcf,'Color','w');
set(gcf, 'Position', [1000,180,680,640]);
xlim([0, worldSize]);
ylim([0, worldSize]);
hold on

% retailers
nRetailers = size(retailersPositions,1);
scatter(retailersPositions(:,1), retailersPositions(:,2),40,'bo','filled');
retailersLabels = num2str((1:nRetailers)','%d');
text(retailersPositions(:,1), retailersPositions(:,2), retailersLabels, ...
    'horizontal','left', 'vertical','bottom');

% warehouses
nWarehouses = size(warehousesPositions,1);
scatter(warehousesPositions(:,1), warehousesPositions(:,2),80,[0 0.5 0],'s','filled');
warehousesLabels = num2str((1:nWarehouses)','%d');
text(warehousesPositions(:,1), warehousesPositions(:,2), warehousesLabels, ...
    'horizontal','left', 'vertical','bottom');

% manufacturers
nManufacturers = size(manufacturersPositions,1);
scatter(manufacturersPositions(:,1), manufacturersPositions(:,2),100,'r^','filled');
manufacturersLabels = num2str((1:nManufacturers)','%d');
text(manufacturersPositions(:,1), manufacturersPositions(:,2), manufacturersLabels, ...
    'horizontal','left', 'vertical','bottom');

box on;

% Initialise links
parulaColors = get(groot,'DefaultAxesColorOrder');
linksRetailersWarehouses = [];
for i = 1:nRetailers
   linksRetailersWarehouses(i) = line([0 0], [0 0],'LineWidth',0.33);
end
linksWarehousesManufacturers = [];
for i = 1:nWarehouses
   linksWarehousesManufacturers(i) = line([0 0], [0 0], 'Color',parulaColors(2,:));
end

end