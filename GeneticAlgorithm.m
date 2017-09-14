%可用于多维约束问题

%遗传算法是一种通过模拟自然进化过程搜索最优解的方法；
%SGA(Simple genetic algorithm)是遗传算法初级阶段，由编解码、个体适应度评估和遗传运算构成；

%遗传算法的编码和解码在宏观上可以对应生物的基因型和表现型，微观上对应DNA转录和翻译的两个过程；
%交配即用随机数产生交配点位置，然后两个个体交换基因码；
%突变即对于基因码的小概率翻转；

%本质上是一种启发式的随机搜索算法，每次得出的结果都不尽相同；
%自变量在给定的约束条件下进行了无缝编码，有很多机会得到全局最优结果而不是局部最优；

%种群规模的一个建议值为0~100；
%变异概率一般取0.0001~0.2；
%交配概率一般取0.4~0.99；
%进化代数一般取100~500；
%种群初始化前，尽量进行一个大概的区间估计，以免出事种群分布在原理全局最优解的解码空间，同时减轻负担；

clc;
clear all;
close all;       
tic
global BitLength
global boundsbegin
global boundsend
bounds=[-2 2];              %一维自变量的取值范围
precision=0.0001;           %运算精度
boundsbegin=bounds(:,1);
boundsend=bounds(:,2);

%计算如果满足求解精度至少需要多长的染色体
BitLength=ceil(log2((boundsend-boundsbegin)'./precision));
popsize=50;                 %初始种群大小
Generationmax=15;          %最大代数
pcrossover=0.90;            %交配概率
pmutation=0.09;             %变异概率

%产生初始种群
population=round(rand(popsize,BitLength));
%计算适应度，返回适应度Fitvalue和累计概率cumsump
[Fitvalue,cumsump]=fitnessfun(population);
Generation=1;
while Generation<(Generationmax+1)
    for j=1:2:popsize
        %选择操作
        seln=selection(population,cumsump);
        %交叉操作
        scro=crossover(population,seln,pcrossover);
        scnew(j,:)=scro(1,:);
        scnew(j+1,:)=scro(2,:);
        %变异操作
        smnew(j,:)=mutation(scnew(j,:),pmutation);
        smnew(j+1,:)=mutation(scnew(j+1,:),pmutation);
    end
    population=smnew;       %产生了新种群
    [Fitvalue,cumsump]=fitnessfun(population);
    %记录当前代最好的适应度和平均适应度
    [fmax,nmax]=max(Fitvalue);
    fmean=mean(Fitvalue);
    ymax(Generation)=fmax;
    ymean(Generation)=fmean;
    %记录当前带的最佳染色体个体
    x=transform2to10(population(nmax,:));
    %自变量取值范围是[-2,2]，经过遗传计算把染色体翻译到区间
    xx=boundsbegin+x*(boundsend-boundsbegin)/(power((boundsend),BitLength)-1);
    xmax(Generation)=xx;
    Generation=Generation+1;
end

Bestpopulation=xx
Besttargetfunvalue=targetfun(xx)
% 绘制经过遗传运算后的适应度曲线。一般的，如果进化过程中种族的平均适应度与最大适应度在
% 曲线上有相互趋同的形态，表示算法收敛进行的很顺利，没有出现震荡；在这种前提下，最大适
% 应度个体连续若干代都没有发生进化则代表种群已经成熟
figure(1);
hand1=plot(1:Generationmax,ymax);
set(hand1,'linestyle','-','linewidth',1.8,'marker','*','markersize',6)
hold on;
hand2=plot(1:Generationmax,ymean);
set(hand2,'color','r','linestyle','-','linewidth',1.8,'marker','h','markersize',6)
xlabel('进化代数');ylabel('适应度');xlim([1 Generationmax]);
legend('最大适应度','平均适应度');
box off;
hold off;
toc

%子程序：新种群交叉操作
function scro=crossover(population,seln,pc)
    global BitLength
    pcc=IfCroIfMut(pc);
    if pcc==1
        chb=round(rand*(BitLength-2))+1;    %产生随机交叉位
        scro(1,:)=[population(seln(1),(1:chb)),population(seln(2),(chb+1):BitLength)];
        scro(2,:)=[population(seln(2),(1:chb)),population(seln(1),(chb+1):BitLength)];
    else
        scro(1,:)=population(seln(1),:);
        scro(2,:)=population(seln(2),:);
    end
end

%子程序：计算适应度函数
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
    %给适应度加上一个大小合理的数以便保证种群适应度为正数
    Fitvalue=Fitvalue'+230;
    %计算选择概率
    fsum=sum(Fitvalue);
    Pperpopulation=Fitvalue/fsum;
    %计算累计概率
    cumsump=cumsum(Pperpopulation);
end

%子程序：新种群变易操作
function snnew=mutation(snew,pmutation)
    BitLength=size(snew,2);
    snnew=snew;
    pmm=IfCroIfMut(pmutation);
    if pmm==1
        chb=round(rand*(BitLength-1))+1;    %产生随机变异位
        snnew(chb)=abs(snew(chb)-1);
    end
end

%子程序：判断遗传运算是否需要进行交叉或变异
function pcc=IfCroIfMut(mutORcro)
    test(1:100)=0;
    l=round(100*mutORcro);
    test(1:l)=1;
    n=round(rand*99)+1;
    pcc=test(n);
end

%子程序：新种群选择操作
function seln=selection(~,cumsump)
    %从种群中选择两个个体
    for i=1:2
        r=rand;
        prand=cumsump-r;
        j=1;
        while prand(j)<0
            j=j+1;
        end
        seln(i)=j;          %选中个体的序号
    end
end

%子程序：将二进制转换为十进制数
function x=transform2to10(Population)
    BitLength=size(Population,2);
    x=Population(BitLength);
    for i=1:BitLength-1
        x=x+Population(BitLength-i)*power(2,i);
    end
end

%子程序：对于优化最大值或极大值函数问题，目标函数可作为适应度函数
function y=targetfun(x)
    y=200*exp(-0.05*x).*sin(x);
end