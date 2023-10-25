

close all;clear all;clc;


iptsetpref('ImshowBorder','tight');
 
pathname = uigetdir('E:/MBI/2023 analysis/new codes/Cell1 pos6/FTTC/');%select processed file
new_folder=[pathname,'/radial forcemap 300/'];
mkdir(new_folder);
x0 = 390;%x coordinate of initial fracture
y0 = 548;%y coordinate of initial fracture
Files = dir(fullfile(pathname,['Traction_PIV','*.txt']));%select the file of interest
Files = natsortfiles(Files); 
filename = string({Files(:).name});

for i = 1:length(filename)
    myfile = fullfile(pathname,filename(i));
    a1 = load(myfile);%loading files
    x = a1(:,1);%x axis
    y = a1(:,2);%y axis
        Tx = a1(:,3);% traction x-component (Pa)
    Ty = a1(:,4);% traction y-component (Pa)

    % Calculate angle and radial traction
    row_length = height(x);
    sin_theta = zeros(row_length,1);
    cos_theta = zeros(row_length,1);
    Tr = zeros(row_length,1);
    for j = 1:row_length
        %theta(j) = atan((y(j)-y0)/(x(j)-x0));
        %Tr(j) = Tx(j)*cos(theta(j))+Ty(j)*sin(theta(j));
        sin_theta(j) = (y(j)-y0)/(sqrt(((x(j)-x0)^2)+((y(j)-y0)^2)));
        cos_theta(j) = (x(j)-x0)/(sqrt(((x(j)-x0)^2)+((y(j)-y0)^2)));
        Tr(j) = Tx(j)*cos_theta(j)+Ty(j)*sin_theta(j);
    end


    size_image = [1152,1152]; % image size (pixel number x pixel number)

    %[X, Y] = meshgrid(linspace(min(x),max(x),size_image(1)), linspace(min(y),max(y),size_image(2)));%create matrix space for xy
    [X, Y] = meshgrid(linspace(1,size_image(1),size_image(1)), linspace(1,size_image(2),size_image(2)));
    Z = griddata(x,y,Tr,X,Y);

    %// Remove the NaNs for imshow:
    Z(isnan(Z)) = 0;
    
    figure;    
    imshow(Z,[-300 300]);
    % m = min(Z(Z~=0));
    % M = max(Z(Z~=0));
    axis off % off the x-y axis
    %  colorbar
    colormap(redblue)
    %  caxis([0 1000]) % color bar range, unit: pa
   
    print('-dtiffnocompression','-r180',[new_folder,'/',num2str(i),'.png']); 

    close();

end

