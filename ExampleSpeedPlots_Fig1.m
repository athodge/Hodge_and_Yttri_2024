%dd=movmean(sqrt(diff(ddd(:,1)).^2+diff(ddd(:,2)).^2),33);
dd=sqrt(diff(ddd(:,1)).^2+diff(ddd(:,2)).^2)*0.098;
dd=movmean(dd,8)*4;
tim=linspace(1,length(ddd)*33,length(ddd));
%sqrt(diff(ddata(2).xy(:,1)).^2+diff(ddata(2).xy(:,2)).^2);
rr=315:1211; %500:800, 200:800
tim=tim(rr-1);tim=(tim-tim(1))/1000;
dd1=dd(rr-1);
xx=ddd(rr,1)*0.098;xx=xx-min(xx);
yy=ddd(rr,2)*0.098;yy=yy-min(yy);
oopsNan=find(isnan(dd1));
colMult=1.3;
%dd1(oopsNan)=dd1(oopsNan-1);
%xx(oopsNan)=xx(oopsNan-1);
%yy(oopsNan)=yy(oopsNan-1);
figure; hold on;
for i=1:length(dd1)-1
    plot(xx(i:i+1),yy(i:i+1), 'Color',[1-dd1(i)/max(dd1), dd1(i)/max(dd1), 1-dd1(i)/max(dd1)],'linewidth',3)
    %scatter(xx(i:i+1),yy(i:i+1),'.','markeredgecolor',[1-dd1(i)/max(dd1), dd1(i)/max(dd1), 1-dd1(i)/max(dd1)]);
end
xlabel('X position (cm)');ylabel('Y position (cm)');
if 1==2
figure; subplot(311); hold on;
for i=1:length(dd1)-1
    plot(i:i+1, xx(i:i+1), 'Color',[1-dd1(i)/max(dd1), dd1(i)/max(dd1), 1-dd1(i)/max(dd1)], 'LineWidth', 3)
end
subplot(312); hold on;
for i=1:length(dd1)-1
    plot(i:i+1, yy(i:i+1), 'Color',[1-dd1(i)/max(dd1), dd1(i)/max(dd1), 1-dd1(i)/max(dd1)], 'LineWidth', 3)
end
%subplot(313); hold on;
end

figure; hold on;
for i=1:length(dd1)-1
    plot(tim(i:i+1), dd1(i:i+1), 'Color',[1-dd1(i)/max(dd1), dd1(i)/max(dd1), 1-dd1(i)/max(dd1)], 'LineWidth', 3)
end
xlabel('Time (s)')

figure;hold on;
%spds=unique(dd1);
for i=1:0.1:max(dd1)
scatter(1,i,'markerfacecolor',[1-i/max(dd1), i/max(dd1), 1-i/max(dd1)],'markeredgecolor',[1-i/max(dd1), i/max(dd1), 1-i/max(dd1)])
end
ylabel('Speed (cm/s)')