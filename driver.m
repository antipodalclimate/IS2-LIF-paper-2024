%% Overall code driver for instructions
% Clear all variables and close all figures
clear
close all

% Define the folder paths relative to the current directory
Code_folder = pwd;
Data_folder = [Code_folder '/Data']; % Adjust based on your local setup
Output_folder = [Code_folder '/Output']; % Adjust based on your local setup
Orbit_folder = [Code_folder '/Orbital-Incidence'];
Metadata_folder = [Code_folder '/Locations-of-Scenes'];
Emulator_folder = [Code_folder '/Emulator-Main'];
Plotting_folder = [Code_folder '/Plotting']; 
Script_folder = [Code_folder '/Scripts']; 

% Figure_folder = '~/Library/CloudStorage/Dropbox-Brown/Apps/Overleaf/IS2-Concentration-Part-2/Figures';
Figure_folder = '/Users/chorvat/Dropbox (Brown)/Apps/Overleaf/IS2-Concentration-Part-2/Figures';

load([Output_folder '/Orientation_Histograms.mat']);
load([Output_folder '/Emulator_Data.mat']);
load([Output_folder '/Image_Metadata.mat']);

% Now do some plotting
addpath(Plotting_folder)
addpath(Script_folder)

% Orbital orientation figure
plot_orbital_data(Figure_folder,orientation_hist,lat_disc,orient_disc);

%%
% Figure of emulation on a single random image
plot_single_image(Figure_folder,image_location,image_done,true_SIC,length_ice_measured,length_measured,sample_orients,sample_points);



%% Now examine 
plot_bias_data; 

%% Now plot the LIF global biases vs non