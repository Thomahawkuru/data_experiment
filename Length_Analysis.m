%% Determine Path Lengths
if calculated == false
    for P = first : last
        Length = P
        for T = 1:Scene1(P).Trails
            Scene1(P).Input(T).Length = PathLength(Scene1(P).Input(T).Path);
        end
        for T = 1:Scene2(P).Trails
            Scene2(P).Input(T).Length = PathLength(Scene2(P).Input(T).Path);
        end 
    end
    clear Length

    length_1 = [];
    length_2 = [];

    for i = first:last
        Scene1(i).avgLength = mean([Scene1(i).Input.Length], 'omitnan');
        Scene2(i).avgLength = mean([Scene2(i).Input.Length], 'omitnan');
        length_1 = cat(1,length_1,Scene1(i).Input.Length);
        length_2 = cat(1,length_2,Scene2(i).Input.Length);
    end
end

%% Plotting
figure(6); clf(6); 
Plotting(length_1, length_2, [Scene1.avgLength], [Scene2.avgLength], conditions, 'Path Length', '[m]');

clc 
N_1_2 = sum([Scene1.Trails])
medAllLength_1_2 = [median(length_1, 'omitnan'), median(length_2, 'omitnan')]
varAllLength_1_2 = [var(length_1), var(length_2)]

[H0, p,ci,stats] = ttest([Scene1.avgLength], [Scene2.avgLength]);

subplot(223); text(max([Scene1.avgLength])*0.9,min([Scene2.avgLength])*0.9,append('t(25) = ',sprintf('%.6f',stats.tstat)));
subplot(223); text(max([Scene1.avgLength])*0.9,min([Scene2.avgLength])*0.8,append('p = ',sprintf('%.6f',p)));

% [h11, p11] = ttest([Scene1.avgLength], avgAllLength_1_2(1))
% [h12, p12] = ttest([Scene1.avgLength], avgAllLength_1_2(2))
% [h21, p21] = ttest([Scene2.avgLength], avgAllLength_1_2(1))
% [h22, p22] = ttest([Scene2.avgLength], avgAllLength_1_2(2))

%% Fontsize
set(findall(gcf,'-property','FontSize'),'FontSize',fontsize)