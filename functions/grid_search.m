%############################ grid_search.m ##############################
% Reference:"An Adaptive Method for Camera Identification
%            under Complex Radial Distortion Corrections"
%Author: Andrea Montibeller
% Work address: Universita' di Trento (DISI), via sommarive 5
% email: andrea.montibeller@unitn.it
% Website: /
% June 2022; Last revision: June 2022
% -------------------------------INPUT-------------------------------------
% Noise : test PRNU
% Fingerprint : reference fingeprint
% ri and ro :  inner and outter radii of the annulus
% theta, R, xi, yi, center, imageSize, ut, vt : reference to cartesian and polar coordinates
% transf_idx : integer to select the radial correction (or inversion) model
% -------------------------------OUTPUT------------------------------------
% alpha_k0 : best tranformation parameter for the annuli of index k_0
% phi : eq. (27) obtained with alpha_k0 for the annuli of index k_0
% W_transf :  transformed test PRNU
%##########################################################################

function [alpha_k0,phi,W_transf]=grid_search(Noise,Fingerprint,imageSize,ro,ri,r,theta,R,xi,yi,center,ut,vt, transf_idx)


alpha=[0.01 0.02 0.03 0.04 0.05 0.06 0.07];               
alpha1=[0.08 0.09 0.1 0.11 0.12 0.13 0.14];   
alpha2=[0.15 0.16 0.17 0.18 0.19 0.2 0.21];                         
alpha3=[-0.01 -0.02 -0.03 -0.04 -0.05 -0.06 -0.07];                 
alpha4=[-0.08 -0.09 -0.1 -0.11 -0.12 -0.13 -0.14];  
alpha5=[-0.15 -0.16 -0.17 -0.18 -0.19 -0.2 -0.21];    

      
[alpha_k0_1,phi1,W_1]=local_search(Noise,Fingerprint,alpha,alpha1,alpha2,ri,ro,r, theta,R,xi,yi,center,imageSize,ut,vt, transf_idx); 
[alpha_k0_2,phi2,W_2]=local_search(Noise,Fingerprint,alpha3,alpha4,alpha5,ri,ro,r, theta,R,xi,yi,center,imageSize,ut,vt, transf_idx);

phi_array(1,1)=phi1;
phi_array(1,2)=phi2;
phi=max(phi_array);
[q,w]=find(phi_array(1,:)==phi);
switch w(1)
      case 1
            alpha_k0=alpha_k0_1; 
            W_transf = W_1; 
            
      case 2
            alpha_k0=alpha_k0_2; 
            W_transf = W_2; 
     
            
end

end
