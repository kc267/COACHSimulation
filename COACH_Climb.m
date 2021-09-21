% Climbing Of A Constructed Hierarchy Simulation: COACH Simulation
% Author: Coach K, No Copyright
% Description: this scirpt climbs the social ladder

%% setup

drawgraph = 1;
colorize = 1;
mode = 2; % 1=weak, 2=strong, please comment in stats mode
total_tick = 10; % 10/20/30 years

if mode == 1 % weak
    p_intro = 0.1;
    sample_size = 10; % 100 people per year
end

if mode == 2 % strong
    p_intro = 0.2;
    sample_size = 1; % 10 people per year
end

%% parameters

n = size(g.Nodes,1);
n1 = n/5;

nodes_record = (1:n)';
edges_record = [g.Edges.EndNodes,g.Edges.Weight];

ladder_nodes = [];
ladder_edges = [];
new_edge_weight = 0.5;

intro_cap = 1000;

% another setting for a different model
% if mode == 1 % weak
%     p_intro = 0.001;
%     sample_size = 4;
% end
% 
% if mode == 2 % strong
%     p_intro = 0.005;
%     sample_size = 1;
% end

% used for color coding
ColorCode = [1 0 0 0 0;
             0 2 0 0 0;
             0 0 3 0 0;
             0 0 0 4 0;
             0 0 0 0 5];
ColorCode = repelem(ColorCode, n1, n1);
ColorCode(n+1,n+1) = 0;
color0 = [0.3 0.3 0.3];
color1 = [1.000 0.983 0.163];
color2 = [1.000 0.369 0.229];
color3 = [0.009 0.620 0.593];
color4 = [0.001 0.388 0.643];
color5 = [0.399 0.282 0.618];
color_strong = [0.3 0.3 0.3];
color_node = [0.7 0.7 0.7];
color_ladder = [1 1 1];

% line width
w_within = 0.7;
w_between = 0.5;
w_ladder = 1.5;

%% preparing the graph

g2 = addnode(g,1);
my_node = size(g2.Nodes,1);

% randomly sample nodes from last 2 hierarchies
random_idx = n-randsample(n1*2,sample_size);
cur_nodes = nodes_record(random_idx);

% add nodes into ladder_nodes
ladder_nodes = [my_node; cur_nodes];

% take nodes out from record and clean the record
nodes_record(ladder_nodes,1) = 0;
nodes_record = nodes_record(nodes_record~=0);

% add edges into ladder_edges and graph
ladder_edges = [repelem(my_node,size(cur_nodes,1))',cur_nodes,...
    repelem(new_edge_weight,size(cur_nodes,1))'];
g2 = addedge(g2,ladder_edges(:,1)',ladder_edges(:,2)',ladder_edges(:,3)');

%% climbing

for tick = 1:total_tick
    
    cap_count = 0;
    initial_nodes = size(ladder_nodes,1);
    
    %% climb through introduction
    for idx = 1:size(ladder_nodes,1)
        intro_nodes = neighbors(g2,ladder_nodes(idx));
        if rand < p_intro
            intro_nodes = intro_nodes(randperm(length(intro_nodes)));
            if ~(ismember(intro_nodes(1),ladder_nodes))
                % add node to ladder_nodes
                ladder_nodes = [ladder_nodes; intro_nodes(1)];
                cap_count = cap_count + 1;
                % add edge to ladder_edges
                edges_to_add = [ladder_nodes(idx),intro_nodes(1),...
                    new_edge_weight];
                ladder_edges = [ladder_edges; edges_to_add];
                % clean the record
                nodes_record(nodes_record==intro_nodes(1)) = [];
            end
        end
        if cap_count == intro_cap
            break
        end
    end    
    
    if cap_count == intro_cap
        break
    end

    %% climb through oneself

    % randomly sample nodes again from last 2 hierarchies
    cur_nodes = nodes_record(nodes_record>(n-n1*2));
    if sum(cur_nodes) ~= 0;
        cur_nodes = cur_nodes(randperm(length(cur_nodes)));
        cur_nodes = cur_nodes(1:sample_size);
    end

    % add nodes into ladder_nodes
    ladder_nodes = [ladder_nodes; cur_nodes];

    % take nodes out from record and clean the record
    for i = 1:size(cur_nodes,1)
        nodes_record(nodes_record==cur_nodes(i)) = [];
    end

    % add edges into ladder_edges and graph
    edges_to_add = [repelem(my_node,size(cur_nodes,1))',cur_nodes,...
        repelem(new_edge_weight,size(cur_nodes,1))'];
    ladder_edges = [ladder_edges; edges_to_add];
    g2 = addedge(g2,edges_to_add(:,1)',edges_to_add(:,2)',...
        edges_to_add(:,3)');
    
end

%% draw graph

if drawgraph == 1
    
    % draw graph
    g2plot = plot(g2,'Layout','force','WeightEffect','direct',...
        'UseGravity',true);
    
    % basic visual settings
    g2plot.LineWidth = w_between;
    g2plot.EdgeColor = color0;
    g2plot.NodeColor = color_node;
    g2plot.NodeLabel = {};
    ax = gca; ax.Color = [0 0 0]; % set background color
    
end

%% colorize

if colorize == 1;
    
    e = g2.Edges.EndNodes;
    
    % create empty index holder for edge groups
    e1 = zeros(1,n^2);
    e2 = zeros(1,n^2);
    e3 = zeros(1,n^2);
    e4 = zeros(1,n^2);
    e5 = zeros(1,n^2);
    
    % loop to categorize edges
    for row = 1:size(e,1)
        if ColorCode(e(row,1),e(row,2)) == 1; e1(row) = 1;
        elseif ColorCode(e(row,1),e(row,2)) == 2; e2(row) = 1;
        elseif ColorCode(e(row,1),e(row,2)) == 3; e3(row) = 1;
        elseif ColorCode(e(row,1),e(row,2)) == 4; e4(row) = 1;
        elseif ColorCode(e(row,1),e(row,2)) == 5; e5(row) = 1;
        end
    end
    
    % colorize the edges
    e1 = find(e1);
    highlight(g2plot,'Edges',e1,'EdgeColor',color1,'LineWidth',w_within)
    e2 = find(e2);
    highlight(g2plot,'Edges',e2,'EdgeColor',color2,'LineWidth',w_within)
    e3 = find(e3);
    highlight(g2plot,'Edges',e3,'EdgeColor',color3,'LineWidth',w_within)
    e4 = find(e4);
    highlight(g2plot,'Edges',e4,'EdgeColor',color4,'LineWidth',w_within)
    e5 = find(e5);
    highlight(g2plot,'Edges',e5,'EdgeColor',color5,'LineWidth',w_within)
    
    % highlight the ladder
    highlight(g2plot,ladder_nodes,'NodeColor',color_ladder,...
        'MarkerSize',4)
    highlight(g2plot,ladder_edges(:,1)',ladder_edges(:,2)',...
        'EdgeColor',color_ladder,'LineWidth',w_ladder)
    
end
