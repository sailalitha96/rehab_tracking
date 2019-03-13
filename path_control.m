
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
prev_servo=0;
str1='a';
num=8;
div=1/num;
%set the initial angle of servo =0
fprintf(s,['a0' char(13)]);
pause(5)
m=1;
while(m<2)
    trigger(obj);
    img_r = getdata(obj,1);
    img = rot90((img_r),-1);
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
        cent_r=[480-ini_cent_r(1),ini_cent_r(2)];
        cent_g=[480-ini_cent_g(1),ini_cent_g(2)];
        robo_ori= (180/pi) * atan2((cent_g(2) - cent_r(2)),(cent_g(1) - cent_r(1)));
        if robo_ori<0
            robo_ori=robo_ori+360;
        end
        m=m+1;
    end
end
% fixed target

% Taking red as the robot position

ini_cent_c=[(cent_r(1)+cent_g(1))/2,(cent_r(2)+cent_g(2))/2];

p0=ini_cent_c;
p1=[400,150];
p2=[300,400];
i=0;
tar=zeros(num,2); %bezier array
for t=0:div:1
    i=i+1;
    b=(1-t)*(1-t)*p0+2*(1-t)*t*p1+t*t*p2; %quadratic bezier curve
    tar(i,:)= b;
end
plot(tar(:,1),tar(:,2))
axis([0 480 0 640])
hold on
cent_c=ini_cent_c;
% startng the function/ calling the function in a loop
n=2;
while n<num+2
    target=tar(n,:);
    dis=pdist([cent_c;target],'euclidean');
    target_ori= (180/pi) * atan2((target(2)-cent_c(2)),(target(1) - cent_c(1)));
    if target_ori<0
        target_ori=target_ori+360;
    end
    rel_ang = target_ori - robo_ori;
    rel_ang=int16(rel_ang);
    
    while dis > 20
        if ~isempty(cent_r) && ~isempty(cent_g)
            % ask motor to move
            if rel_ang <= 0
                if rel_ang >= -180
                    
                    if (prev_servo + rel_ang) >= 0
                        servo_rot = prev_servo + rel_ang;
                        str2= int2str(servo_rot);
                        st=strcat(str1,str2)
                        prev_servo=servo_rot;
                        fprintf(s,st);
                        pause(0.2)
                        fprintf(s,['m255' char(13)]);
                        fprintf(s,['s20' char(13)]);
                        %s20
                    else
                        servo_rot = prev_servo + 180 + rel_ang
                        str2= int2str(servo_rot);
                        st=strcat(str1,str2)
                        prev_servo=servo_rot;
                        fprintf(s,st);
                        pause(0.2)
                        fprintf(s,['m255' char(13)]);
                        fprintf(s,['s-20' char(13)]);
                        %s-20
                    end
                    
                else
                    rel_ang_1 = 360 + rel_ang
                    
                    if (prev_servo + rel_ang_1) <= 180
                        servo_rot = prev_servo + rel_ang_1;
                        str2= int2str(servo_rot);
                        st=strcat(str1,str2)
                        prev_servo=servo_rot;
                        fprintf(s,st);
                        pause(0.2)
                        fprintf(s,['m255' char(13)]);
                        fprintf(s,['s20' char(13)]);
                        %s20
                    else
                        servo_rot = prev_servo - 180 + rel_ang_1;
                        str2= int2str(servo_rot);
                        st=strcat(str1,str2)
                        prev_servo=servo_rot;
                        fprintf(s,st);
                        pause(0.2)
                        fprintf(s,['m255' char(13)]);
                        fprintf(s,['s-20' char(13)]);
                        %s-20
                    end
                end
            end
            
            if rel_ang > 0
                
                if rel_ang <= 180
                    
                    if rel_ang + prev_servo <= 180
                        servo_rot = prev_servo + rel_ang;
                        str2= int2str(servo_rot);
                        st=strcat(str1,str2)
                        prev_servo=servo_rot;
                        fprintf(s,st);
                        pause(0.2)
                        fprintf(s,['m255' char(13)]);
                        fprintf(s,['s20' char(13)]);
                        %s20
                    else
                        servo_rot = prev_servo + rel_ang - 180;
                        str2= int2str(servo_rot);
                        st=strcat(str1,str2)
                        prev_servo=servo_rot;
                        fprintf(s,st);
                        pause(0.2)
                        fprintf(s,['m255' char(13)]);
                        fprintf(s,['s-20' char(13)]);
                        %s-20
                    end
                    
                else
                    rel_ang_1 = 360 - rel_ang;
                    
                    if prev_servo - rel_ang_1 >= 0
                        servo_rot = prev_servo - rel_ang_1;
                        str2= int2str(servo_rot);
                        st=strcat(str1,str2)
                        prev_servo=servo_rot;
                        fprintf(s,st);
                        pause(0.2)
                        fprintf(s,['m255' char(13)]);
                        fprintf(s,['s20' char(13)]);
                        %s20
                    else
                        servo_rot = prev_servo + 180 - rel_ang_1;
                        str2= int2str(servo_rot);
                        st=strcat(str1,str2)
                        prev_servo=servo_rot;
                        fprintf(s,st);
                        pause(0.2)
                        fprintf(s,['m255' char(13)]);
                        fprintf(s,['s-20' char(13)]);
                        %s-20
                    end
                end
            end
        end
        
        trigger(obj);
        img_r = getdata(obj,1);
        img= rot90((img_r),-1);
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
            cent_r=[480-cent_r(1),cent_r(2)];
            cent_g=[480-cent_g(1),cent_g(2)];
            robo_ori = (180/pi) * atan2((cent_g(2) - cent_r(2)),(cent_g(1) - cent_r(1)))
            if robo_ori<0
                robo_ori=robo_ori+360
            end
            
            cent_c=[(cent_r(1)+cent_g(1))/2,(cent_r(2)+cent_g(2))/2];
            dis = pdist([cent_c;target],'euclidean');
            target_ori= (180/pi) * atan2((target(2)-cent_c(2)),(target(1) - cent_c(1)))
            if target_ori<0
                target_ori=target_ori+360;
            end
            rel_ang = target_ori - robo_ori;
            rel_ang=int16(rel_ang);
            scatter([cent_c(1),target(1)],[cent_c(2),target(2)]);
            hold on
            xlim([0 500]);
            ylim([0,700]);
        end
    end
    n=n+1;
    disp('target reached');
end
fprintf(s,['s0' char(13)])
fclose(s)
disp('target reached');