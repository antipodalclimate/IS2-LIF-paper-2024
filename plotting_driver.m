%% Overall code driver for instructions
% Clear all variables and close all figures
clear
close all

% Define the folder paths relative to the current directory
% This points to the IS2-Emulator repository. 

Output_folder = '/Users/chorvat/Code/IS2-Emulator/Output'; % Adjust based on your local setup
Plotting_folder = pwd; 
Script_folder = [Plotting_folder '/Scripts']; 

% For output

% Figure_folder = '~/Library/CloudStorage/Dropbox-Brown/Apps/Overleaf/IS2-Concentration-Part-2/Figures';
Figure_folder = '~/Dropbox (Brown)/Apps/Overleaf/IS2-Concentration-Part-2/Figures';

load([Output_folder '/Orientation_Histograms.mat']);
load([Output_folder '/Emulator_Data.mat']);
load([Output_folder '/Image_Metadata.mat']);

% Now do some plotting
addpath(Plotting_folder)
addpath(Script_folder)

%% Figures related to emulation - should be self-contained. 
% Orbital orientation figure
addpath([Plotting_folder '/Emulation-Figures'])

plot_orbital_data(Figure_folder,orientation_hist,lat_disc,orient_disc);

%%

plot_single_image(Figure_folder,image_location,image_done,true_SIC,length_ice_measured,length_measured,sample_orients,sample_points);

%%

plot_emulation_uncertainty(Figure_folder,true_SIC,length_ice_measured,length_measured)

%% Figures related to sea ice concentration comparison with global products

clearvars -except *_folder
addpath('Product-Figures');

PM_data_folder = '~/Dropbox (Brown)/Research Projects/Active/Data/SIC-Data';
IS2_data_string = '/Users/chorvat/Code/IS2-Gridded-Products/Output/IS2_Data_25km_NH_v6.h5';


addpath('~/Dropbox (Brown)/Research Projects/Plot-Tools/'); 
addpath('~/Dropbox (Brown)/Research Projects/Plot-Tools/NE_Coastlines/'); 

%%

global_product_preamble; 

%%
% Here look at global coverage of the IS2 product

plot_LIF_coverage; 


%% Here look at biases from the IS2 product and other PM data

plot_histograms_and_biases; 

%% Print Useful Statistics

print_statistics; 

%% Compare the specular and all-lead products, as well as the lead fraction
% between weak and strong-only products. 

comp_weak_spec; 

%% Supporting Figures

<<<<<<< HEAD
addpath([Plotting_folder '/Supporting-Info/'])

=======
%S1
>>>>>>> refs/remotes/origin/main
comp_monthly_hist; 

% S2
comp_spec_monthly; 

% S3
plot_histograms_and_biases_nodark;

<<<<<<< HEAD
plot_geo_coverage_monthly; 
=======
% S4
plot_LIF_coverage_monthly; 
>>>>>>> refs/remotes/origin/main
