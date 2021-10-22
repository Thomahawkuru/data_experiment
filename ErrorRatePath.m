function [error] = ErrorRatePath(path,interval,plotting)
N = length(path);

q  = [1:N];
qx = [1:0.5:N];

x = interp1(q,path(:,1),qx);
y = interp1(q,path(:,3),qx);

intervaln = interp1(q,interval,qx);

start = [x(1),y(1)];
finish = [x(end),y(end)];


%Optimal Path:
xn = linspace(start(1), finish(1), N*2);
yn = linspace(start(2), finish(2), N*2);

xd = [0, diff(x)] ./ intervaln;
yd = [0, diff(y)] ./ intervaln;
xd = sgolayfilt(xd',3,11);
yd = sgolayfilt(yd',3,11);

v       = smoothdata(sqrt(xd.^2 + yd.^2),'sgolay');
a       = smoothdata([0; diff(v)] ./ intervaln');
jerk    = smoothdata([0; diff(a)] ./ intervaln','sgolay');

f = smoothdata(a,'sgolay');

peaks = findpeaks(f,'MinPeakDistance',15,'MinPeakProminence',0.1);

if plotting == true
    figure(20); clf(20)
    subplot(211); plot(xn,yn);
    hold on; plot(x,y);
    
    subplot(212); plot(a);
    hold on; plot(f,'LineWidth',3);    
end

n = length(peaks);

if n > 2
    error = true;
%      pause
else
    error = false;
end

