%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   In order to plot all data logged in the scopes of the simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 close all

% results plots Folder
ResultsFolder = 'Results\' ;
SimulationFolder = 'Simulation_runs\';


%% Load Simulation runs

load(append(SimulationFolder ,'sim_WindRamp_comp.mat'))     ; %out_vramp_comp
load(append(SimulationFolder ,'sim_WindRamp_uncomp.mat'))   ; %out_vramp_comp
disp('Loading done')
%%
%load(append(SimulationFolder ,'sim_comp.mat'))              ; % out_comp
load(append(SimulationFolder ,'sim_uncomp.mat'))            ; % out_uncomp
%%
load(append(SimulationFolder ,'sim_comp_lowload.mat'))      ; % out_comp_lowload
load(append(SimulationFolder ,'sim_comp_highload.mat'))     ; % out_comp_highload
disp('Loading done')

%% P/t Aero Model
%LOGGING SIGNAL
AeroModel_power = out.power_aero;
%plot Figure
figAero = createFigureCustom2AXIS(AeroModel_power.time,  [AeroModel_power.signals(1).values AeroModel_power.signals(3).values],"","Time $[s]$",["Wind speed $[m/s]$" "Torque $[Nm]$"],["Wind speed" "Rotor torque"]);
% SaveFigure as .eps file
saveas(figAero, append(ResultsFolder , 'AeroModel_T~v'),'epsc')

%LOGGING SIGNAL
AeroModel_power = out.power_aero;
%plot Figure
figAero = createFigureCustom2AXIS(AeroModel_power.time,  [AeroModel_power.signals(1).values AeroModel_power.signals(2).values],"","Time $[s]$",["Wind speed $[m/s]$" "Power $[W]$"],["Wind speed" "Rotor power"]);
% SaveFigure as .eps file
saveas(figAero, append(ResultsFolder , 'AeroModel_P~v'),'epsc')

%%  Mechanical Model Validation
close all
% Tt,Te,w /t
%LOGGING SIGNAL
MechModel_validation = out.MechModel_validation;
%figMech_T = createFigureCustom2AXIS(MechModel_validation.time,  [MechModel_validation.signals(1).values MechModel_validation.signals(2).values]," ","Time $[s]$",["Torque $[Nm]$" "Torque $[Nm]$"],["Torque rotor" "Torque generator"],[0 300 ; 0 50]);
%figMech_w = createFigureCustom(MechModel_validation.time,MechModel_validation.signals(3).values, '', "Time $[s]$", "Speed [rad/s]",["shaft speed"]);
figMech = createSubFiguresCustom(MechModel_validation.time, [MechModel_validation.signals(1).values MechModel_validation.signals(2).values MechModel_validation.signals(4).values], '', "Time $[s]$", [" $T_{LS}$ $[Nm]$" " $T_{HS}$ $[Nm]$" "Speed $[rad/s]$"] , ["Rotor" "Generator" "High speed shaft"],[0 300; 0 50 ; 0 170]);
hold on
fontsize(16,'points');
text(6.7,115,"$T_{LS} > T_{HS}$",'FontSize',14,'Interpreter','latex')
text(21,135,"$T_{LS} = T_{HS}$",'FontSize',14,'Interpreter','latex')
text(33.5,115,"$T_{LS} < T_{HS}$",'FontSize',14,'Interpreter','latex')
text(0.1,30,"$T_{LS} \!=\! T_{HS} = 0$",'FontSize',14,'Interpreter','latex')
text(41,50,"$T_{LS} \!=\! T_{HS} = 0$",'FontSize',14,'Interpreter','latex')


% SaveFigure as .eps file
saveas(figMech, append(ResultsFolder , 'MechModel_Tt_Te_w~t'),'epsc')
%% Generator Validation
close all
yvar =  out.genModel_validation.signals(1).values;
xvar = out.genModel_validation.signals(3).values;
%
% For Marker
nr = 1550%1560.5
ns = fs*60/n_pp                  
s_rated = (ns - nr) / ns
ws = 2*pi*fs;
T_rated = 5.575e3/(ws/n_pp)

