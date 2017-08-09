function Individuals_data_labor=labor(aaa,Individuals_data,stat_Labor_Force,stat_Labor_work...
,income1,income2,income3,income4,income5,income6,income7,income8,income9,income10);    

stat_Labor_Force=find(strcmp(aaa(1,:),stat_Labor_Force)==1);
stat_Labor_work=find(strcmp(aaa(1,:),stat_Labor_work)==1);
income1=find(strcmp(aaa(1,:),income1)==1);
income2=find(strcmp(aaa(1,:),income2)==1);
income3=find(strcmp(aaa(1,:),income3)==1);
income4=find(strcmp(aaa(1,:),income4)==1);
income5=find(strcmp(aaa(1,:),income5)==1);
income6=find(strcmp(aaa(1,:),income6)==1);
income7=find(strcmp(aaa(1,:),income7)==1);
income8=find(strcmp(aaa(1,:),income8)==1);
income9=find(strcmp(aaa(1,:),income9)==1);
income10=find(strcmp(aaa(1,:),income10)==1);
income=[income1,income2,income3,income4,income5...
    income6,income7,income8,income9,income10];

%%labor
stat_Labor_Force=cell2mat(aaa(2:end,stat_Labor_Force)); % want to work
stat_Labor_work=cell2mat(aaa(2:end,10)); % work
income=cell2mat(aaa(2:end,income))./100;
Mean_income=nanmean(income);
u=unique(Individuals_data(:,1));
u(isnan(u))=[];
Individuals_data_labor=[];
HH_data(:,6)=0;
for i=1:length(u)
s_data=Individuals_data(Individuals_data(:,1)==u(i),:);
labor_force=find(s_data(:,5)==2);
want_work=datasample(labor_force,round(length(labor_force).*stat_Labor_Force(i)/100),'replace',false);
s_data(want_work,6)=1;
work=datasample(labor_force,round(length(want_work).*stat_Labor_work(i)/100),'replace',false);
s_data(work,6)=2;
income(i,isnan(income(i,:)))=Mean_income(isnan(income(i,:)));
income(i,:)=income(i,:)/sum(income(i,:));

s_data(work,7)=randsrc(length(work),1,[1:10;income(i,:)]);
Individuals_data_labor=[Individuals_data_labor;s_data];

end

