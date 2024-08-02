function [out] = yttriViolin(xpos,SET1,SET2,freq, stat, col1, col2,bincount)
 %AsmViolin creates violin plots for two different sets of comparable data
    %   Requires two matrices or arrays as the second and third inputs, followed by two character arrays to act as labels.
    %   The FIRST input is the x position upon which the violin will be
    %   plotted.
    %   freq = 1 does frequency (all values = 1). anything else will be
    %   counts.  frequency is default
    %   Stat is whether to include a point for the mean or median of each
    %   distribution. none is default
    %   col1, col2 are color.  both [rgb] or 'm' formalisms are accepted.
    %   Nature red and blue and default
    if nargin < 4
        freq=1;
    end
    if nargin < 5
        stat=[];
    end
    if nargin <7
     col1= [1 0 0];
     col2= [0 .67 1];
    end
    if nargin <8
        [h,n] = histcounts(SET1,25);
        [j,m] = histcounts(SET2,25);
        %[h,n] = histcounts(SET1,'BinMethod','sqrt');
        %[j,m] = histcounts(SET2,'BinMethod','sqrt');

        %[h,n] = hist(SET1,20);
        %[j,m] = hist(SET2,20);
    else
       [h,n] = histcounts(SET1,'BinWidth',bincount);
       [j,m] = histcounts(SET2,'BinWidth',bincount); 
    end


if freq==1
  h=h/sum(h);
  j=j/sum(j); 
end
n=[n (max(n)+nanmean(unique(diff(n))))];
h=[0 h 0];h=h+xpos;
m=[m (max(m)+nanmean(unique(diff(m))))];
j=[0 j 0]*-1;j=j+xpos;
%figure;
plot(h,n,'color',col1);hold on
plot(j,m,'color', col2);
Up = max([n,m]);
Down = min([n,m]);
G=fill(h,n,'b');G.FaceAlpha=0.45; G.FaceColor = col1;
G.EdgeColor = col1;
G=fill(j,m,'r');G.FaceAlpha=0.45; G.FaceColor = col2;
G.EdgeColor = col2;
Lne = [Up,0+xpos;Down,0+xpos];
plot(Lne(:,2),Lne(:,1),'k')
if sum(size(SET1)) > 1+length(SET1)
    SET1=reshape(SET1,[],1);
end
if sum(size(SET2)) > 1+length(SET2)
    SET2=reshape(SET2,[],1);
end
%C=nanmean(SET1); %this is chosen kinda randomly, can be the other set
if strcmp(stat,'median')
    scatter(xpos+0.02,median(SET1,'omitnan'),'markeredgecolor', 'k','markerfacecolor',col1);
    scatter(xpos-0.02,median(SET2,'omitnan'),'markeredgecolor', 'k','markerfacecolor',col2);
elseif strcmp(stat, 'mean')
    scatter(xpos+0.02,nanmean(SET1),'markeredgecolor', 'k','markerfacecolor',col1);
    scatter(xpos-0.02,nanmean(SET2),'markeredgecolor', 'k','markerfacecolor',col2);
elseif isempty(stat)
end
Lne=cell(2,1);Lne{1,1}=n;Lne{2,1}=m;
out = Lne;
%% names1 and names2 deleted from inputs, used for plotting legend.
%legend([A,B],{name1,name2});
%Lines = cell(2);
%Lines{1,1}=name1;Lines{1,2}=name2;
%Lines{2,1} = [h;n];Lines{2,2}=[j;m];
%out = Lines;