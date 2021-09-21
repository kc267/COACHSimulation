% Climbing Of A Constructed Hierarchy Simulation: COACH Simulation
% Author: Coach K, No Copyright
% Description: this script constructs the COACH Simulation environment

%% control setting

drawgraph = 1;
colorize = 1;

%% parameters

n1 = 30; % number of people in one hierarchy, 300, 500, 1000
n = n1 * 5; % total number of people

% block matrix
BM = [0.5 0.2 0.1 0.0 0.0;
      0.2 0.5 0.2 0.1 0.0;
      0.1 0.2 0.5 0.2 0.1;
      0.0 0.1 0.2 0.5 0.2;
      0.0 0.0 0.1 0.2 0.5];

% used for color coding
ColorCode = [1 0 0 0 0;
             0 2 0 0 0;
             0 0 3 0 0;
             0 0 0 4 0;
             0 0 0 0 5];
ColorCode = repelem(ColorCode, n1, n1);
color0 = [0.3 0.3 0.3];
color1 = [1.000 0.983 0.163];
color2 = [1.000 0.369 0.229];
color3 = [0.009 0.620 0.593];
color4 = [0.001 0.388 0.643];
color5 = [0.399 0.282 0.618];
color_strong = [0.3 0.3 0.3];

% line width
w_within = 0.7;
w_between = 0.5;
w_strong = 2;

% percentage of strong edges
p_strong = 0.2;

%% basic graph

AM = repelem(BM, n1, n1); % adjacency matrix

for row = 1:size(AM,1)
    for col = 1:size(AM,2)
        % change AM into boolean values with weights for visualization
        if row < col
            if rand<AM(row,col) % if a connection can be made
                AM(row,col)=1/(AM(row,col)^0.2); % edge weight function
            else
                AM(row,col)=0;
            end
        end
    end
end

% transform AM into symmetrical matrix
AM = triu(AM,1);
AM = AM + AM';

% make graph
g = graph(AM);
e = g.Edges.EndNodes;

%% create strong/weak connection matrix, not used

% count_strong = round(size(e,1)*p_strong);
% e_strong_index = randi(size(e,1),count_strong,1);
% e_strong = e(e_strong_index,:);

%% draw graph

if drawgraph == 1
    
    % draw graph
    gplot = plot(g,'Layout','force','WeightEffect','direct',...
        'UseGravity',true);
    
    % basic visual settings
    gplot.LineWidth = w_between;
    gplot.EdgeColor = color0;
    gplot.NodeColor = [1 1 1];
    gplot.NodeLabel = {};
    ax = gca; ax.Color = [0 0 0]; % set background color
    
    % strong edges
    % highlight(gplot,'Edges',e_strong_index,'EdgeColor',color_strong,...
    % 'LineWidth',w_strong)
    
end

%% colorize

if colorize == 1;

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
    highlight(gplot,'Edges',e1,'EdgeColor',color1,'LineWidth',w_within)
    e2 = find(e2);
    highlight(gplot,'Edges',e2,'EdgeColor',color2,'LineWidth',w_within)
    e3 = find(e3);
    highlight(gplot,'Edges',e3,'EdgeColor',color3,'LineWidth',w_within)
    e4 = find(e4);
    highlight(gplot,'Edges',e4,'EdgeColor',color4,'LineWidth',w_within)
    e5 = find(e5);
    highlight(gplot,'Edges',e5,'EdgeColor',color5,'LineWidth',w_within)

    % strong edges
    % highlight(gplot,'Edges',e_strong_index,'LineWidth',w_strong)
    
end

%% cleaning

% clearvars -except AM BM g gplot