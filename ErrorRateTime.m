function [pks, locs] = ErrorRateTime(input)

locs  = find(isoutlier(input,'median') & input >= median(input));
pks   = input(locs);