%
% Plot
fig_GenModel_Te = createFigureCustom(xvar,yvar, "","Slip","Torque $$[Nm]$$","Te gen" );
hold on
ax = gca;
ax.XDir = 'reverse';
plot(s_rated,-T_rated,'o','MarkerEdgeColor',"black",'LineWidth',2)
xline(0,'--',{'Sychronous','Speed'},'LineWidth',1.5,'LabelVerticalAlignment','bottom','FontSize',18);
text(0.5,1.5*min(yvar),{'Motor'},'Color','black','Interpreter','latex','LineWidth',1.5,'FontSize',20)
text(-0.5,1.5*min(yvar),'Generator','Color','black','Interpreter','latex','LineWidth',1.5,'FontSize',20)
%text(-0.06,-T_rated,'$\leftarrow T_{rated}$','Interpreter','latex','FontSize',15)
%line([1 s_rated],[-T_rated -T_rated],'LineStyle','--','Color','black','LineWidth',1)
%text(0.98,-0.85*T_rated,"$$T_{rated}$$",'FontSize',15,'Interpreter','latex')
%yline(0,'--','LineWidth',1.5);


% For Zoom in plot
l = length(xvar);
m = round(l/1.83);
w = round( 0.01*l );
zoom = m-w:m+w ; 
%xlim tight
%ylim([-120 75])
legend(["$$T_e$$" "$$T_{rated}$$"],'FontSize',20, 'Interpreter','latex','Location','southwest')


axes('Position',[.6 .6 .29 .3])
box on
plot(xvar(zoom),yvar(zoom),'b-','LineWidth',1.5)
hold on
plot(s_rated,-T_G_base,'o','MarkerEdgeColor',"black",'LineWidth',1.5)
xline(0,'--','LineWidth',1.5,'HandleVisibility','off');
ax = gca;
ax.XDir = 'reverse';
grid on
%legend('off')
hold off
%%
% SaveFigure as .eps file
saveas(fig_GenModel_Te, append(ResultsFolder , 'GenModel_Te~s'),'epsc')

%% Generator MOdel Validation MEasurement via Time
close all
mytime = out.genModel_validation.time;
mystart = round(1*length(mytime)/mytime(length(mytime)));
yvar =  [ out.genModel_validation.signals(:).values ];
myLegendlabels = ["Mechanical speed generator rotor"  "Slip" "Electromagnetical torque" "Active power" "Reactive power" "Power factor" ];
myYlabels = ["$\omega_{HS}$ $[\frac{rad}{s}]$" "Slip" "$T_{el}$ $[Nm]$"  "P $[kW]$" "Q $[kV\!A\!R]$" "Power factor" ]
myxlim =[1 63];
fig_SCIG_measued  = figure ;
fig_SCIG_measued.Position = [100 0 1280 1080];                         %Sets position on screen and dimensions
nvars = 6;
suplot_height = 0.135;

i = 1 ;
subplot_handle = subplot(nvars, 1, i); % Speed
current_position = get(subplot_handle, 'Position'); % Get current position
current_position(4) = suplot_height; % Adjust the height as needed
set(subplot_handle, 'Position', current_position); % Adjust the [left, bottom, width, height] as needed
plot(mytime(mystart:end), yvar(mystart:end,i),'LineWidth',1.5, 'color', 'b')
ylabel(myYlabels(i),'FontSize',12, 'Interpreter','latex')
hold on
xlim(myxlim)
set(gca, 'TickLabelInterpreter','latex')
legend(myLegendlabels(i));
legend('FontSize',12, 'Interpreter','latex')
legend('Location','Southeast')
grid on
ylim([157 163]);
yline(w_r_rated,'--',{"rated rotor speed"},'LineWidth',1.5,'LabelHorizontalAlignment','center','LabelVerticalAlignment','middle','FontSize',12,'Interpreter','latex','HandleVisibility','off')
text(mytime(length(mytime))+0.2,w_r_rated,string(round(w_r_rated,2)),'FontSize',8,'Interpreter','latex')
xticklabels([])
legend('off')

i = 2 ;
subplot_handle = subplot(nvars,1,i) % Slip
current_position = get(subplot_handle, 'Position'); % Get current position
current_position(4) = suplot_height; % Adjust the height as needed
set(subplot_handle, 'Position', current_position); % Adjust the [left, bottom, width, height] as needed
plot(mytime(mystart:end), yvar(mystart:end,i),'LineWidth',1.5, 'color', 'b')
ylabel(myYlabels(i),'FontSize',12, 'Interpreter','latex')
hold on
xlim(myxlim)
set(gca, 'TickLabelInterpreter','latex')
legend(myLegendlabels(i));
legend('FontSize',12, 'Interpreter','latex')
legend('Location','Northeast')
grid on
yline(s_rated,'--',{"rated slip"},'LineWidth',1.5,'LabelHorizontalAlignment','center','LabelVerticalAlignment','middle','FontSize',12,'Interpreter','latex','HandleVisibility','off')
text(mytime(length(mytime))+0.2,s_rated,string(round(s_rated,3)),'FontSize',8,'Interpreter','latex')
xticklabels([])
legend('off')


