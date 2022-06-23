%######################## ADAPTIVE_Inv_or_Dir ################
% Reference:"An Adaptive Method for Camera Identification
%            under Complex Radial Distortion Corrections"
%Author: Andrea Montibeller
% Work address: Universita' di Trento (DISI), via sommarive 5
% email: andrea.montibeller@unitn.it
% Website: /
% June 2022; Last revision: June 2022
%##########################################################################
% -------------------------------INPUT-------------------------------------
% im : image path
% Fingerprint : Camera fingeprint
% transf_idx : 4,5,6 or 7 (set the radial correction model)
% flag_direct :  0 or 1 (to set Inv or Dir)
% tau_c : threshold for early stopping set for False Positive Rate = 0.05
% -------------------------------OUTPUT------------------------------------
% PCE_not: PCE value before applying the method of the reference paper
% CPCE_inv : CPCE Inv
% CPCE_dir : CPCE Dir
%##########################################################################

function [PCE_not,CPCE] = ADAPTIVE_Inv_or_Dir(im,Fingerprint, transf_idx, flag_direct, tau_c)


idx_partial = 1;
fingersize = size(Fingerprint);
Ak = 9;
r1 = 250;
tstart = tic;
flag_partial = 1;
if exist(im,'file')
    img=imread(im);
    Noise = NoiseExtractFromImage(img,2);
    Noise = WienerInDFT(Noise,std2(Noise));
    imageSize = size(Noise);
    
    if (imageSize(1)==fingersize(2) && imageSize(2)==fingersize(1)) || (imageSize(1)==fingersize(1) && imageSize(2)==fingersize(2))
        %check image orientation
        if imageSize(1)==fingersize(2) && imageSize(2)==fingersize(1)
            Noise=right_side(Noise,Fingerprint);
            imageSize=size(Noise);
        end
        %if direct approach
        if flag_direct == 1
            Fingeprint1 =  Noise;
            Noise1 = Fingerprint;
            Fingerprint = Fingeprint1;
            Noise = Noise1;
        end
        Deltak = 64;
        fing = reshape(Fingerprint,[1 fingersize(1)*fingersize(2)]);
        C_not = crosscorr(Noise,Fingerprint); %compute crosscorr
        [detection_not,denom_not] = PCE(C_not);
        PCE_not = detection_not.PCE;
        center=imageSize/2;
        diag=sqrt((imageSize(1)/2)^2+(imageSize(2)/2)^2);
        %annuli estimation
        annuli_radii=annuli_estimator(diag,center(2)-Deltak,Deltak,r1);
        
        [r,theta,R,xi,yi,center,~,~,~,ut,vt]=radial_coordinates(imageSize(1), imageSize(2));
        fprintf('----Starter index k_0---- \n');
        [k0,sx,varW_v, varK_v, arr_ind_W] = starter_annuli(Noise,fing,annuli_radii,r,theta,R,xi,yi,center,ut,vt,imageSize(1), imageSize(2), transf_idx);
        fprintf('k_0 : %d\n', k0)
        fprintf('----Grid search alpha_{k_0}^*---- \n');
        [alpha_k0,~,~] = grid_search(Noise,Fingerprint,imageSize,...
            annuli_radii(1,k0),annuli_radii(2,k0),r,...
            theta,R,xi,yi,center,ut,vt,transf_idx);
        fprintf('\n alpha_{k_0} : %d\n', alpha_k0)
        Wcrop = PRNU_transformer(Noise, alpha_k0, 0, diag,r, theta,R,xi,yi,center,ut,vt, transf_idx);
        Wcrop_arr = reshape(Wcrop, [1, imageSize(1)*imageSize(2)]);
        ind_wcrop = find(Wcrop_arr<20);
        var_fullW_dist = var(Wcrop_arr(ind_wcrop));
        
        CPCE(1,idx_partial) = 0;
        W_transf{k0} = PRNU_transformer(Noise, alpha_k0,annuli_radii(2,k0),...
            annuli_radii(1,k0),r, theta,R,xi,yi,center,ut,vt,transf_idx);
        W_rs = reshape(W_transf{k0},[1 imageSize(1)*imageSize(2)]);
        ind = find(W_rs<20);
        W_v = W_rs(1,ind);
        arr_ind_K = arr_ind_W;
        arr_ind_W(1, k0) = length(ind);
        varW_v = ones(1, length(varW_v)) * var_fullW_dist;
        varW_v(k0) = var(W_rs(1,ind));
        K_v = fing(1,ind);
        num_CPCE(1,k0) = (W_v(:)'*K_v(:));
        clear W_rs W_v K_v ind
        W = reshape(Noise(:,:,1),[1 imageSize(1)*imageSize(2)]);
        K_transf = 0;
        varK_v = 0;
        arr_ind_K =0;
        fprintf('\n');
        fprintf('----Prediction phase---- \n');
        %backward prediction if k_0 corresponds to the outtermost annuli
        if sx == 1
            lambda=0.001;
            delta=0.01;
            lenk=k0;
            U=6;
            mu=1;
            uk=zeros(1,U);
            uk(U)=1;
            alpha=zeros(1,lenk);
            alpha(1,1)=alpha_k0;
            alpha(2,1)=1;
            error=[];
            index=k0-1;
            adj=0;
            xdim=0;
            %LSTM backward direction
            [W_transf,num_CPCE,CPCE,alpha,error,idx_partial, varW_v, varK_v, arr_ind_W, arr_ind_K] = LSTM_backward(Noise,Fingerprint,r,theta,R,xi,yi,center,ut,vt,...
                imageSize,W_transf,num_CPCE,k0,alpha_k0,Ak,...
                annuli_radii,fing,lambda,delta,lenk,U,...
                mu,uk,alpha,error,index,sx,idx_partial,CPCE, transf_idx,...
                varW_v, varK_v, arr_ind_W, arr_ind_K, tau_c);
        else
            lambda=0.001;
            delta=0.01;
            lenk=length(annuli_radii);
            U=6;
            mu=1;
            uk=zeros(1,U);
            uk(U)=1;
            alpha=zeros(1,lenk);
            alpha(1,k0)=alpha_k0;
            alpha(2,k0)=1;
            error=[];
            index=k0+1;
            adj=0;
            xdim=0;
            %LSTM forward direction
            [W_transf,num_CPCE,CPCE,alpha,error,idx_partial, varW_v, varK_v, arr_ind_W, arr_ind_K] = LSTM_forward(Noise,Fingerprint,r,theta,R,xi,yi,center,ut,vt,...
                imageSize,W_transf,num_CPCE,k0,alpha_k0,Ak,...
                annuli_radii,fing,lambda,delta,lenk,U,...
                mu,uk,alpha,error,index,sx,idx_partial,CPCE,transf_idx,...
                varW_v, varK_v, arr_ind_W, arr_ind_K, tau_c);
            %check if k_0 corresponds to the innemost disk
            if k0 ~= 1
                alpha = fliplr(alpha);
                error = fliplr(error);
                e = error(1,length(error));
                lenk = length(alpha);
                uk=zeros(1,U);
                uk(U)=1;
                alpha_array = (lenk - k0) + 1;
                in_array = alpha_array-U+1;
                if in_array <= 0
                    fill = 6 - alpha_array;
                    bk=[zeros(1,fill) alpha(1,1:alpha_array)];
                else
                    bk=alpha(1,in_array:alpha_array);
                end
                uk=uk+mu*e*bk;
                delta=abs(alpha(1,alpha_array)-alpha(1,alpha_array-1));
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
                index=k0-1;
                adj=0;
                xdim=0;
                %LSTM backward direction
                [W_transf,num_CPCE,CPCE,alpha,~,idx_partial, varW_v, varK_v, arr_ind_W, arr_ind_K] = LSTM_backward(Noise,Fingerprint,r,theta,R,xi,yi,center,ut,vt,...
                    imageSize,W_transf,num_CPCE,k0,alpha_k0,Ak,...
                    annuli_radii,fing,lambda,delta,lenk,U,...
                    mu,uk,alpha,error,index,sx,idx_partial,CPCE, transf_idx,...
                    varW_v, varK_v, arr_ind_W, arr_ind_K, tau_c);
            end
        end
    else
        fprintf('skipped: no same dimension');
        PCE_not = 0;
        center=fingersize/2;
        diag=sqrt((fingersize(1)/2)^2+(fingersize(2)/2)^2);
        annuli_radii=annuli_estimator(diag,center(2)-64,64,r1);
        CPCE = zeros(1,length(annuli_radii));
    end
else
    
    fprintf('skipped: no file in the folder');
    PCE_not = 0;
    center=fingersize/2;
    diag=sqrt((fingersize(1)/2)^2+(fingersize(2)/2)^2);
    annuli_radii=annuli_estimator(diag,center(2)-64,64,r1);
    CPCE = zeros(1,length(annuli_radii));
end

end
