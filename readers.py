# -*- coding: utf-8 -*-
"""
Created on Thu Jan 20 11:14:53 2022

@author: Thomas
"""

import os
import pandas
import math
import functions
import numpy as np


def file(path, participant, trial, filename):
    # read data file
    file = [i for i in os.listdir(path) if os.path.isfile(os.path.join(path, i)) and \
            filename in i]
    csvdata = pandas.read_csv(path + file[0], delimiter=',')

    return csvdata



