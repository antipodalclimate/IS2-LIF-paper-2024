%% Function to plot differences between PM products and the LIF
close all


%

sic_bins = 100*linspace(0,1,101);
bias_bins = 100*linspace(-1,1,201);

color_mapper = [102,194,165
252,141,98
141,160,203
231,138,195
166,216,84]/256; 

sumcolor = [.8 .4 .4]; 
wincolor = [.4 .4 .8]; 


% For the comparison we should only consider when we have enough granules 
% for weak and strong and specular leads. 


subplot(2,2,1); 

% sic_plot = IS2_plot(:,:,winter_mos,:);
% sic_plot = sic_plot(~isnan(sic_plot));




sicplot = nan_usable(:,:,winter_mos,:).*LIF_all(:,:,winter_mos,:);
sicplot = sicplot(~isnan(sicplot));

histogram(100*sicplot,sic_bins,'FaceColor',color_mapper(1,:),'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');
hold on

sicplot = nan_usable(:,:,winter_mos,:).*LIF_spec(:,:,winter_mos,:);
sicplot = sicplot(~isnan(sicplot));

histogram(100*sicplot,sic_bins,'FaceColor',color_mapper(2,:),'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');

sicplot = nan_usable_weak(:,:,winter_mos,:).*LIF_weak(:,:,winter_mos,:);
sicplot = sicplot(~isnan(sicplot));

histogram(100*sicplot,sic_bins,'FaceColor',color_mapper(3,:),'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');

sicplot = nan_usable_strong(:,:,winter_mos,:).*LIF_strong(:,:,winter_mos,:);
sicplot = sicplot(~isnan(sicplot));

histogram(100*sicplot,sic_bins,'FaceColor',color_mapper(4,:),'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');

legend('All','Specular','Weak Only','Strong Only')

grid on; box on;
xlim(100*[0.5 1]);
title('Non-Summer Months','interpreter','latex');


subplot(2,2,2); 

% sic_plot = IS2_plot(:,:,winter_mos,:);
% sic_plot = sic_plot(~isnan(sic_plot));


sicplot = IS2_plot(:,:,summer_mos,:);
sicplot = sicplot(~isnan(sicplot));

histogram(100*sicplot,sic_bins,'FaceColor',color_mapper(1,:),'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');
hold on

sicplot = IS2_plot_spec(:,:,summer_mos,:);
sicplot = sicplot(~isnan(sicplot));

histogram(100*sicplot,sic_bins,'FaceColor',color_mapper(2,:),'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');

sicplot = IS2_plot_weak(:,:,summer_mos,:);
sicplot = sicplot(~isnan(sicplot));

histogram(100*sicplot,sic_bins,'FaceColor',color_mapper(3,:),'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');

sicplot = IS2_plot_strong(:,:,summer_mos,:);
sicplot = sicplot(~isnan(sicplot));

histogram(100*sicplot,sic_bins,'FaceColor',color_mapper(4,:),'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');

legend('All','Specular','Weak Only','Strong Only')
grid on; box on;
xlim(100*[0.5 1]);

title('Summer Months','interpreter','latex');
%%

subplot(223)
cla
% First do specular - all
% Then do weak - strong

sicplot = IS2_plot_spec(:,:,winter_mos,:) - IS2_plot(:,:,winter_mos,:);
sicplot = sicplot(~isnan(sicplot));

 histogram(100*sicplot,bias_bins,'FaceColor',color_mapper(2,:),'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');
    hold on

sicplot = IS2_plot_weak(:,:,winter_mos,:) - IS2_plot_strong(:,:,winter_mos,:);
sicplot = sicplot(~isnan(sicplot));

histogram(100*sicplot,bias_bins,'FaceColor',color_mapper(3,:),'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');
xlim(100*[-.1 .4])
set(gca,'yticklabel','')

legend('Specular - All','Weak - Strong')
    grid on; box on;
    hold off


%%

subplot(224)
cla
% First do specular - all
% Then do weak - strong

sicplot = IS2_plot_spec(:,:,summer_mos,:) - IS2_plot(:,:,summer_mos,:);
sicplot = sicplot(~isnan(sicplot));

 histogram(100*sicplot,bias_bins,'FaceColor',color_mapper(2,:),'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');
    hold on

sicplot = IS2_plot_weak(:,:,summer_mos,:) - IS2_plot_strong(:,:,summer_mos,:);
sicplot = sicplot(~isnan(sicplot));

histogram(100*sicplot,bias_bins,'FaceColor',color_mapper(3,:),'FaceAlpha',0.5,'Normalization','pdf','edgecolor','none');
xlim(100*[-.1 .4])
set(gca,'yticklabel','')

legend('Specular - All','Weak - Strong')
    grid on; box on;
    hold off


%%



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
print([Figure_folder '/comp_defs-figure.pdf'],'-dpdf','-r1200');