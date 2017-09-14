% clear
% clc

%ReadTest
% [name,type,grade,age,answer]=textread('ReadTest.txt','%s type%n %n %n %s',2)

%SaveTest
% [name,type,grade,age,answer]=textread('ReadTest.txt','%s type%n %n %n %s',2);
% fid=fopen('SaveTest.txt','wt');
% fprintf(fid,'SaveTest Begin:\n');
% fprintf(fid,'%s type%u %u %u %s \n',char(name(1)),type(1),grade(1),age(1),char(answer(1)));
% fprintf(fid,'SaveTest End');
% fclose(fid);

%polyfit
% x=1:9;
% y=[9,7,6,3,-1,2,5,7,20];
% P=polyfit(x,y,3);
% xi=1:0.2:9;
% yi=polyval(P,xi);
% plot(xi,yi,x,y,'ro');

%fittype拟合
% x=[0,0.4,1.2,2,2.8,3.6,4.4,5.2,6,7.2,8,9.2,10.4,11.6,12.4,13.6,14.4,15];
% y=[1,0.85,0.29,-0.27,-0.53,-0.4,-0.12,0.17 0.28 0.15 -0.03 -0.15 -0.071 0.059 0.08 0.032 -0.015 -0.02];
% plot(x,y,'r*');
% hold on
% syms m;
% f=fittype('a.*cos(k.*m).*exp(w.*m)','independent','m','coefficients',{'a','k','w'});
% cfun=fit(x',y',f)
% xi=0:0.1:15;
% yi=cfun(xi);
% plot(xi,yi,'b');
% axis tight

%Logistic拟合实例1
% X=(1971:2000)-1970;
% Y=[33815 33981 34004 34165 34212 34327 34344 34458 34498 34476 ...
%     34483 34488 34513 34497 34511 34520 34507 34509 34521 34513 34515 34517 ...
%     34519 34519 34521 34521 34523 34525 34525 34527];
% plot(X,Y,'r*');
% hold on
% %线性化回归
% x=exp(-(1:30));
% y=1./Y;
% %计算，输出回归系数B
% c=ones(30,1);
% X=[c,x'];
% B=((X'*X)\X')*y'
% Y=1./(B(1,1)+B(2,1).*exp(-(1:30)));
% plot(1:30,Y)

%地貌可视化
% [x,y]=meshgrid(1:10);
% h=[0,0.02,-0.12,-2.09,0,-0.58,-0.08,0,0,0; ...
%     0.02,0,0,-2.38,0,-4.96,0,0,0,-0.1; ...
%     0,0.1,1.00,0,-3.04,0,0.53,0,0.10,0; ...
%     0,0,0,3.52,0,0,0,0,0,0; ...
%     -0.43,-1.98,0,0,0,0.77,0,2.17,0,0; ...
%     0,0,-2.29,0,0.69,0,2.59,0,0.30,0; ...
%     -0.09,-0.31,0,0,0,4.27,0,0,0,-0.01; ...
%     0,0,0,5.13,7.40,0,1089,0,0.04,0; ...
%     0.1,0,0.58,0,0,1.75,0,-0.11,0,0; ...
%     0,-0.01,0,0,0.3,0,0,0,0,0.01;];
% [xi,yi]=meshgrid(1:0.1:10);
% hi=interp2(x,y,h,xi,yi,'spline');
% surf(xi,yi,hi);
% xlabel('x');ylabel('y');zlabel('h');
% axis tight

%线性规划问题
% c=[-5,-4,-6];
% a=[1,-1,1;3,2,4;3,2,0];
% b=[20;42;30];
% lb=zeros(3,1);
% [x,fval,exitflag]=linprog(c,a,b,[],[],lb,[])

%非线性规划
% function main
%     f=@(x)(x(1).^2+x(2).^2+8);
%     lb=[0,0];
%     [x,fval]=fmincon(f,rand(2,1),[],[],[],[],lb,[],@nonlcon)
% end
% function [c,ceq]=nonlcon(x)
% c=[-x(1).^2+x(2)];
% ceq=[-x(1)-x(2).^2+2];
% end

%二次规划
%目标函数为x的二次函数，约束条件是全线性的，称为二次规划
%pdf up-40

%整数规划
%最好使用Lingo求解

%遗传算法

% [x1,x2]=meshgrid(-3.0:0.05:12.1,4.1:0.05:5.8);
% f=21.5+x1.*sin(4*pi*x1)+x2.*sin(20*pi*x2);
% mesh(x1,x2,f);
% xlabel('x1');ylabel('x2');zlabel('f');

% function f=MyTemp1(x)
%     if any(x>30|x<-30)
%         f=inf;
%     else
%         f=-2*pi*exp(-0.2*sqrt(1/10.*sum(x.^2)'))-exp(1/10*sum((cos(2*pi*x'))))+2*pi;
%     end
% end