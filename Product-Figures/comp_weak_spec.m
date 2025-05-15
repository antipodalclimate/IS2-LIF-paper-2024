
% look at differences between weak/strong and dark/specular leads.
close all

sic_bins = 100*linspace(0,1,101);

sic_bins = 100*linspace(0,1,101);
bias_bins = 100*linspace(-1,1,101);

SIClims = 100*[0.6 1];
biaslims = 100*[-.3 .3];

cmapper = brewermap(3,'Set2');

names = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};


plotter = 100*nan_usable(:,:,summer_mos,:).*(LIF_spec(:,:,summer_mos,:) - LIF_all(:,:,summer_mos,:));

subplot('position',[.05 .3 .25 .6])

p1 = histogram(plotter(~isnan(plotter)),bias_bins,'FaceColor',sumcolor,'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');
hold on
errplot = mean(plotter(~isnan(plotter)));

if errplot > 0
    errstr = sprintf('+%2.1f',errplot);
else
    errstr = sprintf('%2.1f',errplot);
end

xline(errplot,'--',errstr,'color',sumcolor,'fontsize',8);


plotter = 100*nan_usable(:,:,winter_mos,:).*(LIF_spec(:,:,winter_mos,:) - LIF_all(:,:,winter_mos,:));
p2 = histogram(plotter(~isnan(plotter)),bias_bins,'FaceColor',wincolor,'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');

errplot = mean(plotter(~isnan(plotter)));

if errplot > 0
    errstr = sprintf('+%2.1f',errplot);
else
    errstr = sprintf('%2.1f',errplot);
end

xline(errplot,'--',errstr,'color',wincolor,'fontsize',8);


xlim(biaslims)
set(gca,'yticklabel','')

grid on; box on;

title('Specular - All Leads','interpreter','latex')
xlabel('$\Delta$ LIF','interpreter','latex')

legend([p1 p2],'``Summer"','"Non-Summer"','location',[.225 .075 .2 .025])

subplot('position',[.35 .3 .25 .6])
histogram(100*weak_strong_diff(:,:,summer_mos,:),bias_bins,'FaceColor',sumcolor,'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');
hold on
histogram(100*weak_strong_diff(:,:,winter_mos,:),bias_bins,'FaceColor',wincolor,'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');

errplot = nanmean(100*weak_strong_diff(:,:,summer_mos,:),'all');

if errplot > 0
    errstr = sprintf('+%2.1f',errplot);
else
    errstr = sprintf('%2.1f',errplot);
end


xline(errplot,'--',errstr,'color',sumcolor,'fontsize',8,'LabelVerticalAlignment','middle');

errplot = nanmean(100*weak_strong_diff(:,:,winter_mos,:),'all');

if errplot > 0
    errstr = sprintf('+%2.1f',errplot);
else
    errstr = sprintf('%2.1f',errplot);
end

xline(errplot,'--',errstr,'color',wincolor,'fontsize',8);


xlim(biaslims)
set(gca,'yticklabel','')

grid on; box on;

title('Weak - Strong','interpreter','latex')
xlabel('$\Delta$ LIF','interpreter','latex')

% legend('``Summer"','"Non-Summer"','location','west')

%%
subplot('position',[.7 .3 .275 .6])


dark_color = [31,120,180]/256; 
spec_color = [252,141,98]/256; 
fit_color = [228,26,28]/256; 

dark_frac = nan_usable.*(LIF_spec - LIF_all); 

dark_frac_weak = nan_usable_weak_and_strong.*(LIF_spec_weak - LIF_all_weak); 
dark_frac_strong = nan_usable_weak_and_strong.*(LIF_spec_strong - LIF_all_strong); 

spec_frac_weak = nan_usable_weak_and_strong.*(1-LIF_spec_weak); 
spec_frac_strong = nan_usable_weak_and_strong.*(1-LIF_spec_strong); 


p1_dark = 100*dark_frac_weak(~isnan(dark_frac_weak));
p2_dark = 100*dark_frac_strong(~isnan(dark_frac_strong));


use_darkleadcomp = (p1_dark >= 0) & (p2_dark >= 0); 

fit_dark = polyfit(p1_dark(use_darkleadcomp),p2_dark(use_darkleadcomp),1);
corrcoef(p1_dark(use_darkleadcomp),p2_dark(use_darkleadcomp))


%%

scatter(p1_dark(:),p2_dark(:),1,dark_color,'filled');

hold on


p1_spec = 100*spec_frac_weak(~isnan(spec_frac_weak + spec_frac_strong));
p2_spec = 100*spec_frac_strong(~isnan(spec_frac_weak + spec_frac_strong));

scatter(p1_spec(:),p2_spec(:),1,spec_color,'filled');

use_specleadcomp = (p1_spec >= 0) & (p2_spec >= 0); 

fit_spec = polyfit(p1_spec(use_specleadcomp),p2_spec(use_specleadcomp),1);
corrcoef(p1_spec(use_specleadcomp),p2_spec(use_specleadcomp))

xlabel('Weak Only');
ylabel('Strong Only');


line([0 100],[0 100],'color','k','linestyle','--'); 
plot(sic_bins,polyval(fit_dark,sic_bins),'-','Color','red','linewidth',1);
plot(sic_bins,polyval(fit_spec,sic_bins),'-','Color','blue','linewidth',1);

grid on; box on; 
xlim(fliplr(100-SIClims))
ylim(fliplr(100-SIClims))

legend('Dark','Specular','location',[.7575 .075 .15 .025])
title('Lead Fraction','interpreter','latex')


%% 

use_frac_comp = (p1_spec > 0 & p2_spec > 0 & p1_dark > 0 & p2_dark > 0);




%%

% hold on 
% histogram(100*dark_frac_weak(~isnan(dark_frac_weak)),bias_bins,'FaceColor',cmapper(:,2),'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');
% histogram(100*dark_frac_strong(~isnan(dark_frac_strong)),bias_bins,'FaceColor',cmapper(:,3),'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');
% 
% xlim(biaslims)
% grid on; box on; 

%%
allAxesInFigure = findall(gcf,'type','axes');
letter = {'(c)','(b)','(a)'};

for PMind = 1:length(allAxesInFigure)

    posy = get(allAxesInFigure(PMind),'position');

    set(allAxesInFigure(PMind),'fontname','times','fontsize',8,'xminortick','on','yminortick','on')

    annotation('textbox',[posy(1) posy(2)+posy(4) - .025 .025 .025], ...
        'String',letter{PMind},'LineStyle','none','FontName','Helvetica', ...
        'FontSize',8,'Tag','legtag');

end

pos = [6 2.25];
set(gcf,'windowstyle','normal','position',[0 0 pos],'paperposition',[0 0 pos],'papersize',pos,'units','inches','paperunits','inches');
set(gcf,'windowstyle','normal','position',[0 0 pos],'paperposition',[0 0 pos],'papersize',pos,'units','inches','paperunits','inches');
print([Figure_folder '/LIF-spec-strong-weak.pdf'],'-dpdf','-r1200');