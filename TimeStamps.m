function [spawns, Time] = TimeStamps(Ex)
    spawns = max(Ex.TrailNumber); 
    
    %timestamps
    T = zeros(spawns,1);
    T_start = zeros(spawns,1);
    T_end = zeros(spawns,1);
    trail = 0;
    
    %determine timestamps
    for i = 2:length(Ex.Time)-1
        if Ex.LevelNumber(i) > 0 && (Ex.TrailNumber(i) > 0 || Ex.TrailNumber(i+1) > 0 || Ex.TrailNumber(i-1) > 0)
            %start time when mole position changes from 0 (despawned)
            if abs(Ex.MolePosition(i)) > abs(Ex.MolePosition(i-1))
                trail = trail + 1;
                T_start(trail) = Ex.Time(i);
            end
            %end time when mole position returns to 0 (despawned)
            if abs(Ex.MolePosition(i)) > abs(Ex.MolePosition(i+1))
                T_end(trail) = Ex.Time(i);

                T(trail) = T_end(trail) - T_start(trail);
            end        
        end    
    end
    spawns = length(T);
    
    %put timestamps per spawn in data structure
    for i = 1:spawns
        Time(i).Completion = T(i);
        Time(i).Start = T_start(i);
        Time(i).End = T_end(i);
    end


