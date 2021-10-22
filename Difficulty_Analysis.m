if calculated == false
    for i = first:last
        level11 = [];
        level12 = [];
        level13 = [];
        level21 = [];
        level22 = [];
        level23 = [];

        %Find which spawns belong to which level
        for j = 1:length([Scene1(i).Spawn.Difficulty])
            if Scene1(i).Spawn(j).Difficulty == 1
                level11 = cat(1,level11,j);
            elseif Scene1(i).Spawn(j).Difficulty == 2
                level12 = cat(1,level12,j);
            elseif Scene1(i).Spawn(j).Difficulty == 3
                level13 = cat(1,level13,j);
            end        
        end

        for j = 1:length([Scene2(i).Spawn.Difficulty])
            if Scene2(i).Spawn(j).Difficulty == 1
                level21 = cat(1,level21,j);
            elseif Scene2(i).Spawn(j).Difficulty == 2
                level22 = cat(1,level22,j);
            elseif Scene2(i).Spawn(j).Difficulty == 3
                level23 = cat(1,level23,j);
            end        
        end

        %Determine Data per participant per level
        Difficulty1(i).completion = [mean([Scene1(i).Time(level11).Completion]), ...
                                     mean([Scene1(i).Time(level12).Completion]), ...
                                     mean([Scene1(i).Time(level13).Completion])];                                    
        Difficulty2(i).completion = [mean([Scene2(i).Time(level21).Completion]), ...
                                     mean([Scene2(i).Time(level22).Completion]), ...
                                     mean([Scene2(i).Time(level23).Completion])];
                                 
        Difficulty1(i).pathlength = [mean([Scene1(i).Input(level11).Length]), ...
                                     mean([Scene1(i).Input(level12).Length]), ...
                                     mean([Scene1(i).Input(level13).Length])];                                     
        Difficulty2(i).pathlength = [mean([Scene2(i).Input(level21).Length]), ...
                                     mean([Scene2(i).Input(level22).Length]), ...
                                     mean([Scene2(i).Input(level23).Length])];
                                 
        Difficulty1(i).velocity   = [mean([Scene1(i).Input(level11).MaxVelocity]), ...
                                     mean([Scene1(i).Input(level12).MaxVelocity]), ...
                                     mean([Scene1(i).Input(level13).MaxVelocity])];                                     
        Difficulty2(i).velocity   = [mean([Scene2(i).Input(level21).MaxVelocity]), ...
                                     mean([Scene2(i).Input(level22).MaxVelocity]), ...
                                     mean([Scene2(i).Input(level23).MaxVelocity])];
                                 
%         Difficulty1(i).acceleration = [mean([Scene1(i).Input(level11).MaxAcceleration]), ...
%                                        mean([Scene1(i).Input(level12).MaxAcceleration]), ...
%                                        mean([Scene1(i).Input(level13).MaxAcceleration])];                                     
%         Difficulty2(i).acceleration = [mean([Scene2(i).Input(level21).MaxAcceleration]), ...
%                                        mean([Scene2(i).Input(level22).MaxAcceleration]), ...
%                                        mean([Scene2(i).Input(level23).MaxAcceleration])];
%                                  
%         Difficulty1(i).jerk         = [mean([Scene1(i).Input(level11).MaxJerk]), ...
%                                        mean([Scene1(i).Input(level12).MaxJerk]), ...
%                                        mean([Scene1(i).Input(level13).MaxJerk])];                                     
%         Difficulty2(i).jerk         = [mean([Scene2(i).Input(level21).MaxJerk]), ...
%                                        mean([Scene2(i).Input(level22).MaxJerk]), ...
%                                        mean([Scene2(i).Input(level23).MaxJerk])];
                                 
        Difficulty1(i).errorrate  = [mean([Scene1(i).Input(level11).Error]), ...
                                     mean([Scene1(i).Input(level12).Error]), ...
                                     mean([Scene1(i).Input(level13).Error])] * 100;                                     
        Difficulty2(i).errorrate  = [mean([Scene2(i).Input(level21).Error]), ...
                                     mean([Scene2(i).Input(level22).Error]), ...
                                     mean([Scene2(i).Input(level23).Error])] * 100;
    end
        
%     Difficulty1.completion = cat(1,Difficulty1.level);
%     Difficulty1.completion = cat(1,cat(1,Difficulty1.completion));

end

%% plotting and Ttest
figure(12); clf(12);
subplt = 0;

titles = {'Completion Time',...
          'Path Length',...
          'Maximum Velocity',...
          'Errorrate',};

units = {'Time [s]', 'Length [m]', 'Velocity [m/s]', 'Error rate [%]' };   

fn = {'completion', 'pathlength', 'velocity', 'errorrate'};

for i = 1:numel(fn)
    subplt = subplt +1;
    subplot(2,4,subplt+numel(fn));
    x = 1:3;
    xint = linspace(1,3,50)';
    data1 = cat(1,Difficulty1.(fn{i}));
    data2 = cat(1,Difficulty2.(fn{i}));
    
    y1 = mean(data1);
    y2 = mean(data2);
    difficulty_difference(i,:) = abs(y1-y2);
    
    spl1 = pchip(x,y1);
    spl2 = pchip(x,y2);
    spl3 = pchip(x,difficulty_difference(i,:));
    
    %ttest
    [H, P_difficulty(i,1)] = ttest2(data1(:,1), data2(:,1));
    [H, P_difficulty(i,2)] = ttest2(data1(:,2), data2(:,2));
    [H, P_difficulty(i,3)] = ttest2(data1(:,3), data2(:,3));
    
    plot(x,difficulty_difference(i,:),'ko'); hold on; 
    title('Difference in '+string(titles(i))); 
    xlim([0 4]); ylim([0.8*min(difficulty_difference(i,:)) 1.2*max(difficulty_difference(i,:))]);
    ylabel(units(i)); xlabel('Difficulty level');
    set(gca,'xticklabel',{'','1','2','3',''})

    data.data = [data1(:,1); data1(:,2); data1(:,3); ...
                 data2(:,1); data2(:,2); data2(:,3)];

    n = length(data1);
    data.x = cell(1,n*6);
    data.x(1:n)       = {'Level 1'};
    data.x(n+1:n*2)   = {'Level 2'};
    data.x(n*2+1:n*3) = {'Level 3'};  
    data.x(n*3+1:n*4) = {'Level 1'};
    data.x(n*4+1:n*5) = {'Level 2'};
    data.x(n*5+1:n*6) = {'Level 3'};
    
    level_cat   = categorical(data.x);
    
    data.g(1:n*3)     = {'Separated'};
    data.g(n*3+1:n*6) = {'Situated'};
    
    subplot(2,4,subplt);
    boxchart(level_cat,data.data, 'GroupByColor', data.g);
    title(string(titles(i))+' per level');
    ylabel(units(i));
    clear('data')
end

l = legend;
newPosition = [0.05 0.5 0.05 0.05];
newUnits = 'normalized';
set(l,'Position', newPosition,'Units', newUnits);

%% Fontsize
% set(findall(gcf,'-property','FontSize'),'FontSize',fontsize)