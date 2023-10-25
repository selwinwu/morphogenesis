% REMEMBER TO COPY Traction_PIV.txt TO THE RGB TIMELAPSE FOLDER

pathname = uigetdir('D://control spreading/020322 pos8/RGB subtracted/');%select saving directory
time_series_prefix = 'RGB_'; %filename of the RGB image sequence
new_folder=[pathname,'/TFM/'];
mkdir(new_folder);
length = 61; %total number of frames
range = 500; %maximum range

for i = 1 : length

    fid = fopen(strcat('Traction_PIV',num2str(i),'.txt'),'r');
    txt = textscan(fid,'%f %f %f %f %f');
    fclose(fid);

    if i>99
        temp = strcat(time_series_prefix,num2str(i),'.tif')
        imshow(temp);
    elseif i>9
        temp = strcat(time_series_prefix,'0',num2str(i),'.tif');
        imshow(temp);
    else
        temp = strcat(time_series_prefix,'00',num2str(i),'.tif');
        imshow(temp);
    end
    hold on;
    
    x = txt{1,1};
    y = txt{1,2};
    u = txt{1,3};
    v = txt{1,4};
    m = txt{1,5};
    for j = 1:71 %pad zeros to left side
        u(j) = 0;
        v(j) = 0;
    end
    for j = 4971:5041 %pad zeros to right side
        u(j) = 0;
        v(j) = 0;
    end
    for j = 1:71:4970 % pad zeros to top
        u(j) = 0;
        v(j) = 0;
    end
    for j = 71:71:5041 %pad zeros to bottom
        u(j) = 0;
        v(j) = 0;
    end
    quiver(x,y,u*0.1,v*0.1,'AutoScale','off', 'MaxHeadSize', 0.3,'LineWidth', 0.7, 'Color', 'red');
    %for j = 1 : 5041    
        %if m(j) >= (range)
        %    quiver(x(j),y(j),u(j),v(j),'AutoScaleFactor',5, 'MaxHeadSize', 0.3,'LineWidth', 0.7,'color',[0 0 1]);
        %elseif m(j)>= (0.75*range)
        %    quiver(x(j),y(j),u(j),v(j),'AutoScaleFactor',5, 'MaxHeadSize', 0.3,'LineWidth', 0.7,'color',[0 0 0.75]);
        %elseif m(j)>= (0.5*range)
        %    quiver(x(j),y(j),u(j),v(j),'AutoScaleFactor',5, 'MaxHeadSize', 0.3,'LineWidth', 0.7,'color',[0 0 0.5]);
        %elseif m(j)>= (0.25*range)
        %    quiver(x(j),y(j),u(j),v(j),'AutoScaleFactor',5, 'MaxHeadSize', 0.3,'LineWidth', 0.7,'color',[0 0 0.25]);
        %else
        %    quiver(x(j),y(j),u(j),v(j),'AutoScaleFactor',5, 'MaxHeadSize', 0.3,'LineWidth', 0.7,'color',[0 0 0]);
        %end
    %end
    print('-dtiffnocompression',[new_folder,'/','TFM',num2str(i),'.tif']);
    hold off;
    
end