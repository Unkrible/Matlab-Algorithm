% ģ���˻��㷨

% ���ʵ���Ż������Ŀ�꺯�����Ƿ�͹�ģ��������ֲ����Ž⣻
% ���ȫ���Ż�����ķ����ɷ�Ϊ���࣬һ����ȷ���Է�����һ��������Է�����
% ȷ�����㷨���������һЩ�����������������⣬���ݶȷ���һ����������������������ֲ����ţ�

% SA��һ��ͨ�ø����㷨��������һ�������Ѱ�ռ���Ѱ����������Ž⣻
% ����Ч���NP���⣬��������ֲ����ţ��Գ�ֵû��ǿ������ϵ��

% ����˵����
% ���Ʋ����ĳ�ֵT0����ȴ��ʼ���¶ȣ�
% ���Ʋ���T��˥���������������Ľ��¹�����ɢ���ɽ��¹����е�һϵ���¶ȵ㣻
% ���Ʋ���T����ֵTf��
% Markov���ĳ���Lk����һ�¶�T�ĵ���������

% �㷨ʵ�ʷ�����ѭ��������һ�¶�����Ŷ������½⣬�Ƹ����Ŀ�꺯��ֵ�ı仯�������Ƿ񱻽��ܣ�

% ������һ������������ʼ�¶��㹻�ߣ���ƽ��ʱ���㹻������ֹ�¶��㹻�ͣ����¹����㹻������

% ������ѡ��
% T0�㹻��
% ˥��������һ�����õ�˥�������ǣ�T(k+1)=a*T(k)��a��[0.5,0.99]��
% Markov�����ȵ�ѡȡԭ���ǣ��ڿ��Ʋ���T��˥������ѡ����ǰ���£�LkӦʹ�ڿ��Ʋ���T��ÿһȡֵ
%   �ﵽ׼ƽ�⣬������˵�������Lk=100*n��nΪ�����ģ��


%TSP�����������SA�㷨

clear
clc
tic
a=0.99;                     % �¶�˥�������Ĳ�����
t0=97;tf=3;
t=t0;
Markov_length=10000;        % Markov�����ȣ�
coordinates =[
1 565.0 575.0;2 25.0 185.0;3 345.0 750.0;
4 945.0 685.5;5 845.0 655.0;6 880.0 660.0;
7 25.0 230.0;8 525.0 1000.0;9 580.0 1175.0;
];
coordinates(:,1)=[];
amount = size(coordinates,1);   % ���е���Ŀ��

% ͨ���������ķ�������������
dist_matrix = zeros(amount,amount);
coor_x_tmp1 = coordinates(:,1) * ones(1,amount);
coor_x_tmp2 = coor_x_tmp1';
coor_y_tmp1 = coordinates(:,2) * ones(1,amount);
coor_y_tmp2 = coor_y_tmp1';
dist_matrix = sqrt((coor_x_tmp1-coor_x_tmp2).^2+(coor_y_tmp1-coor_y_tmp2).^2);

sol_new = 1:amount;             % ������ʼ�⣻
sol_current = sol_new;sol_best=sol_new;
% sol_new���½⣻sol_current�ǵ�ǰ�⣻sol_best����ȴ�е����Ž⣻
E_current=inf;E_best=inf;       % E�ǵ�ǰ��·�ľ���;

% SA
while t>=tf
    % Markov��
    for r=1:Markov_length
          
        % ��������Ŷ�
        if (rand<0.5)
            %������
            ind1=0;ind2=0;
            while(ind1==ind2)
                ind1=ceil(rand*amount);
                ind2=ceil(rand*amount);
            end
            tmp1 = sol_new(ind1);
            sol_new(ind1)=sol_new(ind2);
            sol_new(ind2)=tmp1;
%         else
%             %������
%             ind1=0;ind2=0;ind3=0;
%             while((ind1==ind2)||(ind1==ind3)||(ind2==ind3))
%                 ind1=ceil(rand*amount);
%                 ind2=ceil(rand*amount);
%                 ind3=ceil(rand*amount);
%             end
%             % TODO:�����������ȷ��ind1<ind2<ind3
        end
        
        % ����Ƿ�����Լ����
        
        % ����Ŀ�꺯��ֵ��
        E_new = 0;
        for i=1:(amount-1)
            E_new = E_new + dist_matrix(sol_new(i),sol_new(i+1));
        end
        E_new = E_new + dist_matrix(sol_new(amount),sol_new(1));
        
        if E_new < E_current
            E_current = E_new;
            sol_current = sol_new;
            if E_new < E_best
                %������ȴ��������õ�
                E_best = E_new;
                sol_best = sol_new;
            end
        else
            % ��һ�����ʽ����½⣻
            if rand<exp(-(E_new-E_current)./t)
                E_current = E_new;
                sol_current = sol_new;
            else
                sol_new = sol_current;
            end
        end
    end
     t = t.*a;          % �¶�˥����
end
    disp('���Ž⣺')
    disp(sol_best)
    disp('��̾��룺')
    disp(E_best)
toc