function VisualizeNetwork(layer)


layer.influx;

% Plot locations
layer(1).locations;

clf
hold on

markers = {'b.','r.','g.'};
lines = {'b','r'};

for iLayer = 1:3
    X = layer(iLayer).locations(:,1);
    Y = layer(iLayer).locations(:,2);
    
    plot(X,Y,markers{iLayer},'MarkerSize',15)
    xlabel('x coordinate')
    ylabel('y coordinate')
end

for iLayer = 1:length(layer) - 1
    customerLocations = layer(iLayer).locations;
    storeLocations = layer(iLayer + 1).locations;
    
    influx = layer(iLayer).influx;
    
    lines = size(influx);
    lines = influx * (1/(sum(sum(influx))))* 30;
    lineColors = {'b','r'};
    
    [nbrOfCustomers,nbrOfStores] = size(influx);
    
    for i = 1:nbrOfCustomers
        for j = 1:nbrOfStores
            if influx(i,j) > 0
            plot([customerLocations(i,1),storeLocations(j,1)],...
                [customerLocations(i,2),storeLocations(j,2)],lineColors{iLayer})
            end
%             plot([customerLocations(i,1),storeLocations(j,1)],...
%                 [customerLocations(i,2),storeLocations(j,2)],lineColors{iLayer},...
%             'LineWidth',lines(i,j) + 0.01)
        end
    end
    
end


end

