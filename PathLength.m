function len = PathLength(input)
    
    %find discrete line element lengths
    for i = 2:length(input)
        dx(i) = input(i,1)- input(i-1,1);
        sy(i) = input(i,3)- input(i-1,3);
    end
    dLen = sqrt(dx.^2 + sy.^2);
    
    %total length
    len = sum(dLen);
