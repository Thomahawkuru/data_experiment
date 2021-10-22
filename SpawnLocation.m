function [Spawn] = SpawnLocation(Scene)

    %find indexes where spawn begins and ends
    %find(Scene(7).Hand.Time == Scene(7).T_start(1))
    
    for i = 1:Scene.Trails
        idx_start = find(round(Scene.Hand.Time,4) == round(Scene.Time(i).Start,4));
        idx_end   = find(round(Scene.Hand.Time,4) == round(Scene.Time(i).End,4));
         
        idx = idx_start + round((idx_end-idx_start)/2);
        Spawn(i).Location = Scene.Experiment.MolePosition(idx);
        Spawn(i).Difficulty = abs(Scene.Experiment.MolePosition(idx))*10; 
    end
    
end