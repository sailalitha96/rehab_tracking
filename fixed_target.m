% fixed target code
% generating first image
m=1;
while(m<2)
    trigger(obj);
    img = getdata(obj,1);
    
    im_red = (img(:,:,1))-rgb2gray(img);
    final =bwareafilt(imfill(im2bw(im_red,r_lim),'holes'),[min_area_r-30 max_area_r+30]);
    final=bwareafilt(final,1);
    prop = regionprops(final,'Centroid');
    ini_cent_r = cat(1,prop.Centroid);
    
    im_green = (img(:,:,2))-rgb2gray(img);
    final =bwareafilt(imfill(im2bw(im_green,g_lim),'holes'),[min_area_g-30 max_area_g+30]);
    final=bwareafilt(final,1);
    prop = regionprops(final,'Centroid');
    ini_cent_g = cat(1,prop.Centroid)
    
    if ~isempty(ini_cent_r) && ~isempty(ini_cent_g)
        ini_ori= (180/pi) * atan2((ini_cent_g(2) - ini_cent_r(2)),(ini_cent_g(1) - ini_cent_r(1)))
        m=m+1;
    end
end

% fixed target
target=[400,20];
% Taking red as the robot position
dis=pdist([ini_cent_r;target],'euclidean');
target_ori= (180/pi) * atan2((target(2)-ini_cent_r(2)),(target(1) - ini_cent_r(1)));
servo_rot=ini_ori-target_ori;

%set up the motor connection
%s = serial('COM13');
%set(s,'BaudRate',9600);
%fopen(s);
%fprintf(s,['d255' char(13)])
% precision upto 50 pixel area

while dis > 20
    % ask motor to move
    sprintf('keep moving at %s degrees',servo_rot)
    %fprintf(s,['s<servo_rot>' char(13)])
    % ask motor to rotate
    %fprintf(s,['s20' char(13)])
    
    trigger(obj);
    img = getdata(obj,1);
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
        robo_ori = (180/pi) * atan2((cent_g(2) - cent_r(2)),(cent_g(1) - cent_r(1)));
        dis = pdist([cent_r;target],'euclidean');
        target_ori= (180/pi) * atan2((target(2)-cent_r(2)),(target(1) - cent_r(1)));
        servo_rot=robo_ori-target_ori;
        scatter([cent_r(2),target(2)],[cent_r(1),target(1)]);
        xlim([0 500]);
        ylim([0,700]);
    else
        servo_rot=0;
    end
end


% when reached target, come out
%fprintf(s,['s0' char(13)])
%fclose(s)
disp('target reached');
