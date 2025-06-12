%%


dater = datetime('01/15/2018') + calmonths(0:size(area_usable,4)*12-1);


%%

frac_usable_monthly = sum(usable,[4]) ./ sum(usable_PM_alone,[4]);


lat_usable = bsxfun(@times,usable,grid_lat);
lat_usable(lat_usable == 0) = nan;
typical_lat_monthly = squeeze(nanmean(lat_usable,[1 2 4]));


%%

labs = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'}

for moind = 1:12
    
    subplot(2,6,moind)
    worldmap([60 90],[-180 180])
    pcolorm(grid_lat,grid_lon,frac_usable_monthly(:,:,moind))
    set(gca,'clim',[0 1]);
    make_HR_coastlines([.5 .5 .5])
    colormap(brewermap(5,'-Set2'))

    hold on

    lonvals = -180:180;
    latvals = 0*lonvals + typical_lat_monthly(moind);

    plotm(latvals,lonvals,'-k');

%     drawnow
    title(labs{moind},"FontSize",8,'Interpreter','latex')
    tightmap;

end

colorbar('position',[.3 .05 .4 .05],'orientation','horizontal');


allAxesInFigure = findall(gcf,'type','axes');
% letter = {'(a)','(a)','(b)','(a)','(e)','(f)','(g)','(e)','(c)'};



for i = 1:length(allAxesInFigure)

    posy = get(allAxesInFigure(i),'position');

    set(allAxesInFigure(i),'fontname','times','fontsize',8,'xminortick','on','yminortick','on')

    % annotation('textbox',[posy(1) posy(2)+posy(4) - .025 .025 .025], ...
    %     'String',letter{moind},'LineStyle','none','FontName','Helvetica', ...
    %     'FontSize',8,'Tag','legtag');

end

%% 

pos = [6.5 3];
set(gcf,'windowstyle','normal','position',[0 0 pos],'paperposition',[0 0 pos],'papersize',pos,'units','inches','paperunits','inches');
set(gcf,'windowstyle','normal','position',[0 0 pos],'paperposition',[0 0 pos],'papersize',pos,'units','inches','paperunits','inches');
print([Figure_folder '/coverage-figure-monthly.pdf'],'-dpdf','-r1200');