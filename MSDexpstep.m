clear 
clc
% Connect to serial port
s = serial('COM4', 'BaudRate', 9600);
fopen(s);
pause(3);
fprintf("Connection established\n")

% Start a counter and timer
count = 0;
data = 0;
tic
startTimer = toc;

% Get data for 5 seconds
time = 0;
plotTitle = 'Arduino Data Log';
xLabel = 'Tiempo (seg)';
yLabel = 'Theta';
legend1 = 'Sensor 1';
yMax  = 5 ;
yMin  = 0 ;
plotGrid = 'on';
min = 0;
max = 5;
delay = .01;

%Set up Plot
plotGraph = plot(time,data,'-r' );
title(plotTitle,'FontSize',15);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
legend(legend1)
axis([yMin yMax min max]);
grid(plotGrid);
tic


theta=0:.3:2*pi;
k=1;
data=[];


while (toc < startTimer+5)
  fprintf(s, theta(k));
  k=k+1;
  out = fscanf(s, '%f\n');
  fprintf("%d\n",out)
  count = count + 1;
  data(count) = out;
  time(count) = toc;
  set(plotGraph,'XData',time,'YData',data);
  axis([0 time(count) min max]);
  if k==length(theta)
      k=1;
  end
  pause(delay);
end
endTimer = toc;
frequency=count/(endTimer - startTimer);

t=0:1/frequency:endTimer;

ylabel('x(t)'); xlabel('t (s)');
grid on
m=1; kx=0.2; b=1;
G=tf([1],[m,b,kx]);
t=0:0.0311:5;
w=2*pi/0.65;
F=ones(1,length(t));
y = lsim(G,F,t);
hold
plot(t,y,'b','LineWidth',2)
