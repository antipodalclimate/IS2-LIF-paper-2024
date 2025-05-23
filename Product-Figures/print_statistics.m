
num_summer = sum(usable(:,:,summer_mos,:),'all');
num_winter = sum(usable(:,:,winter_mos,:),'all');

area_summer = squeeze(nansum(area_usable(:,:,summer_mos,:),'all'));
area_winter = squeeze(nansum(area_usable(:,:,winter_mos,:),'all'));

coverage_IS2 = squeeze(nansum(area_usable,[1 2]) ./ nansum(area_usable_PM_alone,[1 2])); 

fprintf('\n \nStatistics of IS2 gridded output \n \n')
fprintf('Total number is %2.0f thousand in winter and %2.0f in summer \n',num_winter/1e3,num_summer/1e3);
fprintf('Total area %2.0f million km^2 in winter and %2.0f in summer \n',area_winter/1e6,area_summer/1e6);


%% This is the actual LIF product. We are suggesting using spec returns only in summer months.

LIF_product = LIF_spec; 
LIF_strong_product = LIF_spec_strong; 
LIF_weak_product = LIF_spec_weak; 

% Take bias between our supported product and the concentration of each
% SIC.
PM_bias = bsxfun(@minus,conc_PM,nan_usable.*LIF_product); 

% Average SIC for each PM value in summer months
mean_SIC_summer = squeeze(nanmean(bsxfun(@times,nan_usable(:,:,summer_mos,:),conc_PM(:,:,summer_mos,:,:)),[1 2 3 4])); 
mean_SIC_winter = squeeze(nanmean(bsxfun(@times,nan_usable(:,:,winter_mos,:),conc_PM(:,:,winter_mos,:,:)),[1 2 3 4])); 

% Average bias between SIC values and LIF in each month. 
mean_bias_summer = squeeze(nanmean(PM_bias(:,:,summer_mos,:,:),[1 2 3 4]));
mean_bias_winter = squeeze(nanmean(PM_bias(:,:,winter_mos,:,:),[1 2 3 4]));

% Interquartile range of biases. 
[~,iqr_summer] = iqr(reshape(PM_bias(:,:,summer_mos,:,:),[],nPM),1); 
[~,iqr_winter] = iqr(reshape(PM_bias(:,:,winter_mos,:,:),[],nPM),1); 

fprintf('\nStatistics of Bias from PM Products \n')
for i = 1:nPM
    fprintf('For %s: \nSummer: mean SIC is %2.1f, with mean bias from LIF Product of %2.1f (%2.1f,%2.1f) \nWinter: mean SIC is %2.1f, with mean bias from IS2 of %2.1f (%2.1f,%2.1f) \n' ...
        ,namer{i},100*mean_SIC_summer(i),100*mean_bias_summer(i),100*iqr_summer(1,i),100*iqr_summer(2,i), ...
        100*mean_SIC_winter(i),100*mean_bias_winter(i),100*iqr_winter(1,i),100*iqr_winter(2,i)); 
end


%% Now look at differences between LIFs

% Percentage of usable areas that have lots of strong beams or weak beams
% or lots of both. 

frac_usable_nodark = squeeze(nansum(area_usable_nodark(:,:,:,:),'all'))./(area_summer + area_winter);
frac_usable_nodark_summer = squeeze(nansum(area_usable_nodark(:,:,summer_mos,:),'all'))./(area_summer);
frac_usable_nodark_winter = squeeze(nansum(area_usable_nodark(:,:,winter_mos,:),'all'))./(area_winter);


frac_usable_strong = squeeze(nansum(area_usable_strong(:,:,:,:),'all'))./(area_summer + area_winter);
frac_usable_weak = squeeze(nansum(area_usable_weak(:,:,:,:),'all'))./(area_summer + area_winter);
frac_usable_weak_and_strong = squeeze(nansum(area_usable_weak_and_strong(:,:,:,:),'all'))./(area_summer + area_winter);

% Biases between different LIF values. 

% Statistics of the product LIF
mean_LIF_summer = squeeze(nanmean(nan_usable(:,:,summer_mos,:).*LIF_product(:,:,summer_mos,:),'all')); 
mean_LIF_winter = squeeze(nanmean(nan_usable(:,:,winter_mos,:).*LIF_product(:,:,winter_mos,:),'all')); 

% Statistics of the all-leads LIF. 
mean_LIF_all_summer = squeeze(nanmean(nan_usable(:,:,summer_mos,:).*LIF_all(:,:,summer_mos,:),'all')); 
mean_LIF_all_winter = squeeze(nanmean(nan_usable(:,:,winter_mos,:).*LIF_all(:,:,winter_mos,:),'all')); 

LIF_all_bias = nan_usable.*(LIF_all - LIF_product);

