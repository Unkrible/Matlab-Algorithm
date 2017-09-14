% ����Ⱥ�㷨������Լ���Ż����⣻
% ���׷�Խ�ֲ���Ϣ������Ѱ��ȫ�����Ž⣬�����ܱ�֤һ�����ҵ���
% ȱ�����ھֲ����������ϲ�������Ȳ����ߣ�

% ������m��һ��ȡֵΪ20~40�����������������Ҫ100~200�����ӣ�
%��������w��wԽ�����������ֲ����Ų������㷨���ȣ����Ƕ��彨��0.6~0.75��
%���ٳ���c1��c2��һ�������ȡc1=c2=2.0���㷨ѧ�Ҽ�������������ܴ󣬼�PDF ��-80��
%�������ٶ�Vmax�������ڷ�ֹ������Χ�������巢ɢ�ӹ�����Ŀ��ֵ��ͨ��Ϊÿά�仯��Χ��10%~20%��

%�� maxf(x) = 2.1(1-x+2*x^2)exp(-x^2/2), x��[-5,5] Ϊ��

function ParticleSwarmOptimization()
    clc;
    clear all;
    close all;
    tic;                                    %�������м�ʱ��
    E0=0.001;                               %������
    MaxNum=100;                             %����������������
    narvs=1;                                %Ŀ�꺯�����Ա���������
    particlesize=30;                        %����Ⱥ��ģ��
    c1=2;                                   %ÿ�����ӵĸ���ѧϰ���ӣ�Ҳ��Ϊ���ٳ�����
    c2=2;                                   %ÿ�����ӵ����ѧϰ���ӣ�Ҳ��Ϊ���ٳ�����
    w=0.6;                                  %�������ӣ�
    vmax=0.8;                               %���ӵ��������ٶȣ�
    x= -5+10*rand(particlesize,narvs);      %��ʼ���������ڵ�λ�ã�
    v = 2*rand(particlesize,narvs);         %��ʼ�����ӵķ����ٶȣ�
    
    %��inline������Ӧ�Ⱥ����Ա㽫�Ӻ����ļ����������ļ�����һ��
    %Ŀ�꺯����������
    fitness=inline('1/(1+(2.1*(1-x+2*x.^2).*exp(-x.^2/2)))','x');
    for i=1:particlesize
        f(i)=fitness(x(i,:));
    end
    
    %��ʼ������Ⱥ
    personalbest_x = x;
    personalbest_faval = f;
    [globalbest_faval,i]=min(personalbest_faval);
    globalbest_x=personalbest_x(i,:);
    
    k=1;
    while k<= MaxNum
        for i=1:particlesize
            f(i)=fitness(x(i,:));
            if f(i)<personalbest_x(i)       %�жϵ�ǰλ���Ƿ�����ʷ�����λ��
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
    
    %���
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
    legend('Ŀ�꺯��','�����������ֵ');
    xlabel('x');ylabel('y');
    grid on;
    toc;
end
