%clear
load('I_DC_1500W.mat')
load('I_DC_5000.mat')

%1500W
time1=I_DC.time;
I1=I_DC.signals.values(:,1) *1e3;

%5000W
time2=I_DC_5000.time;
I2=I_DC_5000.signals.values(:,1)* 1e3;

I_DC_mean1=mean(I1(2900:end))%1500
I_DC_mean2=mean(I2(2900:end))%5000

plot(time1, I1,'LineWidth',1.5, 'Color','r')
hold on
plot(time2, I2,'LineWidth',1.5, 'Color','b')

fontsize(16,'points')

legend('At low load', ...
    'At high load',...
    'interpreter','latex', ...
    'Location', 'northeast', ...
    'fontsize', 18)

xlabel('Time [h]','interpreter','latex','FontSize',18)

% Anpassen der x-Achsenbeschriftung
xlim([29 329])
% Neue X-Ticks definieren
new_x_ticks = linspace(29, 329, 11); % 11 Werte von 29 bis 329
% Neue X-Tick-Labels explizit definieren
new_x_tick_labels = {'0', '0.5', '1', '1.5', '2', '2.5', '3', '3.5', '4', '4.5', '5'};
% X-Ticks und Labels setzen
xticks(new_x_ticks);
xticklabels(new_x_tick_labels);

ylabel('DC content [mA]','interpreter','latex','FontSize',18)

xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex'; % latex for x-axis
yaxisproperties= get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex';   % tex for y-axis

grid on

hold off

%% Histogram DC Content

% create figure
fig_DCcontent = figure
hold on
mybins = linspace(0,12,25);
mystart = round(29/329 *length(I1)) ;

% plot
h1 = histogram(I1(mystart:end),mybins ,Normalization="percentage",FaceColor="b",FaceAlpha = 0.7) % Low Load
h2 = histogram(I2(mystart:end),mybins,Normalization="percentage",FaceColor="r",FaceAlpha= 0.7) % high load

%Description
ylabel('Relative distribution $[\%]$','interpreter','latex','FontSize',18)
xlabel('DC content $[mA]$','interpreter','latex','FontSize',18)
legend('At low load', ...
    'At high load',...
    'interpreter','latex', ...
    'Location', 'northeast', ...
    'fontsize', 18)

% Layout
fontsize(16,'points')
xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex'; % latex for x-axis
yaxisproperties= get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex';   % tex for y-axis
xticks(linspace(mybins(1),mybins(length(mybins)),mybins(length(mybins))+1) )
xlim tight
grid on
box on

% save figure
saveas(fig_DCcontent , "DC_content_histogram",'epsc')
%% DC content in comparison to active load
clear
load('I_DC_1500W.mat')
load('I_DC_5000.mat')
load("P_POC_1500.mat")
load('P_POC_5000.mat')

%1500W
time1=I_DC.time;
I1=I_DC.signals.values(:,1)*10e2;

%5000W
time2=I_DC_5000.time;
I2=I_DC_5000.signals.values(:,1)*10e2;

%Power at 1500W
time_p=P_POC_1500.time;
power=P_POC_1500.signals.values;

%Power at 5000W
time_p5=P_POC_5000.time;
power5=P_POC_5000.signals.values;

%Means
I_DC_mean1=mean(I1)
I_DC_mean2=mean(I2)

%Subplot 1 Power
subplot(2,1,1);

plot(time_p, power,'LineWidth', 1.5, 'Color','r')
hold on
plot(time_p5, power5,'LineWidth', 1.5, 'Color','b')
xlim([29 329])
% Neue X-Ticks definieren
new_x_ticks = linspace(29, 329, 11); % 11 Werte von 29 bis 329
% Neue X-Tick-Labels explizit definieren
new_x_tick_labels = {'0', '0.5', '1', '1.5', '2', '2.5', '3', '3.5', '4', '4.5', '5'};
% X-Ticks und Labels setzen
xticks(new_x_ticks);
xticklabels(new_x_tick_labels);

ylabel('Active power [W]','interpreter','latex', 'fontsize', 18)

xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex'; % latex for x-axis
yaxisproperties= get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex';

%Subplot 2 DC content
subplot(2,1,2);

plot(time1, I1,'LineWidth',1.5, 'Color','r')
hold on
plot(time2, I2,'LineWidth',1.5, 'Color','b')

xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex'; % latex for x-axis
yaxisproperties= get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex';   % tex for y-axis

fontsize(16,'points')

legend('At low load', ...
    'At high load',...
    'interpreter','latex', ...
    'Location', 'northeast', ...
    'fontsize', 18)

xlabel('Time [h]','interpreter','latex','FontSize',18)

% Anpassen der x-Achsenbeschriftung
xlim([29 329])

% Neue X-Ticks definieren
new_x_ticks = linspace(29, 329, 11); % 11 Werte von 29 bis 329
% Neue X-Tick-Labels explizit definieren
new_x_tick_labels = {'0', '0.5', '1', '1.5', '2', '2.5', '3', '3.5', '4', '4.5', '5'};
% X-Ticks und Labels setzen
xticks(new_x_ticks);
xticklabels(new_x_tick_labels);


ylabel('DC content [mA]','interpreter','latex','FontSize',18)

hold off
%% 
yyaxis left
plot(time1, I1,'LineWidth',1.5, 'Color','r') %1500
ylabel('DC content [mA]','interpreter','latex','FontSize',18)
yyaxis right
plot(time_p, power,'LineWidth', 1.5, 'Color','k')

xlabel('Time [h]','interpreter','latex','FontSize',18)

% Anpassen der x-Achsenbeschriftung
xlim([29 329])
%x_data_ticks = [29:50:329]; % Ursprüngliche x-Achsenticks
%x_display_labels = [0:50/60:5]; % Gewünschte x-Achsenbeschriftungen
%xticks(x_data_ticks);
%xticklabels(cellstr(num2str(x_display_labels.')));

% Neue X-Ticks definieren
new_x_ticks = linspace(29, 329, 11); % 11 Werte von 29 bis 329
% Neue X-Tick-Labels explizit definieren
new_x_tick_labels = {'0', '0.5', '1', '1.5', '2', '2.5', '3', '3.5', '4', '4.5', '5'};
% X-Ticks und Labels setzen
xticks(new_x_ticks);
xticklabels(new_x_tick_labels);

grid on
hold off


