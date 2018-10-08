function [step3]=Jain(array)
step1=sum(array);
step2=sum((array.^2));
step3=step1.^2./(size(array,1)*step2);