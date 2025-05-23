function plot_emulation_uncertainty(Figure_folder,true_SIC,length_ice_measured,length_measured)

usable = true_SIC < .99 & true_SIC > 0.1 & ~isnan(true_SIC);


% Number of images, sequential crossings, and therefore number of potential
% permutations of those crossings
n_images = sum(usable);
n_crossings = size(length_measured,2);

% How long of a permutation
perm_length = 100;
% Number of permutations we choose
n_perms = 10*n_crossings;

% Measured SIC when accumulating crossings
im_meas_LIF = nan(n_images,perm_length,n_perms);
tot_length = im_meas_LIF;

% For each permutation, take the cumulative sum in each image of the random
% permutation of images.
for j = 1:n_perms

    % randomly permute the number of crossings
    % Without replacement
    % rp = randsample(n_crossings,perm_length); %
    % With replacement. 
    rp = randi(n_crossings,[perm_length 1]); 
    im_meas_LIF(:,:,j) = cumsum(length_ice_measured(usable,rp),2)./cumsum(length_measured(usable,rp),2);
    tot_length(:,:,j) = cumsum(length_measured(usable,rp),2);

end


%% Compute bias fields

% Difference between actual SIC and the accumulated SIC.
SIC_bias = bsxfun(@minus,true_SIC(usable),im_meas_LIF);

% Long-term LIF
LIF_star = mean(im_meas_LIF(:,end,:),3);
% Bias from true value
Bias_i = true_SIC(usable) - LIF_star;

% Variability at end of crossings will be zero since we sample without
% replacement the paths. 
Std_i = 100*std(SIC_bias(:,end,:),[],3,'omitnan');

% Take the mean bias as a function of crossing number.

% Mean bias per crossing averaged over all permutations and images
Bias_n = 100*squeeze(mean(SIC_bias,[1 3],"omitnan"));

% Mean absolute bias per crossing, across all permutations and images
Bias_abs_n = 100*squeeze(mean(mean(abs(SIC_bias),3),1,"omitnan"));

cutoff_n = find(Bias_abs_n<=2.5,1);

Path_variance_at_cutoff = 100*std(SIC_bias(:,cutoff_n,:),[],3,'omitnan');

Std_n = 100*squeeze(mean(std(SIC_bias,[],3,'omitnan'),1,'omitnan'));

cutoff_n = find(Std_n<=2.5,1);

%%

% Mean absolute bias per crossing, when we average over all permutations
% first, then take the absolute value and average across all images
Bias_abs_barfirst_angle = 100*squeeze(mean(abs(mean(SIC_bias,3,'omitnan')),'omitnan'));

% Mean absolute bias per crossing, when we average over all images first
% first, then take the absolute value and average over all permutations.
% I think this one should basically be zero since the mean bias per image
% is pretty low.
Bias_abs_bar_anglefirst = 100*squeeze(mean(abs(mean(SIC_bias,1,'omitnan')),'omitnan'));


%% Standard deviations

% Take the standard deviation of the average bias after averaging out all
% permutations
Bias_std_angle = 100*squeeze(std(mean(SIC_bias,3),[],1,"omitnan"));
% Take the standard deviation of all including all permutations. This will
% decay faster because all individual images have a decaying part.
Bias_std_all = 100*squeeze(std(SIC_bias,[],[1 3],'omitnan'));

Bias_abs_595_all = 100*squeeze(prctile(abs(SIC_bias),100*[exp(-2) 1 - exp(-2)],[1 3]));
Bias_abs_595_barfirst = 100*squeeze(prctile(abs(mean(SIC_bias,3)),100*[exp(-2) 1 - exp(-2)],[1]));

%%

figure(1)
clf


subplot('position',[.075 .15 .25 .75])


histogram(100*Bias_i,[-10:.1:10],'Normalization','probability','facecolor',[.8 .4 .4],'edgecolor','none');
grid on; box on;
xlabel('$B_i$ (\%)','interpreter','latex'); ylabel('PDF','interpreter','latex');
title('Best-case bias $B_i = LIF_i^* - SIC$','interpreter','latex')
xline(prctile(100*Bias_i,75),'k','LineWidth',1)
xline(prctile(100*Bias_i,25),'k','LineWidth',1)
xline(prctile(100*Bias_i,5),'--k','LineWidth',.5)
xline(prctile(100*Bias_i,95),'--k','LineWidth',.5)

set(gca,'yticklabel','')
xlim([-5 5])

%
subplot('position',[.725 .15 .25 .75])

