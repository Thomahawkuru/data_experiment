plotting = false;

%% Calculate Jerk
if calculated == false
    
    for P = first : last
        Jerk = P
        for T = 1:Scene1(P).Trails
            [Scene1(P).Input(T).Jerk, Scene1(P).Input(T).MaxJerk] = ...
                InputJerk(Scene1(P).Input(T).Acceleration, Scene1(P).Input(T).Time, plotting);
        end
        for T = 1:Scene2(P).Trails
            [Scene2(P).Input(T).Jerk, Scene2(P).Input(T).MaxJerk] = ...
                InputJerk(Scene2(P).Input(T).Acceleration, Scene2(P).Input(T).Time, plotting);             
        end
    end
    clear Jerk

    Jerk_1 = [];
    Jerk_2 = [];

    for i = first:last
        Scene1(i).avgJerkMax = mean([Scene1(i).Input.MaxJerk], 'omitnan');
        Scene2(i).avgJerkMax = mean([Scene2(i).Input.MaxJerk], 'omitnan');
        Jerk_1 = cat(1,Jerk_1,Scene1(i).Input.MaxJerk);
        Jerk_2 = cat(1,Jerk_2,Scene2(i).Input.MaxJerk);
    end
end

%% Plotting
figure(9); clf(9); 
Plotting(Jerk_1, Jerk_2, [Scene1.avgJerkMax], [Scene2.avgJerkMax], conditions, 'Max Jerk', '[m/s^3]');

clc 
N_1_2 = [sum([Scene1.Trails]),sum([Scene2.Trails])]
medAllJerk_1_2 = [median(Jerk_1, 'omitnan'), median(Jerk_2, 'omitnan')]
varAllJerk_1_2 = [var(Jerk_1), var(Jerk_2)]

[H0, p,ci,stats] = ttest([Scene1.avgJerkMax], [Scene2.avgJerkMax]);

subplot(223); text(max([Scene1.avgJerkMax])*0.9,min([Scene2.avgJerkMax])*1.3,append('t(25) = ',sprintf('%.6f',stats.tstat)));
subplot(223); text(max([Scene1.avgJerkMax])*0.9,min([Scene2.avgJerkMax])*0.8,append('p = ',sprintf('%.6f',p)));

%% Fontsize
set(findall(gcf,'-property','FontSize'),'FontSize',fontsize)