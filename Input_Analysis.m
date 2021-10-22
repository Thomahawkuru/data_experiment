

%% plotting tracking issues
figure(5); clf(5); 
P = 25;
T = 23;

subplot(211); plot(Scene1(P).Input(T).Path(:,1),Scene1(P).Input(T).Path(:,3)); 
hold on; title('Condition 1 - Participant 5)'); xlabel('Horizontal distance [m]'); ylabel('Depth distance [m]');
subplot(212); plot(Scene2(P).Input(T).Path(:,1),Scene2(P).Input(T).Path(:,3));
hold on; title('Condition 2 - Participant 5)'); xlabel('Horizontal distance [m]'); ylabel('Depth distance [m]');

