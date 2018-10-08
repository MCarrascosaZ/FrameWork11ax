function [AP,STA,Associated]=SSFAssoc(AP,STA,NodeMatrix)

N_APs=length(AP);
N_STAs=length(STA);
Associated=zeros(N_STAs,N_APs);

for i=1:N_STAs
    highest_RP=STA(i).CCA;
    minx=0;
    miny=0;
    for j=1:N_APs
        if(NodeMatrix(i+N_APs,j)>highest_RP)
            highest_RP=NodeMatrix(i+N_APs,j);
            STA(i).APs(j)=highest_RP;
            minx=i;
            miny=j;
        end
    end
    if(minx~=0 && miny~=0)
        Associated(minx,miny)=1;
        STA(i).associated_AP=miny;
    end
end

for i=1:N_APs    
    AP(i).stas=sum(Associated(:,i));
end

end