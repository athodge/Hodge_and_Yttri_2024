%for paper

%load('allD_6_noUnder500.mat')
% pixels to cm
% avg <2 for 500ms




%steering group, flexible funding, program heavy

%500k
%brg(!!!)   bnvt
% cover letter, recommendation  study section, PO,
%douglas kim

% https://art.csr.nih.gov/ART/index.jsp?tabID=FA6242D2E0D971780773BDACC3F6912C24365100
% https://art.csr.nih.gov/ART/index.jsp?tabID=FA6242D2E0D971780773BDACC3F6912C24365100
clrs=[0.25,0.49,0.63;0.89,0.14,0.16;0.85,0.65,0.13;0.57,0.313,0.4];%[0,0,0.61;1,0,0;1,0.75,0;0.75,0.25,0.75];
block=2;
close all;
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',13);


trigVelSize=22:90;
sigMin=.05;
sigMin2=.0001;

%109,110 = inter-stop interval
%111,112 = stop dur
%113, 114 = movement distance
%115, 116 = avg peak speed

%100ms resolution. 10hz
%distMinute is accurate mean dist/min traveled
%velperMin is mean speed per minute
%dp1 = change in position
%rmt is a thing...  same as number of bouts
% stop determined as moving less that 2.5 (stopcut)
%trigTime seems wayy too often
%movDur is clear, but movP(oint) is start of each move bout?
%movTraj is the speed? of each move's trajectory.  realMovTraj is close but
%more selective?
%moveTrajA is Aligned. -5 to +30 samples

%trigStop to show it works
%trigVel, trigVelDiff
%moveVel (change to accel) different, but peakvelMin is same
%sample x,y trace

%detected stop is between 26 and 30

%velocity doesn't change
% predict longer stops for 1 (and shorter for d2). As a consequence of
% this, you'd expect more time between stops in d2.  for d1, they're in the
% state, and break out of it.


%inter stim interval, session medians,
% kstest D1 <0.01, 1.55 1.82s
% d2 0.18   2.24 2.11s
%when only intervals under 5s are considered, both are sig
%d1 .01 , 1.39, 1.60
%d2 .003, 2.00, 1.69

%disp('can double check stops/min with new stop criterion.  also still need distance traveled?')
%movDur session medians
%kstest .47  2.93 2.66  (p stim, cont)
%.067 2.20  2.69
% both are nonsig, but a rightward shift of the distribution of low duration

