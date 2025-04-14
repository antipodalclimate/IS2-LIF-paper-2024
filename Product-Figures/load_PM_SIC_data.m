function conc_PM = load_PM_SIC_data(PM_data_folder)

%% Bias_plot_preamble

% Location of monthly concentration products
conc_locs = {'NSIDC-CDR/CDR_monthly_NH', ...
    'NSIDC-CDR/CDR_monthly_NH', ...
    'NSIDC-CDR/CDR_monthly_NH', ...
    'OSI-450/OSISAF_monthly_regrid_late.mat', ...
    'AMSR2-NT/AMSR2_SIC_monthly.mat', ...
    'AMSR2-ASI/AMSR2_ASI_monthly.mat', ...
    };


fieldnames = {'BS_monthly_NH', ...
    'NT_monthly_NH', ...
    'CDR_monthly_NH', ...
    'SSMI_monthly_NH', ...
    'AMSR_NT_monthly_NH', ...
    'ASI_regrid_NH'};


PM_names = {'BS','NT','CDR','OSI-SAF','AMSR2-NT','AMSR2-ASI'};

% model_conc_loc = {'CLIVAR-LE/CLIVAR_SIC_late'};

%%
% Years that we want to evaluate
yrvals = 2018:2023;

nyrs = length(yrvals);
nPM = length(conc_locs);

% Create an array that contains the SIC in the Arctic for all products and
% over the time period of IS2 data
conc_PM = nan(304,448,12,nyrs,nPM);


%%

for i = 1:length(conc_locs)
    
    clear SSMI_monthly_NH
    
    SICdata = load([PM_data_folder '/' conc_locs{i}],fieldnames{i},'yrlist');
    
    yrlist = SICdata.('yrlist');
    SICdata = SICdata.(fieldnames{i});
    SICdata = reshape(SICdata,size(SICdata,1),size(SICdata,2),12,[]);

    [used_yrs,is_use,pm_use] = intersect(yrvals,yrlist);
    
    conc_PM(:,:,:,is_use,i) = SICdata(:,:,:,pm_use);
    
    fprintf('%s has years %d to %d \n',PM_names{i},used_yrs(1),used_yrs(end));
    
end

