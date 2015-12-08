function links = InitialiseWorldPlot(worldSize, customersPositions, storesPositions)
% InitialiseWorldPlot

figure();
set(gcf,'DoubleBuffer','on');
set(gcf,'Color','w');
set(gcf, 'Position', [1000,180,680,640]);
xlim([0, worldSize]);
ylim([0, worldSize]);
hold on

% customers
nCustomers = size(customersPositions,1);
scatter(customersPositions(:,1), customersPositions(:,2),40,'bo','filled');
customerLabels = num2str((1:nCustomers)','%d');
text(customersPositions(:,1), customersPositions(:,2), customerLabels, ...
    'horizontal','left', 'vertical','bottom');

% stores
nStores = size(storesPositions,1);
scatter(storesPositions(:,1), storesPositions(:,2),100,'r^','filled');
storeLabels = num2str((1:nStores)','%d');
text(storesPositions(:,1), storesPositions(:,2), storeLabels, ...
    'horizontal','left', 'vertical','bottom');

box on;

% Initialise links
links = [];
for i = 1:nCustomers
   links(i) = line([0 0], [0 0]);
end

end