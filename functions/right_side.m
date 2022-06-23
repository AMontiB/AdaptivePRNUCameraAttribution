function Noisex=right_side(Noisex,Fingerprint)


    Noisex_1=imrotate(Noisex,90);
    Noisex_2=imrotate(Noisex,-90);


    C_not = crosscorr(Noisex_1,Fingerprint); %compute crosscorr 
    detection_not= PCE(C_not);
    
    C_not_2 = crosscorr(Noisex_2,Fingerprint); %compute crosscorr 
    detection_not_2= PCE(C_not_2);
    
    if detection_not.PCE>=detection_not_2.PCE
        Noisex=Noisex_1;
    else   
        Noisex=Noisex_2;
    end

end