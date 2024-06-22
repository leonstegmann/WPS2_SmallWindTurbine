function myfigure = createFigureCustom2AXIS(xvar, yvar, mytitle, xlab, ylabs, leg, varargin)
    myfigure = figure;
    myfigure.Position = [100 100 1280 720];  
    if ~isempty(varargin)
        ylimits = varargin{1};
    end
    yyaxis left
    plot(xvar, yvar(:,1),'LineWidth',1.5,'color', 'b')
    set(gca, 'YColor', 'black', 'TickLabelInterpreter','latex')
    ylabel(ylabs(1),'FontSize',18, 'Interpreter','latex','Color','black')
    if ~isempty(varargin)       % Process optional arguments
        ylim(ylimits(1,:));
    end
    hold on
    yyaxis right
    plot(xvar, yvar(:,2),'LineWidth',1.5,'Color','red')
    set(gca, 'YColor', 'black', 'TickLabelInterpreter','latex')
    ylabel(ylabs(2),'FontSize',18, 'Interpreter','latex','Color','black')
    if ~isempty(varargin)       % Process optional arguments
        ylim(ylimits(2,:));
    end
    
    fontsize(16,"points")
    title(mytitle, 'FontSize',20, 'Interpreter','latex')
    xlabel(xlab,'FontSize',18, 'Interpreter','latex')
    legend(leg,'FontSize',18, 'Interpreter','latex')
    %legend('Location','southeast')
    hold off
    grid on
end
