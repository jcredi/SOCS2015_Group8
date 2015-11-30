function DrawNetwork(links, nCustomers, customersPositions, storesPositions, bestSolution)


for iCustomer = 1:nCustomers
    
    customerPos = customersPositions(iCustomer,:);
    chosenStore = bestSolution(iCustomer);
    if isnan(chosenStore)
        set(links(iCustomer),'XData',[NaN NaN]);
        set(links(iCustomer),'YData',[NaN NaN]);
    else
        storePos = storesPositions(chosenStore,:);
    
        set(links(iCustomer),'XData',[customerPos(1) storePos(1)]);
        set(links(iCustomer),'YData',[customerPos(2) storePos(2)]);
    end
end

drawnow;

end
