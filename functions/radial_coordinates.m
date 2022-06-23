function [r,theta,R,xi,yi,center,r1,xt,yt,ut,vt]=radial_coordinates(M, N)
    center = [round(N/2) round(M/2)];
    % Creates N x M (#pixels) x-y points
    [xi,yi] = meshgrid(1:N,1:M);
    % Creates converst the mesh into a colum vector of coordiantes relative to
    % the center
    xt = xi(:) - center(1);
    yt = yi(:) - center(2);
    % Converts the x-y coordinates to polar coordinates
    [theta,r1] = cart2pol(xt,yt);
    % Calculate the maximum vector (image center to image corner) to be used
    % for normalization
    R = sqrt(center(1)^2 + center(2)^2);
    % Normalize the polar coordinate r to range between 0 and 1 
    r = r1/R;
    ut(1:length(r)) =NaN;
    vt(1:length(r)) =NaN;
end