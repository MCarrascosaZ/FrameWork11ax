function [rew,STA,AP] = Main(AP,STA,assocs,seed,path)



%%%%%%%%CENTRAL PROCESSING%%%%%%%%%%%%%%%
rng('default');


CCA=-82;    %Clear Channel Assessment
N_APs=AP;  %Number of APs
N_STAs=STA;   %Number of STAs
L=12000;    %Packet size
CWmin=16;   %Minimum contention window, for every node
SLOT=9E-6;  %OFDM time slot
MaxIter=1; %Number of e-greedy iterations
rew=zeros(1,N_STAs);




rng(seed);  %Sets seed for all number generators
fid=fopen(path,'r');
[AP,STA,NodeMatrix,shadowingmatrix]=CreateNetwork(N_APs,N_STAs,L,CWmin,SLOT,0,fid);
N_APs=length(AP);
N_STAs=length(STA);
for i=1:N_STAs
    for j=1:N_APs
        if(NodeMatrix(i+N_APs,j)>=CCA)
            STA(i).nAPs=STA(i).nAPs+1;  % Number of APs in range
            STA(i).APs_range(STA(i).nAPs) = j;  % Ids of APs in range
            STA(i).APs(j)=NodeMatrix(i+N_APs,j);    % RSSI of APs in range
        end
    end
end

STAs_unassociated=zeros(1,N_STAs);
for i=1:N_STAs
    if(NodeMatrix(i+N_APs,assocs(i))>=CCA)
        STA(i).associated_AP=assocs(i);
    else
        STAs_unassociated(i)=i;
    end
end


NA_STAs=0;  % Not Associated STAs due to bad signal
for i=1:N_STAs
    if(STA(i).associated_AP==0)
        NA_STAs=NA_STAs+1;
    end
end
if(NA_STAs>0)
    disp('The following STAs are out of range of the AP');
    disp(STAs_unassociated(STAs_unassociated>0));
end
    

    
    Redraw(CCA,AP,STA,NodeMatrix,1); % Execute to see the final scenario
    
    for j=1:N_STAs
        STA(j).satisf=zeros(1,MaxIter);   % Satisfaction
        STA(j).accB=zeros(1,MaxIter);   % B
    end
    
    Bmax=4;
    
    satisfied=0;
    [AP,STA]=nodeLoad(AP,STA, Bmax,NodeMatrix,1);
    
    for j=1:N_STAs
        if(STA(j).satisf(1)==1)
            satisfied=satisfied+1;
        end
    end
    
    if(satisfied==(N_STAs-NA_STAs))
        str2='ALL STAs SATISFIED';
        disp(str2);
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    gen_satisf=zeros(N_STAs,length(STA(1).satisf)); % Stores satisfaction of entire round in a matrix
    gen_accB=zeros(N_STAs,length(STA(1).accB));
    gen_nAPs=zeros(1,N_STAs);
    for j=1:N_STAs
        gen_satisf(j,:)=STA(j).satisf;
        gen_accB(j,:)=STA(j).accB;
        gen_nAPs(j)=STA(j).nAPs;
    end
    
    
    %%%%%%%INFO%%%%%%%%%%%
    disp('Mean Satisfaction')
    disp(mean(gen_satisf));
    disp('STAs satisfied')
    s01=num2str(sum(gen_satisf));
    s02=strcat(s01,' /');
    s03=num2str(sum(N_STAs));
    s04=strcat(s02,s03);
    disp(s04);
    disp('Mean bandwidth obtained')
    disp(mean(gen_accB))
    disp('Jain index for Bandwidth obtained')
    disp(Jain(gen_accB))
    %%%%%%%%%INFO%%%%%%%%%%%%%%
    
    
    for i=1:N_STAs
        if(STA(i).associated_AP~=0)
            rew(i)=STA(i).APs_reward(STA(i).associated_AP);
        else
            rew(i)=-1;
        end
        
    end
end