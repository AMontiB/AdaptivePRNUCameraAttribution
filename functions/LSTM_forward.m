%######################## LSTM_forward.m #####################################
% Reference:"An Adaptive Method for Camera Identification
%            under Complex Radial Distortion Corrections"
%Author: Andrea Montibeller
% Work address: Universita' di Trento (DISI), via sommarive 5
% email: andrea.montibeller@unitn.it
% Website: /
% June 2022; Last revision: June 2022
%##########################################################################
% Input : image PRNU, the camera Fingeprint, their
% polar and carthesian coordinates and the parameters we need to compute the 
% CPCE and update the LSTM
% Output: updated CPCE, transformed image PRNU W_transf, alpha array and
% LSTM parameters
%##########################################################################




function [W_transf,num_CPCE,CPCE,alpha,error,idx_partial, varW_v, varK_v, arr_ind_W, arr_ind_K] = LSTM_forward(Noise,Fingerprint,r,theta,R,xi,yi,center,ut,vt,imageSize,W_transf,num_CPCE,k0,alpha_k0,...
    Ak,annuli_array,fing,lambda,delta,lenk,lenf,...
    mu,uk,alpha,error,index,sx,idx_partial,CPCE, transf_idx, varW_v, varK_v,...
    arr_ind_W, arr_ind_K, tau_c)

indm = 1;
for m=index:lenk
    if sx == 0
        if (m-k0)-lenf>=1
            bk=alpha(1,m-lenf:m-1);
        else
            if (m-k0)==1
                bk=[zeros(1,lenf-2+1),alpha_k0];
            else
                bk=[zeros(1,lenf-((m+1)-k0)+1),alpha(1,k0:m-1)];
            end
        end
    else
        if m-lenf>=1
            bk=alpha(1,m-lenf:m-1);
        else
            if m==2
                bk=[zeros(1,lenf-m+1),alpha_k0];
            else
                bk=[zeros(1,lenf-m+1),alpha(1,1:m-1)];
            end
        end
    end
    fprintf('*');
    alpha(1,m)=uk*bk.';
    ro=annuli_array(1,index);
    ri=annuli_array(2,index);
    [alpha_k,pos,fl,~,~,~]=prediction_check(Ak,alpha(1,m),lambda,ro,ri,Noise,Fingerprint,r,theta,R,xi,yi,center,ut,vt,imageSize, transf_idx);
    W_transf{m} = PRNU_transformer(Noise, alpha_k,annuli_array(2,index),...
        annuli_array(1,index),r, theta,R,xi,yi,center,ut,vt, transf_idx);
    W_rs = reshape(W_transf{m},[1 imageSize(1)*imageSize(2)]);
    ind = find(W_rs<20);
    W_v = W_rs(1,ind);
    arr_ind_W(1, index) = length(ind);
    varW_v(1,index) = var(W_v);
    K_v = fing(1,ind);
    num_CPCE(1,m) = (W_v(:)'*K_v(:));
    index=index+1;
    e=alpha_k-alpha(1,m);
    alpha(1,m)=alpha_k;
    alpha(2,m)=fl;
    if sx ==0 && m == index
        alpha(1,k0)=alpha_k0;
        alpha(2,k0)=1;
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
    uk=uk+mu*e*bk;
    if pos==1 || pos==Ak
        Ak=Ak+2;
    elseif pos<((((Ak-1)/2)+1)+((Ak-1)/2)) && ((((Ak-1)/2)+1)-((Ak-1)/2)) && Ak>9
        Ak=Ak-2;
    end
    denom = sum(var(reshape(Fingerprint, [1 imageSize(1)*imageSize(2)])) * varW_v .* arr_ind_W);
    CPCE(1,idx_partial) = sum(num_CPCE(1,:))^2/denom;
    %early stopping condition
    if sum(num_CPCE(1,:))^2/denom > tau_c
       return 
    end
    idx_partial = idx_partial + 1;
    indm = indm +1;
end

end
