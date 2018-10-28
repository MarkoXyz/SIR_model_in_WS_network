%====================================================
%Author: MarkoXu  04712641@qq.com
%Date: 2018-10-27
%Desc: SIR model in ws model with different p
%Reference: Collective dynamic of 'small-world' networks Fig. 3a
%====================================================

%% ������������p,����WS����
p = 10.^(-4);
WS_network

%% ��θ�Ⱦ���̣�����һ�ΰ�����Ⱦ����
count = 0; %ʵ���ظ�����
T = 1000; %���ü�����������ʱ�䲽��
beta = 0.35; %�����ĸ�Ⱦ�ʣ�������ֵʹ��ǡ���ܸ�Ⱦ����������Ⱥ
flag = 0; %�ɹ���Ⱦ������Ⱥ�ı�־
while count < 1000
    node_state = zeros(N, 1); %�ڵ�״̬��0Ϊ�׸�̬S̬��1Ϊ��Ⱦ̬I̬
    %% ���ӽڵ�ĸ�Ⱦ����=========================
    seed_node = randi(N,1); %���ѡȡһ���ڵ���Ϊ��Ⱦ�����ӽڵ�
    node_state(seed_node) = 1;  %���ѡһ���ڵ���Ϊ��Ⱦ���ӽڵ�
    infected_total_num = 1; %��ʼ��Ⱦ����Ϊ1�������ӽڵ�
    t = 1;
    neighbors = node_neighbors{seed_node}; %���ӽڵ���ھ�
    rand_num = rand(length(neighbors),1);%������������Ⱦ�ʸ�Ⱦ���ʱȽ�
    %��������������Ҫ���������������Ӵ��Ľڵ�ΪS̬���ܳɹ���Ⱦ
    node_infected = neighbors((rand_num<beta)&(~node_state(neighbors))); 
    infected_total_num = infected_total_num + length(node_infected);
    node_state(node_infected) = 1; %��Ⱦ�ڵ�״̬��Ϊ1
    %% �����ڵ�ĸ�Ⱦ����=========================
    while t <= 1000
        t = t + 1;
        node_infected_temp = []; %��¼�¸�Ⱦ���ھӽڵ㣬���ܴ����ظ�������ȥ��
        for j = 1 : length(node_infected)
            neighbors = node_neighbors{node_infected(j)};
            rand_num = rand(length(neighbors),1);
            node_infected_temp = [node_infected_temp; neighbors((rand_num<beta)&(~node_state(neighbors)))];
        end
        node_infected = unique(node_infected_temp, 'stable'); %ȥ���ظ��ĸ�Ⱦ�ھ�
        infected_total_num = infected_total_num + length(node_infected);
        node_state(node_infected) = 1;
    end
    count = count + 1;
    %��Ⱦ���������򴫲�ֹͣ
    if infected_total_num/N >= 0.5
        flag = 1;
        break;
    end
end

if flag == 1
     fprintf('��p��beta��Ͽ��Գɹ���Ⱦ�������ɳ����ʵ����ͼ����ĸ�Ⱦ��beta\n');
else
    fprintf('��p��beta��ϲ��ܳɹ���Ⱦ�������ɳ����ʵ����߼����ĸ�Ⱦ��beta\n');
end

%% ��¼���ʵ��������������
%{
%�������ʵ�ȡֵ��Χ0.0001~1
p_link = logspace(-4, 0, 9); %�������ʵ�ȡֵ��Χ0.0001~1���������
%Ҫ�ﵽ���Ⱦ������С��betaֵ
r_half = [0.34,0.33,0.28,0.25,0.21,0.18,0.16,0.137,0.135]; 
%��������
plot(p_link, r_half, '.', 'markersize', 20);
xlabel('p');ylabel('r_{half}');
title('r_{half}��p�Ĺ�ϵͼ');
set(gca,'xscale','log')
%}

