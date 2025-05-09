% look at monthly changes
close all

sic_bins = 100*linspace(0,1,101);


sumcolor = [.8 .4 .4]; 
wincolor = [.4 .4 .8]; 
shocolor = [.8 .8 .4];

SIClims = 100*[0.6 1];

names = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};

for i = 1:12

    if find(summer_mos==i)
        histc = sumcolor; 
    else
        histc = wincolor;
    end

    
    plotter = 100*nan_usable(:,:,i,:).*LIF_spec(:,:,i,:); 
    plotter = plotter(~isnan(plotter));
    
    medval(i)  = median(plotter(:));

    subplot(2,6,i)
    
    a = histogram(plotter,sic_bins,'FaceColor',histc,'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');
    hold on 
    
    xlim(SIClims);
    plot(sic_bins(2:end),a.Values,'color',histc,'linewidth',1)

    title(names{i},'interpreter','latex');
    set(gca,'yticklabel','')

    hold on
    plotter = 100*nan_usable(:,:,i,:).*LIF_all(:,:,i,:); 
    plotter = plotter(~isnan(plotter));
 
    a = histogram(plotter,sic_bins,'FaceColor',shocolor,'FaceAlpha',0.25,'Normalization','pdf','edgecolor','none');
    plot(sic_bins(2:end),a.Values,'color',shocolor,'linewidth',1)

    grid on; box on;

end


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
print([Figure_folder '/monthly-figure.pdf'],'-dpdf','-r1200');