

close all;clear all;clc;


iptsetpref('ImshowBorder','tight');
 
pathname = uigetdir('D://050722 coculture tfm processed2/pos7/quantification new/');%select processed file
new_folder=[pathname,'/forcemap 400/'];
mkdir(new_folder);
Files = dir(fullfile(pathname,['Traction_PIV','*.txt']));%select the file of interest
Files = natsortfiles(Files); 
filename = string({Files(:).name});

for i = 1:length(filename)
    myfile = fullfile(pathname,filename(i));
    a1 = load(myfile);%loading files
    x = a1(:,1);%x axis
    y = a1(:,2);%y axis
    z = a1(:,5);% force value (pa)

    size_image = [1152,1152]; % image size (pixel number x pixel number)

    [X, Y] = meshgrid(linspace(1,size_image(1),size_image(1)), linspace(1,size_image(2),size_image(2)));%create matrix space for xy
    Z = griddata(x,y,z,X,Y);

    %// Remove the NaNs for imshow:
    Z(isnan(Z)) = 0;
    
    figure;    
    imshow(Z,[0 400]);
    % m = min(Z(Z~=0));
    % M = max(Z(Z~=0));
    axis off % off the x-y axis
    %  colorbar
    colormap(jet)
    %  caxis([0 1000]) % color bar range, unit: pa
   
    print('-dtiffnocompression','-r180',[new_folder,'/',num2str(i),'.png']); 

    close();

end

