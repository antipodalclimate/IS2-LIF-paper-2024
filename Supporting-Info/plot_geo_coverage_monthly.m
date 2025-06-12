%% 


%%
close 

%%

num_years = 6 + zeros(12,1);

num_years(1:9) = 5; 


names = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};


for i = 1:12

    usable_map = 100*squeeze(sum(nan_usable(:,:,i,:),4,'omitnan'))/num_years(i);
    usable_map(usable_map == 0) = nan; 

    subplot(2,6,i);

    worldmap([60 90],[0 360])
    pcolorm(grid_lat,grid_lon,usable_map)
    set(gca,'clim',[0 100]);
    make_HR_coastlines([.5 .5 .5])

    
    
% 
    colormap(brewermap(5,'-Set2'))
    % colorbar('position',[.7 .1 .25 .05],'orientation','horizontal')
    % 
    title(names{i},'interpreter','latex');
    % set(gca,'yticklabel','')

    tightmap
end

colorbar('position',[.1 .1 .8 .05],'orientation','horizontal')
%%
allAxesInFigure = findall(gcf,'type','axes');

drawnow 

for i = 1:length(allAxesInFigure)

    posy = get(allAxesInFigure(i),'position');

    set(allAxesInFigure(i),'fontname','times','fontsize',8,'xminortick','on','yminortick','on')

    % annotation('textbox',[posy(1) posy(2)+posy(4) - .025 .025 .025], ...
    %     'String',letter{i},'LineStyle','none','FontName','Helvetica', ...
    %     'FontSize',8,'Tag','legtag');

end

pos = [6.5 6];
set(gcf,'windowstyle','normal','position',[0 0 pos],'paperposition',[0 0 pos],'papersize',pos,'units','inches','paperunits','inches');
set(gcf,'windowstyle','normal','position',[0 0 pos],'paperposition',[0 0 pos],'papersize',pos,'units','inches','paperunits','inches');
print([Figure_folder '/coverage-figure-monthly.pdf'],'-dpdf','-r1200');