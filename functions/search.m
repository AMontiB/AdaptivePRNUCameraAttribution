%############################ search.m ####################################
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
% alpha : vector of transformation paramenters
% ri and ro :  inner and outter radii of the annulus
% theta, R, xi, yi, center, imageSize, ut, vt : reference to cartesian and polar coordinates
% transf_idx : integer to select the image transformation model
% -------------------------------OUTPUT------------------------------------
% param_mat : a matrix containing the values of eq. (27) and the values of
%               used to obtained them
% W :  transformed test PRNU
%##########################################################################

function [param_mat,W]=search(Noise,Fingerprint,alpha,ri,ro,r, theta,R,xi,yi,center,imageSize,ut,vt, transf_idx)
K = reshape(Fingerprint,[1 imageSize(1)*imageSize(2)]);
for i=1:length(alpha)
    W{i} = PRNU_transformer(Noise, alpha(i),ri,ro,r,theta,R,xi,yi,center,ut,vt, transf_idx);
    W_res = reshape(W{i},[1 imageSize(1)*imageSize(2)]);
    ind = find(W_res~=255);
    W_sel = W_res(1,ind);
    K_sel = K(1,ind);
    param_mat(1,i) =(W_sel(:)'*K_sel(:))/ (var(K_sel) * var(W_sel));
    fprintf('.')
    clear W_sel K_sel W_res
end
param_mat(2,:)=alpha(1,:);
end

