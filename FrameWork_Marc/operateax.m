function [BOS,BOS20]=operateax(x)



%%%%%%%
NSC_Leg=52;
 NSC=234;

if (x>=-82 && x<-79)
    %BPSK cr 1/2
    BOS= (NSC * 1 * (1/2));    %26-->6.5Mbps
    BOS20= (NSC_Leg * 1 * (1/2));
else if(x>=-79 && x<-77)
        %QPSK cr 1/2
         BOS= (NSC * 2 * (1/2));    %52-->13Mbps
         BOS20= (NSC_Leg * 2 * (1/2));
    else if(x>=-77 && x<-74)
            %QPSK 3/4
             BOS= (NSC * 2 * (3/4));    %78-->19,5Mbps
             BOS20= (NSC_Leg * 2 * (3/4)); 
        else if(x>=-74 && x<-70)
                %16-QAM 1/2
                BOS= (NSC * 4 * (1/2)); %104-->26Mbps
                 BOS20= (NSC_Leg * 4 * (1/2));
            else if(x>=-70 && x<-66)
                    %16-QAM 3/4
                    BOS= (NSC * 4 * (3/4)); %156-->39Mbps
                     BOS20= (NSC_Leg * 4 * (3/4));
                else if(x>=-66 && x<-65)
                        %64-QAM 2/3
                        BOS= (NSC * 6 * (2/3)); %208-->52Mbps
                         BOS20= (NSC_Leg * 6 * (2/3));
                    else if(x>=-65 && x<-64)
                            %64-QAM 3/4
                            BOS= (NSC * 6 * (3/4)); %234-->58.5Mbps
                             BOS20= (NSC_Leg * 6 * (3/4));
                        else if(x>=-64 && x<-59)
                                %64-QAM 5/6
                                BOS= (NSC * 6 * (5/6)); %260-->65Mbps
                                 BOS20= (NSC_Leg * 6 * (5/6));
                            else if(x>=-59 && x<-57)
                                    %256-QAM 3/4
                                    BOS= (NSC * 8 * (3/4)); %312-->78Mbps
                                     BOS20= (NSC_Leg * 8 * (3/4));
                                else if(x>=-57 && x<-54)
                                        %256-QAM 5/6
                                        BOS= (NSC * 8 * (5/6)); %346.67-->86,67Mbps
                                         BOS20= (NSC_Leg * 8 * (5/6));
                                    else if(x>=-54 && x<-51)
                                            %1024-QAM 3/4
                                            BOS= (NSC * 10 * (3/4)); %
                                             BOS20= (NSC_Leg * 10 * (3/4));
                                        else if(x>=-51)
                                                %1024-QAM 5/6
                                                  BOS= (NSC * 10 * (5/6)); %
                                                   BOS20= (NSC_Leg * 10 * (5/6));
                                            end
                                        end                                       
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end







end