function [deviation, variance] = OutputError(input)
input = input(:,[1 2]);
start = input(1,:);
finish = input(end, :);
N = length(input);

%Optimal Path:
x = linspace(start(1), finish(1), N);
y = linspace(start(2), finish(2), N);

% figure(7); plot(x,y,'.');
% hold on; plot(input(:,1), input(:,2),'.');

%Maximum Deviation Error
for i = 1:N
    pi  = input(i,:);
    p0 = start;
    p = finish;
    distance(i) = sqrt(norm(pi-p0)^2 - dot(pi-p0,p-p0)^2/norm(p-p0)^2);
end

deviation = max(distance)';
variance  = var(distance);



