function HH_data=create_HH(aaa,data,num_65,HH_65_pcnt,HH_65_alone,HH1,HH2,...
    HH3,HH4,HH5,HH6,HH7,HH_child_total,...
    chil1,chil2,chil3,chil4,chil5)
num_65=find(strcmp(aaa(1,:),num_65)==1);
HH_65_pcnt=find(strcmp(aaa(1,:),HH_65_pcnt)==1);
HH_65_alone=find(strcmp(aaa(1,:),HH_65_alone)==1);
HH1=find(strcmp(aaa(1,:),HH1)==1);
HH2=find(strcmp(aaa(1,:),HH2)==1);
HH3=find(strcmp(aaa(1,:),HH3)==1);
HH4=find(strcmp(aaa(1,:),HH4)==1);
HH5=find(strcmp(aaa(1,:),HH5)==1);
HH6=find(strcmp(aaa(1,:),HH6)==1);
HH7=find(strcmp(aaa(1,:),HH7)==1);

HH_size=[HH1,HH2,HH3,HH4,HH5,HH6,HH7];
HH_child_total=find(strcmp(aaa(1,:),HH_child_total)==1);
chil1=find(strcmp(aaa(1,:),chil1)==1);
chil2=find(strcmp(aaa(1,:),chil2)==1);
chil3=find(strcmp(aaa(1,:),chil3)==1);
chil4=find(strcmp(aaa(1,:),chil4)==1);
chil5=find(strcmp(aaa(1,:),chil5)==1);
HH_chil=[chil1,chil2,chil3,chil4,chil5];

num_65=cell2mat(aaa(2:end,num_65));       % total elderly people
HH_65_pcnt=cell2mat(aaa(2:end,HH_65_pcnt)); % HH with old people
HH_65_alone=cell2mat(aaa(2:end,HH_65_alone));  % HH with only one old
HH_size=cell2mat(aaa(2:end,HH_size));
HH_child_total=cell2mat(aaa(2:end,HH_child_total)); % HH with children
HH_chil=cell2mat(aaa(2:end,HH_chil)); % number of kids

x=1;
DATA=[];
for i=1:size(data,1)
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
                D(D(:,3)==children(j)+2,4)=Cdata(:,4);
                     
            
            elseif N<=size(D(D(:,3)>=children(j)+2 & isnan(D(:,4)),:),1)
                Cdata=D(D(:,3)>=children(j)+2 & isnan(D(:,4)),:);
                Cdata(1:N,4)=children(j);
                D(D(:,3)>=children(j)+2 & isnan(D(:,4)),4)=Cdata(:,4);
            else
                Cdata=D(D(:,3)>=children(j)+1 & isnan(D(:,4)),:);
                if N<=size(Cdata,1)
                        Cdata(1:N,4)=children(j);
                        D(D(:,3)>=children(j)+1 & isnan(D(:,4)),4)=Cdata(:,4);
                        
                    else
                        Cdata(:,4)=children(j);
                        D(D(:,3)>=children(j)+1 & isnan(D(:,4)),4)=Cdata(:,4);
                        extra_child(i,children(j))=N-size(Cdata,1);
                    end
                end
            end
        end
    
    
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
        f=find(D(:,3)>2);
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