i = 3 ;
subplot_handle = subplot(nvars,1,i) % Torque
current_position = get(subplot_handle, 'Position'); % Get current position
current_position(4) = suplot_height; % Adjust the height as needed
set(subplot_handle, 'Position', current_position); % Adjust the [left, bottom, width, height] as needed
plot(mytime(mystart:end), yvar(mystart:end,i),'LineWidth',1.5, 'color', 'b')
ylabel(myYlabels(i),'FontSize',12, 'Interpreter','latex')
hold on
set(gca, 'TickLabelInterpreter','latex')
ylim([-36 3]);
xlim(myxlim)
legend(myLegendlabels(1));
legend('FontSize',12, 'Interpreter','latex')
legend('Location','Northeast')
legend('off')
grid on
yline(-T_rated,'--',{"rated torque"},'LineWidth',1.5,'LabelHorizontalAlignment','center','LabelVerticalAlignment','middle','FontSize',12,'Interpreter','latex','HandleVisibility','off')
text(mytime(length(mytime))+0.2,-T_rated,string(-round(T_rated,2)),'FontSize',8,'Interpreter','latex')
xticklabels([])
legend('off')


i = 4 ;
subplot_handle = subplot(nvars,1,i) % P
current_position = get(subplot_handle, 'Position'); % Get current position
current_position(4) = suplot_height; % Adjust the height as needed
set(subplot_handle, 'Position', current_position); % Adjust the [left, bottom, width, height] as needed
plot(mytime(mystart:end), yvar(mystart:end,i)/1000,'LineWidth',1.5, 'color', 'b')
ylabel(myYlabels(i),'FontSize',12, 'Interpreter','latex')
hold on
xlim(myxlim)
yline(P_out/1000,'--',{"nominal active output power"},'LineWidth',1.5,'LabelHorizontalAlignment','center','LabelVerticalAlignment','middle','FontSize',12,'Interpreter','latex','HandleVisibility','off')
text(mytime(length(mytime))+0.2,P_out/1000,string(round(P_out/1000,2)),'FontSize',8,'Interpreter','latex')
ylim([-0.5 5.6])
set(gca, 'TickLabelInterpreter','latex')
legend(myLegendlabels(i));
legend('FontSize',12, 'Interpreter','latex')
legend('Location','Southeast')
grid on
xticklabels([])
legend('off')

i = 5 ;
subplot_handle = subplot(nvars,1,i) % Q
current_position = get(subplot_handle, 'Position'); % Get current position
current_position(4) = suplot_height; % Adjust the height as needed
set(subplot_handle, 'Position', current_position); % Adjust the [left, bottom, width, height] as needed
plot(mytime(mystart:end), yvar(mystart:end,i)/1000,'LineWidth',1.5, 'color', 'b')
ylabel(myYlabels(i),'FontSize',12, 'Interpreter','latex')
ylim([-4.5 -3]);
hold on
xlim(myxlim)
set(gca, 'TickLabelInterpreter','latex')
legend(myLegendlabels(i));
legend('FontSize',12, 'Interpreter','latex')
legend('Location','Northeast')
grid on
yline( yvar(mystart,i)/1000,'--',{"minimum reactive power"},'LineWidth',1.5,'LabelHorizontalAlignment','center','LabelVerticalAlignment','middle','FontSize',12,'Interpreter','latex','HandleVisibility','off')
text(mytime(length(mytime))+0.2,yvar(mystart,i)/1000,string(round(yvar(mystart,i)/1000,2)),'FontSize',8,'Interpreter','latex')
xticklabels([])
legend('off')

i = 6 ;
subplot_handle = subplot(nvars,1,i) % PF
current_position = get(subplot_handle, 'Position'); % Get current position
current_position(4) = suplot_height; % Adjust the height as needed
set(subplot_handle, 'Position', current_position); % Adjust the [left, bottom, width, height] as needed
plot(mytime(mystart:end), yvar(mystart:end,i),'LineWidth',1.5, 'color', 'b')
ylabel(myYlabels(i),'FontSize',12, 'Interpreter','latex')
ylim([-0.2 0.85]);
hold on
xlim(myxlim)
set(gca, 'TickLabelInterpreter','latex')
legend(myLegendlabels(i));
legend('FontSize',12, 'Interpreter','latex')
legend('Location','Southeast')
grid on
yline(pf,'--',{"rated power factor"},'LineWidth',1.5,'LabelHorizontalAlignment','center','LabelVerticalAlignment','middle','FontSize',12,'Interpreter','latex','HandleVisibility','off')
text(mytime(length(mytime))+0.2,pf,string(round(pf,3)),'FontSize',8,'Interpreter','latex')
legend('off')


