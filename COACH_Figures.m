% Climbing Of A Constructed Hierarchy Simulation: COACH Simulation
% Author: Coach K, No Copyright
% Description: this scirpt generates figures for video

modelname = 'sim'
close all;
figure('InvertHardcopy','off','PaperPosition',[0 0 35 30]);

for k = 1:100
    
    mode = 1;
    
    run('COACH_Env.m')
    run('COACH_Climb.m')
    
    filename = sprintf('%s_%d',modelname,k)
    print(filename,'-dpng')
    
end