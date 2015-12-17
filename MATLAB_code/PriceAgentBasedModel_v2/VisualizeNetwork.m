function VisualizeNetwork(layer,fitness)



clf

if nargin == 2
    subplot(1,2,1)
end

hold on



markers = {'bo','gs','r^'};

for iLayer = 1:3
    X = layer(iLayer).locations(:,1);
    Y = layer(iLayer).locations(:,2);
    priceText = cell(1,size(X,1));
    for i = 1:length(priceText)
        priceText{i} = sprintf('%.2f',layer(iLayer).prices(i));
    end
        
    h = scatter(X,Y,markers{iLayer},'filled','LineWidth',15);
    hChildren = get(h, 'Children');
    set(hChildren, 'Markersize', 1100)
    
    text(X,Y,priceText)
end

for iLayer = 1:length(layer) - 1
    customerLocations = layer(iLayer).locations;
    storeLocations = layer(iLayer + 1).locations;
    
    influx = layer(iLayer).influx;
    
    lineColors = {'b','r'};
    
    [nbrOfCustomers,nbrOfStores] = size(influx);
    
    for i = 1:nbrOfCustomers
        for j = 1:nbrOfStores
            if influx(i,j) > 0
            plot([customerLocations(i,1),storeLocations(j,1)],...
                [customerLocations(i,2),storeLocations(j,2)],lineColors{iLayer})
            end
        end
    end
    
end

if nargin == 2
    subplot(1,2,2)
    plot(fitness)
end


end

