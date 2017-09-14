% 粒子群算法，用于约束优化问题；
% 容易飞越局部信息，善于寻找全局最优解，但不能保证一定能找到；
% 缺点在于局部搜索能力较差，搜索精度不够高；

% 粒子数m，一般取值为20~40；对于特殊的难题需要100~200个粒子；
%惯性因子w，w越大利于跳出局部最优不利于算法精度，若是定义建议0.6~0.75；
%加速常数c1和c2，一般情况下取c1=c2=2.0，算法学家间对这个参数分歧很大，见PDF 上-80；
%最大飞翔速度Vmax，有利于防止搜索范围毫无意义发散掠过最优目标值，通常为每维变化范围的10%~20%；

%以 maxf(x) = 2.1(1-x+2*x^2)exp(-x^2/2), x∈[-5,5] 为例

function ParticleSwarmOptimization()
    clc;
    clear all;
    close all;
    tic;                                    %程序运行计时；
    E0=0.001;                               %允许误差；
    MaxNum=100;                             %粒子最大迭代次数；
    narvs=1;                                %目标函数的自变量个数；
    particlesize=30;                        %粒子群规模；
    c1=2;                                   %每个粒子的个体学习因子，也称为加速常数；
    c2=2;                                   %每个粒子的社会学习因子，也称为加速常数；
    w=0.6;                                  %惯性因子；
    vmax=0.8;                               %粒子的最大飞翔速度；
    x= -5+10*rand(particlesize,narvs);      %初始化粒子所在的位置；
    v = 2*rand(particlesize,narvs);         %初始化粒子的飞翔速度；
    
    %用inline定义适应度函数以便将子函数文件和主程序文件放在一起；
    %目标函数如上所述
    fitness=inline('1/(1+(2.1*(1-x+2*x.^2).*exp(-x.^2/2)))','x');
    for i=1:particlesize
        f(i)=fitness(x(i,:));
    end
    
    %初始化粒子群
    personalbest_x = x;
    personalbest_faval = f;
    [globalbest_faval,i]=min(personalbest_faval);
    globalbest_x=personalbest_x(i,:);
    
    k=1;
    while k<= MaxNum
        for i=1:particlesize
            f(i)=fitness(x(i,:));
            if f(i)<personalbest_x(i)       %判断当前位置是否是历史上最佳位置
                personalbest_x(i,:)=x(i,:);
                personalbest_faval(i)=f(i);
            end
        end
        [globalbest_faval,i]=min(personalbest_faval);
        globalbest_x=personalbest_x(i,:);
        for i=1:particlesize
            v(i,:) = w*v(i,:)+c1.*rand.*(personalbest_x(i,:)-x(i,:)) ...
                +c2.*rand.*(globalbest_x-x(i,:));
            for j=1:narvs
                if v(i,j)>vmax
                    v(i,j)=vmax;
                elseif v(i,j)<-vmax
                    v(i,j)=-vmax;
                end            
            end
            x(i,:)=x(i,:)+v(i,:);
        end
        if abs(globalbest_faval)<E0
            break;
        end
        k=k+1;
    end
    
    %输出
    Value1 = 1/globalbest_faval-1;
    Value1=num2str(Value1);
    disp(strcat('the maximum value','=',Value1));
    Value2 = globalbest_x;Value2=num2str(Value2);
    disp(strcat('the corresponding coordinate','=',Value2));
    x=-5:0.01:5;
    y=2.1*(1-x+2*x.^2).*exp(-x.^2/2);
    plot(x,y,'m-','linewidth',3);
    hold on;
    plot(globalbest_x,1/globalbest_faval-1,'kp','linewidth',4);
    legend('目标函数','搜索到的最大值');
    xlabel('x');ylabel('y');
    grid on;
    toc;
end
