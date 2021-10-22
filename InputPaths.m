function [input] = InputPaths(Scene)

    %find indexes where spawn begins and ends
    %find(Scene(7).Hand.Time == Scene(7).T_start(1))
    
    for i = 1:Scene.Trails
        idx_start = find(round(Scene.Hand.Time,4) == round(Scene.Time(i).Start,4));
        idx_end   = find(round(Scene.Hand.Time,4) == round(Scene.Time(i).End,4));
  
        input(i).Interval = Scene.Hand.DeltaTime(idx_start:idx_end);
        input(i).Time = Scene.Hand.Time(idx_start:idx_end);
        
        if Scene.Handedness == "R"
            input(i).Path = [Scene.Hand.RPositionX(idx_start:idx_end),...
                     Scene.Hand.RPositionY(idx_start:idx_end),...
                     Scene.Hand.RPositionZ(idx_start:idx_end)];                
        else
            input(i).Path  = [Scene.Hand.LPositionX(idx_start:idx_end),...
                     Scene.Hand.LPositionY(idx_start:idx_end),...
                     Scene.Hand.LPositionZ(idx_start:idx_end)];                                
        end
        
        idx = round((idx_end-idx_start)/2);
        Scene.Spawn(i).Location = Scene.Experiment.MolePosition(idx);
        Scene.Spawn(i).Difficulty = abs(Scene.Experiment.MolePosition(idx))*10; 
    end
end