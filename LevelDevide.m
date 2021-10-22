%% Devide data per level

function level = LevelDevide(Experiment) 
    
    idx.practice    = find(Experiment.LevelNumber == 0);
    idx.level1      = find(Experiment.LevelNumber == [1,2,3] );
    idx.level2      = find(Experiment.LevelNumber == 2);
    idx.level3      = find(Experiment.LevelNumber == 3);
    
    level.practice  = Experiment(idx.practice,:);
    level.level1    = Experiment(idx.level1,:);
    level.level2    = Experiment(idx.level2,:);
    level.level3    = Experiment(idx.level3,:);       
        
end