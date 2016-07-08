exec('/home/achyutha/Music/PROJECT_Voice/dtw.sci', -1);
for j= 1:4
    printf("Running utt : %d \n\n\n\n",j);
    printf("Running utt : %d \n\n\n\n",j);
    printf("Running utt : %d \n\n\n\n",j);
    printf("Running utt : %d \n\n\n\n",j);
    printf("Running utt : %d \n\n\n\n",j);
    for i = 1:6
        printf("Running speaker : %d \n\n\n\n",i);
        printf("Running speaker : %d \n\n\n\n",i);
        printf("Running speaker : %d \n\n\n\n",i);
        printf("Running speaker : %d \n\n\n\n",i);
        printf("Running speaker : %d \n\n\n\n",i);
        ka(24*(j-1)+4*(i-1)+1:24*(j-1)+4*i,1:10) = speakRecog_PR_dtw(i,j);
    end
end
csvWrite(ka,'/home/achyutha/Desktop/dtw_2_PR.csv');

for i = 1:20
    rand_(i,1:13) = i;
end

for i = 1:60
    x = int(i/3);
    if x==0 then
        x=1;
    end;
    rand_2(i,1:13) = x;
end
rand_2(61:70,:) = 20;
