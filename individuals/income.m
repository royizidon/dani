function Individuals_data=income(Individuals_data,excel)
income_p=xlsread(excel);
for i=1:10
    inc=income_p(i,2):income_p(i,3);
    asiron=Individuals_data(:,7)==i;
    Individuals_data(asiron,14)=datasample(inc,sum(asiron));
end
Individuals_data(Individuals_data(:,7)>15000,7)=nan;
hist(Individuals_data(:,7))