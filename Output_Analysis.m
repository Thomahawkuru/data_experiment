plotting = false;

%% Determine all paths [m]
for  i = first:last
    Path = i
    
    Scene1(i).Output = OutputPaths(Scene1(i));
    Scene2(i).Output = OutputPaths(Scene2(i));
end

if plotting == true
    figure(7); clf(7); 
    C = 0;
    S = 0.5;
    for P = first : last
        Plot = P
        for i = 1:Scene1(P).Trails
            subplot(7,4,P-pilot); plot(Scene1(P).Output(i).Panda(:,1),Scene1(P).Output(i).Panda(:,3)); 
            hold on;
        end
        for i = 1:Scene2(P).Trails
            subplot(7,4,P-pilot); plot(Scene2(P).Output(i).Panda(:,1)+S,Scene2(P).Output(i).Panda(:,3)+C); 
            hold on; title(join(['Output C1 and C2, Participant: ',int2str(P)])); xlabel('Horizontal distance [m]'); ylabel('Depth distance [m]');
        end 
    end  
end

%% plotting tracking issues
% figure(8); clf(8); 
% P = 16
% T = 81
% 
% subplot(211); plot(Scene1(P).Output(T).Panda(:,1),Scene1(P).Output(T).Panda(:,3)); 
% hold on; title('Condition 1 - Participant 5)'); xlabel('Horizontal distance [m]'); ylabel('Depth distance [m]');
% subplot(212); plot(Scene2(P).Output(T).Panda(:,1),Scene2(P).Output(T).Panda(:,3));
% hold on; title('Condition 2 - Participant 5)'); xlabel('Horizontal distance [m]'); ylabel('Depth distance [m]');

%% Determine Path Deviations
for P = first : last
Error = P
    for T = 1:Scene1(P).Trails
        [Scene1(P).Output(T).Error, Scene1(P).Output(T).Variance] = OutputError(Scene1(P).Output(T).Panda);
    end
    for T = 1:Scene2(P).Trails
        [Scene2(P).Output(T).Error, Scene2(P).Output(T).Variance] = OutputError(Scene2(P).Output(T).Panda);
    end 
end

%% Mean Max Path Deviaton
deviation_1 = [];
deviation_2 = [];

for i = first:last
    Scene1(i).avgDeviation = mean([Scene1(i).Output.Error], 'omitnan');
    Scene2(i).avgDeviation = mean([Scene2(i).Output.Error], 'omitnan');
    deviation_1 = cat(1,deviation_1,Scene1(i).Output.Error);
    deviation_2 = cat(1,deviation_2,Scene2(i).Output.Error);
end

figure(9); clf(9); 
subplot(3,2,[1 2]); plot(deviation_1); xlabel('Trails [n]'); ylabel('Max deviation [m]'); hold on
subplot(3,2,[1 2]); plot(deviation_2); legend('Deviation_1','Deviation_2'); hold on
grid(gca,'minor'); ylim([0 0.1]);

group = [repmat({'First'}, 1, length(deviation_1)), repmat({'Second'}, 1, length(deviation_2))];
subplot(3,2,[3 4]); boxplot([deviation_1;deviation_2],group,'whisker', 3,'Notch','on');
xlabel('Condition'); ylabel('Max deviation_2 [s]');
ylim([0 0.1]); grid(gca,'minor')

%Avg Max Path Deviation Per Participant
for i = 1 : last-pilot
    prelabels(i) = i + pilot;
end

labels = string(prelabels);
 
subplot(3,2,5); plot([Scene1.avgDeviation],[Scene2.avgDeviation],'x');
text([Scene1.avgDeviation],[Scene2.avgDeviation],labels,'FontSize',8);
hold on; plot([0 1.2*max([Scene1.avgDeviation])],[0 1.2*max([Scene1.avgDeviation])])
title('Within subject correlation for each participant');
xlabel('Average max deviation Condition 1 [s]'); ylabel('Average max deviation Condtion 2 [s]');

subplot(3,2,6); boxplot([Scene1.avgDeviation;Scene2.avgDeviation]','whisker',10)
title('Variation of average max deviation between participants[s]');
xlabel('Time [s]'); ylabel('Condtions');
grid(gca,'minor')

%% Paired_Samples T-Test 
clc 
N_1_2 = sum([Scene1.Trails])
avgAllDeviation_1_2 = [mean(deviation_1, 'omitnan'), mean(deviation_2, 'omitnan')]
varAllDeviation_1_2 = [var(deviation_1), var(deviation_2)]

[h0, p0] = ttest([Scene1.avgDeviation], [Scene2.avgDeviation])

% [h11, p11] = ttest([Scene1.avgDeviation], avgAllDeviation_1_2(1))
% [h12, p12] = ttest([Scene1.avgDeviation], avgAllDeviation_1_2(2))
% [h21, p21] = ttest([Scene2.avgDeviation], avgAllDeviation_1_2(1))
% [h22, p22] = ttest([Scene2.avgDeviation], avgAllDeviation_1_2(2))