xlabel('Time [s]','FontSize',12, 'Interpreter','latex')

% SaveFigure as .eps file
saveas(fig_SCIG_measued, append(ResultsFolder , 'GenModel_Test'),'epsc')


%% PF ~ P
close all
genModel_validation = out.genModel_validation

xvar = genModel_validation.signals(4).values ;% active power
yvar = genModel_validation.signals(1).values ;%; PF
zoom = round(0.05*length(xvar)):length(xvar) ;
P_norm = 5e3; % nomianl power
genModel_validation_PF = createFigureCustom(xvar(zoom)/P_norm,yvar(zoom), "","Active power in \% of nominal power","Power factor ","" ,[0 1]);
hold on
yline(0.765,'--',{"PF at $$P_{nom}$$"},'LineWidth',1.5,'LabelHorizontalAlignment','left','FontSize',18,'Interpreter','latex','HandleVisibility','off')
text(-0.05,0.765,"0.77",'FontSize',15,'Interpreter','latex')
yline(0.5625,'--',{"PF at 50\% "},'LineWidth',1.5,'LabelHorizontalAlignment','left','FontSize',18,'Interpreter','latex','HandleVisibility','off')
text(-0.05,0.5625,"0.56",'FontSize',15,'Interpreter','latex')
yline(0.34,'--',{"PF at 25\% "},'LineWidth',1.5,'LabelHorizontalAlignment','left','FontSize',18,'Interpreter','latex','HandleVisibility','off')
%xline(0.25)
xlim tight
grid on
legend('off')
hold off

% SaveFigure as .eps file
saveas(genModel_validation_PF, append(ResultsFolder , 'GenModel_PF~P'),'epsc')

%% PQ ~ s
%{
xvar = genModel_validation.signals(4).values ;% active power
yvar1 = genModel_validation.signals(1).values ;%; PF
yvar2 = genModel_validation.signals(5).values ;%; PF

zoom = round(0.05*length(xvar)):length(xvar) ;
P_norm = 5e3; % nomianl power
genModel_validation_PF;% = createFigureCustom2AXIS(xvar(zoom)/P_norm,[yvar1(zoom) yvar2(zoom)], "","power in % of nominal power",["power factor " "reactive power"],"" ,[0 1 ; -5000 0 ]);
yyaxis right
plot(xvar(zoom)/P_norm, yvar2(zoom)/1000,'LineWidth',1.5)
ylim([-8 0])
ylabel('reactive power [KVAR]')
ax = gca;
ax.YDir = 'reverse';
xlim tight
grid on
legend('off')
hold off
%}
%%
close all
genModel_validation = out.genModel_validation

xvar = genModel_validation.signals(4).values ;% active power
yvar = genModel_validation.signals(5).values ;%; PF
zoom = round(0.05*length(xvar)):length(xvar) ;
P_norm = 5e3; % nomianl power
genModel_validation_Q = createFigureCustom(xvar(zoom)/P_norm,yvar(zoom)/1000, "","Active power in \% of nominal power","Reactive power [KVAR]","" ,[-5 0]);
hold on
ylabel('Reactive power [KVAR]')
yline(-4.225,'--',{"$$Q_{max}$$ at $$P_{nom}$$"},'LineWidth',1.5,'LabelHorizontalAlignment','left','FontSize',18,'Interpreter','latex','HandleVisibility','off')
text(-0.05,-4.225,"-4.3",'FontSize',15,'Interpreter','latex')
yline(-3.34,'--',{"$$Q_{min}$$"},'LineWidth',1.5,'LabelHorizontalAlignment','left','FontSize',18,'Interpreter','latex','HandleVisibility','off')
text(-0.05,-3.3,"-3.3",'FontSize',15,'Interpreter','latex')

ax = gca;
ax.YDir = 'reverse';
xlim tight
grid on
legend('off')
hold off

% SaveFigure as .eps file
saveas(genModel_validation_Q, append(ResultsFolder , 'GenModel_Q~P'),'epsc')

