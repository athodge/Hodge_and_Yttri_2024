function[]=hodgeViolin2(in1,in2,col1,col2,binWidth,offset,scl,OUTLIERS)
binRng=[min([min(in1,[],'all'),min(in2,[],'all')]),max([max(in1,[],'all'),max(in2,[],'all')])]*1.5;
binRng=binRng(1):binWidth:binRng(2);
[N1,edge1]=histcounts(in1,'BinEdges',binRng);
[N2,edge2]=histcounts(in2,'BinEdges',binRng);
N1=(N1/max(N1))*scl;
N2=(N2/max(N2))*scl;
%rng=[min([edge1(~isoutlier(N1)),edge2(~isoutlier(N2))]),max([edge1(~isoutlier(N1)),edge2(~isoutlier(N2))])];
if nargin>7
    rng=[min([edge1(edge1>OUTLIERS(1)),edge2(edge2>OUTLIERS(1))]),max([edge1(edge1<OUTLIERS(2)),edge2(edge2<OUTLIERS(2))])];
else
    rng=[min([edge1,edge2]),max([edge1,edge2])];
end
if N1(end)~=min(N1);N1=[N1,min(N1)];edge1=[edge1,max(edge1)];end
if N2(end)~=min(N2);N2=[N2,min(N2)];edge2=[edge2,max(edge2)];end
N1=movmean(N1,round(length(N1)/5));N2=movmean(N2,round(length(N2)/5));
if N1(end)~=0;N1=[N1,0];edge1=[edge1,edge1(end)+(edge1(end)-edge1(end-1))];end
if N2(end)~=0;N2=[N2,0];edge2=[edge2,edge2(end)+(edge2(end)-edge2(end-1))];end
H=patch([min(N1),N1]+offset-min(N1),movmean(edge1,3),col1);H.FaceAlpha=0.5;hold on;
plot([min(N1),N1]+offset-min(N1),movmean(edge1,3),'color',col1,'linewidth',1.5);
H=patch(-[min(N2),N2]+offset+min(N2),movmean(edge2,3),col2);H.FaceAlpha=0.5;
plot(-[min(N2),N2]+offset+min(N2),movmean(edge2,3),'color',col2,'linewidth',1.5);
line([offset offset],rng,'linewidth',1.25,'color','k');
