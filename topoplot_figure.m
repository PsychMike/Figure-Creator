%this script makes lateralized topoplots at the time window of the N2pc

test = 0;

%load in your masterdata file here
if test
    nfilename2 = 'masterdata/n25acc1tt1cf3sub0.mat';
    multi_plot = 3;
else
    nfilename2 = sprintf('masterdata/%s.mat',nfilename1(1:17));
end

if multi_plot < 5
    contra_ipsi = 1; %contra-ipsi plot
else
    contra_ipsi = 0; %pz plot
end
if test == 0
    load(nfilename2);
    subpos = 1:length(sublist);
    AllConAllSubsData=[];
    type = 1;
    pairleft = [2,12,11,13,18,19,24,26,25,27,29,14];
    pairright = [1,5,7,6,9,8,10,16,17,22,23,28];
    cons = 1;
    for electrode_pair = 1:12
        for con = 1:size(masterdata,2)
            %this bit is organizing the contra and ipsi waveform for each
            %electrode pair and each condition
            test = plotmasterdata(masterdata,electrode_pair,con,subpos,type,nfilename);
            actualsub=0;
            Contrasub = sprintf('NCI/Contrasub_%s',nfilename);
            load(Contrasub);
            Ipsisub = sprintf('NCI/Ipsisub_%s',nfilename);
            load(Ipsisub);
            thissubsdataC = Contrasub{1,1};
            thissubsdataI = Ipsisub{1,1};
            electrodeC = pairright(electrode_pair);
            electrodeI = pairleft(electrode_pair);
            for i = 1:size(Contrasub,2)
                thissubsdataC = Contrasub{1,i};
                thissubsdataI = Ipsisub{1,i};
                if(isempty(thissubsdataC) == 0)
                    AllConAllSubsData(i,con,electrodeC,:)=thissubsdataC';
                    AllConAllSubsData(i,con,electrodeI,:)=thissubsdataI';
                end
            end
            
        end
    end
    %this bit you will need because you need values for the central electrodes
    %as well
    central_electrodes = [3 4 15 21];
    % for electrode = 1:length(central_electrodes)
    %     for con = 1:size(masterdata,2)
    %         test = plotmasterdataCENTRALELECTRODES(masterdata,electrode,cons(con,:),subpos);
    %         load Datasub
    %         thissubsdataCentral = Datasub{1,1};
    %         centralelectrode = central_electrodes(electrode);
    %         for i = 1:size(Datasub,2)
    %             thissubsdataCentral = Datasub{1,i};
    %             if(isempty(thissubsdataCentral) == 0)
    %                 AllConAllSubsData(i,con,centralelectrode,:)=thissubsdataCentral';
    %             end
    %         end
    %     end
    % end
    %Include all electrodes for the corresponding topoplot
    all_electrodes = [1:19,21:29];
    included_electrodes = all_electrodes(~ismember(all_electrodes,central_electrodes)); %exclude central electrodes
    % included_electrodes = [1:2,5:14,16];
    % included_electrodes = [1:19,21:29];
    AllConAllSubsData=AllConAllSubsData(:,:,included_electrodes,:);
    AllConAllSubsData = squeeze(mean(AllConAllSubsData,1));
    
    halfwindow = 3; %this is going to take 3 * 4 = 12ms befor the time point and 12 ms after
    
    %this is to load the channel location file that was very laborious to
    %make and really makes you resent the spherical nature of the head
    load chanlocs3
    % tester=[EEGchanlocs(1:19),EEGchanlocs(21:29)];
    % tester=[EEGchanlocs(1:2),EEGchanlocs(5:14),EEGchanlocs(16:20),EEGchanlocs(22:29)];
    tester = EEGchanlocs(included_electrodes);
    %choose the timepoint that you are interested in MILLISECONDS
    timepoint = [200:20:400];
    %this then translates it into time points
    windows = ceil((timepoint+1000)./4);
    
    %matrices for both N2pcs and pds
    topodata = zeros(1,length(windows));
    
    %Create grand topodata structure
    for electrode = 1:length(included_electrodes)
        for time = 1:length(windows)
            topodata(electrode,time) = squeeze(AllConAllSubsData(electrode,windows(time)));
        end
    end
else
    %Plot the topodata
    % figure
    load('topodata1');
end

if topo_space == 1
    topo_num = 11;
elseif topo_space == 2
    topo_num = 22;
elseif topo_space == 3
    topo_num = 77;
else
    topo_num = 88;
end

for time = 1:length(windows)
    subplot(num_plot_space_y,num_plot_space_x,topo_num+time+(11*multi_factor));
    topoplot(squeeze(topodata(:,time)),tester,'maplimits',[-2 0.5],'colormap','jet','style','map','headrad',0,'electrodes','off');
end
side_topo_label_pos = -16.5;first_topo_text_pos = -15.3; mid_topo_text_pos = -7.7; last_topo_text_pos = -0.3;
label_size = 18;
if multi_plot == 3 || multi_plot == 7
    t_label=text(side_topo_label_pos,0,'Targets','Color','blue');
    set(t_label,'fontweight','bold','fontsize', label_size);
elseif multi_plot == 4 || multi_plot == 8
    text_spacing = 0.2;
    ft_label1=text(side_topo_label_pos,text_spacing,'False');
    ft_label2=text(side_topo_label_pos,-text_spacing,'Targets');
if multi_plot == 4,time_label1='200ms';time_label2='300ms';time_label3='400ms';else time_label1='100ms';time_label2='350ms';time_label3='600ms';end
    first_text=text(first_topo_text_pos,-1,time_label1);
    mid_text=text(mid_topo_text_pos,-1,time_label2);
    last_text=text(last_topo_text_pos,-1,time_label3);
    set(gcf, 'Position', get(0,'Screensize')); % Maximize figure
 set(ft_label1,'fontweight','bold','fontsize', label_size,'Color','red');
 set(ft_label2,'fontweight','bold','fontsize', label_size,'Color','red');
 set(first_text,'fontweight','bold','fontsize', label_size);
 set(mid_text,'fontweight','bold','fontsize', label_size);
 set(last_text,'fontweight','bold','fontsize', label_size);
 rect=rectangle('Position',[-16.65,-1.3,17.5,3.5]);
 set(rect,'clipping','off','edgecolor','green','linewidth',5);
%  close all;figure;xlim([0 1]);quiv=quiver(50,25,'clipping','off');
    keyboard
end
% keyboard
%%%%%%%%%%%%%%%%%