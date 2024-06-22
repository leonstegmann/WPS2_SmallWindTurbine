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

function myfigure = createFigureCustom(xvar, yvar, mytitle, xlab, ylab, leg, varargin)
    vars=size(yvar);
    nvars = vars(2);
    myfigure = figure;
    myfigure.Position = [100 100 1280 720];
    mycolors = ['b' "red" "k" "#D95319" "#7E2F8E" "#77AC30" "#4DBEEE" "#A2142F"];
    %Sets position on screen and dimensions
    for i = 1:nvars
        plot(xvar, yvar(:,i),'LineWidth',1.5,'color', mycolors(i))
        hold on
    end
        % Process optional arguments
    if ~isempty(varargin)
        ylim(varargin{1});
    end
    set(gca, 'TickLabelInterpreter','latex')
    fontsize(16,"points")
    title(mytitle, 'FontSize',20, 'Interpreter','latex')
    ylabel(ylab,'FontSize',18, 'Interpreter','latex')
    xlabel(xlab,'FontSize',18, 'Interpreter','latex')
    legend(leg,'FontSize',18, 'Interpreter','latex')
    hold off
    grid on
end
