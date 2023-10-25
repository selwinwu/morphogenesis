

% Modified by hui ting, 14 March 2022.
% Modified by christina, 9 Sep 2022
% to plot traction forcemap for 1,1 to img_sz,img_sz
% instead of from 17,17 (x min, x min) to 1137,1137 (x max, x max),
% the following changes were made:
% changed meshgrid start and stop from 1 to image size (1152)
% disabled rescaling (pixel2um)


close all;clear all;clc;

img_sz = 1152;

%DIC = import_tif_sequence;
pathname = uigetdir('D://050722 coculture tfm processed2/pos13/quantification (basal)/');%select processed file
[filename_roi, pathname_roi] = uigetfile('*.zip','Select your roiset.zip file');

bw_tp = roi_to_mask(pathname_roi,filename_roi,img_sz);

Files = dir(fullfile(pathname,['Traction_PIV','*.txt']));%select the file of interest
Files = natsortfiles(Files); 
filename = string({Files(:).name});
totalstress = zeros(length(filename),1);
avgstress = zeros(length(filename),1);
force = zeros(length(filename),1);
area = zeros(length(filename),1);
size_image = [img_sz,img_sz];%image size (pixel number x pixel number)
Conv_pixtoum = 0.216;% xx um per pixel

for i = 1:1:length(filename)

    myfile = fullfile(pathname,filename(i));
    a1 = load(myfile);%loading files
    x = a1(:,1);%x axis
    y = a1(:,2);%y axis
    z = a1(:,5);% force value (pa)
    [X, Y] = meshgrid(linspace(1,size_image(1),size_image(1)), linspace(1,size_image(2),size_image(2)));%create matrix space for xy
    %pixel2um = (max(x)-min(x))/size_image(1)*Conv_pixtoum;%xx um per pixel
    Z = griddata(x,y,z,X,Y);
    %// Remove the NaNs for imshow:
    Z(isnan(Z)) = 0;
    figure(i);
    imagesc(Z);
    %m = min(Z(Z~=0));
    %M = max(Z(Z~=0));
    axis off % off the x-y axis
    colorbar
    colormap(jet)
    caxis([0 800])%color bar range, unit: pa
    %saveas(figure(i),[pathname,'/',num2str(i),'.png']);
    
    % mask
    %     h = imfreehand;
    %     roi = wait(h);
    %     boundary = fliplr(getPosition(h));
    %     mask(:,:) =createMask(h);
    mask = bw_tp{i};
    
    
    % get the position and force from the mask
    % position = [X,Y].*mask;
    stress = Z.*mask; % unit: pa

    area(i) = bwarea(mask)*(Conv_pixtoum^2);%unit um^2
    totalstress(i) = nansum(nansum(stress));%kPa
    avgstress(i) = totalstress(i)/bwarea(mask);%avg stress per pixel
    force(i) = totalstress(i)*(Conv_pixtoum^2)*1e-12*1e9;%nN = pa*m2*1e9

    %imwrite(mask,[pathname,'/','Mask-',num2str(i),'.tif']);
    %saveas(figure(i),[pathname,'/','Mask-',num2str(i),'.png']);
    %saveas(figure(1),[pathname,'/',num2str(i),'.fig']);
    close();

end

T = table(area,totalstress/1000,avgstress,force,...
    'VariableNames',{'Cell Area(um^2)','Total stress(kPa)','Average stress(Pa)','Force(nN)'});
writetable(T,[pathname,'/Quantification.xls']);
%xlwrite([pathname,'/Quantification.xls'],["Cell Area(um^2)" "Total stress(kPa)" "Average stress(Pa)" "Force(nN)";area totalstress/1000 avgstress force]);


