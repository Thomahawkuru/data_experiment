function [output] = OutputPaths(Scene)

    %find indexes where spawn begins and ends
    %find(Scene(7).Panda.Time == Scene(7).T_start(1))
    
    for i = 1:Scene.Trails
        idx_start = find(round(Scene.Panda.Time,4) == round(Scene.Time(i).Start,4));
        idx_end   = find(round(Scene.Panda.Time,4) == round(Scene.Time(i).End,4));
        
        output(i).Interval = Scene.Panda.DeltaTime(idx_start:idx_end);
        output(i).Panda = [Scene.Panda.PositionX(idx_start:idx_end),...
                     Scene.Panda.PositionY(idx_start:idx_end),...
                     Scene.Panda.PositionZ(idx_start:idx_end)];
                             
    end
end