histogram(Path_variance_at_cutoff,[0:.05:10],'Normalization','probability','facecolor',[.8 .4 .4],'edgecolor','none');
grid on; box on;
xlabel('$S_{i,n^*}$ (\%)','interpreter','latex'); % ylabel('PDF');
title('Standard Deviation at $n^*$','interpreter','latex')
xline(prctile(Path_variance_at_cutoff,75),'k','LineWidth',1)
xline(prctile(Path_variance_at_cutoff,25),'k','LineWidth',1)
xline(prctile(Path_variance_at_cutoff,5),'--k','LineWidth',.5)
xline(prctile(Path_variance_at_cutoff,95),'--k','LineWidth',.5)


set(gca,'yticklabel','')
xlim([0 10])



subplot('position',[.4 .15 .25 .75])

% Plot the mean over all images and permutations as a function of crossing
% number
plot(1:perm_length,Bias_n,'k','linewidth',1);
hold on
jbfill(1:perm_length,Bias_n + Std_n,Bias_n - Std_n,[.4 .4 .4],[0 0 0],1,0.25);
% jbfill(1:perm_length,Bias_n + Bias_std_angle,Bias_n - Bias_std_angle,[.4 .4 .8],[0 0 0],1,0.25);
grid on; box on;
xlim([1 50])
xline(cutoff_n,'label','$S_n < 2.5\%$','interpreter','latex','fontsize',10)
title('Mean Bias at crossing n','interpreter','latex')
% set(gca,'xticklabel','')
ylabel('\%','interpreter','latex'); xlabel('Crossing Number','interpreter','latex')
% legend('')

% subplot('position',[.55 .075 .375 .375])
% % Now looking at absolute biases
% plot(1:perm_length,Bias_abs_n,'k','linewidth',1);
% hold on
% 
% jbfill(1:perm_length,Bias_abs_595_all(1,:),Bias_abs_595_all(2,:),[.4 .4 .4],[0 0 0],1,0.25);
% hold on
% plot(1:perm_length,Bias_abs_barfirst_angle,'b','linewidth',1);
% % jbfill(1:perm_length,Bias_abs_595_barfirst(1,:),Bias_abs_595_barfirst(2,:),[.4 .4 .8],[0 0 0],1,0.25);
% grid on; box on;
% xline(cutoff_n,'label','2.5\% MAB','interpreter','latex','fontsize',10)
% % yline(2.5,'color','k')
% xlim([1 50])
% xlabel('Crossing Number')
% ylabel('%')
% 
% title('Mean Absolute LIF Bias','interpreter','latex')

% plot(1:n_crossings,SIC_bias_std);
% subplot(222)
% histogram(100*SIC_bias(:,1,:),-50:1:50)
% hold on
% histogram(100*SIC_bias(:,5,:),-50:1:50)
% histogram(100*SIC_bias(:,10,:),-50:1:50)
% grid on; box on;
% xlim([-20 20])
% xline([-2.5 2.5],'linewidth',2)
% legend('Crossing 0','Crossing 5','Crossing 10');



% subplot('position',[.05 .075  .9 .175])
% p = 100*sum(abs(SIC_bias) < 0.01,[1 3]) / numel(SIC_bias(:,1,:));
% r = 100*sum(abs(SIC_bias) < 0.03,[1 3]) / numel(SIC_bias(:,1,:));
% s = 100*sum(abs(SIC_bias) < 0.05,[1 3]) / numel(SIC_bias(:,1,:));
% 
% plot(1:perm_length,p,'b')
% hold on
% plot(1:perm_length,r,'k')
% 
% plot(1:perm_length,s,'r')
% grid on; box on;
% xlim([1 50])
% ylim([0 100])
% legend('Bias < 1%','Bias < 3%','Bias < 5%')
% title('Fraction within bias threshold','interpreter','latex')
%
% %%
allAxesInFigure = findall(gcf,'type','axes');
letter = {'(b)','(c)','(a)','(a)','(e)','(f)','(g)','(e)','(c)'};

for i = 1:length(allAxesInFigure)

    posy = get(allAxesInFigure(i),'position');

    set(allAxesInFigure(i),'fontname','times','fontsize',8,'xminortick','on','yminortick','on')

    annotation('textbox',[posy(1) posy(2)+posy(4) - .005 .025 .025], ...
        'String',letter{i},'LineStyle','none','FontName','Helvetica', ...
        'FontSize',8,'Tag','legtag');

end

pos = [6.5 2.5];
set(gcf,'windowstyle','normal','position',[0 0 pos],'paperposition',[0 0 pos],'papersize',pos,'units','inches','paperunits','inches');
set(gcf,'windowstyle','normal','position',[0 0 pos],'paperposition',[0 0 pos],'papersize',pos,'units','inches','paperunits','inches');
print([Figure_folder '/bias-figure.pdf'],'-dpdf','-r1200');
