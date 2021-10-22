plotting = false;

%% Calculated reaction times
if calculated == false
    for P = first : last
        Reaction = P
        for T = 1:Scene1(P).Trails
            [Scene1(P).Time(T).Reaction] = ReactionTime(Scene1(P).Input(T).Jerk, Scene1(P).Input(T).Interval, plotting);
        end
        for T = 1:Scene2(P).Trails
            [Scene2(P).Time(T).Reaction] = ReactionTime(Scene2(P).Input(T).Jerk, Scene2(P).Input(T).Interval, plotting);             
        end
    end
    clear Reaction

    Reaction_1 = [];
    Reaction_2 = [];

    for i = first:last
        Scene1(i).avgReaction = mean([Scene1(i).Time.Reaction], 'omitnan');
        Scene2(i).avgReaction = mean([Scene2(i).Time.Reaction], 'omitnan');
        Reaction_1 = cat(1,Reaction_1,Scene1(i).Time.Reaction);
        Reaction_2 = cat(1,Reaction_2,Scene2(i).Time.Reaction);
    end
end

%% Plotting
figure(11); clf(11); 
Plotting(Reaction_1, Reaction_2, [Scene1.avgReaction], [Scene2.avgReaction], conditions, 'Reaction Time', '[s]');

clc 
N_1_2 = [sum([Scene1.Trails]),sum([Scene2.Trails])]
avgAllReaction_1_2 = [mean(Reaction_1, 'omitnan'), mean(Reaction_2, 'omitnan')]
varAllReaction_1_2 = [var(Reaction_1, 'omitnan'), var(Reaction_2, 'omitnan')]

[H0, p,ci,stats] = ttest([Scene1.avgReaction], [Scene2.avgReaction]);

subplot(223); text(max([Scene1.avgReaction])*0.9,min([Scene2.avgReaction])*0.9,append('t(25) = ',sprintf('%.6f',stats.tstat)));
subplot(223); text(max([Scene1.avgReaction])*0.9,min([Scene2.avgReaction])*0.8,append('p = ',sprintf('%.6f',p)));

%% Fontsize
set(findall(gcf,'-property','FontSize'),'FontSize',fontsize)