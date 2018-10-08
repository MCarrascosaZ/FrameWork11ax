
function [T_OFDM,T_OFDM_Legacy,Legacy_PHYH,HE_PHYH_SU,HE_PHYH_MU_TG,HE_PHYH_MU]=PHYParams80211ax_BB(SUSS)
  
  
  % Physical Header (Legacy, to be added to the others)
  % ------------------------------------------------------------------
  Legacy_PHYH = 20E-6;
 
  % HE SU Format -----------------------------------------------------
  % ------------------------------------------------------------------
  HE_PHYH_SU = (16 + SUSS*16)*1E-6;
  
  % HE MU Format after trigger (for MU-UPLINK)
  % ------------------------------------------------------------------  
  HE_PHYH_MU_TG = (20 + SUSS*16)*1E-6;
  
  % HE MU Format -----------------------------------------------------
  % ------------------------------------------------------------------
  HE_PHYH_MU = (12 + 64 + SUSS*16)*1E-6; % It is the worst case (64 us, 16 symbols SIG B)  
  
  % OFDM SYMBOL DURATION ---------------------------------------------
  % ------------------------------------------------------------------
  T_OFDM_Legacy = 4E-6;
  T_OFDM = 16E-6;  % Duration of OFDM symbol (CP of 3.2us is included)
end