[~,iqr_all_summer] = iqr(reshape(LIF_all_bias(:,:,summer_mos,:,:),[],1),1); 
[~,iqr_all_winter] = iqr(reshape(LIF_all_bias(:,:,winter_mos,:,:),[],1),1); 

mean_all_bias_summer = squeeze(nanmean(LIF_all_bias(:,:,summer_mos,:),'all'));
mean_all_bias_winter = squeeze(nanmean(LIF_all_bias(:,:,winter_mos,:),'all'));

% Statistics of the no dark leads LIF. 
mean_LIF_nodark_summer = squeeze(nanmean(nan_usable_nodark(:,:,summer_mos,:).*LIF_spec(:,:,summer_mos,:),'all')); 
mean_LIF_nodark_winter = squeeze(nanmean(nan_usable_nodark(:,:,winter_mos,:).*LIF_spec(:,:,winter_mos,:),'all')); 

% Statistics of the specular-only LIF. 
mean_LIF_spec_summer = squeeze(nanmean(nan_usable(:,:,summer_mos,:).*LIF_spec(:,:,summer_mos,:),'all')); 
mean_LIF_spec_winter = squeeze(nanmean(nan_usable(:,:,winter_mos,:).*LIF_spec(:,:,winter_mos,:),'all')); 

LIF_spec_bias = nan_usable.*(LIF_spec - LIF_product);

[~,iqr_spec_summer] = iqr(reshape(LIF_spec_bias(:,:,summer_mos,:,:),[],1),1); 
[~,iqr_spec_winter] = iqr(reshape(LIF_spec_bias(:,:,winter_mos,:,:),[],1),1); 

mean_spec_bias_summer = squeeze(nanmean(LIF_spec_bias(:,:,summer_mos,:),'all'));
mean_spec_bias_winter = squeeze(nanmean(LIF_spec_bias(:,:,winter_mos,:),'all'));

% Statistics of the strong-only LIF. 
LIF_strong_bias = nan_usable_strong.*(LIF_strong_product - LIF_product); 

[~,iqr_strong_summer] = iqr(reshape(LIF_strong_bias(:,:,summer_mos,:,:),[],1),1); 
[~,iqr_strong_winter] = iqr(reshape(LIF_strong_bias(:,:,winter_mos,:,:),[],1),1); 

mean_LIF_strong_summer = squeeze(nanmean(nan_usable_strong(:,:,summer_mos,:).*LIF_strong_product(:,:,summer_mos,:),'all')); 
mean_LIF_strong_winter = squeeze(nanmean(nan_usable_strong(:,:,winter_mos,:).*LIF_strong_product(:,:,winter_mos,:),'all')); 

mean_strong_bias_summer = squeeze(nanmean(LIF_strong_bias(:,:,summer_mos,:),'all'));
mean_strong_bias_winter = squeeze(nanmean(LIF_strong_bias(:,:,winter_mos,:),'all'));

% Statistics of the weak-only LIF
LIF_weak_bias = nan_usable_weak.*(LIF_weak_product - LIF_product); 

[~,iqr_weak_summer] = iqr(reshape(LIF_weak_bias(:,:,summer_mos,:,:),[],1),1); 
[~,iqr_weak_winter] = iqr(reshape(LIF_weak_bias(:,:,winter_mos,:,:),[],1),1); 

mean_LIF_weak_summer = squeeze(nanmean(nan_usable_weak(:,:,summer_mos,:).*LIF_weak_product(:,:,summer_mos,:),'all')); 
mean_LIF_weak_winter = squeeze(nanmean(nan_usable_weak(:,:,winter_mos,:).*LIF_weak_product(:,:,winter_mos,:),'all')); 

mean_weak_bias_summer = squeeze(nanmean(LIF_weak_bias(:,:,summer_mos,:),'all'));
mean_weak_bias_winter = squeeze(nanmean(LIF_weak_bias(:,:,winter_mos,:),'all'));

% Statistics of weak vs strong when evaluated on the same well-sampled
% area.

weak_strong_diff_spec = nan_usable_weak_and_strong.*(LIF_spec_weak - LIF_spec_strong);
weak_strong_diff_all = nan_usable_weak_and_strong.*(LIF_all_weak - LIF_all_strong);

mean_ws_spec_diff_summer = squeeze(nanmean(weak_strong_diff_spec(:,:,summer_mos,:),'all'));
mean_ws_spec_diff_winter = squeeze(nanmean(weak_strong_diff_spec(:,:,winter_mos,:),'all'));

mean_ws_all_diff_summer = squeeze(nanmean(weak_strong_diff_all(:,:,summer_mos,:),'all'));
mean_ws_all_diff_winter = squeeze(nanmean(weak_strong_diff_all(:,:,winter_mos,:),'all'));

mean_LIF_spec_ws_summer = squeeze(nanmean(nan_usable_weak_and_strong(:,:,summer_mos,:).*LIF_spec(:,:,summer_mos,:),'all')); 
mean_LIF_spec_ws_winter = squeeze(nanmean(nan_usable_weak_and_strong(:,:,winter_mos,:).*LIF_spec(:,:,winter_mos,:),'all')); 

