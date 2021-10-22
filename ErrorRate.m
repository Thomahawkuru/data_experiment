function [error] = ErrorRate(input,time,plotting,all)
    %timestamps
    time = time - time(1);
    dt = gradient(time);
    
    %input coordinates
    x  = input(:,1);
    y  = input(:,3);
    
    %calculated velocities and smooth the result
    dx = gradient(x)./dt;
    dxf = smooth(time,dx,15,'loess');
    dxf = smooth(time,dxf,15,'sgolay');
    dy = gradient(y)./dt;
    dyf = smooth(time,dy,15,'loess');
    dyf = smooth(time,dyf,15,'sgolay');
    
    v   = sqrt(dx.^2 + dy.^2);
    vf  = sqrt(dxf.^2 + dyf.^2);
    
    %calcualated acceleration and jerk and smooth results
    a   = gradient(vf) ./ dt;
    af  = smooth(time,a);
    j   = gradient(af) ./ dt;
    jf  = smooth(time,j);
    
    %find peaks in profile for velocity, acceleration  and jerk
    %only peaks with certain prominence and height are counted
    [peaksv,locsv] = findpeaks(vf,'MinPeakDistance',5,...
        'MinPeakProminence',0.1*max(vf),'MinPeakHeight',0.1*max(vf));
    [peaksa,locsa] = findpeaks(af,'MinPeakDistance',5,...
        'MinPeakProminence',0.1*max(af),'MinPeakHeight',0.1*max(af));
    [peaksj,locsj] = findpeaks(jf,'MinPeakDistance',5,...
        'MinPeakProminence',0.1*max(jf),'MinPeakHeight',0.1*max(jf));
    
    %count peaks and run error detection
    nj = length(peaksj);
    nv = length(peaksv);
    na = length(peaksa);
    
    if (nv>2 || na>2) && nj>2 && nv>1 && na>1
        error = 1;
        detect = true;
    else
        error = 0;
        detect = false;
    end

    %plot data
    if plotting == true && (detect == true || all == true)
        plotdata(x,y,v,vf,a,af,j,jf,locsj,locsv,locsa,time);
        if detect == true
            pause
        end
    end
end

function plotdata(x,y,v,vf,a,af,j,jf,locsj,locsv,locsa,time)
    figure(101); clf(101) 
    subplot(411); plot(x,y); title('Path');
    xlabel 'x [m]'; ylabel 'y [m]';
    subplot(412); plot(time, v); title('Velocity');
    hold on; plot(time, vf,'LineWidth',2);
    hold on; hold on; plot(time(locsv), vf(locsv),'xb','LineWidth',5)
    legend('raw','smooth'); xlabel 'time [s]'; ylabel 'velocity [m/s]'
    subplot(413);plot(time, a); title('Acceleration');
    hold on;  plot(time, af,'LineWidth',2);
    hold on; plot(time(locsa),af(locsa),'xb','LineWidth',5)
    legend('raw','smooth'); xlabel 'time [s]'; ylabel 'acceleration [m/s^2]'
    subplot(414); plot(time, j); title('Jerk');
    hold on; plot(time, jf,'LineWidth',2);
    hold on; plot(time(locsj), jf(locsj),'xb','LineWidth',5)
    legend('raw','smooth'); xlabel 'time [s]'; ylabel 'jerk [m/s^3]'
end