%% PF ~ s
%close all
%{
genModel_validation = out.genModel_validation

xvar = genModel_validation.signals(2).values ;% slip
yvar = genModel_validation.signals(1).values ;%; PF
zoom = round(0.05*length(xvar)):length(xvar) ;
P_norm = 5e3; % nomianl power
genModel_validation_PF = createFigureCustom(xvar(zoom),yvar(zoom), "","slip","power factor ","" ,[0 1]);
hold on
xline(s_rated,'--',{"nomial slip"},'LineWidth',1.5,'LabelHorizontalAlignment','left','FontSize',18,'Interpreter','latex')
ax = gca;
ax.XDir = 'reverse';
xlim tight
grid on
legend('off')

%}
%%  Full Model Validation
%out = out_comp;

%LOGGING SIGNALS
fullModel_aero =out.fullModel_aero % wind, Pt, Tt

fullModel_Gen = out.fullModel_Gen ; % PF, P, Q, s at SWT
%fullModel_POC = out.fullModel_POC ; % PF, P, Q     at POC 
%fullModel_Bus1 = out.fullModel_Bus1 ; % PF, P, Q

% time axis
time = fullModel_aero.time ;
start = round(30*length(time)/time(length(time)));
zoom = start:length(time);
time = time(zoom)-time(zoom(1));
%%
% PLot
% Wind,P ~t
figAero = createFigureCustom2AXIS(time,  [fullModel_aero.signals(1).values(zoom) fullModel_Gen.signals(2).values(zoom)/1000],"","Time $[h]$",["Wind speed $\left[\frac{m}{s}\right]$" "Power $[kW]$"],["Wind speed" "Active power"],[0 15 ; 0 8]);
hold on 
xticks([0 30 60 90 120 150 180 210 240 270 300])
xticklabels({'0','0.5','1','1.5','2','2.5','3','3.5','4','4.5','5'})
legend('Location','southeast')
hold off
% SaveFigure as .eps file
saveas(figAero, append(ResultsFolder , 'fullModel_2axes_P,v~t'),'epsc')

%%
% Wind, Pg ~ t
figFullModel_vP_t = createSubFiguresCustom(time, [fullModel_aero.signals(1).values(zoom) fullModel_Gen.signals(2).values(zoom)/1000], '', "Time $[h]$", ["Wind speed $[m/s]$" "Active power $[KW]$" "Reactive power $[KVAR]$"] , ["" "" ],[0 16 ; 0 5]);
hold on
xlim tight
legend('off')
xticks([0 30 60 90 120 150 180 210 240 270 300])
xticklabels({'0','0.5','1','1.5','2','2.5','3','3.5','4','4.5','5'})
hold off
% SaveFigure as .eps file
saveas(figFullModel_vP_t, append(ResultsFolder , 'fullModel_P,v~t'),'epsc')

%% safe simulation results from capacitor compensated run
%m = matfile('sim_comp.mat','Writable',true);
out_comp = out;
save(append(SimulationFolder ,'sim_comp.mat'),'out_comp');
%out_uncomp = out;
%save(append(SimulationFolder ,'sim_uncomp.mat'),'out_uncomp');

% load the simulation results
load(append(SimulationFolder ,"sim_comp.mat"));
%load(append(SimulationFolder ,"sim_uncomp.mat"));
disp('done')

%% PF comparison PF ~ t
time = out_comp_lowload.tout;
start = round(30*length(time)/time(length(time)));
zoom = start:length(time);
time = time(zoom)-time(zoom(1));
xvar = time;
yvar = [ out_uncomp.fullModel_Gen.signals(1).values(zoom) out_comp_highload.fullModel_Gen.signals(1).values(zoom) out_comp_lowload.fullModel_Gen.signals(1).values(zoom)];
xlab = "Time [h]" ;
ylab = [ "Power factor" "Power factor"];
leg = ["Without RPC" "With RPC and high load" "With RPC and low load"  ];

% plot
genModel_validation_PF_comp = figure;

subplot(2,1,1)
plot(xvar, yvar(:,1),'LineWidth',1, 'color', 'b')
hold on
grid on
set(gca, 'TickLabelInterpreter','latex')
ylim([0 1.05])
ylabel(ylab(2),'FontSize',12, 'Interpreter','latex')
legend(leg(1),'FontSize',10, 'Interpreter','latex')
legend('Location','Southwest')
yline(1,'-','LineWidth',1,'HandleVisibility','off')
yline(0.9,'--','LineWidth',1,'HandleVisibility','off')
text(-12,0.9,{"0.9"},'LineWidth',1,'HandleVisibility','off','FontSize',8, 'Interpreter','latex')
xticks([0 30 60 90 120 150 180 210 240 270 300])
xticklabels({'0','0.5','1','1.5','2','2.5','3','3.5','4','4.5','5'})

