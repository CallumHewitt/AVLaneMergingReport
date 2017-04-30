%% Import data.
filename = 'aimTrafficLevelResults.csv';
delimiter = ',';
startRow = 2;

formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

aimResults = [dataArray{1:end-1}];

filename = 'queueTrafficLevelResults.csv';
delimiter = ',';
startRow = 2;

formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

queueResults = [dataArray{1:end-1}];

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Setup Parameters
% Crete X Axis
trafficRates = queueResults(:,1);

%% Average Delay Plot
% Create figure
figure

% Get Data
averageDelayAIM = aimResults(:,8);
averageTargetDelayAIM = aimResults(:,9);
averageMergeDelayAIM = aimResults(:,10);

delayStdAIM = aimResults(:,11);
targetDelayStdAIM = aimResults(:,12);
mergeDelayStdAIM = aimResults(:,13);

averageDelayQueue = queueResults(:,8);
averageTargetDelayQueue = queueResults(:,9);
averageMergeDelayQueue = queueResults(:,10);

delayStdQueue = queueResults(:,11);
targetDelayStdQueue = queueResults(:,12);
mergeDelayStdQueue = queueResults(:,13);

% Create Average Delay Plot
ax1 = subplot(3,1,1);
plot(ax1, trafficRates, averageDelayAIM, '-b', trafficRates, delayStdAIM, '--b', trafficRates, averageDelayQueue, '-r', trafficRates, delayStdQueue, '--r');

% Add labels
grid on;
title(ax1,'Average Delay by Traffic Rate');
xlabel('Traffic Rate (vehicles/hour/lane)');
ylabel('Delay (seconds)');
legend({'AIM Average Delay','AIM Standard Deviation Delay','Queue Average Delay','Queue Standard Deviation Delay'});

% Create Average Delay Target Lane Plot
ax2 = subplot(3,1,2);
plot(ax2, trafficRates, averageTargetDelayAIM, '-b', trafficRates, targetDelayStdAIM, '--b', trafficRates, averageTargetDelayQueue, '-r', trafficRates, targetDelayStdQueue, '--r');

% Add labels
grid on;
title(ax2,'Average Target Lane Delay by Traffic Rate');
xlabel('Traffic Rate (vehicles/hour/lane)');
ylabel('Delay (seconds)');
legend({'AIM Average Target Lane Delay','AIM Standard Deviation Target Lane Delay','Queue Average Target Lane Delay','Queue Standard Deviation Target Lane Delay'});

% Create Average Delay Merge Lane Plot
ax3 = subplot(3,1,3);
plot(ax3, trafficRates, averageMergeDelayAIM, '-b', trafficRates, mergeDelayStdAIM, '--b', trafficRates, averageMergeDelayQueue, '-r', trafficRates, mergeDelayStdQueue, '--r');

% Add labels
grid on;
title(ax3,'Average Merge Lane Delay by Traffic Rate');
xlabel('Traffic Rate (vehicles/hour/lane)');
ylabel('Delay (seconds)');
legend({'AIM Average Merge Lane Delay','AIM Standard Deviation Merge Lane Delay','Queue Average Merge Lane Delay','Queue Standard Deviation Merge Lane Delay'});

% Y Limits
ylim manual;
maxVal = max(max(horzcat(ax1.YLim,ax2.YLim,ax3.YLim)));
minVal = min(min(horzcat(ax1.YLim,ax2.YLim,ax3.YLim)));

ylim(ax1,[minVal maxVal]);
ylim(ax2,[minVal maxVal]);
ylim(ax3,[minVal maxVal]);

clearvars -except trafficRates aimResults queueResults

%% Create Throughput Plot
% Create figure
figure

% Get Data
throughputAIM = aimResults(:,14);
throughputTargetAIM = aimResults(:,15);
throughputMergeAIM = aimResults(:,16);

throughputQueue = queueResults(:,14);
throughputTargetQueue = queueResults(:,15);
throughputMergeQueue = queueResults(:,16);