%stopDur session medians
%d1 .063  2.75  2.05
%d2  .99  1.70  1.86
FIG1=figure('renderer','painters');
FIG2=figure('renderer','painters');
%%
if 1==2
    for kk=15:70
        if allD(kk).ddata(1).realExp==0
            ddata=allD(kk).ddata;
            trigStop=[];
            preTrig=29;
            postTrig=39;
            for i = ddata(1).trigTime'
                if i-preTrig>0 &&  i+postTrig<numel(ddata(2).dp1)
                    trigStop=[trigStop; ddata(1).dp1(i-preTrig:i+postTrig)'];
                end
            end
            figure(kk+400);
            semline(trigStop,1,'k');
            ylim([0 8])
            xlim([0 60])
        end
    end
end
%%
if 1==1
    %This needs to become part of a supplemental figure
for kk=64%[20,50,64,38,37]%[54,56,48,65]%1:2:length(allD) %
    ddata=allD(kk).ddata;
    trigStop=[];
    preTrig=29;
    postTrig=39;
    for i = ddata(1).trigTime'
        if i-preTrig>0 &&  i+postTrig<numel(ddata(2).dp1)
            trigStop=[trigStop; ddata(1).dp1(i-preTrig:i+postTrig)'];
        end
    end
    %set(0,'defaultFigurePosition', [100,600, 400, 600]);
    %figure(FIG1);%figure(101);
    figure('renderer','painters');
    subplot(8,16,[1:3,17:19,33:35,49:51,65:67,81:83])
    %figure(kk+300)
    imagesc(trigStop); colorbar; caxis([0 13]) %was 10
    xlim([0 60])
    colormap('bone')
end
ylabel('Stop-detection number');
xticklabels([]);
%set(0,'defaultFigurePosition', [100,600, 400, 200]);
subplot(8,16,[113:115]);%figure(102);
semline(trigStop,1,'k');
hold on;
   h=fill([25,30,30,25],[0,0,8,8],'k');
h.EdgeColor='k';
h.EdgeAlpha=0.3; h.FaceAlpha=0.1;
colorbar
ylim([0 8])
xlim([0 60])
vline(preTrig+1,'k'); vline(preTrig-3.5,'k');
vline([25,30],'k');
xticks([0 25.5 50.5])
xticklabels([-2.5 0 2.5]);
xlabel('Time (s)');
ylabel('Speed (cm/s)')
title('avg vel@ trig')
end

%%
trigMins=[]; velMins=[]; stopMins=[];
trigVels=[]; stopVels=[]; movVels=[];
distts=[];
stimData=[]; contData=[];
stopD=[]; movD=[];

dLeng=length(allD);
for j = 1:dLeng
    ddata=allD(j).ddata; %new
    mousenum = ddata(1).mouseNum;
    strain=ddata(1).strain;
    realExp=ddata(1).realExp;
    sess=j;
    
    
    
    for i=1:3
        trigMins = [trigMins; [j,strain, realExp,i,hist(ddata(i).trigTime,300:600:12000)]];
        stopMins = [stopMins; [j,strain, realExp,i,hist(ddata(i).stopP,300:600:12000)]];
        velMins = [velMins;  [j,strain, realExp,i,ddata(i).velPerMin']];
        stopVels= [stopVels; [repmat([j,strain, realExp,i],size(ddata(i).stopTrajA,1),1), ddata(i).stopTrajA]];
        movVels= [movVels; [repmat([j,strain, realExp,i],size(ddata(i).movTrajA,1),1), ddata(i).movTrajA]];
        trigVels= [trigVels; [repmat([j,strain, realExp,i],size(ddata(i).trigPos,1),1), ddata(i).trigPos]];
        distts= [distts; [j,strain, realExp,i, nansum(ddata(i).dp1)]];
        stopD= [stopD; [j,strain, realExp,i, nansum(ddata(i).stopDur)]];
        movD= [movD; [j,strain, realExp,i, nansum(ddata(i).movDur)]];
    end
    
end
%for session: stopMin, trigMin

if 1==2
    dataVals=   {trigMins stopMins velMins, stopVels,  movVels,  distts};
    dataNames={'trigMins' 'stopMins' 'velMins' 'stopVels' 'movVels' 'distts'};
    
    
    
    disp(' ' )
    disp(' ******** SESSION      d1 stim vs cont ******')
    for dd=1:length(dataVals)
        thisData=cell2mat(dataVals(dd));
        stimData1=thisData(thisData(:,2)==1 & thisData(:,3)==1 & thisData(:,4)==2,5:end);
        contData1=thisData(thisData(:,2)==1 & thisData(:,3)==0 & thisData(:,4)==2,5:end);
        
        if 1==2
            figure('renderer','painters')
            [pval,ddiff]=ttest3(stimData1, contData1);
            if pval<0.2
                disp([  dataNames(dd), num2str(pval), 'stim > by ', num2str(ddiff)])
                disp(' ' )
            end
            
            if dd<5
                subplot(2,2,dd); hold on
                semline(contData1,3,'k');
                semline(stimData1,3,'b');
                title(dataNames(dd))
                if dd==1
                    subplot(224);    title('d1 stim vs cont')
                end
            end
        end %1==2
    end
    
    
    
    disp(' ' )
    disp(' ******** SESSION      d2 stim vs cont ******')
    for dd=1:length(dataVals)
        thisData=cell2mat(dataVals(dd));
        stimData1=thisData(thisData(:,2)==2 & thisData(:,3)==1 & thisData(:,4)==2,5:end);
        contData1=thisData(thisData(:,2)==2 & thisData(:,3)==0 & thisData(:,4)==2,5:end);
        
        
        if 1==2
            figure('renderer','painters')
            [pval,ddiff]=ttest3(stimData1, contData1);
            if pval<0.2
                disp([  dataNames(dd), num2str(pval), 'stim > by ', num2str(ddiff)])
                disp(' ' )
            end
            
            if dd<5
                subplot(2,2,dd); hold on
                semline(contData1,3,'k');
                semline(stimData1,3,'m');
                title(dataNames(dd))
                if dd==1
                    subplot(224);    title('d2 stim vs cont')
                end
            end
        end %1==2
        
    end
    
end

%% vels
dataVals=   {trigVels stopVels movVels};
dataNames={'trigVels' 'stopVels' 'movVels'};


disp(' ' )
disp(' ******** SESSION      d1 stim vs cont ******')
for dd=1%:length(dataVals)
    thisData=cell2mat(dataVals(dd));
    stimData1=thisData(thisData(:,2)==1 & thisData(:,3)==1 & thisData(:,4)==2,5:end);
    contData1=thisData(thisData(:,2)==1 & thisData(:,3)==0 & thisData(:,4)==2,5:end);
    
    if dd==1
        jumpy=[zeros(size(stimData1,1),1),(diff(stimData1')')>12];
        stimData1(jumpy==1)=nan;
        jumpy=[zeros(size(contData1,1),1),(diff(contData1')')>12];
        contData1(jumpy==1)=nan;
        
        %set(0,'defaultFigurePosition', [400,400, 400, 200]);
        %figure(106); hold on; semline(stimData1-nanmean(contData1),4,'b');
        
        sigTrace=[];
        for tt = 1:5:size(stimData1,2)-5
            ss=stimData1(:,tt:tt+4);
            cc=contData1(:,tt:tt+4);
            sigTrace=[sigTrace,ttest2(ss(:),cc(:), 'alpha',sigMin2)];
        end
        % hold on; plot(find(sigTrace==1)*5,-.9,'b.')
    end
    
    %set(0,'defaultFigurePosition', [400,400, 400, 300]);
    figure('renderer','painters');%figure(107)
    %subplot(8,16,[5:7,21:23,37:39]);
    xlim([0 60])
    [pval,ddiff]=ttest3(stimData, contData);
    if pval<0
        disp([  dataNames(dd), num2str(pval), 'stim > by ', num2str(ddiff)])
        disp(' ' )
    end
    
    if dd<5
        %   subplot(2,2,dd);
        hold on
        semline(contData1(:,trigVelSize),3,'k');
        semline(stimData1(:,trigVelSize),3,clrs(1,:));
        h=fill([30,34.5,34.5,30],[0,0,8,8],'c');
        h.EdgeColor=[0,1,1];%'c';
        h.FaceColor = [0,1,1];
        h.EdgeAlpha=0.3; h.FaceAlpha=0.1;
        
        %  title(dataNames(dd))
        if dd==1
            ylim([0 7.5])
            vline(25,'k--')
            %  vline(preTrig+1,'c'); vline(preTrig-3.5,'c');
            % vline(55, 'k');
            
            %  subplot(224);    title('d1 stim vs cont')
        end
    end
end

hold on;
for i=1:length(sigTrace)
    if sigTrace(i)==1
        plot([i i+1]*5-25,[0,0],'color',clrs(1,:),'LineWidth',7.5)
    end
end
xticks([0 25 50])
xticklabels([]);
%xlabel('Time (s)');
ylabel('Speed (cm/s)')

%%

disp(' ' )
disp(' ******** SESSION      d2 stim vs cont ******')
for dd=1%:length(dataVals)
    thisData=cell2mat(dataVals(dd));
    stimData1=thisData(thisData(:,2)==2 & thisData(:,3)==1 & thisData(:,4)==2,5:end);
    contData1=thisData(thisData(:,2)==2 & thisData(:,3)==0 & thisData(:,4)==2,5:end);
    
    if dd==1
        jumpy=[zeros(size(stimData1,1),1),(diff(stimData1')')>12];
        stimData1(jumpy==1)=nan;
        jumpy=[zeros(size(contData1,1),1),(diff(contData1')')>12];
        contData1(jumpy==1)=nan;
        % figure(106); hold on; semline(stimData1-nanmean(contData1),4,'r');
        
        sigTrace=[];
        
        for tt = 1:5:size(stimData1,2)-5
            ss=stimData1(:,tt:tt+4);
            cc=contData1(:,tt:tt+4);
            sigTrace=[sigTrace,ttest2(ss(:),cc(:), 'alpha',sigMin2)];% .001
        end
        
        %plot([find(sigTrace==1)*5,0,'r.')
        %plot([0 121], [0 0],'k--')
    end
    
    figure('renderer','painters');%figure(108)
    %subplot(8,16,[85:87,101:103,117:119]);
    xlim([0 60])
    [pval,ddiff]=ttest3(stimData, contData);
    if pval<0
        disp([  dataNames(dd), num2str(pval), 'stim > by ', num2str(ddiff)])
        disp(' ' )
    end
    
    if dd<5
        % subplot(2,2,dd);
        hold on
        semline(contData1(:,trigVelSize),3,'k');
        semline(stimData1(:,trigVelSize),3,clrs(2,:));
        %title(dataNames(dd))
        if dd==1
            ylim([0 7.5])
            %vline(55,'k');
            % vline(preTrig+1,'c'); vline(preTrig-3.5,'c');
            h=fill([30,34.5,34.5,30],[0,0,8,8],'c');
            h.EdgeColor=[0,1,1];
            h.FaceColor=[0,1,1];
            h.EdgeAlpha=0.3; h.FaceAlpha=0.1;
            vline(25,'k--');
            %  subplot(224);    title('d2 stim vs cont')
        end
    end
end

hold on;
for i=1:length(sigTrace)
    if sigTrace(i)==1
        plot([i i+1]*5-25,[0,0],'color',clrs(2,:),'LineWidth',7.5)
    end
end
%disp('theres lots of sessions with >5 blocks, consider compressing across many')

%disp(' why have the double stop in d1? check to see if this correlates / goes away with second stim.  maybe the reason for the extra peak in d2.   also look into session by session.  lastly, figure out a good story for why other movement dynamics are or are not changed')
%disp(' solution!  d1 vMaxs are all very small, these are abortive locomotor bouts!  try to get these to be listed as stops')
%disp('also, rmtdists under 8 have a positive shift for d2 and a negative shift for d1 - but this washes out with big big values')
xticks([0 25 50])
xticklabels([-2.5 0 2.5]);
xlabel('Time (s)');
ylabel('Speed (cm/s)')

%%  inter-trig interval

trigVSvel=[];
d1trigs=[]; d1trigsSham=[]; d2trigs=[]; d2trigsSham=[];
d1trigsM=[]; d1trigsShamM=[]; d2trigsM=[]; d2trigsShamM=[];

for j = 1:dLeng
    ddata=allD(j).ddata; %new
    mousenum = ddata(1).mouseNum;
    strain=ddata(1).strain;
    realExp=ddata(1).realExp;
    sess=j;
    
    diffs1=ddata(block).trigTime; %baseline
    % diffs1(diffs1<20)=[];
    %diffs1(diffs1>11900) =[];
    
    diffs=diff(diffs1);
    diffs(diffs<8)=[];
    diffs(diffs>50)=[];
    
    trigHist=hist(diffs,1:1:60);
    if strain ==2 &  realExp==1
        % d2trigs=[d2trigs; trigHist];% /sum(trigHist)];
        d2trigs=[d2trigs; trigHist /sum(trigHist)];
        d2trigsM=[d2trigsM; [nanmean(diffs), median(diffs)]];
    elseif strain ==2 &  realExp==0
        %d2trigsSham=[d2trigsSham; trigHist];% /sum(trigHist)];
        d2trigsSham=[d2trigsSham; trigHist/sum(trigHist)];
        d2trigsShamM=[d2trigsShamM; [nanmean(diffs), median(diffs)]];
    elseif strain ==1 &  realExp==1
        %d1trigs=[d1trigs; trigHist];% /sum(trigHist)];
        d1trigs=[d1trigs; trigHist/sum(trigHist)];
        d1trigsM=[d1trigsM; [nanmean(diffs), median(diffs)]];
    elseif strain ==1 &  realExp==0
        %d1trigsSham=[d1trigsSham; trigHist];% /sum(trigHist)];
        d1trigsSham=[d1trigsSham; trigHist /sum(trigHist)];
        d1trigsShamM=[d1trigsShamM; [nanmean(diffs), median(diffs)]];
    end
    
end

%set(0,'defaultFigurePosition', [400,400, 200, 300]);
figure('renderer','painters');%figure(FIG1);
subplot(8,16,[9:11,25:27,41:43]);%figure(109); 
hold on
semline(d1trigsSham,2,'k');
semline(d1trigs,2,clrs(1,:));
xlim([6 30]);ylim([0 .13]);ylabel('Frequency');
subplot(8,16,[89:91,105:107,121:123]);%figure(110); 
hold on
semline(d2trigsSham,2,'k');
semline(d2trigs,2,clrs(2,:));
xlim([6 30]); ylim([0 .13]);
ylabel('Frequency');
xlabel('Inter Stop Interval (s)');

disp('### d1 stop inverval stim, sham ###')
[a,b]=kstest2(d1trigsM(:,2), d1trigsShamM(:,2)); %.47  2.93 2.66  (p stim, cont)
b
mean(d1trigsM)/1000
mean(d1trigsShamM)/1000
disp('~~~ d2 stop interval stim, sham ~~~ ')
[a,b]=kstest2(d2trigsM(:,2), d2trigsShamM(:,2)); %.067 2.20  2.69
% nonsig, but a rightward shift of the distribution of low duration
% movements
b
mean(d2trigsM)/1000
mean(d2trigsShamM)/1000


sigd1=[]; sigd2=[];
for i=1:30
    [a,b]=kstest2(d1trigs(:,i), d1trigsSham(:,i));
    if b<sigMin; sigd1=[sigd1,i];end
    [a,b]=kstest2(d2trigs(:,i), d2trigsSham(:,i));
    if b<sigMin; sigd2=[sigd2,i];end
end
subplot(8,16,[9:11,25:27,41:43]);%figure(109); %plot(sigd1,ones(length(sigd1)*0.01,[],'bs','filled')
for i=1:length(sigd1)
    plot([sigd1(i) sigd1(i)+1],[0 0],'color',clrs(1,:),'LineWidth',7.5)
end
%scatter(sigd1+0.5,ones(1,length(sigd1))*0.005,[],'bs','filled','SizeData',220)
%h.MarkerFaceColor = [0 0 1];
subplot(8,16,[89:91,105:107,121:123]);%figure(110);
for i=1:length(sigd2)
    plot([sigd2(i) sigd2(i)+1],[0 0],'color',clrs(2,:),'LineWidth',7.5)
end
%scatter(sigd2+0.5,ones(1,length(sigd2))*0.005,[],'rs','filled','SizeData',220)


%% new stop dur


for i = ddata(1).trigTime'
    if i-preTrig>0 &  i+postTrig<numel(ddata(1).dp1)
        trigStop=[trigStop; ddata(1).dp1(i-preTrig:i+postTrig)'];
    end
end;


trigVSvel=[];
d1trigs=[]; d1trigsSham=[]; d2trigs=[]; d2trigsSham=[];
d1trigsM=[]; d1trigsShamM=[]; d2trigsM=[]; d2trigsShamM=[];
d1ss=[];d2ss=[];  d1Shamss=[]; d2Shamss=[];

for j = 1:dLeng
    ddata=allD(j).ddata; %new
    mousenum = ddata(1).mouseNum;
    strain=ddata(1).strain;
    realExp=ddata(1).realExp;
    sess=j;
    
    trigs=ddata(block).trigTime;
    trigs(find(diff(trigs)<8)+1)=[];
    vv=ddata(block).dp1';
    diffs=[];
    speeds=[];
    for tt=trigs'
        diffs=[diffs,find(vv((tt):end)>10,1)];
        if tt<length(vv)-40; speeds=[speeds; vv(tt:(tt+39))];end
    end
    
    diffs(diffs==2)=nan;
    diffs=diffs+5;
    %diffs(diffs>15)=[];
    
    
    trigHist=hist(diffs,1:1:60);
    if strain ==2 &  realExp==1
        % d2trigs=[d2trigs; trigHist];% /sum(trigHist)];
        d2trigs=[d2trigs; trigHist /sum(trigHist)];
        d2trigsM=[d2trigsM; [nanmean(diffs), nanmedian(diffs)]];
        d2ss=[d2ss;nanmean(speeds)];
    elseif strain ==2 &  realExp==0
        %d2trigsSham=[d2trigsSham; trigHist];% /sum(trigHist)];
        d2trigsSham=[d2trigsSham; trigHist/sum(trigHist)];
        d2trigsShamM=[d2trigsShamM; [nanmean(diffs), nanmedian(diffs)]];
        d2Shamss=[d2Shamss;nanmean(speeds)];
    elseif strain ==1 &  realExp==1
        %d1trigs=[d1trigs; trigHist];% /sum(trigHist)];
        d1trigs=[d1trigs; trigHist/sum(trigHist)];
        d1trigsM=[d1trigsM; [nanmean(diffs), nanmedian(diffs)]];
        d1ss=[d1ss;nanmean(speeds)];
    elseif strain ==1 &  realExp==0
        %d1trigsSham=[d1trigsSham; trigHist];% /sum(trigHist)];
        d1trigsSham=[d1trigsSham; trigHist /sum(trigHist)];
        d1trigsShamM=[d1trigsShamM; [nanmean(diffs), nanmedian(diffs)]];
        d1Shamss=[d1Shamss;nanmean(speeds)];
    end
    
end

d1trigs(:,7)=mean([d1trigs(:,6),d1trigs(:,8)]');
d2trigs(:,7)=mean([d2trigs(:,6),d2trigs(:,8)]');
d1trigsSham(:,7)=mean([d1trigsSham(:,6),d1trigsSham(:,8)]');
d2trigsSham(:,7)=mean([d2trigsSham(:,6),d2trigsSham(:,8)]');
figure('renderer','painters');%figure(FIG1);
%figure(111); 
subplot(8,16,[13:15,29:31,45:47]);hold on
semline(d1trigsSham,2,'k');
semline(d1trigs,2,clrs(1,:));
xlim([4 35]);ylim([0 .079]);ylabel('Frequency');yticks([0.03 0.06]);
%subplot(122);
%figure(112); 
subplot(8,16,[93:95,109:111,125:127]);hold on
semline(d2trigsSham,2,'k');
semline(d2trigs,2,clrs(2,:));
xlim([4 35]); ylim([0 .079]);yticks([0.03 0.06]);
ylabel('Frequency');
xlabel('Stop duration (s)');

%title('New stopDur')


[a,b]=kstest2(d1trigsM(:,2), d1trigsShamM(:,2)); %.47  2.93 2.66  (p stim, cont)
b
mean(d1trigsM)/10
mean(d1trigsShamM)/10
[a,b]=kstest2(d2trigsM(:,2), d2trigsShamM(:,2)); %.067 2.20  2.69
% nonsig, but a rightward shift of the distribution of low duration
% movements
b
mean(d2trigsM)/10
mean(d2trigsShamM)/10


sigd1=[]; sigd2=[];
for i=1:30
    [a,b]=kstest2(d1trigs(:,i), d1trigsSham(:,i));
    if b<sigMin; sigd1=[sigd1,i];end
    [a,b]=kstest2(d2trigs(:,i), d2trigsSham(:,i));
    if b<sigMin; sigd2=[sigd2,i];end
end
figure;%figure(111); %plot(sigd1,ones(length(sigd1)*0.01,[],'bs','filled')
%subplot(8,16,[13:15,29:31,45:47]);hold on
for i=1:length(sigd1)
    plot([sigd1(i) sigd1(i)+1],[0 0],'color',clrs(1,:),'LineWidth',7.5)
end
%scatter(sigd1+0.5,ones(1,length(sigd1))*0.005,[],'bs','filled','SizeData',220)
%h.MarkerFaceColor = [0 0 1];
%figure(112);
figure;%subplot(8,16,[93:95,109:111,125:127]);hold on
for i=1:length(sigd2)
    plot([sigd2(i) sigd2(i)+1],[0 0],'color',clrs(2,:),'LineWidth',7.5)
end
%figFix(FIG1,55,1.75,'Figure1_OPENFIELDSTUFF_20230801');
%%



% this is probably done better as a batch process on the whole dataset.
% write mov1, mov2, etc
% yttriViolin(1.4, movDur, stopDur, 0, 'mean','g','r')


%for iii = 1:allDlength
%   ddata=allD(1).ddata;
%  allmovDurPre(iii,1:length(ddata(1).movDur))= ddata(1).movDur;
% movStim=ddata(block).movDur;
%movPost=ddata(3).movDur;
%
%  stopPre=ddata(1).stopDur;
% stopStim=ddata(block).stopDur;
%stopPost=ddata(3).stopDur;





%place preference
%smooth movDur - to get rid of too-short stops


%%

tMin=[]; dLeng=length(allD);
for j = 1:dLeng
    ddata=allD(j).ddata; %new
    mousenum = ddata(1).mouseNum;
    strain=ddata(1).strain;
    realExp=ddata(1).realExp;
    sess=j;
    for i=1:3
        tMin = [tMin; [j,strain, realExp,i,ddata(i).trigMinute(2,:)]];
    end
end


%%
if 1==2
    %d1 trigs
    thisData=trigMins;
    stimData1=thisData(thisData(:,2)==1 & thisData(:,3)==1 & thisData(:,4)==2,5:end); %5:end
    contData1=thisData(thisData(:,2)==1 & thisData(:,3)==0 & thisData(:,4)==2,5:end);
    [a,b]=ttest3(mean(stimData1'),mean(contData1'))
    stimTrigs=hist(mean(stimData1),30:50); contTrigs=hist(mean(contData1),30:50);
    figure; plot(stimTrigs); hold on; plot(contTrigs,'k')
    
    %d2trigs
    stimData1=thisData(thisData(:,2)==2 & thisData(:,3)==1 & thisData(:,4)==2,5:end);
    contData1=thisData(thisData(:,2)==2 & thisData(:,3)==0 & thisData(:,4)==2,5:end);
    [a,b]=ttest3(mean(stimData1'),mean(contData1'))
    stimTrigs=hist(mean(stimData1),30:50); contTrigs=hist(mean(contData1),30:50);
    figure; plot(stimTrigs,'r'); hold on; plot(contTrigs,'k')
    
    %%  distance traveled
    %d1
    thisData=distts;
    stimData1=thisData(thisData(:,2)==1 & thisData(:,3)==1 & thisData(:,4)==2,5); %5:end
    contData1=thisData(thisData(:,2)==1 & thisData(:,3)==0 & thisData(:,4)==2,5);
    [a,b]=ttest3(stimData1, contData1)
    ss=hist(stimData1,3e4:1e4:15e4); cc=hist(contData1,3e4:1e4:15e4);
    figure; plot(ss/length(stimData1),'b'); hold on; plot(cc/length(contData1),'k')
    
    %d2
    stimData1=thisData(thisData(:,2)==2 & thisData(:,3)==1 & thisData(:,4)==2,5); %5:end
    contData1=thisData(thisData(:,2)==2 & thisData(:,3)==0 & thisData(:,4)==2,5);
    [a,b]=ttest3(stimData1, contData1)
    ss=hist(stimData1,3e4:1e4:15e4); cc=hist(contData1,3e4:1e4:15e4);
    figure; plot(ss/length(stimData1),'r'); hold on; plot(cc/length(contData1),'k')
    
end

%% movement distributions
%set(0,'defaultFigurePosition', [100,600, 400, 200]);
trigVSvel=[];
d1trigs=[]; d1trigsSham=[]; d2trigs=[]; d2trigsSham=[];
d1trigsM=[]; d1trigsShamM=[]; d2trigsM=[]; d2trigsShamM=[];

for j = 1:dLeng
    ddata=allD(j).ddata; %new
    mousenum = ddata(1).mouseNum;
    strain=ddata(1).strain;
    realExp=ddata(1).realExp;
    sess=j;
    
    
    
    diffs=ddata(block).movDur; %baseline
    %diffs(diffs>10000)=[];
    trigHist=hist(diffs,0:200:15000);
    if strain ==2 &  realExp==1
        % d2trigs=[d2trigs; trigHist];% /sum(trigHist)];
        d2trigs=[d2trigs; trigHist /sum(trigHist)];
        d2trigsM=[d2trigsM; [nanmean(diffs), median(diffs)]];
    elseif strain ==2 &  realExp==0
        %d2trigsSham=[d2trigsSham; trigHist];% /sum(trigHist)];
        d2trigsSham=[d2trigsSham; trigHist/sum(trigHist)];
        d2trigsShamM=[d2trigsShamM; [nanmean(diffs), median(diffs)]];
    elseif strain ==1 &  realExp==1
        %d1trigs=[d1trigs; trigHist];% /sum(trigHist)];
        d1trigs=[d1trigs; trigHist/sum(trigHist)];
        d1trigsM=[d1trigsM; [nanmean(diffs), median(diffs)]];
    elseif strain ==1 &  realExp==0
        %d1trigsSham=[d1trigsSham; trigHist];% /sum(trigHist)];
        d1trigsSham=[d1trigsSham; trigHist /sum(trigHist)];
        d1trigsShamM=[d1trigsShamM; [nanmean(diffs), median(diffs)]];
    end
    
end


%single session trace


figure('renderer','painters');%figure(FIG2);
subplot(11,18,[6:8,24:26,42:44]);%figure(113); 
hold on
%title('movDis')
semline(d1trigsSham,2,'k');
semline(d1trigs,2,clrs(1,:));
xlim([2 25]);ylim([0 .08]);ylabel('Frequency');xlabel('Distance/bout (cm)');
subplot(11,18,[16:18,34:36,52:54]);%figure(114); 
hold on
%title('movDis')
semline(d2trigsSham,2,'k');
semline(d2trigs,2,clrs(2,:));
xlim([2 25]); ylim([0 .08]);ylabel('Frequency');xlabel('Distance/bout (cm)');

[a,b]=kstest2(d1trigsM(:,2), d1trigsShamM(:,2)); %.47  2.93 2.66  (p stim, cont)
b
mean(d1trigsM)/1000
mean(d1trigsShamM)/1000
[a,b]=kstest2(d2trigsM(:,2), d2trigsShamM(:,2)); %.067 2.20  2.69
% nonsig, but a rightward shift of the distribution of low duration
% movements
b
mean(d2trigsM)/1000
mean(d2trigsShamM)/1000

sigd1=[]; sigd2=[];
for i=1:30
    [a,b]=kstest2(d1trigs(:,i), d1trigsSham(:,i));
    if b<sigMin; sigd1=[sigd1,i];end
    [a,b]=kstest2(d2trigs(:,i), d2trigsSham(:,i));
    if b<sigMin; sigd2=[sigd2,i];end
end


subplot(11,18,[6:8,24:26,42:44]);%figure(113);
for i=1:length(sigd1)
    plot([sigd1(i) sigd1(i)+1],[0 0],'color',clrs(1,:),'LineWidth',5)
end
subplot(11,18,[16:18,34:36,52:54]);%figure(114);
for i=1:length(sigd2)
    plot([sigd2(i) sigd2(i)+1],[0 0],'color',clrs(2,:),'LineWidth',5)
end



%%  avg peak speed
trigVSvel=[];
d1trigs=[]; d1trigsSham=[]; d2trigs=[]; d2trigsSham=[];
d1trigsM=[]; d1trigsShamM=[]; d2trigsM=[]; d2trigsShamM=[];

for j = 1:dLeng
    ddata=allD(j).ddata; %new
    mousenum = ddata(1).mouseNum;
    strain=ddata(1).strain;
    realExp=ddata(1).realExp;
    sess=j;
    
    diffs1=ddata(block).movTraj; %baseline
    diffs=max(diffs1');
    diffs(diffs<8)=[];
    trigHist=hist(diffs,0:2:50);
    if strain ==2 &&  realExp==1
        % d2trigs=[d2trigs; trigHist];% /sum(trigHist)];
        d2trigs=[d2trigs; trigHist /sum(trigHist)];
        d2trigsM=[d2trigsM; [nanmean(diffs), nanmedian(diffs)]];
    elseif strain ==2 &&  realExp==0
        %d2trigsSham=[d2trigsSham; trigHist];% /sum(trigHist)];
        d2trigsSham=[d2trigsSham; trigHist/sum(trigHist)];
        d2trigsShamM=[d2trigsShamM; [nanmean(diffs), nanmedian(diffs)]];
        %  figure; imagesc(diffs1); caxis([0 30]); colorbar
    elseif strain ==1 &&  realExp==1
        %d1trigs=[d1trigs; trigHist];% /sum(trigHist)];
        d1trigs=[d1trigs; trigHist/sum(trigHist)];
        d1trigsM=[d1trigsM; [nanmean(diffs), nanmedian(diffs)]];
    elseif strain ==1 &&  realExp==0
        %d1trigsSham=[d1trigsSham; trigHist];% /sum(trigHist)];
        d1trigsSham=[d1trigsSham; trigHist /sum(trigHist)];
        d1trigsShamM=[d1trigsShamM; [nanmean(diffs), nanmedian(diffs)]];
    end
    
end

figure('renderer','painters');
subplot(11,18,[78:80,96:98,114:116]);%figure(115); %subplot(121);
hold on
semline(d1trigsSham,2,'k');
semline(d1trigs,2,clrs(1,:));
xlim([3 20]);ylim([0 .155]);ylabel('Frequency');xlabel('Peak Speed (cm/s)');
%subplot(122);
subplot(11,18,[88:90,106:108,124:126]);%figure(116)
hold on
semline(d2trigsSham,2,'k');
semline(d2trigs,2,clrs(2,:));
xlim([3 20]); ylim([0 .155]);ylabel('Frequency');xlabel('Peak Speed (cm/s)');
%title('mov Vel')

[~,b]=kstest2(d1trigsM(:,2), d1trigsShamM(:,2)); %.47  2.93 2.66  (p stim, cont)
disp(b);
mean(d1trigsM)
mean(d1trigsShamM)
[~,b]=kstest2(d2trigsM(:,2), d2trigsShamM(:,2)); %.067 2.20  2.69
% nonsig, but a rightward shift of the distribution of low duration
% movements
disp(b);
mean(d2trigsM)
mean(d2trigsShamM)

sigd1=[]; sigd2=[];
for i=1:25
    [~,b]=kstest2(d1trigs(:,i), d1trigsSham(:,i));
    if b<sigMin; sigd1=[sigd1,i];end
    [~,b]=kstest2(d2trigs(:,i), d2trigsSham(:,i));
    if b<sigMin; sigd2=[sigd2,i];end
end

subplot(11,18,[78:80,96:98,114:116]);%figure(115);
for i=1:length(sigd1)
    plot([sigd1(i) sigd1(i)+1],[0 0],'b','LineWidth',5)
end
subplot(11,18,[88:90,106:108,124:126]);%figure(116);
for i=1:length(sigd2)
    plot([sigd2(i) sigd2(i)+1],[0 0],'r','LineWidth',5)
end

%%
figure('renderer','painters');
%set(0,'defaultFigurePosition', [100,600, 400, 400]);
%bigRNG1=[1:4,19:22,37:40,55:58,73:76];
%bigRNG2=[109:112,127:130,145:148,163:166,181:184];
bigRNG1=[1:2,19:20,37:38,55:56,73:74,91,92,109,110,127,128,145,146,163,164,181,182];
bigRNG2=[3,4,21,22,39,40,57,58,75,76,93,94,111,112,129,130,147,148,165,166,183,184];
ddata=allD(7).ddata;
subplot(11,18,bigRNG1+10),%figure(151); 
hold on; grid on
ccol='br';
%plot3(ddata(2).xy(:,1),ddata(2).xy(:,2), 2001:length(ddata(2).xy(:,1))+2000,'Color',ccol(ddata(1).strain) )
plot3(ddata(2).xy(:,1),ddata(2).xy(:,2), .1:.1:length(ddata(2).xy(:,1))/10,'Color',clrs(2,:));%ccol(ddata(1).strain) )
plot3(ddata(2).xy(:,1),ddata(2).xy(:,2), ones(1,length(ddata(2).xy))*-299, 'Color',[.5 .5 .5]  )
zlim([-299 1200]);xticklabels([]);yticklabels([]);zlabel('Time (min)');
zticks([0 300 600 900 1200]);zticklabels([0 5 10 15 20]);
view([20,20]);
%set(0,'defaultFigurePosition', [100,600, 400, 800]);
ddata=allD(14).ddata;
subplot(11,18,bigRNG2+10),%figure(251); 
hold on; grid on
plot3(ddata(2).xy(:,1),ddata(2).xy(:,2), .1:.1:length(ddata(2).xy(:,1))/10,'Color','k' )
plot3(ddata(2).xy(:,1),ddata(2).xy(:,2), ones(1,length(ddata(2).xy))*-299, 'Color',[.5 .5 .5]  )
zlim([-299 1200]);%zlabel('Time (min)');
zticks([0 300 600 900 1200]);zticklabels([ ]);%zticklabels([0 5 10 15 20]);
xticklabels([]);yticklabels([]);
view([20,20]);

