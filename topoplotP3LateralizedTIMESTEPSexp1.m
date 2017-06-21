alreadydone=0;

for cf = 1:2; %targ (1) or FT (0)?
    true_targ = 1;
    nfilename = sprintf('n25acc%dtt%dcf%dsub0',true_targ,true_targ,cf);
    type = 1;
    if alreadydone == 0
        load(sprintf('masterdata/%s',nfilename));
        
        subpos = [1:length(sublist)];
        %     BucketedData=[];
        %     BucketedDigit=[];
        AllConAllSubsData=[];
        
        pairleft = [2,12,11,13,18,19,24,26,25,27,29,14];
        pairright = [1,5,7,6,9,8,10,16,17,22,23,28];
        
        for electrode_pair = 1:12
            for con = 1
                test = plotmasterdata(masterdata,electrode_pair,con,subpos,type,nfilename);
                actualsub=0;
                
                load(sprintf('NCI/Contrasub_%s',nfilename));
                load(sprintf('NCI/Ipsisub_%s',nfilename));
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
        
        central_electrode = [3 4 15 21];
        for electrode = 1:4
            for con = 1
                test = plotmasterdataCENTRALELECTRODES(masterdata,electrode,con,subpos);
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
        
        goodsubCD=[];
        goodelectrodes=[1:19,21:29];
        AllConAllSubsData = AllConAllSubsData(:,:,goodelectrodes,:);
        for sub = 1:size(AllConAllSubsData,1)
            possible_bad_electrode = [];
            for electrode = 1:size(AllConAllSubsData,3)
                if max(AllConAllSubsData(sub,1,electrode,:))==0
                    possible_bad_electrode=[possible_bad_electrode,electrode];
                end
            end
            if length(possible_bad_electrode) == 0
                goodsubCD=[goodsubCD,sub];
            end
        end
        AllConAllSubsData = AllConAllSubsData(goodsubCD,:,:,:);
        %
        %     BucketedColor = mean(AllConAllSubsData(:,[1,3,5],:,:),2);
        %     BucketedDigit= mean(AllConAllSubsData(:,[2,4,6],:,:),2);
        AllConAllSubsData = mean(AllConAllSubsData(:,:,:,:),2);
        
        %     AllConAllSubsData = [BucketedData,BucketedDigit]; %all bucketed and ready to go!
        AllConAllSubsData = squeeze(mean(AllConAllSubsData));
    end
    halfwindow = 3; %this is going to take 3 * 4 = 12ms befor the time point and 12 ms after
    
    %matrices for both N2pcs and pds
    topodata1 = zeros(1,31);
    topodata2 = zeros(1,31);
    %this is to load the channel location file that was very laborious to
    %make
    load chanlocs3
    tester=[EEGchanlocs(1:19),EEGchanlocs(21:29)];
    timepoint = [100:50:600];
    windows = ceil((timepoint+1000)./4);
    popout = figure;
%     ortho1 = figure;
    for electrode = 1:28
        for time = 1:length(windows)
            topodata1(electrode,time) = squeeze(AllConAllSubsData(electrode,windows(time)));
            %         topodata2(electrode,time) = squeeze(AllConAllSubsData(2,electrode,windows(time)));
        end
    end
    for time = 1:length(windows)
%         figure
        subplot(1,11,time)
        topoplot(squeeze(topodata1(:,time)),tester,'maplimits',[-2 8],'colormap','jet','style','map','headrad',0,'electrodes','off')
        %     if time ==1
        %     colorbar
        %     end
        %     title(sprintf(timepoint(time)))
        
%         figure(ortho1)
%         subplot(6,15,time)
        %     topoplot(squeeze(topodata2(:,time)),tester,'maplimits',[-3 5],'colormap','jet','style','map','headrad',0,'electrodes','off')
        %     if time ==1
        %     colorbar
        %     end
        %     title(sprintf(timepoint(time)))
    end
    %     topoplot(topodata1,tester,'maplimits',[-5 10],'colormap','jet')
    %     topoplot(topodata2,tester,'maplimits',[-5 10],'colormap','jet')
    
    %put in white circles
end
