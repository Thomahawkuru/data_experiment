%% avg mean time
times_1 = [];
times_2 = [];

for i = first:last
    Scene1(i).avgTime = mean([Scene1(i).Time.Completion], 'omitnan');
    Scene2(i).avgTime = mean([Scene2(i).Time.Completion], 'omitnan');
    Scene1(i).varTime = var([Scene1(i).Time.Completion], 'omitnan');
    Scene2(i).varTime = var([Scene2(i).Time.Completion], 'omitnan');
    times_1 = cat(1,times_1,Scene1(i).Time.Completion);
    times_2 = cat(1,times_2,Scene2(i).Time.Completion);
end

%% Plotting
figure(4); clf(4);
Plotting(times_1, times_2, [Scene1.avgTime], [Scene2.avgTime], conditions , 'Completion Time', '[s]');

clc
N_1_2 = [sum([Scene1.Trails]), sum([Scene2.Trails])]
medAllTime_1_2 = [median(times_1, 'omitnan'), median(times_2, 'omitnan')]
varAllTime_1_2 = [var(times_1, 'omitnan'), var(times_2, 'omitnan')]

[H0, p,ci,stats] = ttest([Scene1.avgTime], [Scene2.avgTime]);

subplot(223); text(max([Scene1.avgTime])*0.9,min([Scene2.avgTime])*0.9,append('t(25) = ',sprintf('%.6f',stats.tstat)));
subplot(223); text(max([Scene1.avgTime])*0.9,min([Scene2.avgTime])*0.8,append('p = ',sprintf('%.6f',p)));


% [h11, p11] = ttest([Scene1.avgTime], avgAllTime_1_2(1))
% [h12, p12] = ttest([Scene1.avgTime], avgAllTime_1_2(2))
% [h21, p21] = ttest([Scene2.avgTime], avgAllTime_1_2(1))
% [h22, p22] = ttest([Scene2.avgTime], avgAllTime_1_2(2))

%% Fontsize
set(findall(gcf,'-property','FontSize'),'FontSize',fontsize)