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
% diag : half of the image diagonal
% h : half of the image with 
% Deltak : width of the annulus
% ro : outter radii of the first annulus
% -------------------------------OUTPUT------------------------------------
% annuli array : set of inner and outter radii of the annuli
%##########################################################################

function annuli_array=annuli_estimator(diag,h,Deltak,ro)

ymax=diag;
ri=0;
n=(h - ro)/Deltak;
n=ceil(n)+1;
for i=1:n
    annuli_array(1,i)=ro;
    annuli_array(2,i)=ri;
    if i==1
        ri=ro;
        ro=ro+Deltak;
    else
        ri=ro;
        ro=ro+Deltak;
    end
end
if (ymax-annuli_array(1,n))<20
    annuli_array(1,n)=ymax;
else
    annuli_array(1,n+1)=ymax;
    annuli_array(2,n+1)=annuli_array(1,n);
end
end











