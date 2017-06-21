function PD_plot_cateeg(x,y,variance)
%% function PD_line(x,y,variance)

% PD_line(x) will plot the data as if x = y with the x dimension being the
% length of y

% PD_line(x,y) will plot data as if x and y are the x and y dimensions

% PD_line(x,y,variance) will add error bars to the plot. Variance should
% have the same dimensions as y or can be equal to 0

% function written by Garrett Swan, gsp.swan@gmail.com & modified heavily
% by Michael Hess, mrhess25@gmail.com

%Add a key to the bottom plot?
second_key = 0;

new_fig = 1;
if new_fig
    close all;
else
    figure;
end
num_plot_space_x = 11;
num_plot_space_y = 7;
multi_factor = num_plot_space_y - 3;
for multi_plot = 1:4
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%Top line plot%%%
    if multi_plot == 1
        nfilename1 = 'n25acc1tt1cf3sub0_n2pc.csv';
        subplot(num_plot_space_y,num_plot_space_x,1:(num_plot_space_x*multi_factor));
    elseif multi_plot == 2
        nfilename1 = 'n25acc0tt0cf3sub0_n2pc.csv';
        %%%Top topoplot%%%
    elseif multi_plot == 3
        % clf(fig,'reset')
subplot(7,11,50:51)
x=[0.32 1 0.9 1 0.88];
y=[1 0.7 0.91 0.7 0.58];
xlim([0 1]);
ylim([0 1]);
% line(x,y);
l=line(x,y,'color','green','linewidth',5);
set(l,'clipping','off')
axis off
% xlim([0 1]);
        nfilename1 = 'n25acc1tt1cf3sub0_n2pc.csv';
        topo_space = 1;
        topoplot_figure;
    elseif multi_plot == 4
        nfilename1 = 'n25acc0tt0cf3sub0_n2pc.csv';
        topo_space = 2;
        topoplot_figure;
        %%%Bottom line plot% %%
    elseif multi_plot == 5
        nfilename1 = 'n25acc1tt1cf3sub0_pz.csv';
        subplot(num_plot_space_y,num_plot_space_x,34:34+num_plot_space_x);
    elseif multi_plot == 6
        nfilename1 = 'n25acc0tt0cf3sub0_pz.csv';
        %%%Bottom topoplot%%%
    elseif multi_plot == 7
        nfilename1 = 'n25acc1tt1cf3sub0_pz.csv';
        topo_space = 3;
        topoplot_figure;
    else
        nfilename1 = 'n25acc0tt0cf3sub0_pz.csv';
        topo_space = 4;
        topoplot_figure;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if multi_plot < 3 || multi_plot == 5 || multi_plot == 6
        csvfile = sprintf('csv_ERP_data/%s',nfilename1);
        y = csvread(csvfile);
        y = y';
        x = ((1:length(y))*4) - 1000;
        range = (200:500);
        x = x(range);
        y = y(range);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if nargin == 0
            if size(x,1)~=size(y,1)
                if size(x,2)~=size(y,2)
                    error_displays(1);
                    return
                end
            end
            variance = 0;
        elseif nargin == 3
            if variance ~= 0
                if isempty(variance)~=0
                    if size(variance,1)~=size(y,1)
                        if size(variance,2)~=size(y,2)
                            error_displays(1);
                            return
                        end
                    end
                end
            end
        end
        
        % we want y to be indexed by rows
        if size(y,1) < size(y,2)
            y = permute(y,[2 1]);
        end
        if size(x,1) < size(x,2)
            x = permute(x,[2 1]);
        end
        if size(variance,1) < size(variance,2)
            variance = permute(variance,[2 1]);
        end
        
        style = 1;
        if multi_plot == 1 || multi_plot == 5
            color{style} = [0 0 1]; % 1 is the maximum, RGB
            marker_edge_color{style} = [0 0 0]; % change this to [1 1 1] to make the lines not touch the markers
            marker_face_color{style} = [0 0 0];
            linestyle{style} = '-'; % e.g. '-','--','none'
            marker{style} = 'none'; % e.g. 'none','o','.','*', etc
            marker_size{style} = 2; % multiple by 2 to make the lines not touch the markers
            line_size{style} = 2;
        elseif multi_plot == 2 || multi_plot == 6
            color{style} = [1 0 0]; % 1 is the maximum, RGB
            marker_edge_color{style} = [0 0 0]; % change this to [1 1 1] to make the lines not touch the markers
            marker_face_color{style} = [0 0 0];
            linestyle{style} = '-'; % e.g. '-','--','none'
            marker{style} = 'none'; % e.g. 'none','o','.','*', etc
            marker_size{style} = 2; % multiple by 2 to make the lines not touch the markers
            line_size{style} = 2;
        end
        
        
        % axes properties
        ticklength = [.02 .02]; % length of tick marks, default = .02
        tickdirection = 'out'; % length of tick marks, default = .02
        
        xmax = [];
        xmin = [];
        
        % labels
        if multi_plot == 1
            x_label = '';
            y_label = 'Amplitude (µV)';
            title_label = 'Contra-Ipsi (P7/P8 electrodes)';
            ytick_label = ['-2';'-1';' 0';' 1'];
            xtick_label = ['-200ms';'      ';'      ';' 400ms';'      ';'      ';'1000ms'];
            ytick_interval = 1; % default= [], which is whatever matlab decides
            xtick_interval = 200; % default= [], which is whatever matlab decides
            % dimensions of the axes
            ymax = 1;
            ymin = -2;
        elseif multi_plot == 5
            x_label = '';
            y_label = '';
            title_label = 'PZ electrode';
            ytick_label = ['-4';' 0';' 4';' 8';'12'];
            xtick_label = ['-200ms';'      ';'      ';' 400ms';'      ';'      ';'1000ms'];
            ytick_interval = 4; % default= [], which is whatever matlab decides
            xtick_interval = 200; % default= [], which is whatever matlab decides
            ymax = 12;
            ymin = -4;
        end
        
        % font parameters
        label_size = 18;
        title_size = 20;
        label_weight = 'normal';
        title_weight = 'bold';
        font_name = 'Arial';
        
        % axes parameters
        size_of_numbers_in_axes = 14; % for a lack of a better word, at the moment
        
        savefile = 0; % save the figure
        filename = 'pd_test'; % file name
        filetype = 'pdf'; % this can be pdf, eps2, et cetera
        
        new_figure = 0; % if 1, yes. If 0, then no new figure
        
        % we want y to be indexed by rows
        if size(y,1) < size(y,2)
            y = permute(y,[2 1]);
        end
        if size(x,1) < size(x,2)
            x = permute(x,[2 1]);
        end
        if size(variance,1) < size(variance,2)
            variance = permute(variance,[2 1]);
        end
        
        if new_figure
            figure('Color',[1 1 1])
            hold on
        end
        
        for which_set = 1:size(y,2)
            
            style = which_set;
            
            if variance ~= 0
                
                errorbar(x,y(:,which_set),variance(:,which_set),...
                    'LineWidth',line_size{style}, ...
                    'Marker',marker{style}, ...
                    'Color',color{style}, ...
                    'LineStyle',linestyle{style}, ...
                    'MarkerEdgeColor' , marker_edge_color{style}, ...
                    'MarkerFaceColor' , marker_face_color{style}, ...
                    'MarkerSize'      , marker_size{style});
                
            end
            if multi_plot < 3 || multi_plot >= 5
                plot(x,y(:,which_set),...
                    'LineWidth',line_size{style}, ...
                    'Marker',marker{style}, ...
                    'Color',color{style}, ...
                    'LineStyle',linestyle{style}, ...
                    'MarkerEdgeColor' , marker_edge_color{style}, ...
                    'MarkerFaceColor' , marker_face_color{style}, ...
                    'MarkerSize'      , marker_size{style});
            end
            
        end
        hline1 = refline(90,0);
        set(hline1,'LineStyle','--','Color',[0 0 0])
        hline2 = refline(0,0);
        set(hline2,'LineStyle','-','Color',[0 0 0])
                %% Global figure parameters
        xlims = get(gca,'XLim');
        ylims = get(gca,'YLim');
        
        if isempty(ymax)==0
            ylims(2) = ymax;
        end
        if isempty(ymin)==0
            ylims(1) = ymin;
        end
        if isempty(xmax)==0
            xlims(2) = xmax;
        end
        if isempty(xmin)==0
            xlims(1) = xmin;
        end
        
        set(gca,'YLim',ylims)
        set(gca,'XLim',xlims)
        %Set the positions of the plot keys
        if multi_plot == 1 %Top plot (Contra-Ipsi)
            rect_height = 0.2;
            rect_x = 590;
            gap_size = 0.3;
            rect_y1 = 0.65;
            rect_width = 150;
            rect_y2 = rect_y1 - gap_size;
            rectangle('Position',[rect_x rect_y1 rect_width rect_height],'FaceColor',[0 0 1]);
            rectangle('Position',[rect_x rect_y2 rect_width rect_height],'FaceColor',[1 0 0]);
            text_x = rect_x + 160;
            text_y1 = rect_y1 + rect_height*0.5;
            text_y2 = text_y1 - gap_size;
            sig_x = 200; sig_y = -1.9999; sig_width = 200; sig_height = 3;
            %         set(gca,'fontsize',100)
            text(text_x,text_y1,'Targets')
            text(text_x,text_y2,'False Targets')
        elseif multi_plot == 5 %Bottom plot (PZ electrode)
            if second_key
                rect_height = 1.2;
                rect_x = 50;
                gap_size = 1.75;
                rect_y1 = 10;
                rect_width = 150;
                rect_y2 = rect_y1 - gap_size;
                rectangle('Position',[rect_x rect_y1 rect_width rect_height],'FaceColor',[0 0 1]);
                rectangle('Position',[rect_x rect_y2 rect_width rect_height],'FaceColor',[1 0 0]);
                text_x = rect_x + 160;
                text_y1 = rect_y1 + rect_height*0.5;
                text_y2 = text_y1 - gap_size;
                text(text_x,text_y1,'Targets')
                text(text_x,text_y2,'False Targets')
            end
            sig_x = 100; sig_y = -3.9999; sig_width = 500; sig_height = 16;
        end
        
        %Significance window (light green square)
        p=patch([0 0 0 0],[0 0 0 0],'r');
        set(p,'FaceAlpha',0.5);
        lightness = 0.8; %out of 1
        rectangle('Position',[sig_x sig_y sig_width sig_height],'FaceColor',[lightness 1 lightness]);
        
        hold on
        
        %% Global figure parameters
        xlims = get(gca,'XLim');
        ylims = get(gca,'YLim');
        
        if isempty(ymax)==0
            ylims(2) = ymax;
        end
        if isempty(ymin)==0
            ylims(1) = ymin;
        end
        if isempty(xmax)==0
            xlims(2) = xmax;
        end
        if isempty(xmin)==0
            xlims(1) = xmin;
        end
        
        set(gca,'YLim',ylims)
        set(gca,'XLim',xlims)
        
        if isempty(ytick_interval)==0
            set(gca,'YTick',ylims(1):ytick_interval:ylims(2))
        end
        if isempty(xtick_interval)==0
            set(gca,'XTick',xlims(1):xtick_interval:xlims(2))
        end
        
        if isempty(xtick_label)==0
            set(gca,'XTickLabel',xtick_label);
        end
        if isempty(ytick_label)==0
            set(gca,'YTickLabel',ytick_label);
        end
        
        % Change axis labels
        ylabel_var = ylabel(y_label);
        xlabel_var = xlabel(x_label);
        title_var = title(title_label);
        
        % Change font of labels
        set([xlabel_var , ylabel_var], ...
            'fontsize'        , label_size,...
            'fontweight'      , label_weight);
        
        % Change font of title
        set([title_var], ...
            'fontsize'        , title_size, ...
            'fontweight'      , title_weight); % b = bold
        
        set([title_var, xlabel_var, ylabel_var], 'FontName',font_name);
        
        set(gca,'FontSize',size_of_numbers_in_axes);
        
        set(gca,'TickLength',ticklength);
        set(gca,'TickDir',tickdirection);
        
            set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
        
        %Defines the properties of the axes.
        set(gca, ...
            'Box'               , 'off', ... %Turns the box on or off
            'XMinorTick'        , 'off', ...%Adds smaller tick marks between larger ones on the x axis
            'YMinorTick'        , 'off', ...%Adds smaller tick marks between larger ones on the y axis
            'YGrid'             , 'off', ... %Adds a thin grid to the y axis
            'XColor'            , [0 0 0], ... %Changes the color of the x axis
            'YColor'            , [0 0 0], ... %Changes the color of the y axis
            'LineWidth'         , 1.5);
        
        % Important for getting rid of ticks on the top and right sides
        xlims = get(gca,'XLim');
        ylims = get(gca,'YLim');
        
        line([xlims(1) xlims(2)],[ylims(2) ylims(2)],'Color',[0 0 0], 'LineWidth', 1.5);
        line([xlims(2) xlims(2)],ylims,'Color',[0 0 0], 'LineWidth', 1.5);
        
        %Saves the graph as an .eps file, thus allowing alternate programs to
        %sharpen the graph for publication.
        set(gcf, 'PaperPositionMode', 'auto');
        
        print_name = sprintf('-d%s %s',filetype,filename);
        print_command = sprintf('print %s',print_name);   %set up the command to output it
        
        if savefile
            eval(print_command)
        end
        
    end
end
end