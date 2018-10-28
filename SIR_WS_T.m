%====================================================
%Author: MarkoXu  704712641@qq.com
%Date: 2018-10-27
%Desc: SIR model in ws model with sufficient infectious disease
%Reference: Collective dynamic of 'small-world' networks Fig. 3b
%====================================================
clear,close all;
%% ������������p,����WS����
p = 10.^(-4);
WS_network

%% 50�δ�Ⱦʵ�飬��ȡ��������p���Ⱦȫ������ʱ��T�Ĺ�ϵ
T_p_avg = 0; %100�δ����µĸ�Ⱦȫ�������ƽ��ʱ��
beta = 1; %�輲���Ĵ�Ⱦ����Ϊ1
for i = 1 : 100
    if mod(i,5) == 0
        WS_network  %ÿ������ʵ�����һ���µ���p�����WS����
    end
    T_p = 0; %��¼���ּ�����Ⱦȫ������ʱ��
    node_state = zeros(N, 1); %�ڵ�״̬��0Ϊ�׸�̬S̬��1Ϊ��Ⱦ̬I̬
    %% ���ӽڵ�ĸ�Ⱦ����=========================
    seed_node = randi(N,1); %���ѡһ���ڵ���Ϊ��Ⱦ���ӽڵ�
    node_state(seed_node) = 1;  %�����ӽڵ�״̬��Ϊ��Ⱦ̬
    infected_total_num = 1; %��ʼ��Ⱦ����Ϊ1�������ӽڵ�
    t = 1;
    neighbors = node_neighbors{seed_node}; %���ӽڵ���ھ�
    rand_num = rand(length(neighbors),1); %������������Ⱦ�ʸ�Ⱦ���ʱȽ�
    %��������������Ҫ���������������Ӵ��Ľڵ�ΪS̬���ܳɹ���Ⱦ
    node_infected = neighbors((rand_num<beta)&(~node_state(neighbors)));
    infected_total_num = infected_total_num + length(node_infected);
    node_state(node_infected) = 1; %��Ⱦ�ڵ�״̬��Ϊ1
    %% �����ڵ�ĸ�Ⱦ����=========================
    while infected_total_num ~= N
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
        T_p = T_p + 1;
    end
    T_p_avg = T_p_avg + T_p;
end
T_p_avg = T_p_avg / 100;
fprintf('��������p=%.5fʱ��Ⱦȫ��ƽ������ʱ�䲽Ϊ%.2f\n', p, T_p_avg);

%{
%% ��¼p��T_p_avg�Ķ�Ӧ��ϵ����������
p_link = logspace(-4, 0, 9); %�������ʵ�ȡֵ��Χ0.0001~1���������
T_p = [347.9, 163.2, 65.1, 24.1, 14.7, 8.9, 6.1, 5, 5]; %��Ӧ��Ⱦȫ�������ƽ��ʱ��
T_0 = max(T_p);
plot(p_link, T_p/T_0, '.', 'markersize', 20);
xlabel('p'); ylabel('T(p)/T(0)');
title('T(p)/T(0)��p�Ĺ�ϵͼ');
set(gca,'xscale','log')
%}

