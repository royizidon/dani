%%%%% models parameters
estimated_HH_size=3.35;
% xls should contain only numbers or empty cells except to first line
[raw_data,colmn_names]=open_data('SA_data_1.xlsx');
stat='locality_stat';
HH_total='households.hh_total_thou';
pop_size='pop2014.pop';
Average_HH_size='households.size_avg';

data=start_HH(raw_data,estimated_HH_size,stat,HH_total,pop_size,Average_HH_size);
%%% data includes zone, num hh/1000, pop size, number  hh 2008, number of HH 2014, 
%%% HH parameters
num_65='demog_yishuv.age_65_up';
HH_65_pcnt='households.hh65_pcnt'
HH_65_alone='Ages.65LiveAlone65_pcnt'
HH1='households.size1_pcnt';
HH2='households.size2_pcnt';
HH3='households.size3_pcnt';
HH4='households.size4_pcnt';
HH5='households.size5_pcnt';
HH6='households.size6_pcnt';
HH7='households.size7up_pcnt';
HH_child_total='households.hh0_17_pcnt';
chil1='households.hh0_17_1_pcnt';
chil2='households.hh0_17_2_pcnt';
chil3='households.hh0_17_3_pcnt';
chil4='households.hh0_17_4_pcnt';
chil5='households.hh0_17_5_pcnt';

HH_data=create_HH(raw_data,data,num_65,HH_65_pcnt,HH_65_alone,HH1,HH2,...
HH3,HH4,HH5,HH6,HH7,HH_child_total,...
chil1,chil2,chil3,chil4,chil5);


% set individuals data:
Individuals_data=set_Ind_data(HH_data);

% labor
stat_Labor_Force='LaborForce.LaborForceY_pcnt'; % want to work
stat_Labor_work='LaborForce.Wrk2008Y_pcnt'; % work
income1='income.q1';income2='income.q2';income3='income.q3';
income4='income.q4';income5='income.q5';income6='income.q6';
income7='income.q7';income8='income.q8';income9='income.q9';
 income10='incoome.q10';

Individuals_data=labor(raw_data,Individuals_data,stat_Labor_Force,stat_Labor_work...
,income1,income2,income3,income4,income5,income6,income7,income8,income9,income10);    



%%%%%
income_p=xlsread('Income_zidon.xlsx');
for i=1:10
    inc=income_p(i,2):income_p(i,3);
    asiron=Individuals_data(:,7)==i;
    Individuals_data(asiron,14)=datasample(inc,sum(asiron));
end

Individuals_data(Individuals_data(:,7)>15000,7)=nan;
    
% % % HH_labors
works=Individuals_data(:,6)==2;
[u1,u2,u3]=unique(Individuals_data(works,2));
countElA=histc(Individuals_data(works,2),u1); %# get the count of elements
[locA,locB]=ismember(HH_data(:,2),u1);
HH_data(locA,6)=countElA;

% % % disabilitie
dis1='disabilities.hear5_pcnt';  
dis2='disabilities.see5_pcnt';
dis3='disabilities.remember5_pcnt';
dis4='disabilities.dress5_pcnt';
dis5='disabilities.walk5_pcnt';
create_disabilities(raw_data,Individuals_data,dis1,dis2,dis3,dis4,dis5,stat);

% income_medianWage=cell2mat(aaa(2:end,[1,143]));
  % car by regresion HH divide by asiron and size.
  

