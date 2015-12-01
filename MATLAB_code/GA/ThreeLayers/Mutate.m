function mutatedGenome = Mutate(genome, mutationProbability, nRetailers, ...
    nWarehouses, nManufacturers)
% Mutate

mutatedGenome = genome;

% chromosome 1 (retailers-warehouses)
for iRetailer = 1:nRetailers
    if rand() < mutationProbability
        % if mutation occurs
        if rand() < 0.5
            % then random mutation
            newWarehouse = randi(nWarehouses+1);
            if newWarehouse == nWarehouses+1
                newWarehouse = NaN;
            end
            mutatedGenome{1}(1,iRetailer) = newWarehouse;
        else
            % swap mutation
            swapWith = randi(nRetailers);
            tmp = genome{1}(1,iRetailer);
            mutatedGenome{1}(1,iRetailer) = mutatedGenome{1}(1,swapWith);
            mutatedGenome{1}(1,swapWith) = tmp;
        end
    end
end

% chromosome 2 (warehouses-manufacturers)
for iWarehouse = 1:nWarehouses
    if rand() < mutationProbability
        % if mutation occurs
        if rand() < 0.5
            % then random mutation
            newManufacturer = randi(nManufacturers+1);
            if newManufacturer == nManufacturers+1
                newManufacturer = NaN;
            end
            mutatedGenome{2}(1,iWarehouse) = newManufacturer;
        else
            % swap mutation
            swapWith = randi(nWarehouses);
            tmp = genome{2}(1,iWarehouse);
            mutatedGenome{2}(1,iWarehouse) = mutatedGenome{2}(1,swapWith);
            mutatedGenome{2}(1,swapWith) = tmp;
        end
    end
end


end