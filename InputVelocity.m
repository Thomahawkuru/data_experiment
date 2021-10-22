function [vf, maxvel] = InputVelocity(input,time,plotting)
    plotting = false;
    
    %timestamps
    time = time - time(1);
    dt = gradient(time);
        
    %input coordinates
    x  = input(:,1);
    y  = input(:,3);
    
    %differentation coordinates and smooth result
    dx = gradient(x)./dt;
    dxf = smooth(time,dx,20,'loess');
    dy = gradient(y)./dt;
    dyf = smooth(time,dy,20,'loess');
    
    %calculate velocity with Pythagoras Theorem
    v   = sqrt(dx.^2 + dy.^2);
    vf  = sqrt(dxf.^2 + dyf.^2);
    
    %find peaks and max peak value
    maxvel  = max(findpeaks(vf));
    if isempty(maxvel)
        maxvel = max(vf);
    end
    
    if plotting == true
        figure(101); clf(101); plot(time,v);
        hold on; plot(time,vf,'LineWidth',3);
        title 'Velocity profiles (Raw vs smooth)'
        legend('raw','smooth');
        xlabel 'time [s]'; ylabel 'velocity [m/s]';
        pause
    end

