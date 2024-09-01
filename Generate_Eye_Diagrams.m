%% Task 1 & 2

%% Impulse train representing BPSK symbols


bit_rate           = 10; 
bit_duration       = 1/bit_rate; 
sampling_frequency = bit_duration/10; 

endtime = 10;
time    = 0:sampling_frequency:endtime;

BPSK_symbols = zeros(size(time));

% BPSK modulation
for i=1:bit_duration/sampling_frequency:numel(BPSK_symbols) 
    BPSK_symbols(i) = 2*randi([0 1])-1;
end

Eb_No_dB = 10 ; % 10dB
Eb_No = 10^ (Eb_No_dB/10) ; % converting SNR per bit into linear range

figure;
stem(time,BPSK_symbols);
hold on;



%% Sinc pulse shaping filter

timefor_sinc = -endtime:sampling_frequency:endtime;

sinc_filter          = sinc(timefor_sinc/bit_duration);
transmit_signal_sinc = conv(sinc_filter,BPSK_symbols,"same") ;

Eb_transmit_signal_sinc = bandpower(transmit_signal_sinc)/bit_rate ; % Eb = P (signal power )/R ( symbol or bit rate )
No_transmit_signal_sinc = Eb_transmit_signal_sinc / Eb_No ; % power spectraldensity of the transmit signal
sigma_transmit_signal_sinc = sqrt(No_transmit_signal_sinc/2); % noise variance

plot(timefor_sinc+endtime/2,transmit_signal_sinc);
grid on;
title("Sinc pulse shaping without noise");
xlabel("time");
ylabel("Magnitude");
legend("BPSK symbols","Transmit signal");

% Generating noise

sinc_with_noise                 = sigma_transmit_signal_sinc * randn(1,numel(transmit_signal_sinc));
transmit_sinc_signal_with_noise = transmit_signal_sinc+sinc_with_noise ;


% plotting the signal after adding noise 
figure
plot(timefor_sinc+endtime/2 , transmit_sinc_signal_with_noise);
title("Sinc pulse shaping with noise");
xlabel("time");
ylabel("Magnitude");
grid on;

%% Eye diagrams for sinc pulse shaping

% plotting the eye diagram without noise
eyediagram(transmit_signal_sinc,bit_duration/sampling_frequency,bit_duration);
title("Eye diagram for sinc pulse shaping without noise");

% plotting the eye diagram with noise
eyediagram(transmit_sinc_signal_with_noise,bit_duration/sampling_frequency,bit_duration);
title("Eye diagram for sinc pulse shaping with noise");


%% Raised cosine filters

% Roll off factor = 0.5
r1 = 0.5 ; 
raised_cosine_1 = rcosdesign(r1,(numel(timefor_sinc)-1)/(bit_duration/sampling_frequency),bit_duration/sampling_frequency); 

transmit_signal_rcosine1=conv(raised_cosine_1,BPSK_symbols,"same");

figure
stem(time,BPSK_symbols);
hold on;
plot(timefor_sinc+endtime/2,transmit_signal_rcosine1);
legend("BPSK symbols" , "Transmit signal");
title("Raised cosine pulse shaping without noise ( Roll-off = 0.5 )");
xlabel("time");
ylabel("Magnitude");
grid on;

% Generating noise
Eb_transmit_signal_rcosine_1    = bandpower(transmit_signal_rcosine1)/bit_rate ;
No_transmit_signal_rcosine_1    = Eb_transmit_signal_rcosine_1 / Eb_No ;
sigma_transmit_signal_rcosine_1 = sqrt(No_transmit_signal_rcosine_1/2);

noise_for_rcosine1 = sigma_transmit_signal_rcosine_1 * randn(1,numel(transmit_signal_rcosine1));
transmit_rcosine1_signal_afternoise = transmit_signal_rcosine1+noise_for_rcosine1 ;


% plotting the signal after adding noise ;
figure
plot(timefor_sinc+endtime/2 , transmit_rcosine1_signal_afternoise);
title("Raised cosine pulse shaping with noise ( Roll-off = 0.5 )");
xlabel("time");
ylabel("Magnitude");
grid on;

eyediagram(transmit_signal_rcosine1,bit_duration/sampling_frequency,bit_duration);
title("Eye diagram for raised cosine pulse shaping without noise( roll-off = 0.5)");

eyediagram(transmit_rcosine1_signal_afternoise,bit_duration/sampling_frequency,bit_duration);
title("Eye diagram for raised cosine pulse shaping with noise( roll-off = 0.5)");



% Roll off factor = 1 
r2 = 1; 
raised_cosine_2 = rcosdesign(r2,(numel(timefor_sinc)-1)/(bit_duration/sampling_frequency),bit_duration/sampling_frequency);

transmit_signal_rcosine_2=conv(raised_cosine_2,BPSK_symbols,"same");

figure
stem(time,BPSK_symbols);
hold on;
plot(timefor_sinc+endtime/2,transmit_signal_rcosine_2);
legend("BPSK symbols" , "Transmit signal");
title("Raised cosine pulse shaping without noise ( Roll-off = 1 )");
xlabel("time");
ylabel("Magnitude");
grid on;


% Generating noise
Eb_transmit_signal_rcosine_2 = bandpower(transmit_signal_rcosine_2)/bit_rate ;
No_transmit_signal_rcosine_2 = Eb_transmit_signal_rcosine_2 / Eb_No ;
sigma_transmit_signal_rcosine_2 = sqrt(No_transmit_signal_rcosine_2/2);

noise_for_rcosine_2 = sigma_transmit_signal_rcosine_2 * randn(1,numel(transmit_signal_rcosine_2));
transmit_rcosine_2_signal_afternoise = transmit_signal_rcosine_2+noise_for_rcosine_2 ;

% plotting the signal after adding noise ;

figure
plot(timefor_sinc+endtime/2 , transmit_rcosine_2_signal_afternoise);
title("Raised cosine pulse shaping with noise ( Roll-off = 1 )");
xlabel("time");
ylabel("Magnitude");
grid on;

eyediagram(transmit_signal_rcosine_2,bit_duration/sampling_frequency,bit_duration);
title("Eye diagram for raised cosine pulse shaping without noise( roll-off = 1)");

eyediagram(transmit_rcosine_2_signal_afternoise,bit_duration/sampling_frequency,bit_duration);
title("Eye diagram for raised cosine pulse shaping with noise( roll-off = 1)");