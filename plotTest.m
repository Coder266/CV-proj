cd = [ 60 60 60 0.2 0.25 0.30 0.35 0.40 0.45 51 ];
md = [ 27 26 26 0.2 0.25 0.30 0.35 0.40 0.45 2 ];
fa = [ 4  4  4  0.2 0.25 0.30 0.35 0.40 0.45 16 ];
df = [ 2  2  3  0.2 0.25 0.30 0.35 0.40 0.45 25 ];
ma = [ 47 47 47 0.2 0.25 0.30 0.35 0.40 0.45 47 ];


import array.*

t = 0.05 : 0.05 : 0.5;
%


figure(1)
plot(t, match_area_vec);
title('Success Plot') 
xlabel 'Threshold'; 
ylabel '%';

% figure(1)
% subplot(5,1,1) 
% plot(t, ma);
% title('Match Area') 
% xlabel 'Threshold'; 
% ylabel '%';
% 
% subplot(5,1,2) 
% plot(t, cd); 
% title('Correct Detections') 
% xlabel 'Threshold'; 
% ylabel '%'; 
% 
% subplot(5,1,3) 
% plot(t, md); 
% title('Merge Detections') 
% xlabel 'Threshold'; 
% ylabel '%';
% 
% subplot(5,1,4) 
% plot(t, fa); 
% title('False Alarms') 
% xlabel 'Threshold'; 
% ylabel '%';
% 
% subplot(5,1,5) 
% plot(t, df); 
% title('Detection Failures') 
% xlabel 'Threshold'; 
% ylabel '%';