# -*- coding: utf-8 -*-
"""
Created on Thu Jan 20 11:14:53 2022

@author: Thomas
"""

import os
import matplotlib.pyplot as plt
import numpy as np
import readers
import calculators

# Import csv files --------------------------------------------------------------------------------------------------
datapath        = os.getcwd() + "\\data\\"        # full path to data
savepath        = os.getcwd() + "\\save\\"        # full path to data
participants    = 26                            # number of participants
trials          = 2                             # trials per participant
filename        = 'Experiment.csv'              # looks for files with this string in the name

for participant in range(1, participants + 1):
    print(), print(), print(f'Analyisis results for participant {participant}')

    for trial in range(1, trials + 1):
        print(), print('Trial ' + str(trial))
        
        trialpath = datapath + f'{participant}\\Scene {trial}'
        
        experiment_data     = readers.file(trialpath, participant, trial, 'Experiment.csv' )
        timestamps          = calculators.timestamps(experiment_data, savepath, participant, trial)   
              
        #hand_data           = readers.file(trialpath, participant, trial, 'Hand.csv' )
        #input_paths         = calcualtors.input_paths(timestamps, hand_data)
    
                