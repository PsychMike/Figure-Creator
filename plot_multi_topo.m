    topodata1 = x;
tester=y;
    timepoint = [100:50:600];
    windows = ceil((timepoint+1000)./4);
    figure
    for time = 1:length(windows)
        subplot(1,11,time)
        topoplot(squeeze(topodata1(:,time)),tester,'maplimits',[-2 8],'colormap','jet','style','map','headrad',0,'electrodes','off')
    end