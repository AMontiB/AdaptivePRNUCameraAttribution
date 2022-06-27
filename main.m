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
% im : image path
% Fingerprint : Camera fingeprint
% -------------------------------OUTPUT------------------------------------
% PCE_not: PCE value before applying the method of the reference paper
% CPCE_inv : CPCE inverting the radial correction to im
% CPCE_dir : CPCE radial correcting Fingerprint
% CPCE : CPCE inverting the radial correction to im
% -----------------Combo of parameters we used in the paper----------------
% transf_idx = 5 flag_direct = 0  
% transf_idx = 4 flag_direct = 1 
% transf_idx = 7 flag_direct = 1 
% transf_idx = 6 flag_direct = 0 
%##########################################################################


%compile
warning off
clear all
clc
addpath functions

%% INPUT
Fingerprint = importdata('PRNU_FILES/Fingerprint_CanonEOS1200d.dat');
im = 'test_images/canon1200d/im-66.JPG';

%transf_idx = 4; % to use s = r.*(1+k.*(r.^2)); to transform the PRNU and 
                % s = r.*(1-k.*(r.^2)+3*(k^2).*(r.^4)); for the Fingerprint
transf_idx = 5; % to use s = r.*(1-k.*(r.^2)+3*(k^2).*(r.^4)); to transform the PRNU and 
                % s = r.*(1+k.*(r.^2)); for the Fingerprint            
%transf_idx = 6; % to use s = r.*(1+k); to transform the PRNU and 
                % s = r.*(1./(1+k));  for the Fingerprint
%transf_idx = 7; % to use s = r.*(1./(1+k)); to transform the PRNU and 
                % s = r.*(1+k); for the Fingerprint
flag_direct = 0; % for the Inv or ID estimation
%flag_direct = 1; % for the Dir or DI estimation

tau_c = 73.48; %early stopping tau set for FPR=0.05 see reference paper

%%  H1 Hypothesis

[PCE_not_V1, CPCE_inv, CPCE_dir] = ADAPTIVE_Inv_and_Dir(im,Fingerprint, 5, 0, tau_c);

fprintf('\n PCE H1 value before: %f \n', PCE_not_V1)

fprintf('Final H1 CPCE_inv value: %f \n', CPCE_inv(1, length(CPCE_inv)))

fprintf('Final H1 CPCE_dir value: %f \n\n', CPCE_dir(1, length(CPCE_dir)))

[PCE_not_V2, CPCE] = ADAPTIVE_Inv_or_Dir(im,Fingerprint, 5, 0, tau_c);

fprintf('\n PCE H1 value before: %f \n', PCE_not_V2)

fprintf('Final H1 CPCE value: %f \n\n', CPCE(1, length(CPCE)))

%%  H0 Hypothesis

im = 'test_images/sx230.jpg';

[PCE_not_V1, CPCE_inv, CPCE_dir] = ADAPTIVE_Inv_and_Dir_H0(im,Fingerprint, 5, 0, tau_c);

fprintf('\n PCE H0 value before: %f \n', PCE_not_V1)

fprintf('Final H0 CPCE_inv value: %f \n', CPCE_inv(1, length(CPCE_inv)))

fprintf('Final H0 CPCE_dir value: %f \n\n', CPCE_dir(1, length(CPCE_dir)))

[PCE_not_V2, CPCE] = ADAPTIVE_Inv_or_Dir_H0(im,Fingerprint, 5, 0, tau_c);

fprintf('\n PCE H0 value before: %f \n', PCE_not_V2)

fprintf('Final H0 CPCE value: %f \n\n', CPCE(1, length(CPCE)))
