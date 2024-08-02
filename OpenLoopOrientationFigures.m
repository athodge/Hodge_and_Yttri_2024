clrs=[0.25,0.49,0.63;0.89,0.14,0.16;0.85,0.65,0.13;0.57,0.313,0.4];%[0,0,0.61;1,0,0;1,0.75,0;0.75,0.25,0.75];

for a=1:2
    %Long orientation
    figure('name',['long ',char(string(a))]);%Need to condense into one plot
    O=KKOLM{a,3};%O(O>360 |O<-360)=NaN;
     O(sum(isnan(O),2)>=(size(O,2)/2),:)=[];
     O=diff(O,[],2);
    O(O<-180)=O(O<-180)+360;O(O>180)=O(O>180)-360;
   O=cumsum(O,2,'omitnan');
    O=O-O(:,63);
    
    %-0.5s to +3s
    xlim([0 192]);%ylim([-210 210]);
    %O(sum(O==0,2)==size(O,2),:)=[];
    %if a==1;E=hline([-90 90],'k:');E(1).Color=[0.7 0.7 0.7];E(2).Color=[0.7 0.7 0.7];end
    E=shadedErrorBar(1:size(O,2),nanmean(O),nanstd(O)./sqrt(sum(~isnan(O(:,1)))));
    E.mainLine.Color=clrs(a,:);E.edge(1).Color=clrs(a,:);E.edge(2).Color=clrs(a,:);%xlim
    E.patch.FaceColor=clrs(a,:);
    
    ylim([-210 210]);
    yticks(-360:45:360);
    yticklabels({-360,[],-270,[],-180,[],-90,[],0,[],90,[],180,[],270,[],360});
    
    xticks([32 63 95 127 159 192 225]);xticklabels([]);
    hline(0,'k--');%ylabel('Rotations');
    hold on;
    scatter([63,63],[-180,-175],'.','markerfacecolor',[0,1,1],'markeredgecolor',[0,1,1]); hold on;
    %[~,~,stats]=anova1(O(:,63:end));p=multcompare(stats);
%     p0=ranksum(O(:,63),O(:,83));
%     p1=ranksum(O(:,63),O(:,127));
%     p2=ranksum(O(:,63),O(:,192));
    xlim([32 192]);
    [~,p0]=ttest2(O(:,63),O(:,83));%[~,p0]=ttest2(mean(O(:,1:62),2),O(:,83));
    [~,p1]=ttest2(O(:,63),O(:,127));%[~,p1]=ttest2(mean(O(:,1:62),2),O(:,127));
    [~,p2]=ttest2(O(:,63),O(:,192));%[~,p2]=ttest2(mean(O(:,1:62),2),O(:,192));
    if a==2;E=vline([83 127 192],'k:');E(1).Color=[0.7 0.7 0.7];E(2).Color=[0.7 0.7 0.7];E(3).Color=[0.7 0.7 0.7];end
    if a==1;E=vline([83 127 192],'k:');E(1).Color=[0.7 0.7 0.7];E(2).Color=[0.7 0.7 0.7];E(3).Color=[0.7 0.7 0.7];end
     fprintf('%d Long Stim 310ms p=%d, 1s p=%d, 2s p=%d\n',a,p0,p1,p2);
     
%      E=[nanmean(O(:,83))+aSEM(O(:,83)),nanmean(O(:,83))-aSEM(O(:,83))];
%     E=E(abs(E)==max(abs(E)));
    if a==1;E=-90;else;E=90;end
    if p0<0.001
        scatter([72,77,82],1.5*E*ones(1,3),'p','markerfacecolor',clrs(a,:),'markeredgecolor',clrs(a,:));
    elseif p0<0.005
        scatter([76,82],1.5*E*ones(1,2),'p','markerfacecolor',clrs(a,:),'markeredgecolor',clrs(a,:));
    elseif p0<0.05
        scatter(82,1.5*E,'p','markerfacecolor',clrs(a,:),'markeredgecolor',clrs(a,:));
    end
%     E=[nanmean(O(:,127))+aSEM(O(:,127)),nanmean(O(:,127))-aSEM(O(:,127))];
%     E=E(abs(E)==max(abs(E)));
    if p1<0.001
        scatter([116,121,126],1.5*E*ones(1,3),'p','markerfacecolor',clrs(a,:),'markeredgecolor',clrs(a,:));
    elseif p1<0.005
        scatter([120,126],1.5*E*ones(1,2),'p','markerfacecolor',clrs(a,:),'markeredgecolor',clrs(a,:));
    elseif p1<0.05
        scatter(126,1.5*E,'p','markerfacecolor',clrs(a,:),'markeredgecolor',clrs(a,:));
    end
