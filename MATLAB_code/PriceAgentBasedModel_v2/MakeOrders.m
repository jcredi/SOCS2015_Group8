function [customerLayer,storeLayer] = MakeOrders(customerLayer,storeLayer,parameterSettings)

greed = parameterSettings.greed;

customerValues = customerLayer.prices;
storePrices = storeLayer.prices;

customerLocations = customerLayer.locations;
storeLocations = storeLayer.locations;

nbrOfCustomers = length(customerValues);
nbrOfStores = length(storePrices);

customerBackOrders = customerLayer.demand;
customerBackOrders;
% TODO
nbrOfOrders = floor(sum(customerBackOrders));

% OBS! sätt inte dennna parameter här!:
% decay = 0.1;
decay = parameterSettings.decay;

storeDemand = storeLayer.demand * (1 - decay);


% storeDemand = zeros(1,nbrOfStores);
storeStock = storeLayer.supply;

influx = zeros(size(customerLayer.influx));


% tradeProbabilities = rand(10,5);
randomTransactions = zeros(1,nbrOfOrders);
iTransaction = 1;

    function UpdateRandomTransactions()
        if sum(tradeProbabilities(:)) > 0 
            randomTransactions = randp(tradeProbabilities(:),1,nbrOfOrders);
        end
%         'size'
%         size(randomTransactions);
%         'size'
%         nbrOfOrders
    end

    function [i,j] = ChooseTransaction()
        transaction = randomTransactions(iTransaction);
        [i,j] = ind2sub(size(tradeProbabilities),transaction);
        iTransaction = iTransaction + 1;
    end



% distances = zeros(nbrOfCustomers,nbrOfStores);
% 
% 
% for i = 1:nbrOfCustomers
%     for j = 1:nbrOfStores
%         distances(i,j) = norm(customerLocations(i,:) - storeLocations(j,:));
%     end
% end

distances = customerLayer.distances;

transportationCost = parameterSettings.transportationCost;

tradeProbabilities = zeros(nbrOfCustomers,nbrOfStores);

for i = 1:nbrOfCustomers
    for j = 1:nbrOfStores
        tradeProbabilities(i,j) = max(0,customerValues(i) - storePrices(j) ...
            - transportationCost * distances(i,j));
        
        % TODO manipulate trade probabilities;
    end
end

% ------------------Random start ------------------%

% % UpdateRandomTransactions();
% if sum(tradeProbabilities(:)) > 0
%     randomTransactions = randp(tradeProbabilities(:),1,nbrOfOrders);
% end

% ------------------Random end ------------------%


isNonZeroProbabilities = true;

if(sum(tradeProbabilities(:))>0)
    randomTransactions = randp(tradeProbabilities(:),1,nbrOfOrders);
%     size(randomTransactions,2)
%     'b'
%     'nbrOfOrders'
%     nbrOfOrders
    if (size(randomTransactions,2) < nbrOfOrders)
        assert(false)
    end
else
    isNonZeroProbabilities = false;
end
iTransaction = 1;

if nbrOfOrders == 0
    return
end

while (isNonZeroProbabilities && (iTransaction < nbrOfOrders))
    
    % While there are possible transactions left to perform:
    if (~(sum(tradeProbabilities(:)) > 0))
        isNonZeroProbabilities = false;
        break
    end
    
    [~,ind] = max(tradeProbabilities(:));
    [i,j] = ind2sub(size(tradeProbabilities),ind);
    
    %----------------- GREED start --------------------------%
%     
%     if rand() < greed
%         [~,ind] = max(tradeProbabilities(:));
%         [i,j] = ind2sub(size(tradeProbabilities),ind);
%     else
% %         [i,j] = ChooseRandomIndexFromMatrix(tradeProbabilities);
% %         iTransaction
% %         size(randomTransactions)
%         
% %         transaction = randomTransactions(iTransaction);
% %         iTransaction = iTransaction + 1;
%         
% %         size(tradeProbabilities)
%         [i,j] = ChooseTransaction();
% 
% %         [i,j] = ind2sub(size(tradeProbabilities),transaction);
% %         disp([i,j])
% %         disp([x,y])
% %         disp(sprintf('\n'))
%         
%     end
%     
    %----------------- GREED end --------------------------%
    
    if customerBackOrders(i) > 0
        while customerBackOrders(i) > 0
            storeDemand(j) = storeDemand(j) + 1*decay;
            
            customerBackOrders(i) = customerBackOrders(i) - 1;
            if storeStock(j) > 0
                influx(i,j) = influx(i,j) + 1;
                storeStock(j) = storeStock(j) - 1;
            end
            
        end
        tradeProbabilities(i,:) = zeros;
%         UpdateRandomTransactions();


        % ------------------ Random start--------------------------%

%         if sum(tradeProbabilities(:)) > 0 
%             randomTransactions = randp(tradeProbabilities(:),1,nbrOfOrders);
%         end
        
        % ------------------ Random end --------------------------%
        
%         if (sum(tradeProbabilities(:)) > 0)
%             
%             randomTransactions = randp(tradeProbabilities(:),1,nbrOfOrders);
%         end
        
    else
        tradeProbabilities(i,:) = zeros;
        
        %------------------ Random start -------------------------%
        
% %         UpdateRandomTransactions();
%         if sum(tradeProbabilities(:)) > 0 
%             randomTransactions = randp(tradeProbabilities(:),1,nbrOfOrders);
%         end
        
        %------------------ Random end -------------------------%
        
        
%         randomTransactions = randp(tradeProbabilities(:),1,nbrOfOrders);
%         if (sum(tradeProbabilities(:)) > 0)
%             randomTransactions = randp(tradeProbabilities(:),1,nbrOfOrders);
%         end
    end
end

storeLayer.demand = storeDemand;

customerLayer.influx = influx;

end



