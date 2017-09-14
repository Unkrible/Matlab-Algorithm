% 人工神经网络(Artificial Neural Network, ANN)

% 人工神经网络是由大量简单的基本原件——神经元相互连接，通过模拟人的大脑处理信息方式，
% 进行信息并行处理和非线性转换的复杂网络系统；
% 优点是多输入多输出实现了数据的并行处理以及自学习能力；

% 目前技术最成熟、应用范围最广泛的两种网络：前向反馈(back propagation,BP)
% 和径向基(radical basis function,RBF)网络；

% 神经网络的拓扑结构包括网络层数、各层神经元数量以及各神经元之间相互连接的方式，根据实际情况定值；

% BP网络是一种具有三层或以上神经元的神经网络，包括输入层、中间层（隐含层）和输出层；
% 上下层之间实现全连接，而同一层的神经元之间无连接；
% 输入神经元和隐含层神经元之间是网络的权值，其意义是两个神经元之间的连接强度；
% 隐含层或输出层任一神经元将钱一层所有神经元传来的消息进行整合，通常还会在整合消息中添加
%   一个阈值，模仿生物学中神经元必须达到一定的阈值才会触发的原理，将整合过的信息作为该层输入；
% 当一对学习样本提供给输入神经后，神经元激活值（该层输出值）从输入层经过各隐含层向输出层传播，
%   在输出层的各神经元获得网络的输入响应，然后减少网络输出与实际输出样本之间误差的方向，从输出层
%   反向经过各隐含层回到输入层，从而逐步修正各连接权值，这种算法称为误差反向传播算法，即BP算法；

% w(t+1) = -n(E/w) + w(t);      上-116


% Matlab神经网络工具箱包含了许多用于BP网络分析与设计的函数：

% BP网络创建函数：
% PR：由每组输入元素的最大值和最小值组成的RX2的矩阵；
% Si：第i层的长度，共计N层；   TFi：第i层的激励函数，默认为“tansig”；
% BTF：网络的训练函数，默认为“trainlm"; BLF：权值和阈值的学习算法，默认为“learngdm”；
% PF：网络的性能函数，默认为“mse”；
% 前向网络创建函数：newcf、newff、newfftd；
% newcf：创建级联前向BP网络；
% newff：创建一个BP网络；
% newfftd：创建一个存在输入延迟的前向网络；
% 格式： newxx(PR,[S1 S2 ... SN],{TF1 TF2 ... TFN},BTF,BLF,PF);

% 神经元激励函数：
% 激励函数：logsig、dlogsig、tansig、dtansig、purelin、dpurelin；
% 激励函数是BP神经网络的重要组成部分，它必须是连续可微的，BP网络经常此案用S型的对数或者正切函数
%   和线性函数；
% logsig：为S型的对数函数，
%   A=logsig(N);  info=logsig(code);
%   N为Q个S为的输入列向量，A为函数返回值，info根据code值不同返回不同信息；
% dlogsig：d=a(1-a)，为logsig的导函数，
%   dA_dN = dlogsig(N,A);
%   N为SxQ维网络输入，A为SxQ维网络输出，dA_dN为函数返回值；
% tansig：为双曲正切S型激励函数，
%   A=tansig(N);    info=tansig(code);
% dtansig：是tansig的导函数，
%   dA_dN = dtansig(N,A);
% purelin：为线性激励函数，
%   A=purelin(N);   info=purelin(code);
% dpurelin:是purelin的导函数，
%   dA_dN = dpurelin(N,A);

% BP网络学习函数：
% 学习函数：learngd、learngdm；
% learngd：梯度下降权值/阈值学习函数，它通过神经元的输入和误差，以及权值和阈值的学习速率
%   计算权值或阈值的变化率；
%   [dW,LS] = learngd(W,P,Z,N,A,T,E,gW,gA,D,LP,LS);
%   [db,LS] = learngd(b,ones(1,Q),Z,N,A,T,E,gW,gA,D,LP,LS);
%   info = learngd(code);
%   W为SxR维的权值矩阵；        b为S维的阈值向量；             P为Q组R维的输入向量；
%   ones(1,Q)为产生输入向量；   Z为W组S为的加权输入向量；      N为Q组S维的输入向量；
%   A为Q组S维的输出向量；       T为Q组S维的层目标向量；        E为Q组S维的层误差向量；
%   gW为性能相关的SxR维梯度；   gA为性能相关的S型R维输出梯度； D为SxS维的神经元距离矩阵；
%   LP为学习参数，设置学习速率； LS为学习状态，初始为空；       dW为SxR维的权值/阈值变化率；
%   db为S维的阈值变化率；        ls为新的学习状态；           info根据code值返回函数学习信息；
% learngdm：梯度下降动量学习函数，它利用神经元的输入和误差、权值或阈值学习速率和动量常熟计算权值
%   或阈值的变化率，
%   [dW,LS] = learngdm(W,P,Z,N,A,T,E,gW,gA,D,LP,LS);
%   [db,LS] = learngdm(b,ones(1,Q),Z,N,A,T,E,gW,gA,D,LP,LS);
%   info = leargdm(code);
%   常数动量mc是通过学习参数LP设置的，格式为LP.mc=0.8；

