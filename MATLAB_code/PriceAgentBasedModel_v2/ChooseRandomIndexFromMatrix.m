function [i,j] = ChooseRandomIndexFromMatrix( A )

% assert no negative elements
assert(sum(A(:)<0) == 0)
% assert at least one element > 0!
assert(sum(A(:)) ~= 0)

nbrOfRows = size(A,1);
nbrOfColumns = size(A,2);

v = zeros(1,nbrOfRows*nbrOfColumns);

for i = 1:nbrOfRows
    for j = 1:nbrOfColumns
        v((i-1)*nbrOfColumns + j) = A(i,j);
    end
end

index = ChooseRandomIndexFromVector(v);

j = mod(index -1,nbrOfColumns) + 1;
i = (index - j)/nbrOfColumns + 1;

end

