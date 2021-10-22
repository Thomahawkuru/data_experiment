function Plotting(data1,data2,avg1,avg2,conditions,name,unit)

    name = convertCharsToStrings(name);
    unit = convertCharsToStrings(unit);

    subplot(2,2,[1 2]); plot(data1); xlabel('Targets [n]'); ylabel(name + ' ' + unit); 
    title(name + ' for all targets')
    hold on; subplot(2,2,[1 2]); plot(data2); legend(conditions(1), conditions(2));
    grid(gca,'minor'); ylim([0 max([data1;data2])+0.5]);

    % Avg Times Per Participant
    subplot(2,2,3); plot(avg1,avg2,'x');
    hold on;    plot(fit(avg1',avg2','poly1'));
    % text(avg1,avg2,labels,'FontSize',8); 
    hold on; plot([0.7*min(avg1), 1.2*max(avg1)],[0.7*min(avg1), 1.2*max(avg1)])
    title('Mean ' + name + ' Correlation [n=26]');
    xlabel(conditions(1) + ' ' + name + ' ' + unit); ylabel(conditions(2) + ' ' + name + ' '+ unit);
    legend('Participants','LLSQ fit','x = y','Location','northwest');
    
    group1(1:length(avg1)) = {'Separated'};
    group2(1:length(avg2)) = {'Situated'};
    group = [group1,group2];
    cat = categorical(group);
    
    subplot(2,2,4); boxchart(cat,[avg1,avg2]) %, 'GroupByColor', group)
    title('Mean ' + name + ' per condtion [n=26]');
    grid(gca,'minor'); ylabel(name + ' ' + unit);
    hold on; plot([mean(avg1),mean(avg2)],'bo');
    hold on; plot([mean(avg1),mean(avg2)],'b');
    
    %hold on; plot([mean(avg1),mean(avg2)]'); legend('mean');
%     hold on; text(1,median(avg1),sprintf('%.3f',median(avg1)),...
%         'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',7);
%     hold on; text(2,median(avg2),sprintf('%.3f',median(avg2)),...
%         'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',7);

end