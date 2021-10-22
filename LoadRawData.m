function [Scene1, Scene2] = LoadRawData(last)

for i = 1:last 
    loading = i
    
    Scene1(i).Experiment    = readtable(append('Data/',int2str(i),'/Scene 1/Experiment.csv'));
    Scene1(i).Gaze          = readtable(append('Data/',int2str(i),'/Scene 1/Gaze.csv'));
    Scene1(i).Hand          = readtable(append('Data/',int2str(i),'/Scene 1/Hand.csv'));
    Scene1(i).HMD           = readtable(append('Data/',int2str(i),'/Scene 1/HMD.csv'));
    Scene1(i).Panda         = readtable(append('Data/',int2str(i),'/Scene 1/Panda.csv'));

    Scene2(i).Experiment    = readtable(append('Data/',int2str(i),'/Scene 2/Experiment.csv'));
    Scene2(i).Gaze          = readtable(append('Data/',int2str(i),'/Scene 2/Gaze.csv'));
    Scene2(i).Hand          = readtable(append('Data/',int2str(i),'/Scene 2/Hand.csv'));
    Scene2(i).HMD           = readtable(append('Data/',int2str(i),'/Scene 2/HMD.csv'));
    Scene2(i).Panda         = readtable(append('Data/',int2str(i),'/Scene 2/Panda.csv'));

end