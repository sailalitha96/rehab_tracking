% a fixed path

p0=[100,50];

p1=[400,150];
p2=[300,400];
i=0;
tar=zeros(4,2); %bezier array
for t=0:0.25:1
    i=i+1;
    b=(1-t)*(1-t)*p0+2*(1-t)*t*p1+t*t*p2; %quadratic bezier curve
    tar(i,:)= b;
end
plot(tar(:,1),tar(:,2))
axis([0 480 0 640])

%%

