% postProcessingFigures_template

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   In order to plot all data logged in the scopes of the simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% close all

% result plots folder
folder = 'Results\' ;

% Logged signals (2 signals)
x = out.torque.time ;
s1 = out.torque.signals(1).values ;
s2 = out.torque.signals(2).values ;
% Plot
figT = createFigureCustom(x,[s1,s2],"Torque [$T$]","Time [$s$]","Mechanical Torque",["$T_{rot}$","$T_{rot} (pu)$"],[0,400]) ;
% save
saveas(figT, append(folder ,'Test'),'epsc')


