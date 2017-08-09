function Individuals_data=create_disabilities(aaa,Individuals_data,dis1,dis2,dis3,dis4,dis5,stat)
dis1=find(strcmp(aaa(1,:),dis1)==1);
dis2=find(strcmp(aaa(1,:),dis2)==1);
dis3=find(strcmp(aaa(1,:),dis3)==1);
dis4=find(strcmp(aaa(1,:),dis4)==1);
dis5=find(strcmp(aaa(1,:),dis5)==1);
stat=find(strcmp(aaa(1,:),stat)==1);
disabiliti=cell2mat(aaa(2:end,[stat,dis1,dis2,dis3,dis4,dis5]));
% dis2=cell2mat(aaa(2:end,dis2));
% dis3=cell2mat(aaa(2:end,dis3));
% dis4=cell2mat(aaa(2:end,dis4));
% dis5=cell2mat(aaa(2:end,dis5));
% 
% disabiliti=[dis1,dis2,dis3,dis4,dis5];
% regression
% independent: % old % income % work
% dependent: % disa

u=unique(Individuals_data(:,1));
u(isnan(u))=[];
work=[];
for i=1:length(u)
s_data=Individuals_data(Individuals_data(:,1)==u(i),:);
s=size(s_data,1);
old(i,1)=sum(s_data(:,5)==3)/s;
adults(i,1)=sum(s_data(:,5)==2)/s;
kids(i,1)=sum(s_data(:,5)==1)/s;
work(i,1)=sum(s_data(:,6)==2)/s;
countElA=histc(s_data(:,7),[1:10]); %# get the count of elements
inc(i,:)=countElA/s';
disa(i,:)=disabiliti(disabiliti(:,1)==u(i),2:end);
% incomeWedge(i,:)=income_medianWage(income_medianWage(:,1)==u(i),2);
end
Olds=find(Individuals_data(:,5)==3);
Kids=find(Individuals_data(:,5)==1);
Adults=find(Individuals_data(:,5)==2);
Individuals_data(:,8:13)=0;
for i=1:size(disa,2)
y=disa(:,i)/100;
x=[old,adults,kids];
yy=isnan(y);
x(yy,:)=[];
y(yy)=[];
yy=x(:,1)==0 | x(:,2)==0 | x(:,3)==0;
x(yy,:)=[];
y(yy)=[];
B=x\y;
[b,bint,r,rint,stats] = regress(y,x);
dis1_old=datasample(Olds,round(length(Olds)*b(1)),'replace',false);
Individuals_data(dis1_old,i+7)=1;
 dis1_adults=datasample(Adults,round(length(Adults)*b(2)),'replace',false);
 Individuals_data(dis1_adults,i+7)=1;
 if round(length(Kids)*b(3))>0
dis1_kids=datasample(Kids,round(length(Kids)*b(3)),'replace',false);
Individuals_data(dis1_kids,i+7)=1;
 else
     round(length(Kids)*b(3))
 end
end
DISA=sum(Individuals_data(:,8:13),2);
DISA=DISA>0;
Individuals_data(DISA,9)=1;
Individuals_data(:,8)=Individuals_data(:,14);
Individuals_data(:,10:14)=[];

