%�����ڶ�άԼ������

%�Ŵ��㷨��һ��ͨ��ģ����Ȼ���������������Ž�ķ�����
%SGA(Simple genetic algorithm)���Ŵ��㷨�����׶Σ��ɱ���롢������Ӧ���������Ŵ����㹹�ɣ�

%�Ŵ��㷨�ı���ͽ����ں���Ͽ��Զ�Ӧ����Ļ����ͺͱ����ͣ�΢���϶�ӦDNAת¼�ͷ�����������̣�
%���伴����������������λ�ã�Ȼ���������彻�������룻
%ͻ�伴���ڻ������С���ʷ�ת��

%��������һ������ʽ����������㷨��ÿ�εó��Ľ����������ͬ��
%�Ա����ڸ�����Լ�������½������޷���룬�кܶ����õ�ȫ�����Ž�������Ǿֲ����ţ�

%��Ⱥ��ģ��һ������ֵΪ0~100��
%�������һ��ȡ0.0001~0.2��
%�������һ��ȡ0.4~0.99��
%��������һ��ȡ100~500��
%��Ⱥ��ʼ��ǰ����������һ����ŵ�������ƣ����������Ⱥ�ֲ���ԭ��ȫ�����Ž�Ľ���ռ䣬ͬʱ���Ḻ����

clc;
clear all;
close all;       
tic
global BitLength
global boundsbegin
global boundsend
bounds=[-2 2];              %һά�Ա�����ȡֵ��Χ
precision=0.0001;           %���㾫��
boundsbegin=bounds(:,1);
boundsend=bounds(:,2);

%�������������⾫��������Ҫ�೤��Ⱦɫ��
BitLength=ceil(log2((boundsend-boundsbegin)'./precision));
popsize=50;                 %��ʼ��Ⱥ��С
Generationmax=15;          %������
pcrossover=0.90;            %�������
pmutation=0.09;             %�������

%������ʼ��Ⱥ
population=round(rand(popsize,BitLength));
%������Ӧ�ȣ�������Ӧ��Fitvalue���ۼƸ���cumsump
[Fitvalue,cumsump]=fitnessfun(population);
Generation=1;
while Generation<(Generationmax+1)
    for j=1:2:popsize
        %ѡ�����
        seln=selection(population,cumsump);
        %�������
        scro=crossover(population,seln,pcrossover);
        scnew(j,:)=scro(1,:);
        scnew(j+1,:)=scro(2,:);
        %�������
        smnew(j,:)=mutation(scnew(j,:),pmutation);
        smnew(j+1,:)=mutation(scnew(j+1,:),pmutation);
    end
    population=smnew;       %����������Ⱥ
    [Fitvalue,cumsump]=fitnessfun(population);
    %��¼��ǰ����õ���Ӧ�Ⱥ�ƽ����Ӧ��
    [fmax,nmax]=max(Fitvalue);
    fmean=mean(Fitvalue);
    ymax(Generation)=fmax;
    ymean(Generation)=fmean;
    %��¼��ǰ�������Ⱦɫ�����
    x=transform2to10(population(nmax,:));
    %�Ա���ȡֵ��Χ��[-2,2]�������Ŵ������Ⱦɫ�巭�뵽����
    xx=boundsbegin+x*(boundsend-boundsbegin)/(power((boundsend),BitLength)-1);
    xmax(Generation)=xx;
    Generation=Generation+1;
end

Bestpopulation=xx
Besttargetfunvalue=targetfun(xx)
% ���ƾ����Ŵ���������Ӧ�����ߡ�һ��ģ�������������������ƽ����Ӧ���������Ӧ����
% ���������໥��ͬ����̬����ʾ�㷨�������еĺ�˳����û�г����𵴣�������ǰ���£������
% Ӧ�ȸ����������ɴ���û�з��������������Ⱥ�Ѿ�����
figure(1);
hand1=plot(1:Generationmax,ymax);
set(hand1,'linestyle','-','linewidth',1.8,'marker','*','markersize',6)
hold on;
hand2=plot(1:Generationmax,ymean);
set(hand2,'color','r','linestyle','-','linewidth',1.8,'marker','h','markersize',6)
xlabel('��������');ylabel('��Ӧ��');xlim([1 Generationmax]);
legend('�����Ӧ��','ƽ����Ӧ��');
box off;
hold off;
toc

%�ӳ�������Ⱥ�������
function scro=crossover(population,seln,pc)
    global BitLength
    pcc=IfCroIfMut(pc);
    if pcc==1
        chb=round(rand*(BitLength-2))+1;    %�����������λ
        scro(1,:)=[population(seln(1),(1:chb)),population(seln(2),(chb+1):BitLength)];
        scro(2,:)=[population(seln(2),(1:chb)),population(seln(1),(chb+1):BitLength)];
    else
        scro(1,:)=population(seln(1),:);
        scro(2,:)=population(seln(2),:);
    end
end

%�ӳ��򣺼�����Ӧ�Ⱥ���
function [Fitvalue,cumsump]=fitnessfun(population)
    global BitLength
    global boundsbegin
    global boundsend
    popsize=size(population,1);
    for i=1:popsize
        x=transform2to10(population(i,:));
        xx=boundsbegin+x*(boundsend-boundsbegin)/(power((boundsend),BitLength)-1);
        Fitvalue(i)=targetfun(xx);
    end
    %����Ӧ�ȼ���һ����С��������Ա㱣֤��Ⱥ��Ӧ��Ϊ����
    Fitvalue=Fitvalue'+230;
    %����ѡ�����
    fsum=sum(Fitvalue);
    Pperpopulation=Fitvalue/fsum;
    %�����ۼƸ���
    cumsump=cumsum(Pperpopulation);
end

%�ӳ�������Ⱥ���ײ���
function snnew=mutation(snew,pmutation)
    BitLength=size(snew,2);
    snnew=snew;
    pmm=IfCroIfMut(pmutation);
    if pmm==1
        chb=round(rand*(BitLength-1))+1;    %�����������λ
        snnew(chb)=abs(snew(chb)-1);
    end
end

%�ӳ����ж��Ŵ������Ƿ���Ҫ���н�������
function pcc=IfCroIfMut(mutORcro)
    test(1:100)=0;
    l=round(100*mutORcro);
    test(1:l)=1;
    n=round(rand*99)+1;
    pcc=test(n);
end

%�ӳ�������Ⱥѡ�����
function seln=selection(~,cumsump)
    %����Ⱥ��ѡ����������
    for i=1:2
        r=rand;
        prand=cumsump-r;
        j=1;
        while prand(j)<0
            j=j+1;
        end
        seln(i)=j;          %ѡ�и�������
    end
end

%�ӳ��򣺽�������ת��Ϊʮ������
function x=transform2to10(Population)
    BitLength=size(Population,2);
    x=Population(BitLength);
    for i=1:BitLength-1
        x=x+Population(BitLength-i)*power(2,i);
    end
end

%�ӳ��򣺶����Ż����ֵ�򼫴�ֵ�������⣬Ŀ�꺯������Ϊ��Ӧ�Ⱥ���
function y=targetfun(x)
    y=200*exp(-0.05*x).*sin(x);
end