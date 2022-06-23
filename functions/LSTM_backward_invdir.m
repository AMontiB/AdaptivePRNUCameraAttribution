%######################## LSTM_backward_invdir.m #####################################
% Reference:"An Adaptive Method for Camera Identification
%            under Complex Radial Distortion Corrections"
%Author: Andrea Montibeller
% Work address: Universita' di Trento (DISI), via sommarive 5
% email: andrea.montibeller@unitn.it
% Website: /
% June 2022; Last revision: June 2022
%##########################################################################
% Input : test PRNU, the  reference Fingeprint, their
% polar and carthesian coordinates and the parameters we need to compute the 
% CPCE and update the LSTM
% Output: updated CPCE, transformed test PRNU W_transf, alpha array and
% LSTM parameters
%##########################################################################



function [W_inv,K_corr,num_CPCE,CPCE_inv,CPCE_dir,alpha,error,idx_partial, varW_v, varK_v, arr_ind_W, arr_ind_K] = LSTM_backward_invdir(Noise,Fingerprint,r,theta,R,xi,yi,center,ut,vt,imageSize,W_inv,num_CPCE,K_corr,k0,alpha_k0,...
    Ak,annuli_radii,fing,W,lambda,delta,lenk,lenf,...
    mu,uk,alpha,error,index,sx,idx_partial,CPCE_inv,CPCE_dir, transf_idx, varW_v, varK_v,...
    arr_ind_W, arr_ind_K)

indm = 1;
if sx == 0
    n = lenk-k0+2;
    
else
    n = 2;
end
for m=n:lenk
    if m-lenf>=1
        bk=alpha(1,m-lenf:m-1);
    else
        if m==2
            bk=[zeros(1,lenf-m+1),alpha_k0];
        else
            bk=[zeros(1,lenf-m+1),alpha(1,1:m-1)];
        end
    end
    M(1,indm) = Ak;
    fprintf('*');
    alpha(1,m)=uk*bk.';
    ro=annuli_radii(1,index);
    ri=annuli_radii(2,index);
    [alpha_k,pos,fl,~,~,~]=prediction_check(Ak,alpha(1,m),lambda,ro,ri,Noise,Fingerprint,r,theta,R,xi,yi,center,ut,vt,imageSize, transf_idx); %alpha
    W_inv{index} = PRNU_transformer(Noise, alpha_k,annuli_radii(2,index),...
        annuli_radii(1,index),r, theta,R,xi,yi,center,ut,vt,transf_idx);
    W_rs = reshape(W_inv{index},[1 imageSize(1)*imageSize(2)]);
    ind = find(W_rs<20);
    arr_ind_W(1, index) = length(ind);
    W_v = W_rs(1,ind);
    varW_v(1,index) = var(W_v);
    K_v = fing(1,ind);
    num_CPCE(1,index) = (W_v(:)'*K_v(:));
    clear W_v K_v ind W_rs ind
    K_corr{index} = fingerprint_transformator(Fingerprint, alpha_k,annuli_radii(2,index),...
        annuli_radii(1,index),r, theta,R,xi,yi,center,ut,vt,transf_idx);
    K_arr = reshape(K_corr{index},[1 imageSize(1)*imageSize(2)]);
    ind = find(K_arr<20);
    varK_v(1, index) = var(K_arr(ind));
    arr_ind_K(1, index) = length(ind);
    K_v = K_arr(1,ind);
    W_v = W(1,ind);
    num_CPCE(2,index) = (W_v(:)'*K_v(:));
    clear W_v K_v ind W_rs ind
    index=index-1;
    e=alpha_k-alpha(1,m);
    alpha(1,m)=alpha_k;
    alpha(2,m)=fl;
    if sx == 0 && m == n
        alpha(1,n-1)=alpha_k0;
    else
        if m == 2
            alpha(1,1)=alpha_k0;
        end
    end
    
    if alpha_k == 0
        %to AVOID alpha_k explosion
        lambda = 0.01;
        delta = 0.1;
    else
        delta=abs(alpha(1,m-1)-alpha(1,m));
        if delta>=0.1
            lambda=0.1;
        elseif delta<0.1 && delta>0.01
            lambda=0.01;
        elseif delta<=0.01 && delta>0.005
            lambda=0.005;
        elseif delta<=0.005 && delta>0.002
            lambda=0.002;
        elseif delta<=0.002
            lambda=0.001;
        end
    end
    error=[error e];
    a=uk+mu*e*bk;
    if pos==1 || pos==Ak
        Ak=Ak+2;
    elseif pos<((((Ak-1)/2)+1)+((Ak-1)/2)) && ((((Ak-1)/2)+1)-((Ak-1)/2)) && Ak>9
        Ak=Ak-2;
    end
    denom_inv = sum(var(reshape(Fingerprint, [1 imageSize(1)*imageSize(2)])) * varW_v .* arr_ind_W);
    denom_dir = sum(var(reshape(Noise, [1 imageSize(1)*imageSize(2)])) * varK_v .* arr_ind_K);
    CPCE_inv(1,idx_partial) = sum(num_CPCE(1,:))^2/denom_inv;
    CPCE_dir(1,idx_partial) = sum(num_CPCE(2,:))^2/denom_dir;
    idx_partial = idx_partial + 1;
    indm = indm +1;
end


end
