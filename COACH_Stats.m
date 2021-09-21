% Climbing Of A Constructed Hierarchy Simulation: COACH Simulation
% Author: Coach K, No Copyright
% Description: this scirpt calculates the statistics

%% setup

close all; clear

loop1 = 3;
loop2 = 3;
stats = zeros(loop1*loop2,5);
stats_count = 1;

%% looping

mode = 1;

for i = 1:loop1
    run('COACH_Env.m')
    for j = 1:loop2
        run('COACH_Climb.m')
        result = [size(ladder_nodes(ladder_nodes<=n1),1)...
        size(ladder_nodes(logical((ladder_nodes>n1).*(ladder_nodes<=2*n1))),1)...
        size(ladder_nodes(logical((ladder_nodes>2*n1).*(ladder_nodes<=3*n1))),1)...
        size(ladder_nodes(logical((ladder_nodes>3*n1).*(ladder_nodes<=4*n1))),1)...
        size(ladder_nodes((ladder_nodes>4*n1)),1)-1];
        stats(stats_count,:) = result;
        stats_count = stats_count + 1;
    end
end

[mean(stats), sum(mean(stats))]

stats_count = 1;
mode = 2;

for i = 1:loop1
    run('COACH_Env.m')
    for j = 1:loop2
        run('COACH_Climb.m')
        result = [size(ladder_nodes(ladder_nodes<=n1),1)...
        size(ladder_nodes(logical((ladder_nodes>n1).*(ladder_nodes<=2*n1))),1)...
        size(ladder_nodes(logical((ladder_nodes>2*n1).*(ladder_nodes<=3*n1))),1)...
        size(ladder_nodes(logical((ladder_nodes>3*n1).*(ladder_nodes<=4*n1))),1)...
        size(ladder_nodes((ladder_nodes>4*n1)),1)-1];
        stats(stats_count,:) = result;
        stats_count = stats_count + 1;
    end
end

[mean(stats), sum(mean(stats))]


