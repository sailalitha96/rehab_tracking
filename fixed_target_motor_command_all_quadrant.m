% including all the quadrants 
% fixed target with motor commands
% fixed target code
% generating first image
delete(instrfind)
s = serial('COM14');
set (s,'BaudRate',9600);
fopen(s);
fprintf(s,['d255' char(13)]);
fprintf(s,['m255' char(13)]);
fprintf(s,['s0' char(13)]);
% fprintf(s,['s10' char(13)]);
pause(1)

str1='a';
servo_ini=0;
m=1;
while(m<2)
    trigger(obj);
    img_r = getdata(obj,1);
    img = rot90((img_r),1);
    im_red = (img(:,:,1))-rgb2gray(img);
    final =bwareafilt(imfill(im2bw(im_red,r_lim),'holes'),[min_area_r-30 max_area_r+30]);
    final=bwareafilt(final,1);
    prop = regionprops(final,'Centroid');
    ini_cent_r = cat(1,prop.Centroid);
    
    im_green = (img(:,:,2))-rgb2gray(img);
    final =bwareafilt(imfill(im2bw(im_green,g_lim),'holes'),[min_area_g-30 max_area_g+30]);
    final=bwareafilt(final,1);
    prop = regionprops(final,'Centroid');
    ini_cent_g = cat(1,prop.Centroid);
    
    if ~isempty(ini_cent_r) && ~isempty(ini_cent_g)
        ini_ori= (180/pi) * atan2((ini_cent_g(2) - ini_cent_r(2)),(ini_cent_g(1) - ini_cent_r(1)));
        if ini_ori<0
            ini_ori=ini_ori+360;
        end
        m=m+1;
    end
end

% fixed target
target=[300,400];
% Taking red as the robot position
dis=pdist([ini_cent_r;target],'euclidean');
ini_cent_c=[(ini_cent_r(1)+ini_cent_g(1))/2,(ini_cent_r(2)+ini_cent_g(2))/2];
target_ori= (180/pi) * atan2((target(2)-ini_cent_c(2)),(target(1) - ini_cent_c(1)));
servo_rot=int16(target_ori);

%set up the motor connection

% precision upto 50 pixel area
%%
while dis > 20
    % ask motor to move
    %sprintf('keep moving at %s degrees',servo_rot);
%     if servo_rot > 180
%         k=1
%         servo_rot = servo_rot-180
%         str2= int2str(servo_rot);
%         st=strcat(str1,str2)
%         fprintf(s,st);
%         pause(1)
%         fprintf(s,['m255' char(13)]);
%         fprintf(s,['s-20' char(13)]);
%     end
    if servo_rot < 0
        k=2
        servo_rot_f = servo_rot+180
        str2= int2str(servo_rot_f);
        st=strcat(str1,str2)
        fprintf(s,st);
        pause(1)
        fprintf(s,['m255' char(13)]);
        fprintf(s,['s-20' char(13)]);
    end
    if servo_rot <= 180 && servo_rot >=0
        k=3
        servo_rot_f = servo_rot;
        str2= int2str(servo_rot_f)
        st=strcat(str1,str2)
        fprintf(s,st);
        pause(1)
        fprintf(s,['m255' char(13)]);
        fprintf(s,['s20' char(13)]);
    end
    trigger(obj);
    img_r = getdata(obj,1);
    img=rot90((img_r),1);
    im_red = (img(:,:,1))-rgb2gray(img);
    final =bwareafilt(imfill(im2bw(im_red,r_lim),'holes'),[min_area_r-30 max_area_r+30]);
    final=bwareafilt(final,1);
    prop = regionprops(final,'Centroid');
    cent_r = cat(1,prop.Centroid);
    
    im_green = (img(:,:,2))-rgb2gray(img);
    final =bwareafilt(imfill(im2bw(im_green,g_lim),'holes'),[min_area_g-30 max_area_g+30]);
    final=bwareafilt(final,1);
    prop = regionprops(final,'Centroid');
    cent_g = cat(1,prop.Centroid);
    
    if ~isempty(cent_r) && ~isempty(cent_g)
        robo_ori = (180/pi) * atan2((cent_g(2) - cent_r(2)),(cent_g(1) - cent_r(1)))
        dis = pdist([cent_r;target],'euclidean');
        cent_c=[(cent_r(1)+cent_g(1))/2,(cent_r(2)+cent_g(2))/2];
        target_ori= (180/pi) * atan2((target(2)-cent_c(2)),(target(1) - cent_c(1)))
        servo_rot=int16(target_ori)
        scatter([cent_c(1),target(1)],[cent_c(2),target(2)]);
        xlim([0 500]);
        ylim([0,700]);
    end
end


% when reached target, come out
fprintf(s,['s0' char(13)])
fclose(s)
disp('target reached');