% Transform Data
transformNumber = 3600;
throughputHourAIM = throughputAIM * transformNumber;
throughputTargetHourAIM = throughputTargetAIM * transformNumber;
throughputMergeHourAIM = throughputMergeAIM * transformNumber;

throughputHourQueue = throughputQueue * transformNumber;
throughputTargetHourQueue = throughputTargetQueue * transformNumber;
throughputMergeHourQueue = throughputMergeQueue * transformNumber;

% Create Throughput Subplot
ax1 = subplot(2,1,1);
plot(ax1, trafficRates, throughputHourAIM, '-b', trafficRates, throughputHourQueue, '-r');

% Add labels
grid on;
title('Total Throughput by Traffic Rate');
xlabel('Traffic Rate (vehicles/hour/lane)');
ylabel('Throughput (Vehicles per Hour)');
legend({'AIM Total Throughput','Queue Total Throughput'});

% Create Throughput By Lane Subplot
ax2 = subplot(2,1,2);
plot(ax2, trafficRates, throughputTargetHourAIM, '-b', trafficRates, throughputMergeHourAIM, '--b', trafficRates, throughputTargetHourQueue, '-r', trafficRates, throughputMergeHourQueue, '--r');

% Add labels
grid on;
title('Throughput per Lane by Traffic Rate');
xlabel('Traffic Rate (vehicles/hour/lane)');
ylabel('Throughput (Vehicles per Hour)');
legend({'AIM Target Lane Throughput','AIM Merge Lane Throughput','Queue Target Lane Throughput','Queue Merge Lane Throughput'});

% Y Limits
ylim manual;
maxVal = max(max(horzcat(ax1.YLim,ax2.YLim)));
minVal = min(min(horzcat(ax1.YLim,ax2.YLim)));

ylim(ax1,[minVal maxVal]);
ylim(ax2,[minVal maxVal]);

clearvars -except trafficRates aimResults queueResults

%% Create Number of Vehicles Plot
% Create figure
figure

% Get Data
vehiclesNumberAIM = aimResults(:,17);
vehiclesNumberTargetAIM = aimResults(:,18);
vehiclesNumberMergeAIM = aimResults(:,19);

vehiclesNumberQueue = queueResults(:,17);
vehiclesNumberTargetQueue = queueResults(:,18);
vehiclesNumberMergeQueue = queueResults(:,19);

% Create Number Vehicles Completed Subplot
ax1 = subplot(2,1,1);
plot(ax1, trafficRates, vehiclesNumberAIM, '-b', trafficRates, vehiclesNumberQueue, '-r');

% Add labels
grid on;
title('Total Number Vehicles Completed by Traffic Rate');
xlabel('Traffic Rate (vehicles/hour/lane)');
ylabel('Number Vehicles Completed');
legend({'AIM Total Number Vehicles Completed','Queue Total Number Vehicles Completed'});

% Create Number Vehicles Completed By Lane Subplot
ax2 = subplot(2,1,2);
plot(ax2, trafficRates, vehiclesNumberTargetAIM, '-b', trafficRates, vehiclesNumberMergeAIM, '--b', trafficRates, vehiclesNumberTargetQueue, '-r', trafficRates, vehiclesNumberMergeQueue, '--r');

% Add labels
grid on;
title('Number Vehicles Completed per Lane by Traffic Rate');
xlabel('Traffic Rate (vehicles/hour/lane)');
ylabel('Number Vehicles Completed');
legend({'AIM Target Lane Number Vehicles Completed','AIM Merge Lane Number Vehicles Completed','Queue Target Lane Number Vehicles Completed','Queue Merge Lane Number Vehicles Completed'});

% Y Limits
ylim manual;
maxVal = max(max(horzcat(ax1.YLim,ax2.YLim)));
minVal = min(min(horzcat(ax1.YLim,ax2.YLim)));

ylim(ax1,[minVal maxVal]);
ylim(ax2,[minVal maxVal]);

clearvars -except trafficRates aimResults queueResults

