function [imx,Fingerprint1]=crop_in_center(imx,Fingerprint1)

size1=size(imx);
size2=size(Fingerprint1);
if size1(1:2)==size2(1:2)

else
    if size1(1)>size2(1) && size1(2)>size2(2)
        %croppo imx
        imx = imcrop(imx,[(ceil(size1(2)/2)-ceil(size2(2)/2))...
            (ceil(size1(1)/2)-ceil(size2(1)/2)) size2(2)-1 size2(1)-1]); %[XMIN YMIN WIDTH HEIGHT];
        size1=size(imx);
    end

    if size2(1)>size1(1) && size2(2)>size1(2)
        Fingerprint1 = imcrop(Fingerprint1,[(ceil(size2(2)/2)-ceil(size1(2)/2))...
            (ceil(size2(1)/2)-ceil(size1(1)/2)) size1(2)-1 size1(1)-1]); %[XMIN YMIN WIDTH HEIGHT];
        size2=size(Fingerprint1);
    end
    if size1(1)>size2(1) %&& size1(2)<size2(2)        
        if size1(2)<size2(2)
            imx = imcrop(imx,[(1)...
                (ceil(size1(1)/2)-ceil(size2(1)/2)) size1(2)-1 size2(1)-1]); %[XMIN YMIN WIDTH HEIGHT];
            Fingerprint1 = imcrop(Fingerprint1,[(ceil(size2(2)/2)-ceil(size1(2)/2))...
                (1) size1(2)-1 size2(1)-1]); %[XMIN YMIN WIDTH HEIGHT];
        else
            imx = imcrop(imx,[(1)...
                (ceil(size1(1)/2)-ceil(size2(1)/2)) size1(2)-1 size2(1)-1]); %[XMIN YMIN WIDTH HEIGHT];
            Fingerprint1 = imcrop(Fingerprint1,[(ceil(size2(2)/2)-ceil(size1(2)/2))...
                (1) size1(2) size2(1)-1]); %[XMIN YMIN WIDTH HEIGHT];
        end
        size1=size(imx);
        size2=size(Fingerprint1);
    end
    if size1(1)<size2(1) 
        if size1(2)>size2(2)
            imx = imcrop(imx,[(ceil(size1(2)/2)-ceil(size2(2)/2))...
                (1) size2(2)-1 size1(1)-1]); %[XMIN YMIN WIDTH HEIGHT];
            Fingerprint1 = imcrop(Fingerprint1,[(1)...
                (ceil(size2(1)/2)-ceil(size1(1)/2)) size2(2)-1 size1(1)-1]); %[XMIN YMIN WIDTH HEIGHT];
        else
            imx = imcrop(imx,[(ceil(size1(2)/2)-ceil(size2(2)/2))...
                (1) size2(2) size1(1)-1]); %[XMIN YMIN WIDTH HEIGHT];
            Fingerprint1 = imcrop(Fingerprint1,[(1)...
                (ceil(size2(1)/2)-ceil(size1(1)/2)) size2(2) size1(1)-1]); %[XMIN YMIN WIDTH HEIGHT] 
        end 
    end 
end
end


