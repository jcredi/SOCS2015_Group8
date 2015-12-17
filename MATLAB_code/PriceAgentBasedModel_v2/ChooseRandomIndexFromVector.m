function index = ChooseRandomIndexFromVector( v )

% assert no negative elements
assert(sum(v<0) == 0)
% assert at least one element > 0!
assert(sum(v) ~= 0)

% Normalize to get probability vector:
probabilityDistribution = v/sum(v);

cumulativeDistribution = cumsum(probabilityDistribution) - probabilityDistribution;

r = rand();
for i = 1:length(probabilityDistribution)
    if r > cumulativeDistribution(i)
        index = i;
    end
end

end

