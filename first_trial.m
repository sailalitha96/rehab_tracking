delete(imaqfind)
clear all
close all
clc

obj = videoinput('winvideo', 1, 'MJPG_320x240')
obj.ReturnedColorspace = 'rgb';
%src = getselectedsource(vid);
obj.FramesPerTrigger = 1;
% preview(obj);

triggerconfig(obj,'manual');

set(obj,'TriggerRepeat', Inf);

start(obj)     % start ???

%%
while(1)
    
    trigger(obj);
    img = getdata(obj,1);       % 1 ???
    im_red = (img(:,:,1))-rgb2gray(img);
    final =bwareafilt(imfill(im2bw(im_red,40/255),'holes'),[200 350]);
    %imshow(final)
    prop = regionprops(final,'Centroid');
    centroid2 = cat(1,prop.Centroid);
    
    
    im_green = (img(:,:,2))-rgb2gray(img);
    final =bwareafilt(imfill(im2bw(im_green,15/255),'holes'),[200 350]);
    prop = regionprops(final,'Centroid');
    centroid = cat(1,prop.Centroid);
    %imshow(final)
    
    
    
    if ~isempty(centroid) && ~isempty(centroid2)
        text(centroid(1),centroid(2),'*');
        
        text(centroid2(1),centroid2(2),'*');
        
        imshow(img)
        line([centroid(1),centroid2(1)],[centroid(2),centroid2(2)]);
    
        tann = (180/pi) * atan2((centroid2(1) - centroid(1)),(centroid2(2) - centroid(2)));
    
    
    
    end
end
