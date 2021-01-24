clc,clear;
t=0:0.001:10;
uc=zeros(1,length(t));
ucrec=zeros(1,length(t));
us=zeros(1,length(t));
usrec=zeros(1,length(t));
up1=zeros(1,length(t));
up2=zeros(1,length(t));
up=zeros(1,length(t));
vcoff=zeros(1,length(t));
vsoff=zeros(1,length(t));
% the below for loop generates the message signal 
for n=1:10
    val1=randi([0 1],1);
    if(val1<0.5);val1=-1;else;val1=1;end
    val2=randi([0 1],1);
    if(val2<0.5);val2=-1;else;val2=1;end
    for i=(n-1):0.001:n
        index=round(i*1000)+1;
        uc(index)=val1;
        us(index)=val2;
    end
end
% subplot(2,1,1)
% plot(0:0.001:10,uc);
% title('the I component');
% subplot(2,1,2)
% plot(0:0.001:10,us);
% title('the Q component');
% the below for loop generates the passband signal from the baseband signal
for i=t
    index=round(i*1000)+1;
    up1(index)=uc(index)*cos(40*pi*i);
    up2(index)=us(index)*sin(40*pi*i);
    up(index)=up1(index)-up2(index);
end
% subplot(3,1,1)
% plot(t,up1);
% title('Modulated I component');
% subplot(3,1,2)
% plot(t,up2);
% title('Modulated Q component');
% subplot(3,1,3)
% plot(t,up);
% title('Passband signal');
fc=10; % change this frequency to change the resolution of the ourput signal
fs=1000;
theta=0;
[b,a]=butter(6,2*fc/fs);
% the below for loop generates the signals after demodulation 
for i=t
    index=round(i*1000)+1;
    ucrec(index)=2*up(index)*cos(40*i*pi+theta);
    usrec(index)=-2*up(index)*sin(40*i*pi+theta);
end
% subplot(2,1,1)
% plot(t,ucrec);
% subplot(2,1,2)
% plot(t,usrec);
% the demodulated signal has to be filtered to get only the message signals
vc=filter(b,a,ucrec);
vs=filter(b,a,usrec);
% the below for loop tries to remove the offset 
for i=t
    index=round(i*1000)+1;
    vcoff(index)=vc(index)*cos(theta*i)-vs(index)*sin(theta*i);
    vsoff(index)=1*vs(index)*cos(theta*i)+vc(index)*sin(theta*i);
end
% title('the phase is pi/4');
subplot(2,2,1)
plot(t,uc);
title('the transmitted I component');
subplot(2,2,2)
plot(t,vcoff);
title('the received I component');
subplot(2,2,3)
plot(t,us);
title('the transmitted Q component');
subplot(2,2,4)
plot(t,vsoff);
title('the received Q component');