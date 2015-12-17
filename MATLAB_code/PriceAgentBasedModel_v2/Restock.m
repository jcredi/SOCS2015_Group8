function [customerLayer,storeLayer] = Restock(customerLayer,storeLayer,parameterSettings)

customerValues = customerLayer.prices;
storePrices = storeLayer.prices;
customerLocations = customerLayer.locations;
storeLocations = storeLayer.locations;

nbrOfCustomers = length(customerValues);
nbrOfStores = length(storePrices);

storeStock = storeLayer.supply;

%TODO do not put this parameter here!
% decay = 0.2;

decay = parameterSettings.decay;
customerSupply = customerLayer.supply * (1 - decay);

% customerSupply = zeros(1,nbrOfCustomers);

% customerBackOrders = customerLayer.backOrders;

% influx = zeros(size(customerLayer.influx));

transportationCost = parameterSettings.transportationCost;

nbrOfOrders = sum(storeStock);

% randomTransactions = zeros(1,nbrOfOrders);
iTransaction = 1;


% 
%     function UpdateRandomTransactions()
%         if sum(tradeProbabilities(:)) > 0 
%             randomTransactions = randp(tradeProbabilities(:),1,nbrOfOrders);
%         end
%     end


%     function [i,j] = ChooseTransaction()
%         transaction = randomTransactions(iTransaction);
%         [i,j] = ind2sub(size(tradeProbabilities),transaction);
%         iTransaction = iTransaction + 1;
%     end





% 
% distances = zeros(nbrOfCustomers,nbrOfStores);
% 
% for i = 1:nbrOfCustomers
%     for j = 1:nbrOfStores
%         distances(i,j) = norm(customerLocations(i,:) - storeLocations(j,:));
%     end
% end

distances = customerLayer.distances;


tradeProbabilities = zeros(nbrOfCustomers,nbrOfStores);

for i = 1:nbrOfCustomers
    for j = 1:nbrOfStores
        % TODO manipulate probabilities
        tradeProbabilities(i,j) = max(0,customerValues(i) - storePrices(j) ...
            - transportationCost * distances(i,j));
        
    end
end

% greed = parameterSettings.greed;

% UpdateRandomTransactions()

while iTransaction < nbrOfOrders
    % While there are possible transactions left to perform:
    if (sum(tradeProbabilities) == 0)
        break
    end
    
    [~,ind] = max(tradeProbabilities(:));
    [i,j] = ind2sub(size(tradeProbabilities),ind);
    % --------------Random start------------------------%
    %     if rand() < greed
    %         [~,ind] = max(tradeProbabilities(:));
    %         [i,j] = ind2sub(size(tradeProbabilities),ind);
    %     else
    % %         [i,j] = ChooseTransaction();
    %         % Choose a random transaction:
    %         transaction = randomTransactions(iTransaction);
    %         [i,j] = ind2sub(size(tradeProbabilities),transaction);
    %         iTransaction = iTransaction + 1;
    %
    
    % --------------Random end------------------------%
    
    
    %         [i,j] = ChooseRandomIndexFromMatrix(tradeProbabilities);
    % end
    
    if storeStock(j) > 0
        customerSupply(i) = customerSupply(i) + 1*decay;
        storeStock(j) = storeStock(j) - 1;
        
        %         if customerBackOrders(i) > 0
        %             influx(i,j) = influx(i,j) + 1;
        %             customerBackOrders(i) = customerBackOrders(i) - 1;
        %         end
        %         influx(i,j) = influx(i,j) + 1;
    else
        tradeProbabilities(:,j) = zeros;
        %         UpdateRandomTransactions();
    end
end

customerLayer.supply = customerSupply;

end

