function [deviation] = PathDeviation(input,plotting)
    input = smoothdata(input(:,[1 3]),'sgolay');
    s = input(1,:); %start
    f = input(end, :); %finish
    N = length(input);
    
    %find discrete line element lengths
    for i = 2:length(input)
        dx(i) = input(i,1)- input(i-1,1);
        dy(i) = input(i,2)- input(i-1,2);
    end
    dLen = sqrt(dx.^2 + dy.^2);
    
    %find total length as running sum over dLen
    Len = [0];
    for i = 2:length(dLen)
        Len(i) = Len(i-1) + dLen(i);
    end

    %calculate distance to optimal path per data point
    for i = 1:N
        pi  = input(i,:);
        distance(i) = abs(real(sqrt(norm(pi-s)^2 - ...
            dot(pi-s,f-s)^2/norm(f-s)^2)));
    end
    
    %trapezoidal numerical integration to find deviation area
    deviation = trapz(Len,distance)*10000;
    
    % plot examples
    if plotting == true
        figure(101); clf(101); 
        subplot(121); plot(input(:,1),input(:,2)); 
        title('example of input path vs optimal path')
        hold on; plot([s(1),f(1)],[s(2),f(2)])
        legend('path taken', 'optimal path')
        xlabel 'x [m]'; ylabel 'y [m]'
        
        subplot(122); plot(Len,distance);
        title('Distance to optimal path over length')
        xlabel 'x [m]'; ylabel 'y [m]'
    end
    

