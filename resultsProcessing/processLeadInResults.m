%% Import data.
filename = 'leadInResults.csv';
delimiter = ',';
startRow = 2;

formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

leadInResults = [dataArray{1:end-1}];

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Setup Parameters
% Create X Axis
mergeLaneDistances = leadInResults(:,1);
targetLaneDistance = leadInResults(:,2);

xAxis = cell(1, length(mergeLaneDistances));
for pairIndex = 1:length(mergeLaneDistances)
    xAxis{pairIndex} = strcat(num2str(mergeLaneDistances(pairIndex)),'/',num2str(targetLaneDistance(pairIndex)));
end

% Colours
colour1 = [0.2 0.2 0.5];
colour2 = [0 0.7 0.7];

clearvars pairIndex

%% Create Mean Delays Bar Charts
% Create Figure
figure

% Get Data
meanDelay = leadInResults(:,9);
meanTargetDelay = leadInResults(:,10);
meanMergeDelay = leadInResults(:,11);

delayStd = leadInResults(:,12);
targetDelayStd = leadInResults(:,13);
mergeDelayStd = leadInResults(:,14);

% Create Mean Delay Plot
ax1 = subplot(3,1,1);

% Add bars
bar(ax1, categorical(xAxis), meanDelay, 0.5, 'FaceColor',colour1);
hold on;
bar(ax1, categorical(xAxis), delayStd, 0.25, 'FaceColor',colour2);
hold off;

% Add labels
grid on;
title(ax1,'Mean Delay by Lead In Distances');
xlabel('Lead in Distance (Merge Lane / Target Lane)');
ylabel('Delay (seconds)');
legend({'Mean Delay','Standard Deviation Delay'});

% Create Mean Target Delay Plot
ax2 = subplot(3,1,2);

% Add bars
bar(ax2, categorical(xAxis), meanMergeDelay, 0.5, 'FaceColor',colour1);
hold on;
bar(ax2, categorical(xAxis), mergeDelayStd, 0.25, 'FaceColor',colour2);
hold off;

% Add labels
grid on;
title(ax2,'Mean Delay for Merge Lane by Lead In Distances');
xlabel('Lead in Distance (Merge Lane / Target Lane)');
ylabel('Delay (seconds)');
legend({'Mean Merge Lane Delay','Standard Deviation Merge Lane Delay'});

% Create Mean Merge Delay Plot
ax3 = subplot(3,1,3);

% Add bars
bar(ax3, categorical(xAxis), meanTargetDelay, 0.5, 'FaceColor',colour1);
hold on;
bar(ax3, categorical(xAxis), targetDelayStd, 0.25, 'FaceColor',colour2);
hold off;

% Add labels
grid on;
title(ax3,'Mean Delay for Target Lane by Lead In Distances');
xlabel('Lead in Distance (Merge Lane / Target Lane (m))');
ylabel('Delay (seconds)');
legend({'Mean Target Lane Delay','Standard Deviation Target Lane Delay'});

% Y limits
ylim manual;
maxVal = max(max(horzcat(ax1.YLim,ax2.YLim,ax3.YLim)));
minVal = min(min(horzcat(ax1.YLim,ax2.YLim,ax3.YLim)));

ylim(ax1,[minVal maxVal]);
ylim(ax2,[minVal maxVal]);
ylim(ax3,[minVal maxVal]);

clearvars -except xAxis mergeLaneDistances leadInResults targetLaneDistances colour1 colour2

%% Create Throughput Bar Charts
% Create Figure
figure

% Get Data
throughputTarget = leadInResults(:,16);
throughputMerge = leadInResults(:,17);

% Transform Data
transformNumber = 3600;
throughputTargetHour = throughputTarget * transformNumber;
throughputMergeHour = throughputMerge * transformNumber;

% Add bars
vehiclesNumberChart = bar(categorical(xAxis), horzcat(throughputTargetHour, throughputMergeHour), 'stacked');
vehiclesNumberChart(1).FaceColor = colour1;
vehiclesNumberChart(2).FaceColor = colour2;

% Add labels
grid on;
title('Throughput by Lead In Distance');
xlabel('Lead in Distance (Merge Lane / Target Lane (m))');
ylabel('Throughput (Vehicles per Hour)');
legend({'Target Lane Throughput','Merge Lane Throughput'});

clearvars -except xAxis mergeLaneDistances leadInResults targetLaneDistances colour1 colour2

%% Create Number of Vehicles Bar Charts
% Create Figure
figure

% Get Data
vehiclesNumberTarget = leadInResults(:,19);
vehiclesNumberMerge = leadInResults(:,20);

% Add bars
vehiclesNumberChart = bar(categorical(xAxis), horzcat(vehiclesNumberTarget, vehiclesNumberMerge), 'stacked');
vehiclesNumberChart(1).FaceColor = colour1;
vehiclesNumberChart(2).FaceColor = colour2;

% Add labels
grid on;
title('Number of Vehicles Completed by Lead In Distance');
xlabel('Lead in Distance (Merge Lane / Target Lane (m))');
ylabel('Number of Vehicles Completed');
legend({'Target Vehicles Complete','Merge Vehicles Complete'});

clearvars -except mergeLaneDistances leadInResults targetLaneDistances