function [G]=GreyForecasting(A,forecast_num)
%GreyForecasting ��ɫԤ�⣬�ȶ��ض����ݽ���Ԥ��
%   A��Ϊԭʼ���ݣ��Ի�ɫģ��Ԥ��forecast_num�������ΪG
    syms a b;                   %aΪ��չϵ����bΪ��ɫ������
    B=cumsum(A);                %ԭʼ�����ۼ�
    n=length(A);
    for i=1:(n-1)
        C(i)=(B(i)+B(i+1))/2;   %�����ۼӾ���C
    end
    D=A;
    D(1)=[];
    D=D';                       %���ɳ���������D
    
    %����С���˷��������������ֵ
    E=[-C;ones(1,n-1)];
    c=(E*E')\E*D;
    c=c';
    a=c(1);b=c(2);
    
    %Ԥ���������
    F=zeros(1,n+forecast_num);F(1)=A(1);
    for i=2:(n+forecast_num)
        F(i)=(A(1)-b/a)/exp(a*(i-1))+b/a;
    end
    G=zeros(1,n+forecast_num);G(1)=A(1);
    for i=2:(n+forecast_num)
        G(i)=F(i)-F(i-1);
    end
    
    %ͼ������۲����
    plot(1:length(A),A,'ro',1:length(G),G,'b');
end