%main script for data pro
%Thomas de Boer 415291 
%Master Thesis TU Delft 2021

clc
close all;
clear;

plotting = false;
loaded = false;
calculated = false;
panda = true;
    
%% Startup
%Defenitions
pilot = 4; %amount of pilot experiments ran
first = 5; %first participant number for actual experiment
last = 30; %last participant

fontsize = 13;
conditions = ["Separated", "Situated"];

Handedness(1:last)  = "R";
Handedness(13)      = "L";
Handedness(22)      = "L";

for i = 1 : last-pilot
    prelabels(i) = i + pilot;
end

labels = string(prelabels);

%% Load Data
if loaded == false
    
    for i = first:last 
        loading = i

        Scene1(i).Experiment    = readtable(append('Data/',int2str(i),'/Scene 1/Experiment.csv'));
        Scene1(i).Gaze          = readtable(append('Data/',int2str(i),'/Scene 1/Gaze.csv'));
        Scene1(i).Hand          = readtable(append('Data/',int2str(i),'/Scene 1/Hand.csv'));
        Scene1(i).HMD           = readtable(append('Data/',int2str(i),'/Scene 1/HMD.csv'));
        Scene1(i).Panda         = readtable(append('Data/',int2str(i),'/Scene 1/Panda.csv'));
        Scene1(i).Handedness    = Handedness(i);
        
        Scene2(i).Experiment    = readtable(append('Data/',int2str(i),'/Scene 2/Experiment.csv'));
        Scene2(i).Gaze          = readtable(append('Data/',int2str(i),'/Scene 2/Gaze.csv'));
        Scene2(i).Hand          = readtable(append('Data/',int2str(i),'/Scene 2/Hand.csv'));
        Scene2(i).HMD           = readtable(append('Data/',int2str(i),'/Scene 2/HMD.csv'));
        Scene2(i).Panda         = readtable(append('Data/',int2str(i),'/Scene 2/Panda.csv'));
        Scene2(i).Handedness    = Handedness(i);
    end
    loaded = true;
end
clear Handedness

%% Determine Completion Times
if calculated == false
    for i = first:last
        Stamps = i
        %Trail Times
        [Scene1(i).Trails, Scene1(i).Time] = TimeStamps(Scene1(i).Experiment);
        [Scene2(i).Trails, Scene2(i).Time] = TimeStamps(Scene2(i).Experiment);

        Scene1(i).Hz = mean(Scene1(i).Experiment.DeltaTime,'omitnan');
        Scene2(i).Hz = mean(Scene2(i).Experiment.DeltaTime,'omitnan');
    end
end

%% Determine Spawns [m]
if calculated == false
    Difficulty_1 = [];
    Difficulty_2 = [];

    for  i = first:last
        Spawn = i

        Scene1(i).Spawn = SpawnLocation(Scene1(i));
        Scene2(i).Spawn = SpawnLocation(Scene2(i));

        Scene1(i).avgDifficulty = mean([Scene1(i).Spawn.Difficulty], 'omitnan');
        Scene2(i).avgDifficulty = mean([Scene2(i).Spawn.Difficulty], 'omitnan');
        Difficulty_1 = cat(1,Difficulty_1,Scene1(i).Spawn.Difficulty);
        Difficulty_2 = cat(1,Difficulty_2,Scene2(i).Spawn.Difficulty);

    end

    N_1_2 = [sum([Scene1.Trails]),sum([Scene2.Trails])]
    avgAllDifficulty_1_2 = [mean(Difficulty_1, 'omitnan'), mean(Difficulty_2, 'omitnan')]
    varAllDifficulty_1_2 = [var(Difficulty_1, 'omitnan'), var(Difficulty_2, 'omitnan')]
end

%% Determine Input Paths [m]
if calculated == false
    for  i = first:last
        Path = i

        Scene1(i).Input = InputPaths(Scene1(i));
        Scene2(i).Input = InputPaths(Scene2(i));

        Scene1(i).Output = OutputPaths(Scene1(i));
        Scene2(i).Output = OutputPaths(Scene2(i));
    end
end

%% plotting Times per participant
if plotting == true
    figure(1); clf(1);
    for i = first:last
        Plot = i
        subplot(7,4,i-pilot); plot([Scene1(i).Time.Completion]);
        hold on; plot([Scene2(i).Time.Completion]); 
        title(join(['Completion Time Participant: ', int2str(i)])); ylim([0 3]); hold on;
        xlabel('Trails [n]'); ylabel('Time [s]');
        legend(conditions(1), conditions(2));
    end
end

%% Plotting Paths per particpant
if plotting == true
    figure(2); clf(2); 
    C = -0.05;
    S = 0.5;
    for P = first : last
        Plot = P
        for i = 1:Scene1(P).Trails
            subplot(7,4,P-pilot); plot(Scene1(P).Input(i).Path(:,1),Scene1(P).Input(i).Path(:,3)); 
            hold on;
        end
        for i = 1:Scene2(P).Trails
            subplot(7,4,P-pilot); plot(Scene2(P).Input(i).Path(:,1)+S,Scene2(P).Input(i).Path(:,3)+C); 
            hold on; title(join(['Input Participant: ',int2str(P-pilot)])); xlabel('Horizontal distance [m]'); ylabel('Depth distance [m]');
        end 
    end  
