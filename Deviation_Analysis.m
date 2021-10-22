plotting = false;
%% Determine Path Deviations
if calculated == false
    for P = first : last
        Deviation = P

        for T = 1:Scene1(P).Trails
            [Scene1(P).Input(T).Error] = ...
                PathDeviation(Scene1(P).Input(T).Path, plotting);
        end
        for T = 1:Scene2(P).Trails
            [Scene2(P).Input(T).Error] = ...
                PathDeviation(Scene2(P).Input(T).Path, plotting);
        end 
    end
    clear Deviation

    deviation_1 = [];
    deviation_2 = [];

    for i = first:last
        Scene1(i).avgDeviation = mean([Scene1(i).Input.Error], 'omitnan');
        Scene2(i).avgDeviation = mean([Scene2(i).Input.Error], 'omitnan');
        deviation_1 = cat(1,deviation_1,Scene1(i).Input.Error);
        deviation_2 = cat(1,deviation_2,Scene2(i).Input.Error);
    end
end

%% plotting
figure(5); clf(5); 
Plotting(deviation_1, deviation_2, [Scene1.avgDeviation], [Scene2.avgDeviation], conditions, 'Path Deviation', '[cm^2]');

%% Paired_Samples T-Test 
clc 
N_1_2 = [sum([Scene1.Trails]), sum([Scene2.Trails])]
medAllDeviation_1_2 = [median(deviation_1, 'omitnan'), median(deviation_2, 'omitnan')]
varAllDeviation_1_2 = [var(deviation_1, 'omitnan'), var(deviation_2, 'omitnan')]

[H0, p,ci,stats] = ttest([Scene1.avgDeviation], [Scene2.avgDeviation]);

subplot(223); text(max([Scene1.avgDeviation])*0.7,min([Scene2.avgDeviation])*1.7,append('t(25) = ',sprintf('%.6f',stats.tstat)));
subplot(223); text(max([Scene1.avgDeviation])*0.7,min([Scene2.avgDeviation])*1.3,append('p = ',sprintf('%.6f',p)));

% [h11, p11] = ttest([Scene1.avgDeviation], avgAllDeviation_1_2(1))
% [h12, p12] = ttest([Scene1.avgDeviation], avgAllDeviation_1_2(2))
% [h21, p21] = ttest([Scene2.avgDeviation], avgAllDeviation_1_2(1))
% [h22, p22] = ttest([Scene2.avgDeviation], avgAllDeviation_1_2(2))

%% Fontsize
set(findall(gcf,'-property','FontSize'),'FontSize',fontsize)