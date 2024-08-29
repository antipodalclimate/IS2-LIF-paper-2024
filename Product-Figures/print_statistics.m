
num_summer = numel(IS2_summer);
num_winter = numel(IS2_winter);

area_summer = squeeze(nansum(area_usable(:,:,summer_mos,:),'all'));
area_winter = squeeze(nansum(area_usable(:,:,winter_mos,:),'all'));

IS2_bias = bsxfun(@minus,conc_PM,nan_usable.*LIF); 

LIF_specular_bias = nan_usable.*(LIF_specular - LIF);  
LIF_strong_bias = nan_usable_strong.*(LIF_strong - LIF); 

mean_SIC_summer = squeeze(nanmean(bsxfun(@times,nan_usable(:,:,summer_mos,:),conc_PM(:,:,summer_mos,:,:)),[1 2 3 4])); 
mean_SIC_winter = squeeze(nanmean(bsxfun(@times,nan_usable(:,:,winter_mos,:),conc_PM(:,:,winter_mos,:,:)),[1 2 3 4])); 

median_bias_summer = squeeze(nanmedian(IS2_bias(:,:,summer_mos,:,:),[1 2 3 4]));
median_bias_winter = squeeze(nanmedian(IS2_bias(:,:,winter_mos,:,:),[1 2 3 4]));

[~,iqr_summer] = iqr(reshape(IS2_bias(:,:,summer_mos,:,:),[],nPM),1); 
[~,iqr_winter] = iqr(reshape(IS2_bias(:,:,winter_mos,:,:),[],nPM),1); 

[~,iqr_spec_summer] = iqr(reshape(LIF_specular_bias(:,:,summer_mos,:,:),[],1),1); 
[~,iqr_spec_winter] = iqr(reshape(LIF_specular_bias(:,:,winter_mos,:,:),[],1),1); 

[~,iqr_strong_summer] = iqr(reshape(LIF_strong_bias(:,:,summer_mos,:,:),[],1),1); 
[~,iqr_strong_winter] = iqr(reshape(LIF_strong_bias(:,:,winter_mos,:,:),[],1),1); 


mean_LIF_summer = squeeze(nanmean(nan_usable(:,:,summer_mos,:).*LIF(:,:,summer_mos,:),'all')); 
mean_LIF_winter = squeeze(nanmean(nan_usable(:,:,winter_mos,:).*LIF(:,:,winter_mos,:),'all')); 

mean_LIF_specular_summer = squeeze(nanmean(nan_usable(:,:,summer_mos,:).*LIF_specular(:,:,summer_mos,:),'all')); 
mean_LIF_specular_winter = squeeze(nanmean(nan_usable(:,:,winter_mos,:).*LIF_specular(:,:,winter_mos,:),'all')); 

mean_LIF_strong_summer = squeeze(nanmean(nan_usable_strong(:,:,summer_mos,:).*LIF_strong(:,:,summer_mos,:),'all')); 
mean_LIF_strong_winter = squeeze(nanmean(nan_usable_strong(:,:,winter_mos,:).*LIF_strong(:,:,winter_mos,:),'all')); 

median_strong_bias_summer = squeeze(nanmedian(LIF_strong_bias(:,:,summer_mos,:),'all'));
median_strong_bias_winter = squeeze(nanmedian(LIF_strong_bias(:,:,winter_mos,:),'all'));

median_specular_bias_summer = squeeze(nanmedian(LIF_specular_bias(:,:,summer_mos,:),'all'));
median_specular_bias_winter = squeeze(nanmedian(LIF_specular_bias(:,:,winter_mos,:),'all'));

coverage_IS2 = squeeze(nansum(area_usable,[1 2]) ./ nansum(area_usable_PM_alone,[1 2])); 


%% Now produce output

fprintf('\n \nStatistics of IS2 gridded output \n \n')
fprintf('Total number is %2.0f thousand in winter and %2.0f in summer \n',num_winter/1e3,num_summer/1e3);
fprintf('Total area %2.0f million km^2 in winter and %2.0f in summer \n',area_winter/1e6,area_summer/1e6);

for i = 1:nPM
    fprintf('For product %s: \nSummer: mean SIC is %2.1f, with median bias from IS2 of %2.1f (%2.1f,%2.1f) \nWinter: mean SIC is %2.1f, with median bias from IS2 of %2.1f (%2.1f,%2.1f) \n' ...
        ,namer{i},100*mean_SIC_summer(i),100*median_bias_summer(i),100*iqr_summer(1,i),100*iqr_summer(2,i), ...
        100*mean_SIC_winter(i),100*median_bias_winter(i),100*iqr_winter(1,i),100*iqr_winter(2,i)); 
end

fprintf('For the LIF products \n')

fprintf('For main LIF: \nSummer: mean SIC is %2.1f \nWinter: mean SIC is %2.1f \n' ...
        ,100*mean_LIF_summer,100*mean_LIF_winter); 

fprintf('For %s: \nSummer: mean SIC is %2.1f, with median bias from IS2 of %2.1f (%2.1f,%2.1f) \nWinter: mean SIC is %2.1f, with median bias from IS2 of %2.1f (%2.1f,%2.1f) \n' ...
        ,'specular LIF',100*mean_LIF_specular_summer,100*median_specular_bias_summer,100*iqr_spec_summer(1),100*iqr_spec_summer(2), ...
        100*mean_LIF_specular_winter,100*median_specular_bias_winter,100*iqr_spec_winter(1),100*iqr_spec_winter(2)); 

fprintf('For %s: \nSummer: mean SIC is %2.1f, with median bias from IS2 of %2.1f (%2.1f,%2.1f) \nWinter: mean SIC is %2.1f, with median bias from IS2 of %2.1f (%2.1f,%2.1f) \n' ...
        ,'strong LIF',100*mean_LIF_strong_summer,100*median_strong_bias_summer,100*iqr_strong_summer(1),100*iqr_strong_summer(2), ...
        100*mean_LIF_strong_winter,100*median_strong_bias_winter,100*iqr_strong_winter(1),100*iqr_strong_winter(2)); 
