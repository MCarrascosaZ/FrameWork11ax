function Redraw(CCA,AP,STA,NodeMatrix,figN)

figure(figN);clf;
%CCA=-82;
N_APs=length(AP);
N_STAs=length(STA);

x=zeros(1,N_APs);
y=zeros(1,N_APs);

xn=zeros(1,N_STAs);
yn=zeros(1,N_STAs);

for i=1:length(AP)
    x(i)=AP(i).x;
    y(i)=AP(i).y;
end

for i=1:length(STA)
    xn(i)=STA(i).x;
    yn(i)=STA(i).y;
end


axes;
set(gca,'fontsize',12);

h1=scatter(x,y,30,[0 0 0],'filled'); % x,y, size, color

labels = num2str((1:size(y' ))','%d');  % variable, not function or label, numbers of each AP
labels2 = num2str((1:size(yn' ))','%d');  % variable, not function or label, numbers of each sta
text(x, y, labels, 'horizontal','left', 'vertical','bottom') % gives the number to each dot, the dot is at the left and bottom of the text
text(xn, yn, labels2, 'horizontal','left', 'vertical','bottom') % gives the number to each dot, the dot is at the left and bottom of the text

xlabel('x [meters]','fontsize',12);
ylabel('y [meters]','fontsize',12);
axis([0-5 55 0-5 55]);
hold

h2=scatter(xn,yn,40,[0.5 0.5 0.5],'^','filled');
h3=0;
for i=1:length(STA)
   
    for j=1:N_APs
%         if(NodeMatrix(i+N_APs,j)>= CCA && sum(ismember(STA(i).options(1,:),j))==1)
%             h5=line([STA(i).x,AP(j).x],[STA(i).y,AP(j).y],'Color',[0.7,0.7,0.8]); %gray?
%         end
    end
    if(STA(i).associated_AP~=0)
        h3=line([STA(i).x,AP(STA(i).associated_AP).x],[STA(i).y,AP(STA(i).associated_AP).y],'Color',[0.0,0.0,1.0]);
        %plot([STA(i).x,AP(STA(i).associated_AP).x],[STA(i).y,AP(STA(i).associated_AP).y],'Color',[0.0,0.0,1.0]);

    end
end


for i=1:N_APs
    for j=1:N_APs
        if(NodeMatrix(i,j) >= CCA && AP(i).channel==AP(j).channel)
            h4=line([AP(i).x,AP(j).x],[AP(i).y,AP(j).y],'Color',[1.0,0.0,0.0]);
            %plot([AP(i).x,AP(j).x],[AP(i).y,AP(j).y],'Color',[1.0,0.0,0.0]);
            %N_Matrix(j,i)=1;
        end
    end
    
end

if(h3==0)
    legend([h1(1),h2(1),h4(1)],'APs','STAs','Share channel','Location','best')
else
    legend([h1(1),h2(1),h3(1),h4(1)],'APs','STAs','Association','Share channel','Location','best')
end

end