subplot(2,1,2)
hold on
plot(xvar, yvar(:,2),'LineWidth',1, 'color', 'b')
plot(xvar, yvar(:,3),'LineWidth',1, 'color', 'red')
set(gca, 'TickLabelInterpreter','latex')
ylim([0.896 1.006])
ylabel(ylab(1),'FontSize',12, 'Interpreter','latex')
legend(leg(2:3),'FontSize',10, 'Interpreter','latex')
legend('Location','Southwest')
yline(1,'-','LineWidth',1,'HandleVisibility','off')
yline(0.9,'--','LineWidth',1,'HandleVisibility','off')
%text(-15,0.9,{"0.95"},'LineWidth',1,'HandleVisibility','off','FontSize',8, 'Interpreter','latex')
xticks([0 30 60 90 120 150 180 210 240 270 300])
xticklabels({'0','0.5','1','1.5','2','2.5','3','3.5','4','4.5','5'})

%Layout 
xlabel(xlab,'FontSize',12, 'Interpreter','latex')
grid on
box on
hold off

%SaveFigure as .eps file
saveas(genModel_validation_PF_comp, append(ResultsFolder , 'fullModel_PF_comparison~t'),'epsc')

%% Active and Reactive Power compensated
fig_ActiveReactivePower_POC = createFigureCustom(out_comp.time(zoom) , [out_comp.signals(2).values(zoom)/1000 out_comp.signals(3).values(zoom)/1000], "","Time [h]",["[kW] and [kVAR]"],[" Active power P" "Reactive power Q"],[-1 6])
hold on
xticks([0 30 60 90 120 150 180 210 240 270 300])
xticklabels({'0','0.5','1','1.5','2','2.5','3','3.5','4','4.5','5'})
xlim tight
hold off
%SaveFigure as .eps file
saveas(fig_ActiveReactivePower_POC, append(ResultsFolder , 'ActiveReactivePower_POC_P,Q~t'),'epsc')

 %% Ploting Capacitor Bank compensation
% 
% %Q_array = [Q_base Q_base+1*Q_step Q_base+2*Q_step Q_base+3*Q_step Q_base+4*Q_step]
% Q_array = [Q_base 0 0 0 0 ; Q_base Q_step 0 0 0 ; Q_base Q_step Q_step 0 0 ; Q_base Q_step Q_step Q_step 0 ; Q_base Q_step Q_step Q_step Q_step ] *3 ;
% Q_name = ["Cb" 'Cb-C1' 'Cb-C2' 'Cb-C3' 'Cb-C4'];
% % plot 
% figQ = figure;
% hold on
% bar(Q_name,Q_array,0.4,'stacked', 'EdgeColor', 'black','LineWidth',1.5);
% yline(Q_min,'--','Q_{min}','LineWidth',1.5);
% yline(Q_max,'--','Q_{max}','LineWidth',1.5);
% yline(Q_tot,'--','Q_{max,comp}','LineWidth',1.5);
% %yline(Q_max-Q_95,'--','Q_{95}','LineWidth',1.5);
% text(0.5,Q_tot*1.04,'pf = 0.95 at nominal power','Interpreter','latex')
% 
% newcolors = [  0.40 0.30 0.90;   0 0.5 1; 0.5 0 1; ; 0.7 0.7 0.7 ;0 0 1 ];
% colororder(newcolors)
% grid on
% box on
% title('Compensated Reactive Power','Interpreter','latex')
% ylabel('Q [KVAR]','Interpreter','latex')
% xlabel('Capacitor steps','Interpreter','latex')
% ResultsFolder = 'plotting_data/Results/' ;
% saveas(figQ, append(ResultsFolder,'Q_compensated_multistepCapacitorbank'),'epsc');

%% Full Model Load flow 
% logged data to workspace TIMESERIES
Vrms_POC  = out.Vrms_POC ;
Irms_POC  = out.Irms_POC ;
Vrms_Bus1 = out.Vrms_Bus1 ;
Irms_Bus1 = out.Irms_Bus1 ;

% logged data structure with time
WT_activePout = out.fullModel_Gen.signals(2).values ;
time_intervals = out.fullModel_Gen.time ;
WT_activePout_ts = timeseries(WT_activePout, time_intervals, 'Name',"Active power");

% safe as .mat files
save('Vrms_POC.mat','Vrms_POC');
save('Irms_POC.mat','Irms_POC');
save('Vrms_Bus1.mat','Irms_POC');
save('Irms_Bus1.mat','Irms_POC');
save('WT_Pout.mat','WT_activePout_ts');