% BP网络训练函数：
% 训练函数：trainbfg、traingd、traingdm；
% trainbfg：为BFGS准牛顿BP算法函数，可以训练任意形式的神经网络，要求激励函数对于权值和输入存在导数，
%   [net,TR,Ac,El]=trainbfg(NET,Pd,Tl,Ai,Q,TS,VV,TV);
%   info = trainbfg(code);
%   NET为待训练的神经网络；       Pd为有延迟的输入向量；        T1为层次目标向量；
%   Ai为初始的输入延迟条件；      Q为批量；                    TS为时间步长；
%   VV用于确认向量结构或为空；    net为训练后的神经网络；       TR为每步训练的信息记录；
%   El为上一次训练的层次误差；
% traingd：是梯度下降BP算法训练函数，
%   [net,TR,Ac,El]=traingd(NET,Pd,Tl,Ai,Q,TS,VV,TV);
%   info = traingd(code);
% traingdm：为梯度下降动量BP算法训练函数，
%   [net,TR,Ac,El]=traingdm(NET,Pd,Tl,Ai,Q,TS,VV,TV);
%   info = traingdm(code);

% BP网络性能函数：
% 性能函数：mse、msereg；
% mse：为均方误差性能函数，
%   perf = mse(e,x,pp);
%   perf = mse(e,net,pp);
%   info = mse(code):
%   e为误差向量矩阵；       x为所有的权值和阈值向量，可忽略；       pp为性能参数，可忽略；
%   net为待评定的神经网络； perf为函数的返回值，平均绝对误差；
% msereg：在mse的基础上增加一项网络权值和阈值的均方值，迫使网络更加平滑；
%   perf = msereg(e,x,pp);
%   perf = msereg(e,net);
%   info = msereg(code);

% 实用Matlab神经网络工具箱的注意事项：
% 神经元节点数：
%   两个经典公式：
%       l = sqrt(m+n)+a;
%       l = sqrt(0.43mn+0.12*n^2+2.54m+0.77n+0.35+0.51);
%           m、n为输入节点数目和输出节点数目，a为1~10间常熟；
% 激励函数都是连续光滑的函数，无法拟合震荡特别强烈的样本；
% 激励函数无法精确快速响应那些从波峰快速衰减到波谷的学习样本；
% 学习速率：net.trainparam.lr一般选择0.01~0.1之间的值；


% 基于MATLAB工具箱的公路运量预测
clear all
close all
clc
% 原始数据
% 人数（单位：万人）
sqrs = [20.55 22.44 25.37 27.13 29.45 30.1 30.96 34.06 36.42 38.09  ...
    39.13 39.99 41.93 44.59 47.30 52.89 55.73 56.76 59.17 60.63];
% 机动车数（单位：万辆）
sqjdcs = [ 0.6 0.75 0.85 0.9 1.05 1.35 1.45 1.6 1.7 1.85 2.15 2.2 2.25 ...
    2.36 2.5 2.6 2.7 2.85 2.95 3.1];
% 公路面积（单位：万平方千米）
sqglmj = [0.09 0.11 0.11 0.14 0.20 0.23 0.23 0.32 0.32 0.34 0.36 ...
    0.36 0.38 0.49 0.56 0.59 0.59 0.67 0.69 0.79];
% 公路客运量（单位：万人）
glkyl = [5126 6217 7730 9145 10460 11387 12353 15750 18304 19836 21024 ...
    19490 20433 22598 25107 33442 36836 40548 42927 43462];
% 公路货运量（单位：万吨）
glhyl = [1237 1379 1385 1399 1663 1714 1834 4322 8132 8936 11099 11203 ...
    10524 11115 13320 16762 18673 20724 20803 21804];
p = [sqrs;sqjdcs;sqglmj];   % 输入数据矩阵；
t = [glkyl;glhyl];          % 目标数据矩阵；

% 对输入数据矩阵和目标矩阵的数据进行归一化；
[pn,minp,maxp,tn,mint,maxt] = premnmx(p,t);      %进行归一化；
dx = [-1,1;-1,1;-1,1];                          %归一化后最小-1最大1；

% BP网络训练；
net = newff(dx,[3,7,2],{'tansig','tansig','purelin'},'traingdx');   % 建立模型
net.trainParam.show = 1000;          % 1000轮回显示一次结果；
net.trainParam.Lr = 0.05;            % 学习速率为0.05；
net.trainParam.epochs = 50000;       % 最大轮回训练次数为50000；
net.trainParam.goal = 0.65*10^(-3);  % 均方误差；
net = train(net,pn,tn);              % 开始训练，其中pn，tn分别为输入输出样本；

% 利用训练好的数据对原始数据进行仿真；
an = sim(net,pn);                   % 用训练好的模型进行仿真；
a = postmnmx(an,mint,maxt);         % 还原目标为原始的数量级；

% 用原始数据仿真结果与意志数据进行对比测试；
% 通常必须用新鲜数据进行测试；
x = 1990:2009;
newk = a(1,:);
newh = a(2,:);
subplot(2,1,1);
plot(x,newk,'r-o',x,glkyl,'b--+');            % glkyl对比图；
legend('net输出客运量','实际客运量');
xlabel('年份');ylabel('客运量/万人');
title('运用工具箱客运量学习和测试对比图');
subplot(2,1,2);
plot(x,newh,'r-o',x,glhyl,'b--+');            % glkyl对比图；
legend('net输出货运量','实际货运量');
xlabel('年份');ylabel('货运量/万人');
title('运用工具箱货运量学习和测试对比图');

% 利用训练好的BP网络对新数据进行仿真
pnew = [73.39 75.55;3.9635 4.0975;0.9880 1.0268];
pnewn = tramnmx(pnew,minp,maxp);
anewn = sim(net,pnewn);
anew = postmnmx(anewn,mint,maxt);
disp(char(anew));