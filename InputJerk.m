function [jf, maxjerk] = InputJerk(a,time,plotting)   
    %timestamps
    time = time - time(1);
    dt = gradient(time);
    
    %differentiate the acceleration and smooth
    j   = gradient(a) ./ dt;
    jf  = smooth(time,j);
    
    %find peaks and max peak value for jerk
    maxjerk = max(findpeaks(jf));
    if isempty(maxjerk)
        maxjerk = max(jf);
    end
    
    if plotting == true
        figure(101); clf(101); 
        
        subplot(211); plot(time,a,'LineWidth',3);
        title 'Acceleration profile (smooth)'
        xlabel 'time [s]'; ylabel 'acceleration [m/s^2]';
        
        subplot(212); plot(time,j);
        hold on; plot(time,jf,'LineWidth',3);
        title 'Jerk profiles (Raw vs smooth)'
        legend('raw','smooth');
        xlabel 'time [s]'; ylabel 'jerk [m/s^3]';
        
        pause
    end
    
