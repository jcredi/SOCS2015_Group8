function newValue = LimitChange(newValue,oldValue,allowedRelativeChange)
%LIMITCHANGE Summary of this function goes here
%   Detailed explanation goes here

% Special case:
if (oldValue == 0 && newValue ~= 0)
    newValue = newValue/abs(newValue);
    return
end

absoluteChange = newValue - oldValue;

relativeChange = abs((absoluteChange)/oldValue);

if relativeChange > allowedRelativeChange
    absoluteChange = absoluteChange * (allowedRelativeChange/relativeChange);
end

newValue = oldValue + absoluteChange;
end

