plotting = false;

%% Calculated reaction times
if calculated == false
    for P = first : last
        ReactionPanda = P
        for T = 1:Scene1(P).Trails
            [Scene1(P).Time(T).ReactionPanda] = ReactionTime(Scene1(P).Output(T).Jerk, Scene1(P).Input(T).Interval, plotting);
        end
        for T = 1:Scene2(P).Trails
            [Scene2(P).Time(T).ReactionPanda] = ReactionTime(Scene2(P).Output(T).Jerk, Scene2(P).Input(T).Interval, plotting);             
        end
    end
    clear ReactionPanda

    ReactionPanda_1 = [];
    ReactionPanda_2 = [];

    for i = first:last
        Scene1(i).avgReactionPanda = mean([Scene1(i).Time.ReactionPanda], 'omitnan');
        Scene2(i).avgReactionPanda = mean([Scene2(i).Time.ReactionPanda], 'omitnan');
        ReactionPanda_1 = cat(1,ReactionPanda_1,Scene1(i).Time.ReactionPanda);
        ReactionPanda_2 = cat(1,ReactionPanda_2,Scene2(i).Time.ReactionPanda);
    end
end

%% Plotting
figure(23); clf(23); 
Plotting(ReactionPanda_1, ReactionPanda_2, [Scene1.avgReactionPanda], [Scene2.avgReactionPanda], conditions, 'Robot Reaction Time', '[s]');

clc 
N_1_2 = [sum([Scene1.Trails]),sum([Scene2.Trails])]
avgAllReactionPanda_1_2 = [mean(ReactionPanda_1, 'omitnan'), mean(ReactionPanda_2, 'omitnan')]
varAllReactionPanda_1_2 = [var(ReactionPanda_1, 'omitnan'), var(ReactionPanda_2, 'omitnan')]

[H0, p,ci,stats] = ttest([Scene1.avgReactionPanda], [Scene2.avgReactionPanda]);

subplot(223); text(max([Scene1.avgReactionPanda])*0.9,min([Scene2.avgReactionPanda])*0.9,append('t(25) = ',sprintf('%.6f',stats.tstat)));
subplot(223); text(max([Scene1.avgReactionPanda])*0.9,min([Scene2.avgReactionPanda])*0.8,append('p = ',sprintf('%.6f',p)));

%% Fontsize
set(findall(gcf,'-property','FontSize'),'FontSize',fontsize)