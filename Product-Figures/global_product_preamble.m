%% Bias_plot_preamble

% Location of monthly concentration products
conc_locs = {'NSIDC-CDR/NSIDC-BS_monthly', ...
    'NSIDC-CDR/NSIDC-NT_monthly', ...
    'NSIDC-CDR/NSIDC-CDR_monthly', ...
    'OSI-450/OSISAF_monthly_regrid_late.mat', ...
    'AMSR2-NT/AMSR2_NT_monthly.mat', ...
    'AMSR2-ASI/ASI_monthly_regrid.mat', ...
    };


PM_names = {'BS','NT','CDR','OSI-SAF','AMSR2-NT','AMSR2-ASI'};

model_conc_loc = {'CLIVAR-LE/CLIVAR_SIC_late'};

%%
% Years that we want to evaluate
yrvals = 2018:2023;

nyrs = length(yrvals);
nPM = length(conc_locs);

summer_months = 6:9;
spring_months = [1:5 10:12];
winter_months = [1 2 12];

% Create an array that contains the SIC in the Arctic for all products and
% over the time period of IS2 data
conc_PM = nan(304,448,12,nyrs,nPM);


% Indices of various products
BS_ind = 1;
NT_ind = 2;
CDR_ind = 3;
OSI_ind = 4;
AMSR_BS_ind = 5;
AMSR_ASI_ind = 6;

% We want to only consider those locations that have at least 5
% intersecting tracks and at least 10000 total segments.
track_thresh = 5;
num_thresh = 10000;

% maximum along-track SIC bias
max_AT_bias = 0.05;

% Thresholds for considering SIC coverage
MIZ_thresh = 0.15;
SIZ_thresh = 0.15;
%%

for i = 1:length(conc_locs)
    
    clear SSMI_monthly_NH
    
    load([PM_data_folder '/' conc_locs{i}])
    
    [used_yrs,is_use,pm_use] = intersect(yrvals,yrlist);
    
    conc_PM(:,:,:,is_use,i) = SSMI_monthly_NH(:,:,:,pm_use);
    
    fprintf('%s has years %d to %d \n',PM_names{i},used_yrs(1),used_yrs(end));
    
end

szer = size(conc_PM);

%% Load in ICESat-2 data for comparison and clear workspace



load('conc_IS2');

%% Locate Usable Areas

clear SIE_NH SIA_NH

conc_PM(conc_PM < MIZ_thresh) = nan;
conc_SSMI_IS2(conc_SSMI_IS2 < MIZ_thresh) = nan;
conc_lead(conc_lead < MIZ_thresh) = nan;
conc_wave(conc_wave < MIZ_thresh) = nan;
conc_spec(conc_spec < MIZ_thresh) = nan;

%% Now do some data pruning and segmentation

% conc_IS = conc_wave; % This was clearly wrong as it incl. clouds by
% accident
conc_IS = conc_lead; % Which are we using as the main IS2 comparison
conc_IS_spec = conc_spec; % IS2 specular leads only

% Want to know what are the usable values
enough_samples = num_meas > num_thresh; % Do we have enough IS2 measurements
enough_tracks = num_tracks > track_thresh;

% Now look at only months where there is all PM data.
common_PM = (~isnan(sum(conc_PM,5))); % Does PM work

% Now isolate those locations where IS2 also has data with PM data
common_IS = (~isnan(conc_IS)).*(~isnan(conc_SSMI_IS2)); % Does IS2 work

% Segment places where all PM data is compact
% Explore only those locations where all PM data is greater than the SIC
% threshold
common_SIZ_PM = sum(conc_PM > SIZ_thresh,5) == size(conc_PM,5);


%% Computing along-track bias
% Compute along-track bias. Difference between AT IS-2 values and the NSIDC
% CDR values for that grid cell.
AT_bias = conc_SSMI_IS2 - conc_PM(:,:,:,:,3);

not_too_biased = abs(AT_bias) < max_AT_bias;

% Adjust IS2 values for this bias. If the along-track PM values are biased
% high, then reduce the IS SIC by the amount of that bias.
conc_IS_bias_adjusted = conc_IS - AT_bias;
conc_IS_spec_bias_adjusted = conc_IS_spec - AT_bias;

% If greater than 1, goes to 1. If less than 0, goes to zero.
conc_IS_bias_adjusted(conc_IS_bias_adjusted > 1) = 1;
conc_IS_bias_adjusted(conc_IS_bias_adjusted < 0) = 0;

conc_IS_spec_bias_adjusted(conc_IS_spec_bias_adjusted > 1) = 1;
conc_IS_spec_bias_adjusted(conc_IS_spec_bias_adjusted < 0) = 0;

% Now do the final pruning

% Which grid cells do we include, not worrying about SIC
usable_PM_alone = logical(... % well-sampled
    common_PM ... % All PM and IS2 data is present
    .*common_SIZ_PM); % has all PM data with compact ice.

% Which grid cells do we include.
usable = logical(enough_samples.*enough_tracks ... % well-sampled
    .*common_PM.*common_IS ... % All PM and IS2 data is present
    .*not_too_biased ... % not a huge along-track bias
    .*common_SIZ_PM); % has all PM data with compact ice.

[summer_usemo,winter_usemo,spring_usemo] = deal(zeros(1,1,12));

spring_usemo(:,:,spring_months) = 1;
summer_usemo(:,:,summer_months) = 1;
winter_usemo(:,:,winter_months) = 1;

usable_winter = bsxfun(@times,usable,winter_usemo);
usable_spring = bsxfun(@times,usable,spring_usemo);
usable_summer = bsxfun(@times,usable,summer_usemo);

% Matrix which is nans when not usable, 1 otherwise.
use_nan = double(usable);
use_nan(use_nan == 0) = nan;

use_nan_winter = double(usable_winter);
use_nan_winter(use_nan_winter == 0) = nan;

use_nan_summer = double(usable_summer);
use_nan_summer(use_nan_summer == 0) = nan;

use_nan_spring = double(usable_spring);
use_nan_spring(use_nan_spring == 0) = nan;
