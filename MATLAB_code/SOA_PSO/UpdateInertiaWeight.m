function inertiaWeight = UpdateInertiaWeight(inertiaWeight,decreaseRate,lowerBound)

if inertiaWeight > lowerBound
  inertiaWeight = decreaseRate*inertiaWeight;
end

end