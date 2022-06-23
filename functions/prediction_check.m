%########################## prediction_check.m #########################
% Reference:"An Adaptive Method for Camera Identification
%            under Complex Radial Distortion Corrections"
%Author: Andrea Montibeller
% Work address: Universita' di Trento (DISI), via sommarive 5
% email: andrea.montibeller@unitn.it
% Website: /
% June 2022; Last revision: June 2022
% -------------------------------INPUT-------------------------------------
% Ak : size of the set
% alpha : transformation param estimated by the LSTM
% lambda : step size of the set
% ri and ro :  inner and outter radii of the annulus
% Noise : test PRNU
% Fingerprint : reference fingeprint
% theta, R, xi, yi, center, imageSize, ut, vt : reference to cartesian and polar coordinates
% transf_idx : integer to select the radial correction (or inversion) model
% -------------------------------OUTPUT------------------------------------
% alpha_best :  best tranformation parameter for the annuli of index k
% pos : position of alpha_best
% phi_0 : eq. (27) obtained with alpha_k0 = 0
% phi : eq. (27) obtained with alpha_best for the annuli of index k
% W_transf :  transformed test PRNU
%##########################################################################

function [alpha_best,pos,fl,phi_0,phi_max,W_transf]=prediction_check(Ak,alpha,lambda,ro,ri,Noise,Fingerprint,r,theta,R,xi,yi,center,ut,vt,imageSize, transf_idx)

alpha_best=alpha;
Fingerprint = reshape(Fingerprint,[1 imageSize(1)*imageSize(2)]);

for i=1:((Ak-1)/2)
    alpha_k(i)=alpha_best-lambda*(((Ak-1)/2)-(i-1));
end
for i=(((Ak-1)/2)+1):Ak
    alpha_k(i)=alpha_best-lambda*(((Ak-1)/2)-(i-1));
end

phi_array(2,:)=alpha_k(:);

for x=1:Ak
    W{x} = PRNU_transformer(Noise, alpha_k(x),ri,ro,r,theta,R,xi,yi,center,ut,vt, transf_idx);
    W_rs = reshape(W{x},[1 imageSize(1)*imageSize(2)]);
    ind = find(W_rs~=255);
    if ~(isempty(ind))
        W_sel = W_rs(1,ind);
        K_sel = Fingerprint(1,ind);
        phi_array(1,x) = ((W_sel(:)'*K_sel(:))/ (var(K_sel) * var(W_sel)));
    end
    clear  W_rs K_v W_v ind
end
ind = find(r>ri/R & r<=ro/R);
W_not = reshape(Noise(:,:,1),[1 imageSize(1)*imageSize(2)]);
Wnot_v (1,:) = W_not(1,ind);
Knot_v(1,:) = Fingerprint(1,ind);
phi_0 = (Wnot_v(:)'*Knot_v(:)) / ((var(Knot_v) * var(Wnot_v)));
phi_max=max(phi_array(1,:));

if phi_max<phi_0
    phi_max = phi_0;
    alpha_best=0;
    pos=(Ak-1)/2;
    fl=1;
    W_not_Transf=single(zeros(size(W_not)));
    W_not_Transf(1,:)=255;
    W_not_Transf(1,ind)=W_not(1,ind);
    W_transf = reshape(W_not_Transf,[imageSize(1) imageSize(2)]);
else
    [~,w]=find(phi_array == phi_max);
    alpha_best=phi_array(2,w(1));
    pos=w(1);
    fl=1;
    W_transf=W{w(1)};
end

end

