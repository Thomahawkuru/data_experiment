function [T] = ReactionTime(j,interval,plotting)
    %determine timestamps
    for i = 1:length(interval)
        time(i) = sum(interval(1:i));
    end
    
    %calculated snap and smooth
    s   = gradient(j) ./ interval;
    sf  = smooth(time,s,10,'loess');

    %find peaks with specific prominence and height
    [peaksr,locsr] = findpeaks(sf,'MinPeakDistance',5,...
        'MinPeakProminence',0.1*max(sf),'MinPeakHeight',0.1*max(sf));
    
    %find timestamp of the first peak
    if isempty(locsr)
        T = NaN;
    else
        T = time(locsr(1))';
    end

    if plotting == true
        figure(101); clf(101)
        subplot(211);plot(time,j,'LineWidth',3);
        title 'Jerk profile (smooth)';
        xlabel 'time [s]'; ylabel 'jerk m/s^3';

        subplot(212);
        plot(time,s); hold on; plot(time,sf,'LineWidth',3);
        hold on; plot(time(locsr),peaksr,'xb','LineWidth',3);
        title 'Snap profile (raw vs smooth) with peaks';
        legend('raw','smooth');
        xlabel 'time [s]'; ylabel 'snap m/s^4';
        pause
    end