ddata=allD(47).ddata;
subplot(11,18,bigRNG1),%figure(152); 
hold on; grid on
plot3(ddata(2).xy(:,1),ddata(2).xy(:,2), .1:.1:length(ddata(2).xy(:,1))/10,'Color',clrs(1,:));%ccol(ddata(1).strain) )
plot3(ddata(2).xy(:,1),ddata(2).xy(:,2), ones(1,length(ddata(2).xy))*-299, 'Color',[.5 .5 .5]  )
zlim([-299 1200]);xticklabels([]);yticklabels([]);zlabel('Time (min)');
zticks([0 300 600 900 1200]);zticklabels([0 5 10 15 20]);
view([20,20]);
% set(0,'defaultFigurePosition', [100,600, 400, 800]);
 ddata=allD(50).ddata;
subplot(11,18,bigRNG2),%figure(252); 
hold on; grid on
plot3(ddata(2).xy(:,1),ddata(2).xy(:,2), .1:.1:length(ddata(2).xy(:,1))/10,'Color','k' )
plot3(ddata(2).xy(:,1),ddata(2).xy(:,2), ones(1,length(ddata(2).xy))*-299, 'Color',[.5 .5 .5] )
zlim([-299 1200]);%zlabel('Time (min)');
zticks([0 300 600 900 1200]);zticklabels([ ]);%zticklabels([0 5 10 15 20]);
xticklabels([]);yticklabels([]);
view([20,20]);