disp('done')

%load('Vrms_POC.mat')

% PLot Load Flow Analysis
figure
plot(Vrms_POC,'blue','LineWidth',1.5)
hold on
plot(Vrms_Bus1,'red','LineWidth',1.5)
ylim([170 260])
yyaxis right
plot(WT_activePout_ts,'LineWidth',1.5)
legend(["Vrms POC" "Vrms Bus1" "Active Power"])
ylim([0 7000])
grid on
hold off

%% Voltage Deviation Analysis Uc +10 -15%
% For Zoom in plot
time = out_comp_lowload.tout;
start = round(30*length(time)/time(length(time)));
zoom = start:length(time);
time = time(zoom)-time(zoom(1));
Vrms_POC_L2L_lowload = out_comp_lowload.fullModel_POC_RMS.signals(1).values(zoom,1) .*sqrt(3);
Vrms_POC_L2L_highload = out_comp_highload.fullModel_POC_RMS.signals(1).values(zoom,1) .*sqrt(3);
%Vrms_POC.Data(zoom,2) .*sqrt(3);

Uc_min = 0.85*400;
Uc_max = 1.1*400;
fig_UC_deviation = createFigureCustom(time,[Vrms_POC_L2L_highload Vrms_POC_L2L_lowload],"","Time [h]","Line RMS Voltage at POC [V]",[ "At high load" "At low load"],[320 460]);
hold on
xticks([0 30 60 90 120 150 180 210 240 270 300])
xticklabels({'0','0.5','1','1.5','2','2.5','3','3.5','4','4.5','5'})
yline(Uc_max,'--k',{"$upper \, limit \; \; U_n +10\% $"},'LineWidth',1.5,'LabelHorizontalAlignment','left','FontSize',18,'Interpreter','latex','HandleVisibility','off')
%text(-12,440,"440",'FontSize',15,'Interpreter','latex')
yline(Uc_min,'--',{"$lower \, limit \; \; U_n  -15\%$"},'LineWidth',1.5,'LabelHorizontalAlignment','left','FontSize',18,'Interpreter','latex','HandleVisibility','off')
%text(-12,340,"340",'FontSize',15,'Interpreter','latex')

hold off
saveas(fig_UC_deviation, append(ResultsFolder , 'Voltage_deviation_Vrms~t'),'epsc')
%% FFT Analysis THD

% Low Load
Vabc_LowL  = out_comp_lowload.Vabc_POC1 ;
Iabc_LowL  = out_comp_lowload.Iabc_POC1 ;
Vabc_POC_LowL  = out_comp_lowload.Vabc_POC ;
Iabc_POC_LowL  = out_comp_lowload.Iabc_POC ;
time  = out_comp_lowload.tout ;
start = round(30*length(time)/time(length(time)));
zoom = start:length(time);
time = time(zoom)-time(zoom(1));

% High Load
Vabc_HighL  = out_comp_highload.Vabc_POC1 ;
Iabc_HighL  = out_comp_highload.Iabc_POC1 ;
Vabc_POC_HighL  = out_comp_highload.Vabc_POC ;
Iabc_POC_HighL  = out_comp_highload.Iabc_POC ;


%%
figure;
fig_Vabc = plot(time,Vabc.signals.values(zoom)) ;
figure;
fig_Vabc_POC = plot(time,Iabc_POC.signals.values(zoom)) ;
figure;
%% VRMS_comparion POC and Bus 1
VRMS_comparion = [out_comp_lowload.fullModel_POC_RMS.signals(1).values out_comp_lowload.fullModel_Bus1_RMS.signals(1).values];
fig_Vabc_comarison = plot(time,VRMS_comparion(zoom,:)) ;

%%
% FFT
signal = Vabc.signals.values(zoom,1);
size(signal)
Y = fft(signal);
t_sampling = 50e-6 ;
f_sampling = 1/t_sampling;
L = time(length(time));

[r,harmpow,harmfreq] = thd(abs(signal),f_sampling,7);
bar(harmfreq,harmpow*10e-15)
%%
f_scan = f_sampling/L*(0:L*T);
plot(f_scan,abs(Y),"Linewidth",3)
%%
mythd = thd(Vabc.signals.values(zoom,1))%,f_sampling,15)
%fig_FFT_Vabc_POC = openfig("FFT_Vabc_POC.fig")

%% Wind Ramp full model

%out_vramp_uncomp = out;
%save(append(SimulationFolder ,'sim_WindRamp_uncomp.mat'),'out_vramp_uncomp');

