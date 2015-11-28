function DrawNetwork(nCustomers, customersPositions, storesPositions, bestSolution)
% DrawNetwork

% TO-DO:
% Fix this function: doesn't work


for iCustomer = 1:nCustomers
    customerPos = customersPositions(iCustomer,:);
    chosenStore = bestSolution(iCustomer);
    storePos = storesPositions(chosenStore,:);
	
    connection(iCustomer) = line(customerPos, storePos);
end