plotting = false;
all = false;

%% Error Rate: Time*1.5
figure(10); clf(10); hold on;
Error_1 = [];
Error_2 = [];

if calculated == false
    for P = first:last
        Error = P

        for T = 1:Scene1(P).Trails
            [Scene1(P).Input(T).Error] = ErrorRate([Scene1(P).Input(T).Path], Scene1(P).Input(T).Time, plotting ,all);
        end
        for T = 1:Scene2(P).Trails
            [Scene2(P).Input(T).Error] = ErrorRate([Scene2(P).Input(T).Path], Scene2(P).Input(T).Time, plotting ,all);
        end
        Error_1 = cat(1,Error_1,Scene1(P).Input.Error);
        Error_2 = cat(1,Error_2,Scene2(P).Input.Error);

        Scene1(P).Error.locs = find([Scene1(P).Input.Error] == true);
        Scene2(P).Error.locs = find([Scene2(P).Input.Error] == true);

        Scene1(P).Error.pks = [Scene1(P).Time(Scene1(P).Error.locs).Completion];
        Scene2(P).Error.pks = [Scene2(P).Time(Scene2(P).Error.locs).Completion];

        Scene1(P).Errors = sum([Scene1(P).Input.Error]);
        Scene2(P).Errors = sum([Scene2(P).Input.Error]);

        Scene1(P).ErrorRate = 100*Scene1(P).Errors / Scene1(P).Trails;
        Scene2(P).ErrorRate = 100*Scene2(P).Errors / Scene2(P).Trails;    
    end
end

for P = first:last
    figure(10);
    subplot(3,2,[1 2]); plot([Scene1(P).Time.Completion],'color',[0,0,0]+0.7); 
    hold on; plot(Scene1(P).Error.locs, Scene1(P).Error.pks, 'or')
    xlabel('Targets [n]'); ylabel('Completion time [s]');
    title('Detected Errors over all targets: ' + conditions(1));
    
    figure(10);
    subplot(3,2,[3 4]); plot([Scene2(P).Time.Completion], 'color',[0,0,0]+0.7); 
    hold on; plot(Scene2(P).Error.locs, Scene2(P).Error.pks, 'or')
    title('Detected Errors over all Targets: ' + conditions(2));
    xlabel('Targets [n]'); ylabel('Completion time [s]');
end

%% Avg Errors Per Participant
for P = 1 : last-pilot
    prelabels(P) = P + pilot;
end

labels = string(prelabels);

subplot(3,2,5); plot([Scene1.ErrorRate],[Scene2.ErrorRate],'x'); 
hold on;    plot(fit([Scene1.ErrorRate]',[Scene2.ErrorRate]','poly1'));
% text([Scene1.ErrorRate],[Scene2.ErrorRate],labels,'FontSize',8);
hold on; plot([-1 1.2*max([Scene1.ErrorRate])],[-1 1.2*max([Scene1.ErrorRate])])
title('Mean Error Rate correlation [n=26]');
xlabel('Average ' + conditions(1) + ' Error Rate [%]'); ylabel('Average ' + conditions(2) + ' Error rate [%]');
legend('Participants','LLSQ fit','x = y','Location','northwest');

group1(1:length([Scene1.ErrorRate])) = {'Separated'};
group2(1:length([Scene2.ErrorRate])) = {'Situated'};
group = [group1,group2];
cg = categorical(group);

subplot(3,2,6); boxchart(cg,[[Scene1.ErrorRate],[Scene2.ErrorRate]]) %, 'GroupByColor', group)
title('Mean Error Rate per condition [n=26]');
grid(gca,'minor'); ylabel('Error Rate [%]');
hold on; plot([mean([Scene1.ErrorRate]),mean([Scene2.ErrorRate])],'bo');
hold on; plot([mean([Scene1.ErrorRate]),mean([Scene2.ErrorRate])],'b');

clc 

N_1_2 = [sum([Scene1.Trails]),sum([Scene2.Trails])]
N_errros_1_2 = [sum([Scene1.Errors]),sum([Scene2.Errors])]
medErrorRate_1_2 = [median([Scene1.ErrorRate]), median([Scene2.ErrorRate])]
varErrorRate_1_2 = [var([Scene1.ErrorRate]), var([Scene2.ErrorRate])]

[H0, p,ci,stats] = ttest([Scene1.ErrorRate], [Scene2.ErrorRate]);

subplot(325); text(max([Scene1.ErrorRate])*0.8,min([Scene2.ErrorRate])+1,append('t(25) = ',sprintf('%.6f',stats.tstat)));
subplot(325); text(max([Scene1.ErrorRate])*0.8,min([Scene2.ErrorRate])-1,append('p = ',sprintf('%.6f',p)));

%% Fontsize
set(findall(gcf,'-property','FontSize'),'FontSize',fontsize)