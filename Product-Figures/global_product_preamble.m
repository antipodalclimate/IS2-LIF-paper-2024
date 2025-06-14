% Grab the concentration from PM 

conc_PM = load_PM_SIC_data(PM_data_folder);

%% Load in ICESat-2 data for comparison and clear workspace

% Numcdber of granules
n_gran = h5read(IS2_data_string,'/GEO/n_gran_all'); 
n_gran_strong = h5read(IS2_data_string,'/GEO/n_gran_strong'); 
n_gran_weak = n_gran - n_gran_strong; 

LIF_all = h5read(IS2_data_string,'/LIF/LIF'); 
LIF_all_strong = h5read(IS2_data_string,'/LIF/LIF_strong'); 
LIF_all_weak = h5read(IS2_data_string,'/LIF/LIF_weak'); 
LIF_spec = h5read(IS2_data_string,'/LIF/LIF_spec'); 
LIF_spec_strong = h5read(IS2_data_string,'/LIF/LIF_spec_strong'); 
LIF_spec_weak = h5read(IS2_data_string,'/LIF/LIF_spec_weak'); 

conc_SSMI_IS2 = h5read(IS2_data_string,'/LIF/SIC_SSMI')/100; 
conc_SSMI_IS2_strong = h5read(IS2_data_string,'/LIF/SIC_SSMI_strong')/100; 

conc_AMSR_IS2 = h5read(IS2_data_string,'/LIF/SIC_AMSR')/100; 
conc_AMSR_IS2_strong = h5read(IS2_data_string,'/LIF/SIC_AMSR_strong')/100; 

grid_area = h5read(IS2_data_string,'/area');
grid_lon = h5read(IS2_data_string,'/longitude');
grid_lat = h5read(IS2_data_string,'/latitude');


%% Some options

% OPTS.summer_months = 6:9;
% OPTS.spring_months = [1:5 10:12];
% OPTS.winter_months = [1 2 12];

% % Indices of various products
% BS_ind = 1;
% NT_ind = 2;
% CDR_ind = 3;
% OSI_ind = 4;
% AMSR_BS_ind = 5;
% AMSR_ASI_ind = 6;

% We want to only consider those locations that have at least 12
% intersecting tracks.
OPTS.track_thresh = 11;

% maximum along-track SIC bias
OPTS.max_AT_bias = 0.025;
OPTS.max_dark_lead = 0.025;

% Thresholds for considering SIC coverage
OPTS.MIZ_thresh = 0.15;
OPTS.SIZ_thresh = 0.15;

%% Locate Usable Areas
conc_PM(conc_PM < OPTS.MIZ_thresh) = nan;

conc_SSMI_IS2(conc_SSMI_IS2 < OPTS.MIZ_thresh | conc_SSMI_IS2 > 100) = nan;
conc_SSMI_IS2_strong(conc_SSMI_IS2_strong < OPTS.MIZ_thresh | conc_SSMI_IS2_strong > 100) = nan;
conc_AMSR_IS2(conc_AMSR_IS2 < OPTS.MIZ_thresh | conc_AMSR_IS2 > 100) = nan;
conc_AMSR_IS2_strong(conc_AMSR_IS2_strong < OPTS.MIZ_thresh | conc_AMSR_IS2_strong > 100) = nan;

LIF_all(LIF_all < OPTS.MIZ_thresh) = nan; 
LIF_all_strong(LIF_all_strong < OPTS.MIZ_thresh) = nan; 
LIF_all_weak(LIF_all_weak < OPTS.MIZ_thresh) = nan; 

%% Now do some data pruning and segmentation

% Examine the total number of tracks - and threshold. 
enough_tracks = n_gran >= OPTS.track_thresh;
enough_tracks_strong = n_gran_strong >= OPTS.track_thresh;
enough_tracks_weak = n_gran_weak >= OPTS.track_thresh;

% Now look at only months where there is all PM data.
common_PM = (~isnan(sum(conc_PM,5))); % Does PM work

% Now isolate those locations where IS2 also has data with PM data
common_LIF = (~isnan(LIF_all)).*(~isnan(conc_SSMI_IS2)); % Does IS2 work
common_LIF_strong = (~isnan(LIF_all_strong)).*(~isnan(conc_SSMI_IS2)); % Does IS2 work

% Segment places where all PM data is compact if we require
% Explore only those locations where all PM data is greater than the SIC
% threshold
common_SIZ_PM = sum(conc_PM > OPTS.SIZ_thresh,5) == size(conc_PM,5);

SIE_PM = conc_PM > OPTS.MIZ_thresh; 

%% Computing along-track biases

% Compute along-track bias. Difference between AT IS-2 values and the NSIDC
% CDR values for that grid cell.
AT_bias_SSMI = conc_SSMI_IS2 - conc_PM(:,:,:,:,3);
AT_bias_AMSR = conc_AMSR_IS2 - conc_PM(:,:,:,:,5);

% Here we select to only consider SSMI - as there may be algorithmic
% differences between the along-track AMSR data and the publicly available
% AMSR data

not_too_biased = max(abs(AT_bias_SSMI),abs(AT_bias_AMSR)) <= OPTS.max_AT_bias;

% Here we want to eliminate measurements with high dark lead fractions. 

not_too_much_dark_lead = (LIF_spec - LIF_all) < OPTS.max_dark_lead; 

% We no longer use bias-adjusted measurements

