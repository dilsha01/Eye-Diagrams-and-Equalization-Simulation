%% Task 3

bit_rate =10 ; 
bit_duration = 1/bit_rate ;

time = 0:bit_duration:100000;
data_bits = randi([0 1],1,numel(time));

PAM2_data = real(pskmod(data_bits,2)); % 2-PAM modulation bit 1 -> +1 and bit 0 ->


% 3-tap multipath channel with impulse response h
h = [0.3 0.7 0.4] ;
rt = conv(PAM2_data,h,"same");

%Bit energy
Eb = sum(PAM2_data.^2)/length(PAM2_data) ; 

% creating Zero forcing equalizer (M - tap equalizer)... h(t)* E(t)=delta(t) ,where h(t)is the  channel impulse response and E(t) is the equalizer
Eb_No_dB = 0:10 ; % dB

for M=3:2:9
    N = (M-1)/2 ;
    Po = zeros(1,M);
    Po(N+1) = 1;
    Pr = toeplitz([h(2) h(1) zeros(1,M-2)],[h(2) h(3) zeros(1,M-2)]) ; % Toeplitz matrix with filter coeffients
    C = Pr\Po' ;

    BER_ISI = zeros(1,11);

    for n=1:numel(Eb_No_dB)

        Eb_No = 10^(Eb_No_dB(n)/10);
        No    = Eb/Eb_No ;
        sigma = sqrt(No/2);

        %signal after adding noise
        rtn_ISI = rt + sigma*randn(1,numel(rt));

        rtn_e                  = conv(rtn_ISI,C,"same"); % Signal after the equalizer
        received_data_bits_ISI = real(pskdemod(rtn_e,2));

        bit_errors_ISI=numel(find(received_data_bits_ISI-data_bits)); % calculating number of bit errors

        BER_ISI(n)=bit_errors_ISI/numel(data_bits); % calculating bit error rate


    end
    
    semilogy(Eb_No_dB,BER_ISI,'linewidth',1);
    grid on;
    hold on;


end

% plotting BER for a AWGN channel in the same figure
BER_AWGN= zeros(1,11);

for n=1:numel(Eb_No_dB)

    Eb_No = 10^(Eb_No_dB(n)/10);
    No = Eb/Eb_No ;
    sigma = sqrt(No/2);

    %signal after adding noise
    rtn_awgn =PAM2_data + sigma*randn(1,numel(PAM2_data));
    received_data_bits_awgn = real(pskdemod(rtn_awgn,2));

    bit_errors_AWGN=numel(find(received_data_bits_awgn-data_bits)); % calculating number of bit errors

    BER_AWGN(n)=bit_errors_AWGN/numel(data_bits); % calculating bit error rate


end

semilogy(Eb_No_dB,BER_AWGN,'linewidth',1);
legend("3-tap","5-tap","7-tap","9-tap","AWGN channel");
title("BER performance");
xlabel("Eb / No");
ylabel("BER");