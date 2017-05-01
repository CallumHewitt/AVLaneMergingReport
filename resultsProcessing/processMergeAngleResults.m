%% Import data.
filename = 'mergeAngleResults.csv';
delimiter = ',';
startRow = 2;

formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

mergeAngleResults = [dataArray{1:end-1}];

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Setup Parameters
% Create X Axis
mergeAngles = mergeAngleResults(:,1);

%% Mean Delay Plot
% Create figure
figure

% Get Data
meanDelay = mergeAngleResults(:,8);
meanTargetDelay = mergeAngleResults(:,9);
meanMergeDelay = mergeAngleResults(:,10);

delayStd = mergeAngleResults(:,11);
targetDelayStd = mergeAngleResults(:,12);
mergeDelayStd = mergeAngleResults(:,13);

% Create Mean Delay Plot
ax1 = subplot(2,1,1);
plot(ax1, mergeAngles, meanDelay, '-k', mergeAngles, delayStd, '--k');

% Add labels
grid on;
title(ax1,'Mean Delay by Merge Angle');
xlabel('Merging Angle (degrees)');
ylabel('Delay (seconds)');
legend({'Mean Delay','Standard Deviation Delay'});

% Create Mean Delay Plot by Lane
ax2 = subplot(2,1,2);
plot(ax2, mergeAngles, meanTargetDelay, '-b', mergeAngles, targetDelayStd, '--b', mergeAngles, meanMergeDelay, '-r', mergeAngles, mergeDelayStd, '--r');

% Add labels
grid on;
title(ax2,'Mean Delay by Merge Angle');
xlabel('Merging Angle (degrees)');
ylabel('Delay (seconds)');
legend({'Mean Target Lane Delay','Standard Deviation Target Lane Delay','Mean Merge Lane Delay','Standard Deviation Merge Lane Delay'});

% Y Limits
ylim manual;
maxVal = max(max(horzcat(ax1.YLim,ax2.YLim)));
minVal = min(min(horzcat(ax1.YLim,ax2.YLim)));

ylim(ax1,[minVal maxVal]);
ylim(ax2,[minVal maxVal]);

clearvars -except mergeAngles mergeAngleResults

%% Create Throughput Plot
% Create figure
figure

% Get Data
throughput = mergeAngleResults(:,14);
throughputTarget = mergeAngleResults(:,15);
throughputMerge = mergeAngleResults(:,16);

% Transform Data
transformNumber = 3600;
throughputHour = throughput * transformNumber;
throughputTargetHour = throughputTarget * transformNumber;
throughputMergeHour = throughputMerge * transformNumber;

% Create Throughput Plot
plot(mergeAngles, throughputHour, '-k', mergeAngles, throughputTargetHour, '-b', mergeAngles, throughputMergeHour, '-r');

% Add labels
grid on;
title('Throughput by Merge Angle');
xlabel('Merging Angle (degrees)');
ylabel('Throughput (Vehicles per Hour)');
legend({'Total Throughput', 'Target Lane Throughput', 'Merge Lane Throughput'});

clearvars -except mergeAngles mergeAngleResults

%% Create Number of Vehicles Plot
% Create figure
figure

% Get Data
vehiclesNumber = mergeAngleResults(:,17);
vehiclesNumberTarget = mergeAngleResults(:,18);
vehiclesNumberMerge = mergeAngleResults(:,19);

% Create Number of Vehicles Completed Plot
plot(mergeAngles, vehiclesNumber, '-k', mergeAngles, vehiclesNumberTarget, '-b', mergeAngles, vehiclesNumberMerge, '-r');

% Add labels
grid on;
title('Number of Vehicles Completed by Merge Angle');
xlabel('Merging Angle (degrees)');
ylabel('Number of Vehicles Completed');
legend({'Total Number of Vehicles Completed', 'Target Lane Number of Vehicles Completed', 'Merge Lane Number of Vehicles Completed'});

clearvars -except mergeAngles mergeAngleResults