end

%% Subjective Analysis
Subjective_Analysis

%% Time Analysis
Time_Analysis

%% Path Deviations
Deviation_Analysis

%% Path Length
Length_Analysis

%% Velocity Analysis
Velocity_Analysis

%% Acceleration Analysis
Acceleration_Analysis

%% Velocity Analysis
Jerk_Analysis

%% Error Analysis
Error_Analysis

%% Reaction Analyis
Reaction_Analyis

%% Difficulty Analysis
Difficulty_Analysis

%% Panda movement analysis
if panda == true    
    Velocity_Analysis_panda
    Acceleration_Analysis_panda
    Jerk_Analysis_panda
    Reaction_Analyis_panda
end

%% Results
Results.completion  = [mean([Scene1.avgTime]), std([Scene1.avgTime]),...
                       mean([Scene2.avgTime]), std([Scene2.avgTime])];
Results.reaction    = [mean([Scene1.avgReaction]),std([Scene1.avgReaction]),...
                       mean([Scene2.avgReaction]),std([Scene2.avgReaction])];
Results.errorrate   = [mean([Scene1.ErrorRate]),std([Scene1.ErrorRate]),...
                       mean([Scene2.ErrorRate]),std([Scene2.ErrorRate])];
Results.length      = [mean([Scene1.avgLength]),std([Scene1.avgLength]),...
                       mean([Scene2.avgLength]),std([Scene2.avgLength])];
Results.deviation   = [mean([Scene1.avgDeviation]),std([Scene1.avgDeviation]),...
                       mean([Scene2.avgDeviation]),std([Scene2.avgDeviation])];
Results.velocity    = [mean([Scene1.avgVelocityMax]),std([Scene1.avgVelocityMax]),...
                       mean([Scene2.avgVelocityMax]),std([Scene2.avgVelocityMax])];
Results.acceleration= [mean([Scene1.avgAccelerationMax]),std([Scene1.avgAccelerationMax]),...
                       mean([Scene2.avgAccelerationMax]),std([Scene2.avgAccelerationMax])];
Results.jerk        = [mean([Scene1.avgJerkMax]),std([Scene1.avgJerkMax]),...
                       mean([Scene2.avgJerkMax]),std([Scene2.avgJerkMax])];

Results.percentages.completion   = 100 - 100 * [mean([Scene2.avgTime])/mean([Scene1.avgTime])];
Results.percentages.reaction     = 100 - 100 * [mean([Scene2.avgReaction])/mean([Scene1.avgReaction])];
Results.percentages.errorrate    = 100 - 100 * [mean([Scene2.ErrorRate])/mean([Scene1.ErrorRate])];
Results.percentages.length       = 100 - 100 * [mean([Scene2.avgLength])/mean([Scene1.avgLength])];
Results.percentages.deviation    = 100 - 100 * [mean([Scene2.avgDeviation])/mean([Scene1.avgDeviation])];
Results.percentages.velocity     = 100 - 100 * [mean([Scene2.avgVelocityMax])/mean([Scene1.avgVelocityMax])];
Results.percentages.acceleration = 100 - 100 * [mean([Scene2.avgAccelerationMax])/mean([Scene1.avgAccelerationMax])];
Results.percentages.jerk         = 100 - 100 * [mean([Scene2.avgJerkMax])/mean([Scene1.avgJerkMax])];

Results.difference.completion   = [mean([Scene2.avgTime])-mean([Scene1.avgTime])];
Results.difference.reaction     = [mean([Scene2.avgReaction])-mean([Scene1.avgReaction])];
Results.difference.errorrate    = [mean([Scene2.ErrorRate])-mean([Scene1.ErrorRate])];
Results.difference.length       = [mean([Scene2.avgLength])-mean([Scene1.avgLength])];
Results.difference.deviation    = [mean([Scene2.avgDeviation])-mean([Scene1.avgDeviation])];
Results.difference.velocity     = [mean([Scene2.avgVelocityMax])-mean([Scene1.avgVelocityMax])];
Results.difference.acceleration = [mean([Scene2.avgAccelerationMax])-mean([Scene1.avgAccelerationMax])];
Results.difference.jerk         = [mean([Scene2.avgJerkMax])-mean([Scene1.avgJerkMax])];

%% Boxplot Summary
% Prepare subplots
fig = figure(13); clf(13);

measures = {'Completion Time','Path Deviation','Path Length','Velocity','Acceleration','Jerk','Error Rate','Reaction Time'};

for i = 1:8
    % source figure
    f(i) = figure(3+i);

    % Paste figures on the subplots
    ax(i) = copyobj(f(i).Children(1), fig);
    ax(i).Title.String = measures{i};
    
    subplot(2,4,i,ax(i))