%% P,Q ~ wind UNCOMPENSATED
% cutout
time = out_vramp_uncomp.tout;
start = round(22*length(time)/time(length(time)));
endtime = round(88.5*length(time)/time(length(time)));
zoom = start:endtime ;
time = time(zoom)-time(zoom(1));

xvar = out_vramp_uncomp.fullModel_aero.signals(1).values ;% Wind
%yvar = [out_vramp_uncomp.fullModel_Gen.signals(2).values out_vramp_uncomp.fullModel_Gen.signals(3).values*-1 ]/1000;
%fig_PQwindRamp_uncomp = createFigureCustom(xvar(zoom),yvar(zoom,:),"","Wind speed $$\left[\frac{m}{s}\right]$$","Power [kW] and [kVAR]",["Active power produced" "Reactive power consumed"],[-1 7])
%SaveFigure as .eps file
%saveas(fig_PQwindRamp_uncomp, append(ResultsFolder , 'PQ~windRamp_uncomp'),'epsc')

yvar = [out_vramp_uncomp.fullModel_POC.signals(2).values out_vramp_uncomp.fullModel_POC.signals(3).values out_vramp_comp.fullModel_POC.signals(3).values ]/1000;
fig_PQwindRamp_compared = createFigureCustom(xvar(zoom),[yvar(zoom,:)],"","Wind speed $$\left[\frac{m}{s}\right]$$","Power [kW] and [kVAR] at POC",["Active power" "Reactive power, without RPC" "Reactive power, with RPC"],[-5 9])
%SaveFigure as .eps file
saveas(fig_PQwindRamp_compared , append(ResultsFolder , 'PQ~windRamp_compared'),'epsc')

%% Pmech,Pel ~ wind COMPENSATED
%out_vramp_comp = out;
%save(append(SimulationFolder ,'sim_WindRamp_comp.mat'),'out_vramp_comp');
load(append(SimulationFolder ,'sim_WindRamp_comp.mat'))
%%
% cutout
time = out_vramp_comp.tout;
start = round(30*length(time)/time(length(time)));
endtime = round(90*length(time)/time(length(time)));
zoom = start:endtime ;
time = time(zoom)-time(zoom(1));

xvar = out_vramp_comp.fullModel_aero.signals(1).values ;% Wind
yvar = [out_vramp_comp.fullModel_aero.signals(2).values out_vramp_comp.fullModel_Gen.signals(2).values]/1000 ;
fig_PmechPelWind =createFigureCustom(xvar(zoom), yvar(zoom,:),"","Wind speed $$\left[\frac{m}{s}\right]$$","Power [kW]",["Mechanical power WT rotor" "Electrical active power generator"],[-1 7])
%SaveFigure as .eps file
saveas(fig_PmechPelWind, append(ResultsFolder , 'PmechPel~WindRamp'),'epsc')
%%  Test
%out_vramp_comp = out;
%plot(time,yvar(zoom,1))
%plot(out_vramp_comp.fullModel_Gen.signals(3).values)
%fig = createSubFiguresCustom(xvar(zoom), [out_vramp_comp.fullModel_Gen.signals(2).values(zoom) out_vramp_comp.fullModel_Gen.signals(4).values(zoom) out_vramp_comp.fullModel_Gen.signals(5).values(zoom) out_vramp_comp.fullModel_aero.signals(3).values(zoom)/8.27],"","",["" "" "" ""],["P" "s" "Tt/gearboxratio" "Te"])

%%
figure;
plot(out_comp_lowload.tout, out_comp_lowload.fullModel_POC_RMS.signals(1).values(:,1),'DisplayName', 'POC')
hold on
plot(out_comp_lowload.tout, out_comp_lowload.fullModel_Bus1_RMS.signals(1).values(:,1),'DisplayName', 'Bus 1')
xticks([0 30 60 90 120 150 180 210 240 270 300])
xticklabels({'0','0.5','1','1.5','2','2.5','3','3.5','4','4.5','5'})
legend
title('lowload')
%%
figure;
plot(out_comp_highload.tout, out_comp_highload.fullModel_POC_RMS.signals(1).values(:,1), 'DisplayName', 'POC')
hold on
plot(out_comp_highload.tout, out_comp_highload.fullModel_Bus1_RMS.signals(1).values(:,1),'DisplayName', 'Bus 1')
hold off
xticks([0 30 60 90 120 150 180 210 240 270 300])
xticklabels({'0','0.5','1','1.5','2','2.5','3','3.5','4','4.5','5'})
title('highload')
legend



