clrs=[0.25,0.49,0.63;0.89,0.14,0.16;0.85,0.65,0.13;0.57,0.313,0.4];%[0,0,0.61;1,0,0;1,0.75,0;0.75,0.25,0.75];
%sqrt(diff(ddd(:,1)).^2+diff(ddd(:,2)).^2)*0.098;
d1L=movmean(d1Long,8,2);%d1L=movmean(d1Long*0.098,8,2)*4;
d2L=movmean(d2Long,8,2);%d2L=movmean(d2Long*0.098,8,2)*4;
d1S=movmean(d1Short,8,2);%d1S=movmean(d1Short*0.098,8,2)*4;
d2S=movmean(d2Short,8,2);%d2S=movmean(d2Short*0.098,8,2)*4;
tim=((1:150)-60)/30;
bsln=[mean(d1L(:,1:59),2,'omitnan'),mean(d2L(:,1:59),2,'omitnan'),mean(d1S(:,1:59),2,'omitnan'),mean(d2S(:,1:59),2,'omitnan')];
figure('name','longStim');
shadedErrorBarColor(tim,nanmean(d1L),nanstd(d1L)./sqrt(60),clrs(1,:));hold on;ylim([0 10]);%ylim([0.5 4]);
shadedErrorBarColor(tim,nanmean(d2L),nanstd(d2L)./sqrt(60),clrs(2,:));vline(0,'k--');
H=patch([0 3 3 0],[0.5 0.5 0.55 0.55],[0.2157 1 1]);H.EdgeColor=[0.2157 1 1];
ylabel('Speed (cm/s)');xlabel('Time (s)');
[~,P1]=ttest2(d1L(:,69),bsln(:,1));
[~,P2]=ttest2(d1L(:,90),bsln(:,1));
[~,P3]=ttest2(d1L(:,120),bsln(:,1));
[~,P4]=ttest2(d2L(:,69),bsln(:,2));
[~,P5]=ttest2(d2L(:,90),bsln(:,2));
[~,P6]=ttest2(d2L(:,120),bsln(:,2));
P=[P1,P2,P3,P4,P5,P6];
disp([P<0.05;P<0.01;P<0.001]);
figure('name','shortStim');
shadedErrorBarColor(tim,nanmean(d1S),nanstd(d1S)./sqrt(60),clrs(1,:));hold on;
shadedErrorBarColor(tim,nanmean(d2S),nanstd(d2S)./sqrt(60),clrs(2,:));ylim([0 10]);%ylim([0.5 4]);
H=patch([0 0.3 0.3 0],[0.5 0.5 0.55 0.55],[0.2157 1 1]);H.EdgeColor=[0.2157 1 1];
vline(0,'k--');
ylabel('Speed (cm/s)');xlabel('Time (s)');
[~,P1]=ttest2(d1S(:,69),bsln(:,3));
[~,P2]=ttest2(d1S(:,90),bsln(:,3));
[~,P3]=ttest2(d1S(:,120),bsln(:,3));
[~,P4]=ttest2(d2S(:,69),bsln(:,4));
[~,P5]=ttest2(d2S(:,90),bsln(:,4));
[~,P6]=ttest2(d2S(:,120),bsln(:,4));
P=[P1,P2,P3,P4,P5,P6];
disp([P<0.05;P<0.01;P<0.001]);