%this script makes lateralized topoplots at the time window of the N2pc
function topoplotN2pc(nfilename)

if nargin == 0
    %load in your masterdata file here
    nfilename = 'csv_ERP_data/n25acc1tt1cf3sub0_n2pc.csv';
    sub_plotting = 0;
else
    nfilename = sprintf('masterdata/%s.mat',nfilename(1:17));
    sub_plotting = 1;
end

load(nfilename);
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
central_electrode = [3 4 15 21];
for electrode = 1:4
    for con = 1:size(masterdata,2)
        test = plotmasterdataCENTRALELECTRODES_pooling(masterdata,electrode,cons(con,:),subpos);
        load Datasub
        thissubsdataCentral = Datasub{1,1};
        centralelectrode = central_electrode(electrode);
        for i = 1:size(Datasub,2)
            thissubsdataCentral = Datasub{1,i};
            if(isempty(thissubsdataCentral) == 0)
                AllConAllSubsData(i,con,centralelectrode,:)=thissubsdataCentral';
            end
        end
    end
end
%this bit is getting rid of the mastoid electrode
AllConAllSubsData=AllConAllSubsData(:,:,[1:19,21:29],:);
AllConAllSubsData = squeeze(mean(AllConAllSubsData,1));

halfwindow = 3; %this is going to take 3 * 4 = 12ms befor the time point and 12 ms after

%matrices for both N2pcs and pds
topodata1 = zeros(1,31);
topodata2 = zeros(1,31);
%this is to load the channel location file that was very laborious to
%make and really makes you resent the spherical nature of the head
load chanlocs3
tester=[EEGchanlocs(1:19),EEGchanlocs(21:29)];
%choose the timepoint that you are interested in MILLISECONDS
timepoint = [206];
%this then translates it into time points
window1 = round((timepoint(1)+1000)/4);

for electrode = 1:28
    topodata1(electrode) = squeeze(AllConAllSubsData(1,electrode,window1));
end

%now to plot the data
if sub_plotting == 0
    figure
end

topoplot(topodata1,tester,'maplimits',[-3 3],'colormap','jet')
%topoplot(topodata1,tester,'colormap','jet')
colorbar

