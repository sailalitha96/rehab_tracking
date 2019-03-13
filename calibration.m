% caliberation
delete(imaqfind)
clear all
close all
clc

obj = videoinput('winvideo', 1, 'M420_640x480');
obj.ReturnedColorspace = 'rgb';
obj.FramesPerTrigger = 1;

triggerconfig(obj,'manual');

set(obj,'TriggerRepeat', Inf);
start(obj);

%%
i=1;
a=zeros(10,1);
r_lim=65/255;
while (i<11)
    trigger(obj);
    img = getdata(obj,1);
    im_red = (img(:,:,1))-rgb2gray(img);
    final =bwareafilt(imfill(im2bw(im_red,r_lim),'holes'),1);
    imshow(final);
    prop = regionprops(final,'Centroid');
    cent_red = cat(1,prop.Centroid);
    if ~isempty(cent_red)
       a(i)=bwarea(final);
       i=i+1;
    end
end
max_area_r=max(a);
min_area_r=min(a);
%%
j=1;
b=zeros(10,1);
g_lim=30/255;
while (j<11)
    trigger(obj);
    img = getdata(obj,1);
    im_green = (img(:,:,2))-rgb2gray(img);
    final =bwareafilt(imfill(im2bw(im_green,g_lim),'holes'),1);
    imshow(final);
    prop = regionprops(final,'Centroid');
    cent_green= cat(1,prop.Centroid);
    if ~isempty(cent_green)
       b(j)=bwarea(final);
       j=j+1;
    end
end
max_area_g=max(b);
min_area_g=min(b);

%%
% cross check if code is working
while (1)
    trigger(obj);
    img = getdata(obj,1);
    im_red = (img(:,:,1))-rgb2gray(img);
    final =bwareafilt(imfill(im2bw(im_red,r_lim),'holes'),[min_area_r-30 max_area_r+30]);
    final=bwareafilt(final,1);
    imshow(final);
    prop = regionprops(final,'Centroid');
    cent_red = cat(1,prop.Centroid);
    if isempty(cent_red)
       sprintf('fail');
    end
end

% cross check if code is  for green
while (1)
    trigger(obj);
    img = getdata(obj,1);
    im_green = (img(:,:,2))-rgb2gray(img);
    final =bwareafilt(imfill(im2bw(im_green,g_lim),'holes'),[min_area_g-30 max_area_g+30]);
    final=bwareafilt(final,1);
    imshow(final);
    prop = regionprops(final,'Centroid');
    cent_green = cat(1,prop.Centroid);
    if isempty(cent_green)
       sprintf('fail');
    end
end