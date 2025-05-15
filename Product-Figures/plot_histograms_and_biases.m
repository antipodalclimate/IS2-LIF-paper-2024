%% Function to plot differences between PM products and the LIF
close all

do_spec = 1; 

%

namer = {'Bootstrap','NASATeam','NSIDC-CDR','OSI-430b','AMRS2-NT','AMRS2-ASI','IS2-LIF'};

sic_bins = 100*linspace(0,1,101);
bias_bins = 100*linspace(-1,1,201);

delx = 0.035;
xfudge = 0.01;
xwidth = 1/(nPM+1) - delx - xfudge;

dely = 0.1;
yfudge = 0.025;
ywidth = 1/2 - dely - yfudge;

sumcolor = [.8 .4 .4];
wincolor = [.4 .4 .8];
shocolor = [.8 .8 .4];

SIClims = 100*[0.6 1];
biaslims = 100*[-.3 .3];

usable_matrix = nan_usable; 


for PMind = 1:nPM


    sic_plot = 100*conc_PM(:,:,:,:,PMind);
    IS2_plot_spec = 100*LIF_spec;
    IS2_plot_all = 100*LIF_all;

    % sic_plot = 100*nan_usable.*conc_PM(:,:,:,:,PMind);
    % 
    % sic_summer = sic_plot(:,:,summer_mos,:);
    % sic_summer = sic_summer(~isnan(sic_summer));
    % 
    % sic_winter = sic_plot(:,:,winter_mos,:);
    % sic_winter = sic_winter(~isnan(sic_winter));
    % 
    plotpos = [(PMind)*xwidth + (PMind+1)*delx + delx + xfudge  dely xwidth ywidth];


    subplot('position',plotpos)

    xline(0,'k','linewidth',0.5);

    hold on

    % Winter IS2 data (specular)
    plotter = usable_matrix(:,:,winter_mos,:).*(sic_plot(:,:,winter_mos,:) - IS2_plot_spec(:,:,winter_mos,:)); 
    histogram(plotter(~isnan(plotter)),bias_bins,'FaceColor',wincolor,'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');

    errplot = mean(plotter(~isnan(plotter)));

    if errplot > 0
        errstr = sprintf('+%2.1f',errplot);
    else
        errstr = sprintf('%2.1f',errplot);
    end

    xline(errplot,'--',errstr,'color',wincolor,'fontsize',8);
    
    % Summer IS2 data (specular)
    plotter = usable_matrix(:,:,summer_mos,:).*(sic_plot(:,:,summer_mos,:) - IS2_plot_spec(:,:,summer_mos,:)); 
    histogram(plotter(~isnan(plotter)),bias_bins,'FaceColor',sumcolor,'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');

    errplot = mean(plotter(~isnan(plotter)));

    if errplot > 0
        errstr = sprintf('+%2.1f',errplot);
    else
        errstr = sprintf('%2.1f',errplot);
    end

    xline(errplot,'--',errstr,'color',sumcolor,'fontsize',8,'LabelVerticalAlignment','middle');


    % Summer IS2 data (all)
    plotter = nan_usable(:,:,summer_mos,:).*(sic_plot(:,:,summer_mos,:) - IS2_plot_all(:,:,summer_mos,:)); 
    histogram(plotter(~isnan(plotter)),bias_bins,'FaceColor',shocolor,'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');


     errplot = mean(plotter(~isnan(plotter)));

    if errplot > 0
        errstr = sprintf('+%2.1f',errplot);
    else
        errstr = sprintf('%2.1f',errplot);
    end

    xline(errplot,'--',errstr,'color',shocolor,'fontsize',8,'LabelVerticalAlignment','bottom');

    xlim(biaslims)
    set(gca,'yticklabel','')

    grid on; box on;

    if PMind == 1
        ylabel('SIC - LIF','interpreter','latex')
    end

    plotpos = [(PMind)*xwidth + (PMind+1)*delx + delx + xfudge  2*dely + ywidth xwidth ywidth];

    subplot('position',plotpos)

    plotter = usable_matrix(:,:,winter_mos,:).*(sic_plot(:,:,winter_mos,:)); 
    histogram(plotter(~isnan(plotter)),sic_bins,'FaceColor',wincolor,'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');
    hold on
    
    plotter = usable_matrix(:,:,summer_mos,:).*(sic_plot(:,:,summer_mos,:)); 
    histogram(plotter(~isnan(plotter)),sic_bins,'FaceColor',sumcolor,'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');

    hold off
    grid on; box on;
    set(gca,'yticklabel','')
    xlim(SIClims);
    title(namer{PMind},'interpreter','latex','fontsize',12)

    if PMind == 1
        ylabel('SIC Distribution','interpreter','latex')

    end

end


plotpos = [delx + xfudge dely + 2*yfudge xwidth 2*ywidth - 2*dely];
subplot('position',plotpos)

plotter = usable_matrix(:,:,summer_mos,:).*(IS2_plot_spec(:,:,summer_mos,:)); 
histogram(plotter(~isnan(plotter)),sic_bins,'FaceColor',sumcolor,'FaceAlpha',0.8,'Normalization','pdf','edgecolor','none');
hold on
plotter = usable_matrix(:,:,winter_mos,:).*(IS2_plot_spec(:,:,winter_mos,:)); 
histogram(plotter(~isnan(plotter)),sic_bins,'FaceColor',wincolor,'FaceAlpha',0.7,'Normalization','pdf','edgecolor','none');

plotter = nan_usable(:,:,summer_mos,:).*(IS2_plot_all(:,:,summer_mos,:)); 

histogram(plotter(~isnan(plotter)),sic_bins,'FaceColor',shocolor,'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');
% 

legend({'"Summer"','"Non-Summer"','"Summer (all)"'},'position', [plotpos(1) plotpos(2) + plotpos(4) + dely plotpos(3) dely])



hold off
grid on; box on;
xlim(SIClims);
set(gca,'yticklabel','')
title(namer{7},'interpreter','latex','fontsize',12)


allAxesInFigure = findall(gcf,'type','axes');
letter = {'(a)','(g)','(m)','(f)','(l)','(e)','(k)','(d)','(j)','(c)','(i)','(b)','(h)'};

for PMind = 1:length(allAxesInFigure)

    posy = get(allAxesInFigure(PMind),'position');

    set(allAxesInFigure(PMind),'fontname','times','fontsize',8,'xminortick','on','yminortick','on')

    annotation('textbox',[posy(1)-.0 posy(2)+posy(4)-.0125 .025 .025], ...
        'String',letter{PMind},'LineStyle','none','FontName','Helvetica', ...
        'FontSize',8,'Tag','legtag');

end

pos = [6.75 3.5];
set(gcf,'windowstyle','normal','position',[0 0 pos],'paperposition',[0 0 pos],'papersize',pos,'units','inches','paperunits','inches');
set(gcf,'windowstyle','normal','position',[0 0 pos],'paperposition',[0 0 pos],'papersize',pos,'units','inches','paperunits','inches');

print([Figure_folder '/histogram-figure.pdf'],'-dpdf','-r1200');
