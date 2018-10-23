% In this file we generate a network of links (between the AP and a node).

function [AP,STA,NodeMatrix,shadowingmatrix]=CreateNetwork(N_APs,N_STAs,L,CWmin,SLOT,cluster,fid)

MaxChannels = 8;
%Bmax=10E06;
EB=(CWmin-1)*SLOT/2;

MaxX=50;
MaxY=50;

%disp('Density of APs');
%disp(N_APs/(MaxX*MaxY));

if(fid==-1)
    disp('Invalid file name, using random scenario');
    
else
    l=textscan(fid,'%c, %f, %f');
    N_APs=sum(count(l{1,1},'a'));
    N_STAs=sum(count(l{1,1},'s'));
end




for j=1:N_APs
    
    AP(j).channel=j;%ceil(MaxChannels*rand());    
    if(fid==-1)
        AP(j).x = MaxX*rand();
        AP(j).y = MaxY*rand();    
    else
        AP(j).x = l{1,2}(j);
        AP(j).y = l{1,3}(j); 
    end
        
    AP(j).stas = 0;
    AP(j).EB=EB;
    AP(j).L=L;
    AP(j).CCA=-82;
    AP(j).CW=CWmin;
    AP(j).airtime = 0;
    
end

% Comment this switch if you want random AP placement
% switch N_APs
%     case 2
%         AP(1).x=MaxX/3;
%         AP(1).y=MaxY/2;
%         AP(2).x=(MaxX/3)*2;
%         AP(2).y=MaxY/2;
%     case 3
%         AP(1).x=MaxX/4;
%         AP(1).y=MaxY/2;
%         AP(2).x=(MaxX*2/4);
%         AP(2).y=(MaxX/2);
%         AP(3).x=MaxX*3/4;
%         AP(3).y=(MaxY/2);
%     case 4
%         AP(1).x=MaxX/3;
%         AP(1).y=MaxY/3;
%         AP(2).x=(MaxX/3)*2;
%         AP(2).y=(MaxX/3)*2;
%         AP(3).x=MaxX/3;
%         AP(3).y=(MaxY/3)*2;
%         AP(4).x=(MaxX/3)*2;
%         AP(4).y=MaxY/3;
%     case 16
%         for i=1:4            
%             for j=1:4                
%                 AP(j+(4*(i-1))).x=(MaxX/5)*mod(i-1,4)+(MaxX/5);
%                 AP(j+(4*(i-1))).y=(MaxY/5)*mod(j-1,4)+(MaxY/5);
%             end            
%         end
%     
% end



for i=1:N_STAs
    if(cluster==0)
        if(fid==-1)
            STA(i).x = rand()*MaxX;%*33.343+8.327;   % uniform distribution for the STAs when using 3 APs
            STA(i).y = rand()*MaxY;%10+20;
        else
            STA(i).x = l{1,2}(i+N_APs);
            STA(i).y = l{1,3}(i+N_APs);
        end
            
    else
       if(mod(i-1,10)==0)
           centerx = (MaxX-5 - 5)*rand()+5;
           centery = (MaxY-5 - 5)*rand()+5;
       end
     

       STA(i).x = ((centerx+5) - (centerx-5))*rand() + (centerx-5);
       STA(i).y = ((centery+5) - (centery-5))*rand() + (centery-5);
           
    end
    STA(i).L=L;
    STA(i).CCA=-82;
    STA(i).CW=CWmin;

%%% Boris
    STA(i).B = 10E06;  %ceil(Bmax*rand());
    STA(i).APs = -inf.*ones(1,N_APs);
    STA(i).d_APs = -inf.*ones(1,N_APs);
    STA(i).nAPs = 0;
    STA(i).Be = 0;
    STA(i).satisfaction = 0;
    STA(i).accB=0;
    STA(i).associated_AP = 0;
    STA(i).ass=zeros(1,N_APs);
    STA(i).APs_range = 0;
    STA(i).APs_reward = zeros(1,N_APs);
    


end


% Interference at every destination

PTdBm = 20;
Pn=10^(-90/10);
PLd1=40.05;
shawdowing = 0;

shadowingmatrix = shawdowing*randn(N_APs+N_STAs);
%shadowingmatrix = triu(shadowingmatrix)+triu(shadowingmatrix)';


fc=5; %Working in 5 Ghz
d_walls=10;%distance between walls
NodeMatrix=zeros(N_APs+N_STAs);
for i=1:N_APs+N_STAs
    for j=1:N_APs+N_STAs
        if(i<=N_APs && j<=N_APs)
            d=sqrt((AP(i).x-AP(j).x)^2+(AP(i).y-AP(j).y)^2);            
            PL = PLd1 + 20*log10(fc/2.4) +20*log10(min(d,10))+(d>=10)*35*log10(d/10) +7*(d/d_walls)+shadowingmatrix(i,j) ;
            NodeMatrix(i,j)=PTdBm-PL;
        end
        if(i<=N_APs && j>N_APs)
            d=sqrt((AP(i).x-STA(j-N_APs).x)^2+(AP(i).y-STA(j-N_APs).y)^2);
            STA(j-N_APs).d_APs(i)=d;            
            PL = PLd1 + 20*log10(fc/2.4) +20*log10(min(d,10))+(d>=10)*35*log10(d/10) +7*(d/d_walls)+shadowingmatrix(i,j) ;            
            NodeMatrix(i,j)=PTdBm-PL;
        end
        if(i>N_APs && j<=N_APs)
            d=sqrt((STA(i-N_APs).x-AP(j).x)^2+(STA(i-N_APs).y-AP(j).y)^2);           
            PL = PLd1 + 20*log10(fc/2.4) +20*log10(min(d,10))+(d>=10)*35*log10(d/10) +7*(d/d_walls)+shadowingmatrix(i,j) ;
            NodeMatrix(i,j)=PTdBm-PL;
        end
        if(i>N_APs && j>N_APs)
            d=sqrt((STA(i-N_APs).x-STA(j-N_APs).x)^2+(STA(i-N_APs).y-STA(j-N_APs).y)^2);           
            PL = PLd1 + 20*log10(fc/2.4) +20*log10(min(d,10))+(d>=10)*35*log10(d/10) +7*(d/d_walls)+shadowingmatrix(i,j) ;
            NodeMatrix(i,j)=PTdBm-PL;
        end
    end
end

 NodeMatrix(NodeMatrix==inf)=0;
 NodeMatrix(isnan(NodeMatrix))=0;

end
