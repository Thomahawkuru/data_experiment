plotting = false;

%% Calculate Acceleration
if calculated == false
    for P = first : last
        Acceleration = P
        for T = 1:Scene1(P).Trails
            [Scene1(P).Output(T).Acceleration, Scene1(P).Output(T).MaxAcceleration] = ...
                InputAcceleration(Scene1(P).Input(T).Velocity, Scene1(P).Input(T).Time, plotting);
        end
        for T = 1:Scene2(P).Trails
            [Scene2(P).Output(T).Acceleration, Scene2(P).Output(T).MaxAcceleration] = ...
                InputAcceleration(Scene2(P).Output(T).Velocity, Scene2(P).Input(T).Time, plotting);             
        end
    end
    clear Acceleration

    Acceleration_1 = [];
    Acceleration_2 = [];

    for i = first:last
        Scene1(i).avgAccelerationMax = mean([Scene1(i).Input.MaxAcceleration], 'omitnan');
        Scene2(i).avgAccelerationMax = mean([Scene2(i).Input.MaxAcceleration], 'omitnan');
        Acceleration_1 = cat(1,Acceleration_1,Scene1(i).Input.MaxAcceleration);
        Acceleration_2 = cat(1,Acceleration_2,Scene2(i).Input.MaxAcceleration);
    end
end

%% Plotting
figure(21); clf(21); 
Plotting(Acceleration_1, Acceleration_2, [Scene1.avgAccelerationMax], [Scene2.avgAccelerationMax], conditions, 'Max Robot Acceleration', '[m/s]');

clc 
N_1_2 = [sum([Scene1.Trails]),sum([Scene2.Trails])]
medAllAcceleration_1_2 = [median(Acceleration_1, 'omitnan'), median(Acceleration_2, 'omitnan')]
varAllAcceleration_1_2 = [var(Acceleration_1), var(Acceleration_2)]

[H0, p,ci,stats] = ttest([Scene1.avgAccelerationMax], [Scene2.avgAccelerationMax]);

subplot(223); text(max([Scene1.avgAccelerationMax])*0.9,min([Scene2.avgAccelerationMax]),append('t(25) = ',sprintf('%.6f',stats.tstat)));
subplot(223); text(max([Scene1.avgAccelerationMax])*0.9,min([Scene2.avgAccelerationMax])*0.8,append('p = ',sprintf('%.6f',p)));

% [h11, p11] = ttest([Scene1.avgAcceleration], avgAllAcceleration_1_2(1))
% [h12, p12] = ttest([Scene1.avgAcceleration], avgAllAcceleration_1_2(2))
% [h21, p21] = ttest([Scene2.avgAcceleration], avgAllAcceleration_1_2(1))
% [h22, p22] = ttest([Scene2.avgAcceleration], avgAllAcceleration_1_2(2))

%% Fontsize
set(findall(gcf,'-property','FontSize'),'FontSize',fontsize)
