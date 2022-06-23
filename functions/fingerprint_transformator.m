%######################### fingerprint_transformator.m #########################
% Reference:"An Adaptive Method for Camera Identification
%            under Complex Radial Distortion Corrections"
%Author: Andrea Montibeller
% Work address: Universita' di Trento (DISI), via sommarive 5
% email: andrea.montibeller@unitn.it
% Website: /
% June 2022; Last revision: June 2022
%##########################################################################

function noise2 = fingerprint_transformator(noise, k, ri, ro,r, theta,R,xi,yi,center,ut,vt,flag_frc, varargin)

    index = find(r>ri/R & r<=ro/R);
    s(1:length(r),1) = 255;
    s(index) = distortfun(r(index),k,flag_frc);
    s2 = s * R;    
    [ut(index),vt(index)] = pol2cart(theta(index),s2(index));
    ut(index) = ut(index) + center(1);
    vt(index) = vt(index) + center(2);
    index1 = find((ut<1 | ut>center(1)*2) & ~isnan(ut));
    index2 = find((vt<1 | vt>center(2)*2) & ~isnan(ut));
    ut(index1) = NaN;
    vt(index2) = NaN;
    u = reshape(ut,size(xi));
    v = reshape(vt,size(yi));
    tmap_B = cat(3,u,v);
    resamp = makeresampler('linear', 'fill');
    noise2 = tformarray(noise,[],resamp,[2 1],[1 2],[],tmap_B,255);

%-------------------------------------------------------------------------
% Nested function that pics the model type to be used
    function s = distortfun(r,k,fcnum)
        switch fcnum
        case(1)
            s = r.*(1./(1+k.*r));
        case(2)
            s = r.*(1./(1+k.*(r.^2)));
        case(3)
            s = r.*(1+k.*r);
        case(4)
            s = r.*(1-k.*(r.^2)+3*(k^2).*(r.^4)); %s = r.*(1+k.*(r.^2));
        case(5)
            s = r.*(1+k.*(r.^2)); %s = r.*(1-k.*(r.^2)+3*(k^2).*(r.^4));
        case (6)
           s = r./(1+k); %s = r.*(1+k);
        case (7)
           s = r.*(1+k); %s = r.*(1./(1+k));
        end
    end
end













