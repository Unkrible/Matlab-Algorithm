clear
clc

MaxSimTime = 100000;
f=@(x)(x(1).^2+(x(2)-(x(1)).^(2/3)).^2);

x = zeros(2,1);
n=0;
rand('state',sum(100*clock));

for i=1:MaxSimTime
    x(1)=rand*2-1;              % x的取值范围是[-1,1];
    x(2)=rand*4-2;              % y的取值范围是[-2,2];
    if(f(x)<=1)
        n = n+1;
    end
end
AreaOfHeart = (n/MaxSimTime)*(2*4);

disp(['蒙特卡洛法求得该心形线面积为：' num2str(AreaOfHeart)])