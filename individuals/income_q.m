function Individuals_data=income_q(Individuals_data,excel1)
income_p=xlsread(excel1);
for i=1:10
    inc=income_p(i,2):income_p(i,3);
    asiron=Individuals_data(:,7)==i;
    Individuals_data(asiron,14)=datasample(inc,sum(asiron));
end
Individuals_data(Individuals_data(:,7)>15000,7)=nan;