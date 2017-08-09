function data=start_HH(aaa,estimated_HH_size,stat,HH_total,pop_size,Average_HH_size)
%find col number
stat=find(strcmp(aaa(1,:),stat)==1);
HH=find(strcmp(aaa(1,:),HH_total)==1);
pop=find(strcmp(aaa(1,:),pop_size)==1);
Average_HH_size=find(strcmp(aaa(1,:),Average_HH_size)==1);
% set data
data=cell2mat(aaa(2:end,[stat,HH,pop]));
Average_HH_size=cell2mat(aaa(2:end,Average_HH_size));
Average_HH_size(isnan(Average_HH_size) | Average_HH_size==0)=estimated_HH_size; 
% calculate number of HH according to pop 2014
data(:,5)=data(:,3)./Average_HH_size;
data(:,4)=data(:,2).*1000;