%     E=[nanmean(O(:,192))+aSEM(O(:,192)),nanmean(O(:,192))-aSEM(O(:,192))];
%     E=E(abs(E)==max(abs(E)));
    if p2<0.001
        scatter([181,186,191],1.5*E*ones(1,3),'p','markerfacecolor',clrs(a,:),'markeredgecolor',clrs(a,:));
    elseif p2<0.005
        scatter([185,191],1.5*E*ones(1,2),'p','markerfacecolor',clrs(a,:),'markeredgecolor',clrs(a,:));
    elseif p2<0.05
        scatter(191,1.5*E,'p','markerfacecolor',clrs(a,:),'markeredgecolor',clrs(a,:));
    end
    ylabel('\Delta Ort (deg)');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Short orientations
    figure('name',['short ',char(string(a))]);%Need to condense into one plot
	O=cell2mat(O2(cell2mat(O2(:,5))==a,3));O(O>720 |O<-720)=NaN;%O=O-O(:,21);
    O=diff(O,1,2);
    O(O<-180)=O(O<-180)+360;O(O>180)=O(O>180)-360;
    
    O=cumsum(O,2,'omitnan');
    
    if a>0%==1
        for c=[21 21.9 22.7 23.6 24.5 25.4 ]
            %area([c,c+0.3 ],-ones(1,2)*620,'facecolor',[0.75,0.9,1],'edgecolor',[0.75,0.9,1]);hold on;
            %area([c,c+0.3 ],-ones(1,2)*720,'facecolor',[0.75,0.9,1],'edgecolor',[0.75,0.9,1]);hold on;
            scatter([c,c,c+0.3,c+0.3],[-180,-175,-175,-180],'.','markerfacecolor',[0,1,1],'markeredgecolor',[0,1,1]);hold on;
        end
    end
    xlim([6 80]);ylim([-210 210]);ylabel('\Delta Ort (deg)');
    %if a==2;E=hline([-90 90],'k:');E(1).Color=[0.7 0.7 0.7];E(2).Color=[0.7 0.7 0.7];end
    E=shadedErrorBar(1:size(O,2),nanmean(O),nanstd(O)./sqrt(size(O,1)));hold on;
    E.mainLine.Color=clrs(a,:);E.edge(1).Color=clrs(a,:);E.edge(2).Color=clrs(a,:);%xlim
    E.patch.FaceColor=clrs(a,:);yticks(-360:45:360);
    yticklabels({-360,[],-270,[],-180,[],-90,[],0,[],90,[],180,[],270,[],360});
    xticks([6  21 36 51 65 80]);xticklabels([-0.5 0 0.5 1 1.5 2]);xlabel('Time (s)');
    hline(0,'k--');%ylabel('Rotations');
    %E=hline([-360 360],'k:');E(1).Color=[0.7 0.7 0.7];E(2).Color=[0.7 0.7 0.7];
    if a==2;E=vline([26 51 80],'k:');E(1).Color=[0.7 0.7 0.7];E(2).Color=[0.7 0.7 0.7];E(3).Color=[0.7 0.7 0.7];end
    if a==1;E=vline([26 51 80],'k:');E(1).Color=[0.7 0.7 0.7];E(2).Color=[0.7 0.7 0.7];E(3).Color=[0.7 0.7 0.7];end
%     p0=ranksum(O(:,21),O(:,26));
%     p1=ranksum(O(:,21),O(:,51));
%     p2=ranksum(O(:,21),O(:,80));
    
    [~,p0]=ttest2(O(:,21),O(:,26));
    [~,p1]=ttest2(O(:,21),O(:,51));
    [~,p2]=ttest2(O(:,21),O(:,80));
    fprintf('%d short Stim 310ms p=%d, 1s p=%d, 2s p=%d\n',a,p0,p1,p2);
%     E=[nanmean(O(:,26))+aSEM(O(:,26)),nanmean(O(:,26))-aSEM(O(:,26))];
%     E=E(abs(E)==max(abs(E)));
    if p0<0.001
        scatter([25.6,26,26.4],1.5*E*ones(1,3),'p','markerfacecolor',clrs(a,:),'markeredgecolor',clrs(a,:));
    elseif p0<0.005
        scatter([25.8,26.2],1.5*E*ones(1,2),'p','markerfacecolor',clrs(a,:),'markeredgecolor',clrs(a,:));
    elseif p0<0.05
        scatter(26,1.5*E,'p','markerfacecolor',clrs(a,:),'markeredgecolor',clrs(a,:));
    end
%     E=[nanmean(O(:,51))+aSEM(O(:,51)),nanmean(O(:,51))-aSEM(O(:,51))];
%     E=E(abs(E)==max(abs(E)));
    if p1<0.001
        scatter([50.6,51,51.4],1.5*E*ones(1,3),'p','markerfacecolor',clrs(a,:),'markeredgecolor',clrs(a,:));
    elseif p1<0.005
        scatter([50.8,51.2],1.5*E*ones(1,2),'p','markerfacecolor',clrs(a,:),'markeredgecolor',clrs(a,:));
    elseif p1<0.05
        scatter(51,1.5*E,'p','markerfacecolor',clrs(a,:),'markeredgecolor',clrs(a,:));
    end
%     E=[nanmean(O(:,80))+aSEM(O(:,80)),nanmean(O(:,80))-aSEM(O(:,80))];
%     E=E(abs(E)==max(abs(E)));
    if p2<0.001
        scatter([79.6,80,80.4],1.5*E*ones(1,3),'p','markerfacecolor',clrs(a,:),'markeredgecolor',clrs(a,:));
    elseif p2<0.005
        scatter([79.8,80.2],1.5*E*ones(1,2),'p','markerfacecolor',clrs(a,:),'markeredgecolor',clrs(a,:));
    elseif p2<0.05
        scatter(80,1.5*E,'p','markerfacecolor',clrs(a,:),'markeredgecolor',clrs(a,:));
    end
end
