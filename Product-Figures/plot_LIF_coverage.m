%% 


dater = datetime('01/15/2018') + calmonths(0:size(area_usable,4)*12-1);


%%

frac_usable = sum(usable,[3 4]) ./ sum(usable_PM_alone,[3 4]);

lat_usable = bsxfun(@times,usable,grid_lat);
lat_usable(lat_usable == 0) = nan; 
typical_lat = nanmean(lat_usable(:));

lat_usable_summer = bsxfun(@times,usable(:,:,summer_mos,:),grid_lat);
lat_usable_summer(lat_usable_summer == 0) = nan; 
typical_lat_summer = nanmean(lat_usable_summer(:));


lat_usable_PM = bsxfun(@times,usable_PM_alone,grid_lat);
lat_usable_PM(lat_usable_PM == 0) = nan; 
typical_PM_lat = nanmean(lat_usable_PM(:));

lat_usable_PM_summer = bsxfun(@times,usable_PM_alone(:,:,summer_mos,:),grid_lat);
lat_usable_PM_summer(lat_usable_PM_summer == 0) = nan; 
typical_PM_lat_summer = nanmean(lat_usable_PM_summer(:));

%%
close 

namer = {'Bootstrap','NASATeam','NSIDC-CDR','OSI-430b','AMRS2-NT','AMRS2-ASI','All PM-SIC','LIF','LIF_{ND}'};


tot_area_PM = reshape(squeeze(sum(area_usable_PM_alone,[1 2])),[],1);
tot_SIE_PM = squeeze(reshape(squeeze(sum(extent_PM,[1 2])),[],1,6));



tot_area = reshape(squeeze(sum(area_usable,[1 2])),[],1);
tot_area(tot_area == 0) = nan; 

tot_area_nodark = reshape(squeeze(sum(area_usable_nodark,[1 2])),[],1);
tot_area_nodark(tot_area_nodark == 0) = nan; 


subplot('position',[0.05 0.3 0.575 0.6])

clabs = brewermap(8,'Paired')

hold on
for i = 1:size(tot_SIE_PM,2)
    plot(dater,tot_SIE_PM(:,i),'--','color',clabs(i,:),'linewidth',0.5);
end

plot(dater,tot_area_PM,'linewidth',1,'color','r')
plot(dater,tot_area,'linewidth',1,'color','k'); 
plot(dater,tot_area_nodark,'--','linewidth',1,'color','k')
xlim([dater(10) dater(72)])

grid on; box on; 
ylabel('Million km$^2$','interpreter','latex')
title('Total Ice Extent','interpreter','latex');


%%
l0 = columnlegend(3,namer,'fontsize',8);
set(l0,'position',[.05 0 .575 .05])
l0.ItemTokenSize(1) = 10;

subplot('position',[0.65 0.25 0.35 0.65])
worldmap([60 90],[-180 180])
pcolorm(grid_lat,grid_lon,frac_usable)
set(gca,'clim',[0 1]); 
make_HR_coastlines([.5 .5 .5])
colormap(brewermap(5,'-Set2'))
colorbar('position',[.7 .1 .25 .05],'orientation','horizontal')


hold on

lonvals = -180:180; 
latvals = 0*lonvals + typical_lat; 

plotm(latvals,lonvals,'-k'); 


latvals = 0*lonvals + typical_lat_summer; 

plotm(latvals,lonvals,'--k'); 

latvals = 0*lonvals + typical_PM_lat;

plotm(latvals,lonvals,'-r'); 



allAxesInFigure = findall(gcf,'type','axes');
letter = {'(b)','(a)','(b)','(a)','(e)','(f)','(g)','(e)','(c)'};

for i = 1:length(allAxesInFigure)

    posy = get(allAxesInFigure(i),'position');

    set(allAxesInFigure(i),'fontname','times','fontsize',8,'xminortick','on','yminortick','on')

    annotation('textbox',[posy(1) posy(2)+posy(4) - .025 .025 .025], ...
        'String',letter{i},'LineStyle','none','FontName','Helvetica', ...
        'FontSize',8,'Tag','legtag');

end

pos = [6.5 2.5];
set(gcf,'windowstyle','normal','position',[0 0 pos],'paperposition',[0 0 pos],'papersize',pos,'units','inches','paperunits','inches');
set(gcf,'windowstyle','normal','position',[0 0 pos],'paperposition',[0 0 pos],'papersize',pos,'units','inches','paperunits','inches');
print([Figure_folder '/coverage-figure.pdf'],'-dpdf','-r1200');