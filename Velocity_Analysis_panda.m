plotting = false;

%% Calculated Velocities
if calculated == false
    for P = first : last
        Velocity = P
        for T = 1:Scene1(P).Trails
            [Scene1(P).Output(T).Velocity, Scene1(P).Output(T).MaxVelocity] = ...
                InputVelocity(Scene1(P).Output(T).Panda, Scene1(P).Input(T).Time, plotting);
        end
        for T = 1:Scene2(P).Trails
            [Scene2(P).Output(T).Velocity, Scene2(P).Output(T).MaxVelocity] = ...
                InputVelocity(Scene2(P).Output(T).Panda, Scene2(P).Input(T).Time, plotting);             
        end
    end
    clear Velocity

    Velocity_1 = [];
    Velocity_2 = [];

    for i = first:last
        Scene1(i).avgVelocityMax = mean([Scene1(i).Output.MaxVelocity], 'omitnan');
        Scene2(i).avgVelocityMax = mean([Scene2(i).Output.MaxVelocity], 'omitnan');
        Velocity_1 = cat(1,Velocity_1,Scene1(i).Output.MaxVelocity);
        Velocity_2 = cat(1,Velocity_2,Scene2(i).Output.MaxVelocity);
    end
end

%%Plotting
figure(20); clf(20); 
Plotting(Velocity_1, Velocity_2, [Scene1.avgVelocityMax], [Scene2.avgVelocityMax], conditions, 'Max Robot Velocity', '[m/s]');

clc 
N_1_2 = [sum([Scene1.Trails]),sum([Scene2.Trails])]
medAllVelocity_1_2 = [median(Velocity_1, 'omitnan'), median(Velocity_2, 'omitnan')]
varAllVelocity_1_2 = [var(Velocity_1), var(Velocity_2)]

[H0, p,ci,stats] = ttest([Scene1.avgVelocityMax], [Scene2.avgVelocityMax]);

subplot(223); text(max([Scene1.avgVelocityMax])*0.9,min([Scene2.avgVelocityMax]),append('t(25) = ',sprintf('%.6f',stats.tstat)));
subplot(223); text(max([Scene1.avgVelocityMax])*0.9,min([Scene2.avgVelocityMax])*0.8,append('p = ',sprintf('%.6f',p)));

% [h11, p11] = ttest([Scene1.avgVelocity], avgAllVelocity_1_2(1))
% [h12, p12] = ttest([Scene1.avgVelocity], avgAllVelocity_1_2(2))
% [h21, p21] = ttest([Scene2.avgVelocity], avgAllVelocity_1_2(1))
% [h22, p22] = ttest([Scene2.avgVelocity], avgAllVelocity_1_2(2))

%% Fontsize
set(findall(gcf,'-property','FontSize'),'FontSize',fontsize)
