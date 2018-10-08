%%%%%%%%CENTRAL PROCESSING%%%%%%%%%%%%%%%
rng('default');
seed=2;

CCA=-82;    %Clear Channel Assessment
N_APs=16;  %Number of APs
N_STAs=64;   %Number of STAs
L=12000;    %Packet size
CWmin=16;   %Minimum contention window, for every node
SLOT=9E-6;  %OFDM time slot
MaxIter=1; %Number of e-greedy iterations

simCounter=0;

while(true) % This entire while only makes sure that every STA senses at least one AP
    
    rng(seed+simCounter);  %Sets seed for all number generators
    [AP,STA,NodeMatrix,shadowingmatrix]=CreateNetwork(N_APs,N_STAs,L,CWmin,SLOT,0);
    for i=1:N_STAs
        for j=1:N_APs
            if(NodeMatrix(i+N_APs,j)>=CCA)
                STA(i).nAPs=STA(i).nAPs+1;  % Number of APs in range
                STA(i).APs_range(STA(i).nAPs) = j;  % Ids of APs in range
                STA(i).APs(j)=NodeMatrix(i+N_APs,j);    % RSSI of APs in range
            end
        end
    end
    [AP,STA,Associated]=SSFAssoc(AP,STA,NodeMatrix);    %   Standard SSF association
    
    NA_STAs=0;  % Not Associated STAs due to bad signal
    for i=1:N_STAs
        if(STA(i).associated_AP==0)
            NA_STAs=NA_STAs+1;
        end
    end
    if(NA_STAs>0)
        simCounter=simCounter+1;
    else
        break;
    end
end

%Redraw(CCA,AP,STA,NodeMatrix,1); % Execute to see the final scenario

for j=1:N_STAs
    STA(j).satisf=zeros(1,MaxIter);   % Satisfaction
    STA(j).accB=zeros(1,MaxIter);   % B
end

Bmax=4;

for i=1:MaxIter  %This is for algorithms, just leave it at 1 if using SSF
    satisfied=0;
    [AP,STA]=nodeLoad(AP,STA, Bmax,NodeMatrix,i);
    
    for j=1:N_STAs
        if(STA(j).satisf(i)==1)
            satisfied=satisfied+1;
        end
    end
    
    if(satisfied==(N_STAs-NA_STAs))
        str2='ALL STAs SATISFIED';
        disp(str2);
    end
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
