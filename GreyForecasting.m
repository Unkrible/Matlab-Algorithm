function [G]=GreyForecasting(A,forecast_num)
%GreyForecasting 灰色预测，稳定地对数据进行预测
%   A作为原始数据，以灰色模型预测forecast_num数据输出为G
    syms a b;                   %a为发展系数，b为灰色作用量
    B=cumsum(A);                %原始数据累加
    n=length(A);
    for i=1:(n-1)
        C(i)=(B(i)+B(i+1))/2;   %生成累加矩阵C
    end
    D=A;
    D(1)=[];
    D=D';                       %生成常数向量项D
    
    %用最小二乘法计算待定参数的值
    E=[-C;ones(1,n-1)];
    c=(E*E')\E*D;
    c=c';
    a=c(1);b=c(2);
    
    %预测后续数据
    F=zeros(1,n+forecast_num);F(1)=A(1);
    for i=2:(n+forecast_num)
        F(i)=(A(1)-b/a)/exp(a*(i-1))+b/a;
    end
    G=zeros(1,n+forecast_num);G(1)=A(1);
    for i=2:(n+forecast_num)
        G(i)=F(i)-F(i-1);
    end
    
    %图表输出观察误差
    plot(1:length(A),A,'ro',1:length(G),G,'b');
end