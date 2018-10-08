% Input parameters
% - L: packet size (from network layer)
% - Na: Number of aggregated packets in an A-MPDU
% - W: RU size OFDMA (channel width)
% - SUSS: Single-User Spatial Streams
% - d: distance

% Instead of d, is it possible to use the SNR?

function [T,T_c,Na_rate]=SUtx80211ax_BB_M(L,Pt)

MaxNa=1;
W=20;
SUSS=1;

  % Load 802.11ax parameters

  % MAC
  [DIFS,SIFS,Te,L_MACH,L_BACK,L_RTS,L_CTS,L_SF,L_DEL,L_TAIL]=MACParams80211ax(1); % Single User
  
  % PHY
  [T_OFDM,T_OFDM_Legacy,Legacy_PHYH,HE_PHYH]=PHYParams80211ax_BB(SUSS);
  
  % Modulation and Coding
  [BOS,BOS20]=operateax(Pt);
    
  % Duplicate RTS/CTS for bandwidth allocation
%   T_RTS  = Legacy_PHYH + ceil((L_SF+L_RTS+L_TAIL)/BOS20)*T_OFDM_Legacy;
%   T_CTS  = Legacy_PHYH + ceil((L_SF+L_CTS+L_TAIL)/BOS20)*T_OFDM_Legacy;
  
  % After successful acquisition of the channel
  
  T_DATA = -1;
  Na_rate = 1;
  for Na=1:MaxNa
      T_DATA_prev = (Legacy_PHYH + HE_PHYH) + ceil((L_SF+Na*(L_DEL+L_MACH+L)+L_TAIL)/BOS)*T_OFDM;
  
      if(T_DATA_prev > 5.484E-3)
          
          %disp(Na);
          %disp(T_DATA_prev);
         break;
      else
         %T_DATA_prev > 5.484E-3;
         Na_rate = Na;
         T_DATA = T_DATA_prev;  
      end
  end
  
  %if(Na < 256)
  %  disp([Na_rate Na]);
  %  disp([T_DATA T_DATA_prev]);
  %  pause
  %end
  
  
  
  T_BACK = Legacy_PHYH + ceil((L_SF+L_BACK+L_TAIL)/BOS20)*T_OFDM_Legacy;
   
  % Successful slot
  %T = T_RTS + SIFS + T_CTS + SIFS + T_DATA + SIFS + T_BACK + DIFS + Te; % (Implicit BACK request)
  T = T_DATA + SIFS + T_BACK + DIFS + Te; % (Implicit BACK request)
  
  % Collision slot
  %T_c = T_RTS + SIFS + T_CTS + DIFS + Te;
  T_c = T;
end