function [imx1,fing]=area_crop_2(I2,Fingerprint)
%imx=imread('rc200-31.JPG'); 

%% RENDI UTILIZZABILE ANCHE PER IL 2-D
imageSize=size(I2); 
%I2=lensdistort_crop(imx,-0.1);
%I2_G=rgb2gray(I2);
I2_G=I2;
%digitsOld = digits(3);
%xi=[1 1;imageSize(2) imageSize(2)];
%yi=[1 imageSize(1);1 imageSize(1)];
center = [round(imageSize(2)/2) round(imageSize(1)/2)];
    xt = imageSize(2) - center(1);
    yt = center(2);
    % Converts the x-y coordinates to polar coordinates
    [theta,r] = cart2pol(xt,yt);
    
    %I2=lensdistort_crop(imx,-2);
    dmax=0;
  i=center(2)-1;
    while i>=1
        
        idx=1;
        
       
        
        for j=(center(1)+1):imageSize(2)
            xt1=j-center(1);
            yt1=center(2)-i;
            
            [theta1,r] = cart2pol(xt1,yt1);
            
            if theta1<=theta
                
              if I2_G(i,j)~=255  
                idx=idx+1;
                row=j;
                col=i;
            end
            
            
            end
            
        end
        if i==center(2)-1
            idx_max=idx;
            
        else
            if idx<idx_max
                idx_max=idx;
                row_max=row;
                col_max=col;
            end
            
        end
        
        i=i-1;
        
        
    end
    
    var1=exist ('row_max','var');
   
    
    if var1==1
    x1=row_max;
    y1=col_max;
    x2=center(1)-(x1-center(1));
    y3=center(2)+(center(2)-y1);
    
    imx1 = imcrop(I2,[x2 y1 (x1-x2) (y3-y1)]); %[XMIN YMIN WIDTH HEIGHT];
    fing = imcrop(Fingerprint,[x2 y1 (x1-x2) (y3-y1)]); %[XMIN YMIN WIDTH HEIGHT];
    
    
    
    else
      imx1=I2;  
      fing=Fingerprint;
        
    end
    
    %RGB = insertShape(I2,'circle',[row_max col_max 35],'LineWidth',5);imshow(RGB)
    %RGB = insertShape(I2,'circle',[x1 y1 35],[x1 y3 35],[x2 y1 35],[x2 y3 35],'LineWidth',5);imshow(RGB)
    %RGB = insertShape(I2,'circle',[x1 y1 35],'LineWidth',5);%imshow(RGB)
    %RGB = insertShape(RGB,'circle',[x1 y3 35],'LineWidth',5);%imshow(RGB)
    %RGB = insertShape(RGB,'circle',[x2 y1 35],'LineWidth',5);%imshow(RGB)
    %RGB = insertShape(RGB,'circle',[x2 y3 35],'LineWidth',5);imshow(RGB)
%hold on
%line([imageSize(2), imageSize(2)/2],[1, imageSize(1)/2])



%figure
%imshow(imx1)


end





   