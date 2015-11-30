function mutatedChromosome = Mutate(chromosome, mutationProbability, nCustomers, nStores)
% Mutate

mutatedChromosome = chromosome;

for iCustomer = 1:nCustomers
    if rand() < mutationProbability
        % if mutation occurs
        if rand() < 0.5
            % then random mutation
            newStore = randi(nStores+1);
            if newStore == nStores+1
                newStore = NaN;
            end
            mutatedChromosome(iCustomer) = newStore;
        else
            % swap mutation
            swapWith = randi(nCustomers);
            tmp = chromosome(iCustomer);
            chromosome(iCustomer) = chromosome(swapWith);
            chromosome(swapWith) = tmp;
        end
    end
            
            
        % or swap mutations
        % WARNING: only use swap mutations if using problem specific
        % operators!!!
        

end

end