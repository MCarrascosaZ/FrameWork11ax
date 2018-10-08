
function [AirTimePercentage]=RequiredAirtimeUser(B,L,Pt)
% B: Load (bps) required by that user (i.e., 10 Mbps)
% L: packet size (bits)

%d=5; %m, distance from the AP
%Pt=100; %mW transmission power
W=20; % 20 MHz channel
MaxAMPDU = 1; % Let's us limit to 1 packet (so, no packet aggregation)
SUSS = 1; % Spatial streams, let's say 1

[T,T_c,Na_rate]=SUtx80211ax_BB_M(L,Pt);
AirTimePercentage = (B/L) * (T + (7.5 * 9E-06)); % Assuming everyone has CW = 16
%>= 0.99
if(AirTimePercentage >1) 
    %disp('Error-We cannot transmit that amount of traffic');
    AirTimePercentage = 1;
end

end
