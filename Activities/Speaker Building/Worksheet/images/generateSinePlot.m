clear all, clf;
close all, clc;

fs = 44100;
f0 = 440;

tt = 0:1/fs:0.005;

xx = sin(2*pi*f0*tt);

plotSize = [14 3.5];

figure()
plot(tt, xx, 'LineWidth', 2);
ylim([-1.1 1.1]), grid on;
xlabel('Time ->'), ylabel('Current');
set(gcf, 'PaperSize', plotSize);
set(gcf, 'PaperPosition', [0 0 plotSize]);
set(gca, 'XTickLabel', '');
print(gcf, '-dpdf', 'sine.pdf');