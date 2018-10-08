function [DIFS,SIFS,Te,L_MACH,L_BACK,L_RTS,L_CTS,L_SF,L_DEL,L_TAIL,L_TRIGGER,L_MU_RTS,L_MUACK]=MACParams80211ax(Nsta)
  
% SUSS: number of spatial streams

% MAC parameters
 
  % DCF 
  DIFS = 34E-6; 
  SIFS = 16E-6;
  Te = 9E-6;
  
  % RTS/CTS 
  L_RTS = 160;
  L_CTS = 112;
  
  % Data Field
  % Service Field  
  L_SF = 16;
  
  % MPDU Delimiter if PA is used
  L_DEL = 32;
  
  %MAC Header including FCS
  L_MACH = 272; %320
  
  % Tail bits
  L_TAIL = 6;
  %L_TAIL = N_BCC*6;
   
  % ACK/Block ACK
  L_BACK = 112;
  %L_BACK = 240;
  %L_BACK = 432; % For up to 256 frames A-MPDU
  
  % Trigger
  L_TRIGGER = 224 + 48*Nsta;
  
  % MU-RTS
  L_MU_RTS = 216 + 40*Nsta;
  
  % MU_ACK
  L_MUACK = 176 + 96*Nsta;
  
end
   

%         ------------------------------
%         HE packet structure
%         ------------------------------
%
%         HE packet = Legacy Preamble (20us) + HE Preamble (16us + N_ss*4us) + HE Data field
%           
%             

%         - Preamble is transmitted over all the Tx antennas
%         - Data field is separated into the N_ss streams

%         HE Data field = Service field (16bits) + data bits (variable length) + N_BCC*tail bits (6bits)

