clear all
close all
clc

% 为避免陷入局部最优，通过多次尝试；
nums_test = 20;

global v            % v为实力因子；
rand('state',sum(100*clock));       % 初始化随机数生成器；
format long g                       % 设置输出格式

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 求解K1型
p_k1 = [2e-7,8e-7,1.8e-5,2.61e-4,3.42e-3,4.1995e-2]';    %K1型中奖概率；
Aeq = [1,1,1,0,0,0];
beq = 1;
a_lb = [10,4,3,4,2,2];
b_ub = [233,54,17,20,10,10];
A = [
    0,0,0,-1,a_lb(4),0;
    0,0,0,1,b_ub(4),0;
    0,0,0,0,-1,a_lb(5);
    0,0,0,0,1,b_ub(5);
    ];
b = [0,0,0,0]';
lb = [0.5,0,0,0,0,0]';
ub = [0.8,1,1,inf,inf,inf]';

rx0_tmp = zeros(6,1);
rx_meta_result = zeros(6,1);
fval_meta_result = inf;
flag_meta_result = nan;         %判断以前是否得到可行解；

for index = 1:nums_test
    rx0_tmp(1) = rand*(0.8-0.5)+0.5;
    rx0_tmp(2) = rand*(1-rx0_tmp(1));
    rx0_tmp(3) = 1-sum(rx0_tmp);
    rx0_tmp(4) = rand*1000;
    rx0_tmp(5) = rand*100;
    rx0_tmp(6) = rand*50;
    
    %寻找最优解
    [rx0_tmp,fval_tmp,flag_tmp,output_tmp] = ...
        fmincon(@cpiao,rx0_tmp,A,b,Aeq,beq,lb,ub,@nonlcon,[],1,p_k1,a_lb,b_ub);
    if(flag_tmp==1)&&(flag_meta_result>fval_tmp)
        fval_meta_result = fval_tmp;
        rx_meta_result = rx0_tmp;
        flag_meta_result = 1;
    end
end

if ~isnan(flag_meta_reslt)          %得到可行解
    rx_k1 = rx_meta_result;
    fval_k1 = fval_meta_result;
    flag_k1 = flag_tmp;
    output_k1 = output_tmp;
end


function f=cpiao(rx,type,p_test,a_lb,b_ub)
    global v
    
    % type表示K1、K2、K3、K4不同类型；
    
    if(type == 1)
        sum_last3 = (p_test(4:6))'*rx(4:6);
        f= - ...
            ( p_test(1).*(1-exp(-(((1-sum_last3).*rx(1))./p_test(1)./v).^2))+ ...
              p_test(2).*(1-exp(-(((1-sum_last3).*rx(2))./p_test(2)./v).^2))+ ...
              p_test(3).*(1-exp(-(((1-sum_last3).*rx(3))./p_test(3)./v).^2))+ ...
              p_test(4).*(1-exp(-(rx(4)./v).^2))+ ...
              p_test(5).*(1-exp(-(rx(5)./v).^2))+ ...
              p_test(6).*(1-exp(-(rx(6)./v).^2)) ...
            );
    elseif (type==2||type==3)
        sum_last4 = (p_test(4:7))'*rx(4:7);
        f= - ...
            ( p_test(1).*(1-exp(-(((1-sum_last4).*rx(1))./p_test(1)./v).^2))+ ...
              p_test(2).*(1-exp(-(((1-sum_last4).*rx(2))./p_test(2)./v).^2))+ ...
              p_test(3).*(1-exp(-(((1-sum_last4).*rx(3))./p_test(3)./v).^2))+ ...
              p_test(4).*(1-exp(-(rx(4)./v).^2))+ ...
              p_test(5).*(1-exp(-(rx(5)./v).^2))+ ...
              p_test(6).*(1-exp(-(rx(6)./v).^2))+ ...
              p_test(7).*(1-exp(-(rx(7)./v).^2)) ...
            );
    elseif (type==4)
        sum_last2 = (p_test(4:5))'*rx(4:5);
        f= - ...
            ( p_test(1).*(1-exp(-(((1-sum_last2).*rx(1))./p_test(1)./v).^2))+ ...
              p_test(2).*(1-exp(-(((1-sum_last2).*rx(2))./p_test(2)./v).^2))+ ...
              p_test(3).*(1-exp(-(((1-sum_last2).*rx(3))./p_test(3)./v).^2))+ ...
              p_test(4).*(1-exp(-(rx(4)./v).^2))+ ...
              p_test(5).*(1-exp(-(rx(5)./v).^2)) ...
            );
    else
        error('Error in function cpiao');
    end
end

function [c,ceq]=nonlcon(rx,type,p_test,a_lb,b_ub)
    global v
    
    % type表示K1、K2、K3、K4不同类型；
    
    % TODO:完成rx对于x的约束条件
    if type==1
        
    end
    
    ceq=[];
end