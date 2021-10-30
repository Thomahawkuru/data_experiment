# Data_experiment
Data analysis project for the experiment found in:  
https://github.com/Thomahawkuru/panda_experiment  
https://github.com/Thomahawkuru/unity_experiment  

Raw data is included

# Required MATLAB add-ons
Curve Fitting Toolbox, Signal Processing Toolbox, Econometrics Toolbox

# Contents
The following scripts are the functions that calculate each individual measure. The script structure is as followed. A main script loads the recorded data from the CSV files and puts the data in a datastructure. Then the main scripts runs analysis scripts for each measure. Each analysis scritp parses the data from from both conditions to the calculation functions, plots the results and performs a t-test.

### Main script
* Set global parameters
*	Load CSV filse per participant from Data folder
* Determine spawn and completion timestamps
  - Run TimeStamps function    
* Determine paths taken between timestamps
* Run ‘Subjective_Analysis.m’
  - Load questionare answers from CSV
  - Take average scores for the subjective measures
  - Plot calculated data
* Run ‘Time_Analysis.m'
  - Load previous determined timestamps, plot data and perform t-test.
* Run ‘Deviation_analysis.m’
  - Run the PathDeviation function, plot data and perform t-test.
* Run ‘Length_Analysis.m’
  - Run the PathLength function, plot data and perform t-test.
* Run ‘Velocity_Analysis.m’
  - Run the InputVelocity function, plot data and perform t-test.
* Run ‘Acceleration_Analysis.m’
  - Run the InputAcceleration function, plot data and perform t-test.
* Run ‘Jerk_Analysis.m’
  - Run the InputJerk function, plot data and perform t-test.
* Run ‘Error_Analysis.m’
  - Run the ErrorRate function, plot data and perform t-test.
* Run ‘Reaction_Analysis.m’
  - Run the ReactionTime function, plot data and perform t-test.
*	Run ‘Difficulty_Analysis.m’
  - Run the previous analyses on the spanws for each level of difficulty
*	Gather overall results
  - Plot boxplot overview of all measures
  - Deterimine correlation matrices