end

set(findall(gcf,'-property','FontSize'),'FontSize',fontsize)

%% Correlation
figure(30); clf(30);
measures = {'Completion','Deviation','Length','Velocity','Acceleration','Jerk','Error','Reaction'};
datatable = [Scene1.avgTime;...
              Scene1.avgDeviation;...
              Scene1.avgLength;...
              Scene1.avgVelocityMax;...
              Scene1.avgAccelerationMax;...
              Scene1.avgJerkMax;...
              Scene1.ErrorRate;...
              Scene1.avgReaction]';
[R,PValue] = corrplot(datatable,'varNames',measures);
title('Correlation Matrix for all measures in the separated condition');
set(findall(gcf,'-property','FontSize'),'FontSize',fontsize)

figure(31); clf(31);
measures = {'Completion','Deviation','Length','Velocity','Acceleration','Jerk','Error','Reaction'};
datatable = [Scene2.avgTime;...
              Scene2.avgDeviation;...
              Scene2.avgLength;...
              Scene2.avgVelocityMax;...
              Scene2.avgAccelerationMax;...
              Scene2.avgJerkMax;...
              Scene2.ErrorRate;...
              Scene2.avgReaction]';
[R,PValue] = corrplot(datatable,'varNames',measures);
title('Correlation Matrix for all measures in the situated condition');

set(findall(gcf,'-property','FontSize'),'FontSize',fontsize)

%% Saving Calculated Data
calculatedHeader = {'spawn','completion_time','reaction_time','spawn_location','spawn_difficulty','input_length','max_velocity','max_acceleration','max_jerk'};

for i = first:last
    data1 = [];
    data1 = array2table(...
            [[1:Scene1(i).Trails]', ...
             [Scene1(i).Time.Completion]', ...
             [Scene1(i).Time.Reaction]', ...
             [Scene1(i).Spawn.Location]', ...
             [Scene1(i).Spawn.Difficulty]', ...
             [Scene1(i).Input.Length]', ...
             [Scene1(i).Input.MaxVelocity]', ...
             [Scene1(i).Input.MaxAcceleration]', ...
             [Scene1(i).Input.MaxJerk]'], ...
             'VariableNames', calculatedHeader);       
    
    mkdir(append('Calculated/Scene_1/', int2str(i)));
    writetable(data1,append('Calculated/Scene_1/', int2str(i),'/calculated_data.csv'));  
    
    data2 = [];
    data2 = array2table(...
            [[1:Scene2(i).Trails]', ...
             [Scene2(i).Time.Completion]', ...
             [Scene2(i).Time.Reaction]', ...
             [Scene2(i).Spawn.Location]', ...
             [Scene2(i).Spawn.Difficulty]', ...
             [Scene2(i).Input.Length]', ...
             [Scene2(i).Input.MaxVelocity]', ...
             [Scene2(i).Input.MaxAcceleration]', ...
             [Scene2(i).Input.MaxJerk]'], ...
             'VariableNames', calculatedHeader);       
    
    mkdir(append('Calculated/Scene_2/', int2str(i)));
    writetable(data2,append('Calculated/Scene_2/', int2str(i),'/calculated_data.csv')); 

end

%% Saving Average Data
avgHeader = {'Participant','Hz','avgDifficulty','avgTime','avgDeviation','avgLength','avgVelocityMax','avgAccelerationMax','avgJerkMax','Errors','ErrorRate','avgReaction'};
for i = first:last
    avgdata1(i,:) = array2table(...
            [i, ...
             Scene1(i).Hz, ...
             Scene1(i).avgDifficulty, ...
             Scene1(i).avgTime, ...
             Scene1(i).avgDeviation, ...
             Scene1(i).avgLength, ...
             Scene1(i).avgVelocityMax, ...
             Scene1(i).avgAccelerationMax, ...
             Scene1(i).avgJerkMax, ...
             Scene1(i).Errors, ...
             Scene1(i).ErrorRate, ...
             Scene1(i).avgReaction], ...
             'VariableNames', avgHeader);       
    
    avgdata2(i,:) = array2table(...
            [i, ...
             Scene2(i).Hz, ...
             Scene2(i).avgDifficulty, ...
             Scene2(i).avgTime, ...
             Scene2(i).avgDeviation, ...
             Scene2(i).avgLength, ...
             Scene2(i).avgVelocityMax, ...
             Scene2(i).avgAccelerationMax, ...
             Scene2(i).avgJerkMax, ...
             Scene2(i).Errors, ...
             Scene2(i).ErrorRate, ...
             Scene2(i).avgReaction], ...
             'VariableNames', avgHeader);
end

mkdir Calculated/Scene_1;  
mkdir Calculated/Scene_2;
writetable(avgdata1, 'Calculated/Scene_1/average_data.csv');  
writetable(avgdata2, 'Calculated/Scene_2/average_data.csv'); 