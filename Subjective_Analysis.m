
%% Load Data
Questionnaire = readtable(append('Data/Questionnaire.csv'));

%% Demografic Analysis
 figure(3); clf(3);
 
[percentage,labels] = PieData(Questionnaire.Age(first:last));
subplot(431); pie(percentage,int2str(labels)); title({'Age';''});
[percentage,labels] = PieData(Questionnaire.Gender(first:last));
subplot(432); pie(percentage,(labels)); title({'Gender';''});
[percentage,labels] = PieData(Questionnaire.Nationality(first:last));
subplot(433); pie(percentage,labels); title({'Nationality';''});
[percentage,labels] = PieData(Questionnaire.Vision(first:last));
subplot(434); pie(percentage,labels); title({'Vision Aids';''});
[percentage,labels] = PieData(Questionnaire.VR(first:last));
subplot(435); pie(percentage,labels); title({'VR Experience';''});
[percentage,labels] = PieData(Questionnaire.AR(first:last));
subplot(436); pie(percentage,labels); title({'MR Experience';''});
[percentage,labels] = PieData(Questionnaire.Handedness(first:last));
subplot(437); pie(percentage,labels); title({'Handedness';''});
[percentage,labels] = PieData(Questionnaire.Hand_1(first:last));
subplot(438); pie(percentage,labels); title({'Hand_1';''});
[percentage,labels] = PieData(Questionnaire.Hand_2(first:last));
subplot(4,3,9); pie(percentage,labels); title({'Hand_2';''});
[percentage,labels] = PieData(Questionnaire.MISC_0(first:last));
subplot(4,3,10); pie(percentage,int2str(labels)); title({'MISC_0';''});
[percentage,labels] = PieData(Questionnaire.MISC_1(first:last));
subplot(4,3,11); pie(percentage,int2str(labels)); title({'MISC_1';''});
[percentage,labels] = PieData(Questionnaire.MISC_2(first:last));
subplot(4,3,12); pie(percentage,int2str(labels)); title({'MISC_2';''});

%% Usability Analysis
flipped = [true false true true true false true true false true false true];

Answers1 = [table2array(Questionnaire(pilot+2:2:end,14:25)); table2array(Questionnaire(pilot+3:2:end,30:41))];
Answers2 = [table2array(Questionnaire(pilot+3:2:end,14:25)); table2array(Questionnaire(pilot+2:2:end,30:41))];

for i = 1:12
    if flipped(i) == true
        Answers1(:,i) = 6-(Answers1(:,i));
        Answers2(:,i) = 6-(Answers2(:,i));
    end
end

for P = first:last
    i = P-pilot;
    Scene1(P).Subjective.Performance = mean(Answers1(i,1:3));
    Scene1(P).Subjective.Usability = mean(Answers1(i,[4,6,8,10,12]));
    Scene1(P).Subjective.Satisfaction = mean(Answers1(i,[5,7,9,11]));
    
    Scene2(P).Subjective.Performance = mean(Answers2(i,1:3));
    Scene2(P).Subjective.Usability = mean(Answers2(i,[4,6,8,10,12]));
    Scene2(P).Subjective.Satisfaction = mean(Answers2(i,[5,7,9,11]));
    
    if Scene1(P).Subjective.Performance > Scene2(P).Subjective.Performance && ...
       Scene1(P).Subjective.Usability > Scene2(P).Subjective.Satisfaction &&  ...
       Scene1(P).Subjective.Satisfaction > Scene2(P).Subjective.Satisfaction
       
        Scene1(P).Preference = true;
        Scene2(P).Preference = [];
    elseif Scene2(P).Subjective.Performance > Scene1(P).Subjective.Performance && ...
           Scene2(P).Subjective.Usability > Scene1(P).Subjective.Satisfaction &&  ...
           Scene2(P).Subjective.Satisfaction > Scene1(P).Subjective.Satisfaction
   
        Scene1(P).Preference = [];
        Scene2(P).Preference = true;
    end
end
        
Preference_1_2 = [sum([Scene1.Preference]), sum([Scene2.Preference])]

        
%% Average Answers
figure(100); clf(100);
avgAnswers1 = mean(Answers1);
avgAnswers2 = mean(Answers2);

Performance_1_2     = [mean(avgAnswers1(1:3)), std(mean(Answers1(:,1:3)')), mean(avgAnswers2(1:3)), std(mean(Answers2(:,1:3)'))]
Usefullness_1_2     = [mean(avgAnswers1([4,6,8,10,12])), std(mean(Answers1(:,[4,6,8,10,12])')), mean(avgAnswers2([4,6,8,10,12])), std(mean(Answers2(:,[4,6,8,10,12])'))]
Satisfaction_1_2    = [mean(avgAnswers1([5,7,9,11])), std(mean(Answers1(:,[5,7,9,11])')), mean(avgAnswers2([5,7,9,11])), std(mean(Answers2(:,[5,7,9,11])'))]

[H0, p_perf,ci,stats] = ttest([avgAnswers1(1:3)], [avgAnswers2(1:3)]);
[H0, p_use,ci,stats] = ttest([avgAnswers1([4,6,8,10,12])], [avgAnswers2([4,6,8,10,12])]);
[H0, p_satis,ci,stats] = ttest([avgAnswers1([5,7,9,11])], [avgAnswers2([5,7,9,11])]);

%% boxplot answers
group1(1:length([Scene1.Hz])) = {'Separated'};
group2(1:length([Scene2.Hz])) = {'Situated'};
group = [group1,group2];
cg = categorical(group);

subplot(1,3,1); boxchart(cg,[mean(Answers1(:,1:3)'),mean(Answers2(:,1:3)')]);
hold on; plot([mean(mean([Answers1(:,1:3)'])),mean(mean([Answers2(:,1:3)']))],'bo');
hold on; plot([mean(mean([Answers1(:,1:3)'])),mean(mean([Answers2(:,1:3)']))],'b');
title('Performance'); grid(gca,'minor'); ylabel('Score [1:5]');

subplot(1,3,2);boxchart(cg,[mean(Answers1(:,[4,6,8,10,12])'),mean(Answers2(:,[4,6,8,10,12])')]);
hold on; plot([mean(mean(Answers1(:,[4,6,8,10,12])')),mean(mean(Answers2(:,[4,6,8,10,12])'))],'bo');
hold on; plot([mean(mean(Answers1(:,[4,6,8,10,12])')),mean(mean(Answers2(:,[4,6,8,10,12])'))],'b');
title('Usefulness'); grid(gca,'minor'); ylabel('Score [1:5]');

subplot(1,3,3); boxchart(cg,[mean(Answers1(:,[5,7,9,11])'),mean(Answers2(:,[5,7,9,11])')]);
hold on; plot([mean(mean(Answers1(:,[5,7,9,11])')),mean(mean(Answers2(:,[5,7,9,11])'))],'bo');
hold on; plot([mean(mean(Answers1(:,[5,7,9,11])')),mean(mean(Answers2(:,[5,7,9,11])'))],'b');
title('Satisfaction'); grid(gca,'minor'); ylabel('Score [1:5]');

clear 'group1' 'group2' 'group' 'cg'

%% Fontsize
set(findall(gcf,'-property','FontSize'),'FontSize',fontsize)