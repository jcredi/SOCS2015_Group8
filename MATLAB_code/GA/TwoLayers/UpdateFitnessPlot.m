function UpdateFitnessPlot(plotHandle, iGeneration, newFitnessValue)

    xData = get(plotHandle,'XData');
    yData = get(plotHandle,'YData');
    xData(end+1) = iGeneration;
    yData(end+1) = newFitnessValue;
    set(plotHandle,'XData',xData,'YData',yData);
    
    drawnow;
end