%% CPP
xdiv=468;
ydiv=297;

trigVSvel=[];
d1trigs=[]; d1trigsSham=[]; d2trigs=[]; d2trigsSham=[];
d1trigsM=[]; d1trigsShamM=[]; d2trigsM=[]; d2trigsShamM=[];

for j = 1:dLeng
    
    ddata=allD(j).ddata; %new
    mousenum = ddata(1).mouseNum;
    strain=ddata(1).strain;
    realExp=ddata(1).realExp;
    sess=j;
    
    xy=ddata(block).xy; %baseline
    pose=[];
    for p = 1:length(xy)
        if xy(p,1)>xdiv
            if xy(p,2)>ydiv
                pos=1;
            else
                pos=2;
            end
        else
            if xy(p,2)>ydiv
                pos=3;
            else
                pos=4;
            end
        end
        pose=[pose,pos];
    end
    trans1=pose(find(abs(diff(pose))>0)+1);
    if numel(unique(pose))>3
        trans=hist(trans1,numel(unique(pose)));
        if trans(4)>1500
            disp(j);
            disp(strain);
            disp(realExp);
        end
        [maxTransVal,maxTrans]=max(trans);
        [minTransVal,minTrans]=min(trans);
        
        %[~,ptrans]=ttest(trans(~ismember(1:4,maxTrans))-trans(maxTrans))  %.25, .2, .14 vs .4 is a p of 0.02
        
        
        if strain ==2 &&  realExp==1
            diffTrans=(minTransVal-min(trans(~ismember(1:4,minTrans))))/sum(trans);
            [~,pTrans]=ttest(trans(~ismember(1:4,minTrans))-trans(minTrans));
            d2trigs=[d2trigs; [pTrans, sort(trans/sum(trans))]];
            d2trigsM=[d2trigsM; diffTrans];
        elseif strain ==2 &&  realExp==0
            diffTrans=(minTransVal-min(trans(~ismember(1:4,minTrans))))/sum(trans);
            [~,pTrans]=ttest(trans(~ismember(1:4,minTrans))-trans(minTrans));
            d2trigsSham=[d2trigsSham; [pTrans, sort(trans/sum(trans))]];
            d2trigsShamM=[d2trigsShamM; diffTrans];
            %  figure; imagesc(diffs1); caxis([0 30]); colorbar
        elseif strain ==1 &&  realExp==1
            diffTrans=(maxTransVal-max(trans(~ismember(1:4,maxTrans))))/sum(trans);
            [~,pTrans]=ttest(trans(~ismember(1:4,maxTrans))-trans(maxTrans));
            d1trigs=[d1trigs; [pTrans, sort(trans/sum(trans))]];
            d1trigsM=[d1trigsM; diffTrans];
        elseif strain ==1 &&  realExp==0
            diffTrans=(maxTransVal-max(trans(~ismember(1:4,maxTrans))))/sum(trans);
            [~,pTrans]=ttest(trans(~ismember(1:4,maxTrans))-trans(maxTrans));
            d1trigsSham=[d1trigsSham; [pTrans, sort(trans/sum(trans))]];
            d1trigsShamM=[d1trigsShamM; diffTrans];
        end
        
    end
