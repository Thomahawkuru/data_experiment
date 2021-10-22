%% 1
N = 1596;
n = 0;
i = first;

while n < N
    n = sum([Scene1(first:i).Trails]);
    i = i+1;
end

P = i-1
T = Scene1(P).Trails - (n-N)

%% 2
N = 59;
n = 0;
i = first;

while n < N
    n = sum([Scene2(first:i).Trails]);
    i = i+1;
end

P = i-1
T = Scene2(P).Trails - (n-N)

%% plotting tracking issues
figure(5); clf(5); 
% P = 5;
% T = 28;

subplot(211); plot(Scene1(P).Input(T).Path(:,1),Scene1(P).Input(T).Path(:,3)); 
hold on; title('Condition 1 - Participant 5)'); xlabel('Horizontal distance [m]'); ylabel('Depth distance [m]');
subplot(212); plot(Scene2(P).Input(T).Path(:,1),Scene2(P).Input(T).Path(:,3));
hold on; title('Condition 2 - Participant 5)'); xlabel('Horizontal distance [m]'); ylabel('Depth distance [m]');

 %% plotting Velocity curves
figure(20); clf(20); 
P = 5;
T = 29;
subplot(211); plot(Scene1(P).Input(T).Velocity); 
hold on; title('Condition 1 - Participant 5)'); xlabel('Horizontal distance [m]'); ylabel('Depth distance [m]');
subplot(212); plot(Scene2(P).Input(T).Velocity);
hold on; title('Condition 2 - Participant 5)'); xlabel('Horizontal distance [m]'); ylabel('Depth distance [m]');

 %% plotting Acceleration curves
figure(20); clf(20); 
% P = 28;
% T = 82;
subplot(211); plot(Scene1(P).Input(T).Acceleration); 
hold on; title('Condition 1 - Participant 5)'); xlabel('Acceleration [m/s^2]'); 
subplot(212); plot(Scene2(P).Input(T).Acceleration);
hold on; title('Condition 2 - Participant 5)'); xlabel('Acceleration [m/s^2]');

%% plotting
figure(1); clf(1);
for i = first:last
    Plot = i
    subplot(7,4,i-pilot); plot([Scene1(i).Input.MaxVelocity]);
    hold on; plot([Scene2(i).Input.MaxVelocity]); 
    title(join(['Action Time Participant: ', int2str(i)])); hold on;
    xlabel('Trails [n]'); ylabel('Time [s]'); ylim([0 5]);
    legend('Scene 1', 'Scene 2');
end

%% Histogram Plot Times
figure(20); clf(20);

subplot(121); histogram(times_1.^(2/3),100); ylim([0 250]);
subplot(122); histogram(times_2.^(2/3),100); ylim([0 250]);

%% Error Plots 1
P = 12;
T = 29; 

plotting = true;
all = true;

ErrorRate([Scene1(P).Input(T).Path],Scene1(P).Input(T).Time,plotting,all)

%% Error Plots 2
P = 12;
T = 64; 
plotting = true;
all = true;

ErrorRate([Scene2(P).Input(T).Path],Scene2(P).Input(T).Time,plotting,all)

