function [af, maxacc] = InputAcceleration(v,time,plotting)  
    %timestamps
    time = time - time(1);
    dt = gradient(time);
    
    %differentiate the velocity and smooth
    a   = gradient(v) ./ dt;
    af  = smooth(time,a);
    
    %find peaks and max peak value for acceleration
    maxacc  = max(findpeaks(af));
    if isempty(maxacc)
        maxacc = max(af);
    end
    
    if plotting == true
        figure(101); clf(101); 
        
        subplot(211); plot(time,v,'LineWidth',3);
        title 'Velocity profile (smooth)'
        xlabel 'time [s]'; ylabel 'velocity [m/s]';
        
        subplot(212); plot(time,a);
        hold on; plot(time,af,'LineWidth',3);
        title 'Acceleration profiles (Raw vs smooth)'
        legend('raw','smooth');
        xlabel 'time [s]'; ylabel 'acceleration [m/s^2]';
        
        pause
    end

