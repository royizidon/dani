function [raw_data1,colmn_names]=open_data(name,colmn_names)
[a,aa,raw_data]=xlsread(name);
colmn_names=char(raw_data(1,:));
bad=[0;sum(isnan(cell2mat(raw_data(2:end,:))),2)];
raw_data1=raw_data(bad<80,:);








