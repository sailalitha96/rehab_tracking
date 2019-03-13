delete(imaqfind)


obj = videoinput('winvideo', 1, 'M420_640x480');
obj.ReturnedColorspace = 'rgb';
obj.FramesPerTrigger = 1;

triggerconfig(obj,'manual');

set(obj,'TriggerRepeat', Inf);
start(obj);
r_lim=65/255

while(1)
    trigger(obj);
   
    img_r = getdata(obj,1);
    img=rot90((img_r),1);
    im_red = (img(:,:,1))-rgb2gray(img); 
    final =bwareafilt(imfill(im2bw(im_red,r_lim),'holes'),[min_area_r-30 max_area_r+30]);
    final=bwareafilt(final,1);
    prop = regionprops(final,'Centroid');
    cent_r = cat(1,prop.Centroid);
    cent_rr=[cent_r(1),640-cent_r(1)];
end


scatter(cent_rr)
