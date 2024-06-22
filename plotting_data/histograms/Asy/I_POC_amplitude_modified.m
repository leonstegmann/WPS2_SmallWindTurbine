%% 
clear
load("I_POC_1500.mat")
load('I_POC_5000.mat')

time=I_POC_1500.time;

I1=I_POC_1500.signals.values(:,1)*10e2;
I2=I_POC_1500.signals.values(:,2)*10e2;
%I3=I_POC_1500.signals.values(:,3)*10e2;
I1I2=abs(I1-I2);
%I1I3=abs(I1-I3);
%I2I3=abs(I2-I3);

I1_5=I_POC_5000.signals.values(:,1)*10e2;
I2_5=I_POC_5000.signals.values(:,2)*10e2;

I1I2_5=abs(I1_5-I2_5);

mean(I1I2(58000:end))
mean(I1I2_5(58000:end))

plot(time,I1I2, 'LineWidth',1.5, 'Color','r') %1500
hold on
plot(time,I1I2_5, 'LineWidth',1.5, 'Color','b')%5000

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

ylabel('Amplitude difference of phase a and b [mA]','interpreter','latex','FontSize',18)
ylim([0 8.5])

xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex'; % latex for x-axis
yaxisproperties= get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex';   % tex for y-axis

grid on

hold off

%% Histogram ASY Content

% create figure
fig_ASYcontent = figure
hold on
mybins = linspace(0,5,21);
mystart = round(29/329 *length(I1I2)) ;

% plot
h1 = histogram(I1I2(mystart:end),mybins ,Normalization="percentage",FaceColor="b",FaceAlpha = 0.7) % Low Load
h2 = histogram(I1I2_5(mystart:end),mybins,Normalization="percentage",FaceColor="r",FaceAlpha= 0.7) % high load

%Description
ylabel('Relative distribution $[\%]$','interpreter','latex','FontSize',18)
xlabel('Amplitude difference of phase a and b [mA]','interpreter','latex','FontSize',18)
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
xticks(linspace(mybins(1),mybins(length(mybins)),mybins(length(mybins))*2+1) )
xlim tight
grid on
box on

% save figure
saveas(fig_ASYcontent , "ASY_content_histogram",'epsc')