% % Adjust IS2 values for this bias. If the along-track PM values are biased
% % high, then reduce the IS SIC by the amount of that bias.
% conc_IS_bias_adjusted = conc_IS - AT_bias_SSMI;
% conc_IS_spec_bias_adjusted = conc_IS_spec - AT_bias_SSMI;
% 
% % If greater than 1, goes to 1. If less than 0, goes to zero.
% conc_IS_bias_adjusted(conc_IS_bias_adjusted > 1) = 1;
% conc_IS_bias_adjusted(conc_IS_bias_adjusted < 0) = 0;
% 
% conc_IS_spec_bias_adjusted(conc_IS_spec_bias_adjusted > 1) = 1;
% conc_IS_spec_bias_adjusted(conc_IS_spec_bias_adjusted < 0) = 0;

% Now do the final pruning

% Which grid cells do we include, not worrying about SIC
usable_PM_alone = logical(... % well-sampled
    common_PM ... % All PM and IS2 data is present
    .*common_SIZ_PM); % has all PM data with compact ice.

% Which grid cells do we include.
usable = logical(enough_tracks ... % well-sampled
    .*common_PM.*common_LIF ... % All PM and IS2 data is present
    .*not_too_biased ... % not a huge along-track bias
    .*common_SIZ_PM); % has all PM data with compact ice.

% Which grid cells do we include.
usable_nodark = logical(enough_tracks ... % well-sampled
    .*common_PM.*common_LIF ... % All PM and IS2 data is present
    .*not_too_biased ... % not a huge along-track bias
    .*common_SIZ_PM ... % has all PM data with compact ice.
    .*not_too_much_dark_lead); % doesn't have a high dark lead fraction. 

% Which grid cells do we include.
usable_strong = logical(enough_tracks_strong ... % well-sampled
    .*common_PM.*common_LIF ... % All PM and IS2 data is present
    .*not_too_biased ... % not a huge along-track bias
    .*common_SIZ_PM); % has all PM data with compact ice.

% Which grid cells do we include.
usable_weak = logical(enough_tracks_weak... % well-sampled
    .*common_PM.*common_LIF ... % All PM and IS2 data is present
    .*not_too_biased ... % not a huge along-track bias
    .*common_SIZ_PM); % has all PM data with compact ice.

% Which grid cells do we include.
usable_weak_and_strong = logical(enough_tracks_weak.*enough_tracks_strong ... % well-sampled
    .*common_PM.*common_LIF ... % All PM and IS2 data is present
    .*not_too_biased ... % not a huge along-track bias
    .*common_SIZ_PM); % has all PM data with compact ice.



%% Other helpers
namer = {'Bootstrap','NASATeam','NSIDC-CDR','OSI-430b','AMRS2-NT','AMRS2-ASI','IS2-LIF'};


summer_mos = [7 8];
shoulder_mos = [];
winter_mos = [1 2 3 4 5 6 9 10 11 12];

if isempty(shoulder_mos)
    do_shoulder = 0; 
else
    do_shoulder = 1;

end


nPM = size(conc_PM,5);

nan_usable = 1*usable;
nan_usable(nan_usable == 0) = nan;

nan_usable_nodark = 1*usable_nodark;
nan_usable_nodark(nan_usable_nodark == 0) = nan;

nan_usable_strong = 1*usable_strong;
nan_usable_strong(nan_usable_strong == 0) = nan;

nan_usable_weak = 1*usable_weak;
nan_usable_weak(nan_usable_weak == 0) = nan;

nan_usable_weak_and_strong = 1*usable_weak_and_strong;
nan_usable_weak_and_strong(nan_usable_weak_and_strong == 0) = nan;

weak_strong_diff = nan_usable_weak_and_strong.*(LIF_all_weak - LIF_all_strong);

area_usable_PM_alone = bsxfun(@times,usable_PM_alone,grid_area);

area_usable = bsxfun(@times,usable,grid_area);
area_usable_nodark = bsxfun(@times,usable_nodark,grid_area);
area_usable_strong = bsxfun(@times,usable_strong,grid_area);
area_usable_weak = bsxfun(@times,usable_weak,grid_area);
area_usable_weak_and_strong = bsxfun(@times,usable_weak_and_strong,grid_area);

extent_PM = bsxfun(@times,SIE_PM,grid_area); 

%%
% IS2_plot_all = nan_usable .* LIF_all;
% IS2_plot_weak = nan_usable_weak.*LIF_weak; 
% IS2_plot_strong = nan_usable_strong.*LIF_strong; 
% IS2_plot_weak_and_strong = nan_usable_weak_and_strong .* LIF_all; 
% 
% IS2_plot_spec = nan_usable.*LIF_spec; 
% 
% IS2_summer_all = IS2_plot_all(:,:,summer_mos,:);
% IS2_summer_all = IS2_summer_all(~isnan(IS2_summer_all));
% 
% IS2_summer_spec = IS2_plot_spec(:,:,summer_mos,:);
% IS2_summer_spec = IS2_summer_spec(~isnan(IS2_summer_spec));
% 
% IS2_winter_spec = IS2_plot_spec(:,:,winter_mos,:);
% IS2_winter_spec = IS2_winter_spec(~isnan(IS2_winter_spec));
% 
% IS2_winter_all = IS2_plot_all(:,:,winter_mos,:);
% IS2_winter_all = IS2_winter_all(~isnan(IS2_winter_all));
% 
% IS2_shoulder_all = IS2_plot_all(:,:,shoulder_mos,:);
% IS2_shoulder_all = IS2_shoulder_all(~isnan(IS2_shoulder_all));