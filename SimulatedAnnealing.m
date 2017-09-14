% 模拟退火算法

% 许多实际优化问题的目标函数都是非凸的，存在许多局部最优解；
% 求解全局优化问题的方法可分为两类，一类是确定性方法，一类是随机性方法；
% 确定性算法适用于求解一些具有特殊特征的问题，而梯度法和一般的随机搜索方法则易陷入局部最优；

% SA是一种通用概率算法，用来在一个大的搜寻空间内寻找问题的最优解；
% 能有效解决NP问题，避免陷入局部最优，对初值没有强依赖关系；

% 参数说明：
% 控制参数的初值T0：冷却开始的温度；
% 控制参数T的衰减函数，将连续的降温过程离散化成降温过程中的一系列温度点；
% 控制参数T的终值Tf；
% Markov链的长度Lk：任一温度T的迭代次数；

% 算法实质分两层循环，在任一温度随机扰动产生新解，逼格计算目标函数值的变化，决定是否被接受；

% 收敛的一般性条件：初始温度足够高；热平衡时间足够长；终止温度足够低；降温过程足够缓慢；

% 参数的选择：
% T0足够大；
% 衰减函数，一个常用的衰减函数是，T(k+1)=a*T(k)，a∈[0.5,0.99]；
% Markov链长度的选取原则是，在控制参数T的衰减函数选定的前提下，Lk应使在控制参数T的每一取值
%   达到准平衡，经验上说简单情况下Lk=100*n，n为问题规模；


%TSP旅行商问题的SA算法

clear
clc
tic
a=0.99;                     % 温度衰减函数的参数；
t0=97;tf=3;
t=t0;
Markov_length=10000;        % Markov链长度；
coordinates =[
1 565.0 575.0;2 25.0 185.0;3 345.0 750.0;
4 945.0 685.5;5 845.0 655.0;6 880.0 660.0;
7 25.0 230.0;8 525.0 1000.0;9 580.0 1175.0;
];
coordinates(:,1)=[];
amount = size(coordinates,1);   % 城市的数目；

% 通过向量化的方法计算距离矩阵；
dist_matrix = zeros(amount,amount);
coor_x_tmp1 = coordinates(:,1) * ones(1,amount);
coor_x_tmp2 = coor_x_tmp1';
coor_y_tmp1 = coordinates(:,2) * ones(1,amount);
coor_y_tmp2 = coor_y_tmp1';
dist_matrix = sqrt((coor_x_tmp1-coor_x_tmp2).^2+(coor_y_tmp1-coor_y_tmp2).^2);

sol_new = 1:amount;             % 产生初始解；
sol_current = sol_new;sol_best=sol_new;
% sol_new是新解；sol_current是当前解；sol_best是冷却中的最优解；
E_current=inf;E_best=inf;       % E是当前回路的距离;

% SA
while t>=tf
    % Markov链
    for r=1:Markov_length
          
        % 产生随机扰动
        if (rand<0.5)
            %两交换
            ind1=0;ind2=0;
            while(ind1==ind2)
                ind1=ceil(rand*amount);
                ind2=ceil(rand*amount);
            end
            tmp1 = sol_new(ind1);
            sol_new(ind1)=sol_new(ind2);
            sol_new(ind2)=tmp1;
%         else
%             %三交换
%             ind1=0;ind2=0;ind3=0;
%             while((ind1==ind2)||(ind1==ind3)||(ind2==ind3))
%                 ind1=ceil(rand*amount);
%                 ind2=ceil(rand*amount);
%                 ind3=ceil(rand*amount);
%             end
%             % TODO:完成三交换，确保ind1<ind2<ind3
        end
        
        % 检查是否满足约束；
        
        % 计算目标函数值；
        E_new = 0;
        for i=1:(amount-1)
            E_new = E_new + dist_matrix(sol_new(i),sol_new(i+1));
        end
        E_new = E_new + dist_matrix(sol_new(amount),sol_new(1));
        
        if E_new < E_current
            E_current = E_new;
            sol_current = sol_new;
            if E_new < E_best
                %保存冷却过程中最好的
                E_best = E_new;
                sol_best = sol_new;
            end
        else
            % 以一定概率接受新解；
            if rand<exp(-(E_new-E_current)./t)
                E_current = E_new;
                sol_current = sol_new;
            else
                sol_new = sol_current;
            end
        end
    end
     t = t.*a;          % 温度衰减；
end
    disp('最优解：')
    disp(sol_best)
    disp('最短距离：')
    disp(E_best)
toc