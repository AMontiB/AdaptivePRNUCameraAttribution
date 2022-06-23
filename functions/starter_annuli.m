%################################ MAIN ####################################
% Reference:"An Adaptive Method for Camera Identification
%            under Complex Radial Distortion Corrections"
%Author: Andrea Montibeller
% Work address: Universita' di Trento (DISI), via sommarive 5
% email: andrea.montibeller@unitn.it
% Website: /
% June 2022; Last revision: June 2022
%##########################################################################
% -------------------------------INPUT-------------------------------------
% Noise : test PRNU
% Fingerprint : reference fingeprint
% ri and ro :  inner and outter radii of the annulus
% theta, R, xi, yi, center, imageSize*, ut, vt : reference to cartesian and polar coordinates
% transf_idx : integer to select the image transformation model
% -------------------------------OUTPUT------------------------------------
% k0 : index first annuli
% sx : set forward / backward prediction direction
% varW_v : array of variance of each annuli for the test PRNU
% varK_v : array of variance of each annuli for the reference fingerprint
% arr_ind : array of number of pixels in each annuli
%##########################################################################

function [k0, sx, varW_v, varK_v, arr_ind] = starter_annuli(Noise,Fingeprint,annuli_radii,r,theta,R,xi,yi,center,ut,vt,imageSize_v, imageSize_h, transf_idx)

for i = 1:length(annuli_radii)
    W_inv = PRNU_transformer(Noise, 0,annuli_radii(2,i),...
        annuli_radii(1,i),r, theta,R,xi,yi,center,ut,vt, transf_idx);
    W_rs = reshape(W_inv,[1 imageSize_v*imageSize_h]);
    ind = find(W_rs<20);
    W_v = W_rs(1,ind);
    K_v = Fingeprint(1,ind);
    varW_v(1,i) = var(W_v);
    varK_v(1,i) = var(K_v);
    arr_ind(1,i) = length(ind);
    corr(1,i) = (W_v(:)'*K_v(:)) / (var(K_v) * var(W_v));
    clear K_v W_v ind W_rs W_inv
end
max_corr = max(corr(1,:));
[x, y] = find (corr(1,:) == max_corr);
k0 = y(1);

if y(1) == length(annuli_radii)
    sx = 1;
else
    sx = 0;
end
end