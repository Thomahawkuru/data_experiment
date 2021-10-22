function [error] = ErrorRateVelocity(v,plotting)

v = [min(v), v(10:end), min(v)];

[peaks,locs] = findpeaks(v,'MinPeakDistance',10,'MinPeakProminence',0.05);

if plotting == true
    figure(20);clf(20);
    plot(v)
%     hold on; plot(f1,'LineWidth',2)
%     hold on; plot(f)
    hold on; plot(locs,peaks,'ob','LineWidth',6)
end


n = length(peaks);

if n > 2
    error = true;
%     pause
else
    error = false;
end