end
[~,d1pval]=ttest2(d1trigsM,d1trigsShamM);
nanmean(d1trigsM)%-nanmean(d1trigsShamM)
[~,d2pval]=ttest2(d2trigsM,d2trigsShamM);
nanmean(d2trigsM)%-nanmean(d2trigsShamM)

sum(d1trigs<.05)/length(d1trigs)
sum(d2trigs<.05)/length(d2trigs)
%%
% disp( '!!!!  !!!! !!!!! !!!!!')
% disp('Hey Alex!!')
% disp('please create bar plot d1trigsSham(:,2:5) vs d1trigs (:,2:5), d2trigsSham vs d2trigs.  will need to flip orer')
figure('renderer','painters');
subplot(11,18,[150:152,168:170,186:188]);%Bottom plot 1
bar([1.8,3.8,5.8,7.8],fliplr(nanmean(d1trigs(:,2:5))),0.4,'facecolor',clrs(1,:),'edgecolor',clrs(1,:));
hold on;
E=errorbar([1.8,3.8,5.8,7.8],fliplr(nanmean(d1trigs(:,2:5))),fliplr(sem(d1trigs(:,2:5))),'k.');
E.LineWidth=2;E.CapSize=0;
bar([1,3,5,7],fliplr(nanmean(d1trigsSham(:,2:5))),0.4,'facecolor',[0.3,0.3,0.3],'edgecolor',[0.3,0.3,0.3]);hold on;
E=errorbar([1,3,5,7],fliplr(nanmean(d1trigsSham(:,2:5))),fliplr(sem(d1trigsSham(:,2:5))),'k.');
E.LineWidth=2;E.CapSize=0;
xticks([1.4 3.4 5.4 7.4]);xticklabels(1:4);
xlim([0.5 8.3]);yticks([0.1 0.3]);
xlabel('Ranked Preference');ylabel('Frequency');

