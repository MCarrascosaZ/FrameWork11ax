function [AP,STA] = nodeLoad(AP,STA,Bmax,NodeMatrix,it)

N_STAs=length(STA);
N_APs=length(AP);


% ------------ Load AP ---------------

for j=1:N_APs
    AP(j).airtime = 0;
end

for i=1:N_STAs
   if(STA(i).nAPs>0)
        airtime = RequiredAirtimeUser(STA(i).B,STA(i).L,NodeMatrix(i+N_APs,STA(i).associated_AP));
        channel = AP(STA(i).associated_AP).channel;
        for j=1:N_APs
          if(STA(i).APs(j)>-inf && AP(j).channel == channel)     
            AP(j).airtime = AP(j).airtime + airtime;  
          end
        end
   end
end


% ------------ Received Bandwidth ---------------


for i = 1:N_STAs
    if(STA(i).associated_AP~=0)
        airtime = RequiredAirtimeUser(STA(i).B,STA(i).L,NodeMatrix(i+N_APs,STA(i).associated_AP));
        if(STA(i).nAPs > 0)
            if(AP(STA(i).associated_AP).airtime < 1)
                
                STA(i).Be = STA(i).B;
                STA(i).satisfaction = STA(i).satisfaction + 1;  
                STA(i).APs_reward(STA(i).associated_AP) = STA(i).APs_reward(STA(i).associated_AP) + 1;
            else
                STA(i).Be = STA(i).B*(airtime / AP(STA(i).associated_AP).airtime);
                STA(i).satisfaction = STA(i).satisfaction + 0; % Just a formality
                STA(i).APs_reward(STA(i).associated_AP) = STA(i).APs_reward(STA(i).associated_AP) + ((airtime /AP(STA(i).associated_AP).airtime));    % Uncomment for proportional rewards
            end
            STA(i).satisf(it)=STA(i).satisfaction;
            STA(i).accB(it)=STA(i).Be;
        else
            STA(i).Be = 0;            
        end
    else
        % Nothing for now
    end
end