mean_LIF_all_ws_summer = squeeze(nanmean(nan_usable_weak_and_strong(:,:,summer_mos,:).*LIF_all(:,:,summer_mos,:),'all')); 
mean_LIF_all_ws_winter = squeeze(nanmean(nan_usable_weak_and_strong(:,:,winter_mos,:).*LIF_all(:,:,winter_mos,:),'all')); 

%% Now produce output


fprintf('\n\nFor the LIF products \n\n')

fprintf('\nFor %s: \nSummer: mean SIC is %2.1f \nWinter: mean SIC is %2.1f \n' ...
        ,'the LIF product',100*mean_LIF_summer, ...
        100*mean_LIF_winter); 


fprintf('\nFor %s: \nSummer: mean SIC is %2.1f, with mean bias from LIF product of %2.1f (%2.1f,%2.1f) \nWinter: mean SIC is %2.1f, with mean bias from LIF product of %2.1f (%2.1f,%2.1f) \n' ...
        ,'LIF with all leads',100*mean_LIF_all_summer,100*mean_all_bias_summer,100*iqr_all_summer(1),100*iqr_all_summer(2), ...
        100*mean_LIF_all_winter,100*mean_all_bias_winter,100*iqr_all_winter(1),100*iqr_all_winter(2)); 

fprintf('\nFor %s:, covering about %2.2f of LIF extent: \nSummer: Coverage is %2.2f and mean SIC is %2.1f, \nWinter: Coverage is %2.2f and mean SIC is %2.1f \n' ...
        ,'LIF with no dark leads',frac_usable_nodark,100*frac_usable_nodark_summer,100*mean_LIF_nodark_summer,100*frac_usable_nodark_winter,100*mean_LIF_nodark_winter); 

fprintf('\nFor %s: \nSummer: mean SIC is %2.1f, with mean bias from LIF product of %2.1f (%2.1f,%2.1f) \nWinter: mean SIC is %2.1f, with mean bias from LIF product of %2.1f (%2.1f,%2.1f) \n' ...
        ,'LIF with spec leads',100*mean_LIF_spec_summer,100*mean_spec_bias_summer,100*iqr_spec_summer(1),100*iqr_spec_summer(2), ...
        100*mean_LIF_spec_winter,100*mean_spec_bias_winter,100*iqr_spec_winter(1),100*iqr_spec_winter(2)); 

fprintf('\nFor %s, covering about %2.2f of LIF extent: \nSummer: mean SIC is %2.1f, with mean bias from LIF product of %2.1f (%2.1f,%2.1f) \nWinter: mean SIC is %2.1f, with mean bias from LIF product of %2.1f (%2.1f,%2.1f) \n' ...
        ,'strong LIF',100*frac_usable_strong,100*mean_LIF_strong_summer,100*mean_strong_bias_summer,100*iqr_strong_summer(1),100*iqr_strong_summer(2), ...
        100*mean_LIF_strong_winter,100*mean_strong_bias_winter,100*iqr_strong_winter(1),100*iqr_strong_winter(2)); 

fprintf('\nFor %s, covering about %2.2f of LIF extent: \nSummer: mean SIC is %2.1f, with mean bias from LIF product of %2.1f (%2.1f,%2.1f) \nWinter: mean SIC is %2.1f, with mean bias from LIF product of %2.1f (%2.1f,%2.1f) \n' ...
        ,'weak LIF',100*frac_usable_weak,100*mean_LIF_weak_summer,100*mean_weak_bias_summer,100*iqr_weak_summer(1),100*iqr_weak_summer(2), ...
        100*mean_LIF_weak_winter,100*mean_weak_bias_winter,100*iqr_weak_winter(1),100*iqr_weak_winter(2)); 

fprintf('\nFor %s, covering about %2.2f of LIF extent: Summer mean LIF is %2.1f and mean weak - strong is %2.1f, \nWinter: mean LIF is %2.1f and mean weak - strong is %2.1f \n' ...
        ,'weak and strong specular LIF',100*frac_usable_weak_and_strong,100*mean_LIF_spec_ws_summer,100*mean_ws_spec_diff_summer, ...
        100*mean_LIF_spec_ws_winter,100*mean_ws_spec_diff_summer); 

fprintf('\nFor %s, covering about %2.2f of LIF extent: Summer mean LIF is %2.1f and mean weak - strong is %2.1f, \nWinter: mean LIF is %2.1f and mean weak - strong is %2.1f \n' ...
        ,'weak and strong all lead LIF',100*frac_usable_weak_and_strong,100*mean_LIF_all_ws_summer,100*mean_ws_all_diff_summer, ...
        100*mean_LIF_all_ws_winter,100*mean_ws_all_diff_winter); 
