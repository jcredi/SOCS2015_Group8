function y = sigmoid(x,minVal,maxVal,steepness,xOffset)

if nargin == 3
    % default value:
    steepness = 6;
    xOffset = 2;
end

offset = minVal;
amplitude = maxVal - minVal;
y = offset + amplitude * 1./(1 + exp(xOffset + (2*x-1)*steepness));


end

