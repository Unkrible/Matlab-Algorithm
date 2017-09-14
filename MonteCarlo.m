clear
clc

MaxSimTime = 100000;
f=@(x)(x(1).^2+(x(2)-(x(1)).^(2/3)).^2);

x = zeros(2,1);
n=0;
rand('state',sum(100*clock));

for i=1:MaxSimTime
    x(1)=rand*2-1;              % x��ȡֵ��Χ��[-1,1];
    x(2)=rand*4-2;              % y��ȡֵ��Χ��[-2,2];
    if(f(x)<=1)
        n = n+1;
    end
end
AreaOfHeart = (n/MaxSimTime)*(2*4);

disp(['���ؿ��巨��ø����������Ϊ��' num2str(AreaOfHeart)])