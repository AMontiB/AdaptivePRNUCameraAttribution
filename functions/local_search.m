%########################### local_search.m ################################
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
% alpha* : vectors of transformation paramenters
% ri and ro :  inner and outter radii of the annulus
% theta, R, xi, yi, center, imageSize, ut, vt : reference to cartesian and polar coordinates
% transf_idx : integer to select the image transformation model
% -------------------------------OUTPUT------------------------------------
% alpha_k0 :  best tranformation parameter for the annuli of index k_0
% phi : eq. (27) obtained with alpha_k0 for the annuli of index k_0
% W :  transformed test PRNU
%##########################################################################

function [alpha_k0,phi,W]=local_search(Noise,Fingerprint,alpha,alpha1,alpha2,ri,ro,r, theta,R,xi,yi,center,imageSize,ut,vt, transf_idx)

[param_mat, W1]=search(Noise,Fingerprint,alpha,ri,ro,r, theta,R,xi,yi,center,imageSize,ut,vt, transf_idx); 
[param_mat1,W2]=search(Noise,Fingerprint,alpha1,ri,ro,r, theta,R,xi,yi,center,imageSize,ut,vt, transf_idx); 
[param_mat2,W3]=search(Noise,Fingerprint,alpha2,ri,ro,r, theta,R,xi,yi,center,imageSize,ut,vt, transf_idx); 
phi_array(1,1)=max(param_mat(1,:)); 
phi_array(1,2)=max(param_mat1(1,:)); 
phi_array(1,3)=max(param_mat2(1,:));
maximum=max(phi_array);
[~, w]=find(phi_array(1,:)==maximum);
w1=w(1);
switch w1        
        case 1   
            [~,w]=find(param_mat(1,:)==maximum);
            alpha_k0=param_mat(2,w(1)); 
            phi=maximum; 
            W = W1{w(1)};
            
        case 2
            [~,w]=find(param_mat1(1,:)==maximum);
            alpha_k0=param_mat1(2,w(1)); 
            phi=maximum; 
            W = W2{w(1)};
            
        case 3
          [~,w]=find(param_mat2(1,:)==maximum);
          alpha_k0=param_mat2(2,w(1)); 
          phi=maximum; 
          W = W3{w(1)};         
end
end