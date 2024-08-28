%% Function to plot differences between PM products and the LIF
close all


nPM = size(conc_PM,5);

namer = {'Bootstrap','NASATeam','NSIDC-CDR','OSI-430b','AMRS2-NT','AMRS2-ASI','IS2-LIF'};


summer_mos = [6 7 8];
winter_mos = [1 2 3 4 5 9 10 11 12];

nan_usable = 1*usable;
nan_usable(nan_usable == 0) = nan;

%

sic_bins = linspace(0,1,101);
bias_bins = linspace(-1,1,201);

IS2_plot = nan_usable .* LIF;

IS2_summer = IS2_plot(:,:,summer_mos,:);
IS2_summer = IS2_summer(~isnan(IS2_summer));

IS2_winter = IS2_plot(:,:,winter_mos,:);
IS2_winter = IS2_winter(~isnan(IS2_winter));

delx = 0.035;
xfudge = 0.01;
xwidth = 1/(nPM+1) - delx - xfudge;

dely = 0.1;
yfudge = 0.025;
ywidth = 1/2 - dely - yfudge;

sumcolor = [.8 .4 .4]; 
wincolor = [.4 .4 .8]; 



for PMind = 1:nPM


    sic_plot = nan_usable.*conc_PM(:,:,:,:,PMind);

    sic_summer = sic_plot(:,:,summer_mos,:);
    sic_summer = sic_summer(~isnan(sic_summer));

    sic_winter = sic_plot(:,:,winter_mos,:);
    sic_winter = sic_winter(~isnan(sic_winter));

    plotpos = [(PMind-1)*xwidth + PMind*delx dely xwidth ywidth];


    subplot('position',plotpos)

    histogram(sic_summer - IS2_summer,bias_bins,'FaceColor',sumcolor,'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');
    hold on
    histogram(sic_winter - IS2_winter,bias_bins,'FaceColor',wincolor,'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');
    hold off

   
    errplot = mean(sic_summer - IS2_summer);

    if errplot > 0
        errstr = sprintf('+%2.2f',100*errplot);
    else
        errstr = sprintf('%2.2f',100*errplot);
    end

    xline(errplot,'--',errstr,'color',sumcolor,'fontsize',8,'LabelVerticalAlignment','middle');  
    errplot = mean(sic_winter - IS2_winter);

     if errplot > 0
        errstr = sprintf('+%2.2f',100*errplot);
    else
        errstr = sprintf('%2.2f',100*errplot);
    end


    xline(errplot,'--',errstr,'color',wincolor,'fontsize',8); 


    xlim([-.2 .2])
    set(gca,'yticklabel','')

    grid on; box on;

    if PMind == 1
        ylabel('SIC - LIF','interpreter','latex')
    end

    plotpos = [(PMind-1)*xwidth + PMind*delx  2*dely + ywidth xwidth ywidth];




    subplot('position',plotpos)

    histogram(sic_summer,sic_bins,'FaceColor',[.8 .4 .4],'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');
    hold on
    histogram(sic_winter,sic_bins,'FaceColor',[.4 .4 .8],'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');


    hold off
    grid on; box on;
    set(gca,'yticklabel','')
    xlim([0.7 1]);
    title(namer{PMind},'interpreter','latex','fontsize',12)

    if PMind == 1
        ylabel('SIC Distribution','interpreter','latex')

    end

end

PMind = 7;

plotpos = [(PMind-1)*xwidth + PMind*delx + xfudge dely + 2*yfudge xwidth 2*ywidth - 2*dely];
subplot('position',plotpos)

histogram(IS2_summer,sic_bins,'FaceColor',[.8 .4 .4],'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');
hold on
histogram(IS2_winter,sic_bins,'FaceColor',[.4 .4 .8],'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');
hold off
grid on; box on;
xlim([0.5 1]);
set(gca,'yticklabel','')
title(namer{PMind},'interpreter','latex','fontsize',12)


legend({'Summer','Winter'},'position', [plotpos(1) plotpos(2) + plotpos(4) + dely plotpos(3) dely])

allAxesInFigure = findall(gcf,'type','axes');
% letter = {'(a)','(b)','(c)','(a)','(e)','(f)','(g)','(e)','(c)'};

for PMind = 1:length(allAxesInFigure)

    posy = get(allAxesInFigure(PMind),'position');

    set(allAxesInFigure(PMind),'fontname','times','fontsize',8,'xminortick','on','yminortick','on')

    % annotation('textbox',[posy(1) posy(2)+posy(4) - .025 .025 .025], ...
    %     'String',letter{i},'LineStyle','none','FontName','Helvetica', ...
    %     'FontSize',8,'Tag','legtag');

end

pos = [6.75 3.5];
set(gcf,'windowstyle','normal','position',[0 0 pos],'paperposition',[0 0 pos],'papersize',pos,'units','inches','paperunits','inches');
set(gcf,'windowstyle','normal','position',[0 0 pos],'paperposition',[0 0 pos],'papersize',pos,'units','inches','paperunits','inches');
print([Figure_folder '/histogram-figure.pdf'],'-dpdf','-r1200');