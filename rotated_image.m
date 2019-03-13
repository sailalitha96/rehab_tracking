delete(imaqfind)

obj = videoinput('winvideo', 1, 'M420_640x480');
obj.ReturnedColorspace = 'rgb';
obj.FramesPerTrigger = 1;

triggerconfig(obj,'manual');

set(obj,'TriggerRepeat', Inf);
start(obj);

trigger(obj);
img = getdata(obj,1);
img = rot90((img),1);
% img = flip(img);
imshow(img)

cent=zeros(1000,1)
