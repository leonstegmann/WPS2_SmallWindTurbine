%Custom function to graph multiple variables in a single graph.
%Example on how to use it:
%t= xvector;                                                        %Define the x-axis vector
% myvars=[yvector1 yvector2];                                       %Define the y-axis vectors to graph in an array (in this case myvars)
% mytitle = "$i_{out}$ and reference";                              %Define the title
% xlab = "Time $[s]$";                                              %Define label for x-axis
% ylab = "$i_d [A]$";                                               %Define label for y-axis
% mylegend = ["$i_d$" "Reference"];                                 %Define the legend
% OPTIONAL ARGUMENT varargin = [ymin,ymax];                                 %Define ylim
% createFigureCustom(t, myvars,mytitle, xlab, ylab, mylegend);      %Call the function

function myfigure = createSubFiguresCustom(xvar, yvar, mytitle, xlab, ylab, leg, varargin)
    vars=size(yvar);
    nvars = vars(2);
    myfigure = figure;
    myfigure.Position = [100 100 1280 720];                         %Sets position on screen and dimensions
    if ~isempty(varargin)
        ylimits = varargin{1};
    end
    for i = 1:nvars
        subplot(nvars,1,i)
        plot(xvar, yvar(:,i),'LineWidth',1.5, 'color', 'b')
        set(gca, 'TickLabelInterpreter','latex')
        grid on
        hold on

        % Process optional arguments
        if ~isempty(varargin)
            ylim(ylimits(i,:));
        end
    
        ylabel(ylab(i),'FontSize',16, 'Interpreter','latex')
        legend(leg(i),'FontSize',12, 'Interpreter','latex')
        legend('Location','Southeast')
        legend('off')
        %xticks([0 30 60 90 120 150 180 210 240 270 300])
        %xticklabels({'0','0.5','1','1.5','2','2.5','3','3.5','4','4.5','5'})
        xlim tight
    end
    xlabel(xlab,'FontSize',16, 'Interpreter','latex')
    sgtitle(mytitle, 'FontSize',20, 'Interpreter','latex') 
    hold off
    
end

