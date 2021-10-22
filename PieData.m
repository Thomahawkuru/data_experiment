function [percentage, labels] = PieChart(input)
    
    labels = unique(input);
     
    for i = 1:length(labels)
        try
            percentage(i) = sum(input(:) == labels(i));
        catch
            percentage(i) = sum(strcmpi(input(:),labels(i)));
        end        
    end     
end