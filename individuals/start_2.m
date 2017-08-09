%models parameters
% old_people_with_family=0.1;
estimated_HH_size=3.35;
%
 [a,aa,aaa]=xlsread('SA_data.xlsx');
DATA=[];

% aaa(1)={'locality_stat'};aaa(35)={'households.hh_total_thou'};aaa(154)={'pop2014.pop'};
data=cell2mat(aaa(2:end,[1,35,154]));
Average_HH_size=cell2mat(aaa(2:end,38));
Average_HH_size(isnan(Average_HH_size) | Average_HH_size==0)=estimated_HH_size; 
% calculate number of HH according to pop 2014
data(:,5)=data(:,3)./Average_HH_size;
data(:,4)=data(:,2).*1000;
% data(isnan(data(:,5)),5)=data(isnan(data(:,5)),4);
% u=unique(data(:,1));

Data=[];
% old people
num_65=cell2mat(aaa(2:end,139));       % total elderly people
HH_65_pcnt=cell2mat(aaa(2:end,37)); % HH with old people
HH_65_alone=cell2mat(aaa(2:end,2));  % HH with only one old

% HH size
HH_size=cell2mat(aaa(2:end,[39:45])); 
% HH children
HH_child_total=cell2mat(aaa(2:end,[36])); % HH with children 
HH_chil=cell2mat(aaa(2:end,[46:50])); % number of kids 
x=1;

for i=1:length(data)
    D=[];
    stat_size=round(data(i,5)); % HH according to 2014 POP SIZE
    D=[repmat(data(i),[stat_size,1])];
    D(:,2)=x:x+stat_size-1; % HH ID
    x=x+stat_size;
    
    
    %     HH size
    st=1;
    D(:,3)=nan;
    for j=1:size(HH_size,2)
        N=floor(stat_size*HH_size(i,j)/100);
        if isnan(N)==0
            D(st:N+st-1,3)=j;
            st=st+N+1;
        end
    end
    D(D(:,1)==0,:)=[];
    D(:,4:5)=nan;
    %% HH children
    children=[5,4,3,2,1];
    extra_child=nan(1,5);
    family_child=round(stat_size*HH_child_total(i)/100);
    
    for j=1:length(children)
        Cdata=[];
        Cdata=D(D(:,3)==children(j)+2,:);
        N=round(family_child*HH_chil(i,children(j))/100);
        if isnan(N)==0
            if N<=size(Cdata,1)
                Cdata(1:N,4)=children(j);
            else
                Cdata(:,4)=children(j);
                extra_child(i,children(j))=N-size(Cdata,1);
            end
            D(D(:,3)==children(j)+2,4)=Cdata(:,4);
        end
    end
    %% extra child
    
    % לא מסתדר מספר הזקנים עם מספר משקי הבית!!!!
    %         number of old people
    NUM_65=round(num_65(i)*1000);
    
    % number of HH old people
    
    % might be a problem with couples - too many old ones
    NUM_65_HH=round(HH_65_pcnt(i)*NUM_65/100);
    HH65alone=floor(NUM_65_HH*HH_65_alone(i)/100);
    HH65Couples=floor(NUM_65_HH-HH65alone);
    left_65=NUM_65-HH65alone-HH65Couples*2;
        
       % HH old people alone
    Cdata=D(D(:,3)==1,:);
    left_65_alone(i)=0;
    if isnan(HH65alone)==0
        if HH65alone<=size(Cdata,1)
            Cdata(1:HH65alone,5)=3;
            
        else
            Cdata(:,5)=3;
            left_65_alone(i)=HH65alone-size(Cdata,1);
        end
        D(D(:,3)==1,5)=Cdata(:,5);
    end   
         % HH 65 couples
    Cdata=D(D(:,3)==2,:);
    left_65_couples(i)=0;
    if isnan(HH65Couples)==0
        if HH65Couples<=size(Cdata,1)
            Cdata(1:HH65Couples,5)=6;
            
        else
            Cdata(:,5)=6;
            left_65_couples(i)=HH65Couples-size(Cdata,1);
        end
        D(D(:,3)==2,5)=Cdata(:,5);
    end
    
        % old people that live with other people
         Y=left_65+left_65_couples(i)+left_65_alone(i); % number old people live with others             
        if Y>0
         f=find(D(:,3)>1 & isnan(D(:,4)) & D(:,5)~=6);
         if Y>length(f)
             old65_problems(i)=1;
         else
        f=datasample(f, Y,'replace',false);
         
        D(f,5)=3;
         end
         end
        DATA=[DATA;D];
    end


% DATA = stat, HH ID, Individuals, childrens, old
DATA(isnan(DATA(:,3)),:)=[];
DATA(isnan(DATA))=0;

HH_data=DATA;

% set individuals data:
U=unique(DATA(:,3));
U(U==1)=[];
U(isnan(U))=[];
individuals=[];


for i=1:length(U)
    ind=DATA(DATA(:,3)==U(i),:);
    ind_no_old=repmat(ind(ind(:,5)==0,:),U(i),1);
    ind_one_old=repmat(ind(ind(:,5)==3,:),U(i),1);
    ind_one_old(sum(ind(:,5)==3)+1:end,5)=0;
    ind_2_old=repmat(ind(ind(:,5)==6,:),U(i),1);
    ind_2_old(:,5)=3;
    
    individuals=[individuals;[ind_no_old; ind_one_old;ind_2_old]];
end
individuals=[individuals;DATA(DATA(:,3)==1,:)];

individuals(individuals(:,1)==0,:)=[];

individuals=sortrows( individuals,[2,5]); % sort according to HH and than by age
u=unique(individuals(:,3)); % family size

KID_DATA=[];
for i=1:length(u)
    kid_data=individuals(individuals(:,3)==u(i),:);
    k=unique(kid_data(:,4));
    for j=1:length(k)
        kid_data_j=kid_data(kid_data(:,4)==k(j),:);
        FS=[ones(k(j),1);zeros(u(i)-k(j),1)];
        FS=repmat(FS,[size(kid_data_j,1)/size(FS,1),1]);
        size(FS,1)==size(kid_data_j,1)
        kid_data_j(FS==1,5)=1;
        KID_DATA=[KID_DATA;kid_data_j];
    end
end
Individuals_data= KID_DATA;

Individuals_data(Individuals_data(:,5)==0,5)=2;

% labor
stat_Labor_Force=cell2mat(aaa(2:end,4));
stat_Labor_work=cell2mat(aaa(2:end,10));
u=unique(Individuals_data(:,1));
u(isnan(u))=[];
Individuals_data_labor=[];
for i=1:length(u)
s_data=Individuals_data(Individuals_data(:,1)==u(i),:);
labor_force=find(s_data(:,5)==2);
want_work=datasample(labor_force,round(length(labor_force).*stat_Labor_Force(i)/100),'replace',false);
s_data(want_work,6)=1;
work=datasample(labor_force,round(length(want_work).*stat_Labor_work(i)/100),'replace',false);
s_data(work,6)=2;
Individuals_data_labor=[Individuals_data_labor;s_data];

% Labor_Force
end