subplot(11,18,[160:162,178:180,196:198]);%Bottom plot 2
bar([1.8,3.8,5.8,7.8],fliplr(nanmean(d2trigs(:,2:5))),0.4,'facecolor',clrs(2,:),'edgecolor',clrs(2,:));
hold on;
E=errorbar([1.8,3.8,5.8,7.8],fliplr(nanmean(d2trigs(:,2:5))),fliplr(sem(d2trigs(:,2:5))),'k.');
E.LineWidth=2;E.CapSize=0;
bar([1,3,5,7],fliplr(nanmean(d2trigsSham(:,2:5))),0.4,'facecolor',[0.3,0.3,0.3],'edgecolor',[0.3,0.3,0.3]);hold on;
E=errorbar([1,3,5,7],fliplr(nanmean(d2trigsSham(:,2:5))),fliplr(sem(d2trigsSham(:,2:5))),'k.');
E.LineWidth=2;E.CapSize=0;
xticks([1.4 3.4 5.4 7.4]);xticklabels(1:4);yticks([0.1 0.3]);
xlim([0.5 8.3])
xlabel('Ranked Preference');ylabel('Frequency');
%%
if 1==2
    disp('hey, theres some really weird/poorly done sessions!!! sess 19? ')
    ccol='br';
    for kk=[7,8, 39,57, 54, 47]  %1:70
        if allD(kk).ddata(1).realExp==1
            ddata=allD(kk).ddata;
            figure(600+kk,'renderer','painters'); subplot(2,2,[1,3])
            plot3(ddata(2).xy(:,1),ddata(2).xy(:,2), 1:length(ddata(2).xy(:,1)),'Color',ccol(ddata(1).strain) )
            view([20,20])
            
            subplot(2,2,2); plot(ddata(2).xy(:,1),ddata(2).xy(:,2),'Color',ccol(ddata(1).strain) )
            subplot(2,2,4); plot(movmean(sqrt(diff(ddata(2).xy(:,1)).^2+diff(ddata(2).xy(:,2)).^2)',5))
            ylim([0 70])
            % title(num2str(nansum(sqrt(diff(ddata(2).xy(:,1)).^2+diff(ddata(2).xy(:,2)).^2))/1000))
        end
    end
end
