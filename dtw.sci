exec('/home/achyutha/Music/PROJECT_Voice/MFCC.sce', -1);

//on the assumption that both clusters are in order
function[x,y] = dtw_dist(dig_cluster,train_cluster)
    dig_pos = 1;
    train_pos = 1;
    net_dist = 0;
    temp_dist = distance(dig_cluster(1,1:13),train_cluster(1,1:13));
    limit_dig = length(dig_cluster)/13;
    limit_train = length(train_cluster)/13;
    y(1:limit_dig,1:limit_train) = 50;
    y(1,1) = 100;
    while ~(dig_pos+1 > limit_dig) | ~(train_pos+1 > limit_train) 
        if ~(dig_pos+1 > limit_dig) & ~(train_pos+1 > limit_train) then
            d(1) = distance(dig_cluster(dig_pos+1,1:13),train_cluster(train_pos,1:13));
            d(2) = distance(dig_cluster(dig_pos+1,1:13),train_cluster(train_pos+1,1:13));
            d(3) = distance(dig_cluster(dig_pos,1:13),train_cluster(train_pos+1,1:13));

        elseif (dig_pos+1 > limit_dig) then
            d(1) = 10000000000000;
            d(2) = 10000000000000;
            d(3) = distance(dig_cluster(dig_pos,1:13),train_cluster(train_pos+1,1:13));
            
        elseif (train_pos+1 > limit_train) then
            d(1) = distance(dig_cluster(dig_pos+1,1:13),train_cluster(train_pos,1:13));
            d(2) = 10000000000000;
            d(3) = 10000000000000;
        end;
        //dtw_var is used for me to change the dig_pos and train_pos accordingly 
        [temp_dist,dtw_var] = min(d);
        //vertical
        if     dtw_var == 1 then
            dig_pos = dig_pos + 1;
        //diagonal
        elseif dtw_var == 2 then
            dig_pos = dig_pos + 1;
            train_pos = train_pos + 1;
        //horizontal
        elseif dtw_var == 3 then
            train_pos = train_pos + 1;
        end;
        net_dist = net_dist + temp_dist;
        y(dig_pos,train_pos) = 100;
    end
    x = net_dist;
    y_x = [1:1:limit_train];
    y_y = [1:1:limit_dig];
    //plot3d(y_y,y_x,y);
endfunction;


function[Digit,dist] = digitRecog_dtw(dig_mat,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9)
    d(1,1) = dtw_dist(dig_mat,y0);
    d(1,2) = dtw_dist(dig_mat,y1);
    d(1,3) = dtw_dist(dig_mat,y2);
    d(1,4) = dtw_dist(dig_mat,y3);
    d(1,5) = dtw_dist(dig_mat,y4);
    d(1,6) = dtw_dist(dig_mat,y5);
    d(1,7) = dtw_dist(dig_mat,y6);
    d(1,8) = dtw_dist(dig_mat,y7);
    d(1,9) = dtw_dist(dig_mat,y8);
    d(1,10) = dtw_dist(dig_mat,y9);
    [dist,Digit] = min(d);
    Digit =Digit-1;
endfunction;

//c_m is cluster no. matrix
function[x] = detectOrder_dtw(s,c_m,k_value)
    count = 0;
    temp_count = 1;
    temp = 0;
    f_c_m = 0;
    while (count ~= k_value)
        temp = c_m(temp_count);
        if( length(find(f_c_m==temp)) == 0) then
            count = count+1;
            f_c_m(count) = c_m(temp_count);
        end;
        temp_count= temp_count+1;
    end;
    for i = 1:k_value
        x(i,1:13) = s(f_c_m(i),1:13);
    end;
endfunction;

function[x] = speakRecog_sep_dtw(speaker_no,k_value)
    [x_0_1,x_0_2,x_0_3,x_0_4,x_1_1,x_1_2,x_1_3,x_1_4,x_2_1,x_2_2,x_2_3,x_2_4,x_3_1,x_3_2,x_3_3,x_3_4,x_4_1,x_4_2,x_4_3,x_4_4,x_5_1,x_5_2,x_5_3,x_5_4,x_6_1,x_6_2,x_6_3,x_6_4,x_7_1,x_7_2,x_7_3,x_7_4,x_8_1,x_8_2,x_8_3,x_8_4,x_9_1,x_9_2,x_9_3,x_9_4] = template_sep(speaker_no);
    [y0,y1,y2,y3,y4,y5,y6,y7,y8,y9] = database_vect(speaker_no);

    [model,y] = nan_kmeans(y0,k_value);
    y0 = detectOrder_dtw(model.X,y,k_value);
    
    [model,y] = nan_kmeans(y1,k_value);
    y1 = detectOrder_dtw(model.X,y,k_value);
    
    [model,y] = nan_kmeans(y2,k_value);
    y2 = detectOrder_dtw(model.X,y,k_value);
    
    [model,y] = nan_kmeans(y3,k_value);
    y3 = detectOrder_dtw(model.X,y,k_value);
    
    [model,y] = nan_kmeans(y4,k_value);
    y4 = detectOrder_dtw(model.X,y,k_value);
    
    [model,y] = nan_kmeans(y5,k_value);
    y5 = detectOrder_dtw(model.X,y,k_value);
    
    [model,y] = nan_kmeans(y6,k_value);
    y6 = detectOrder_dtw(model.X,y,k_value);
    
    [model,y] = nan_kmeans(y7,k_value);
    y7 = detectOrder_dtw(model.X,y,k_value);
    
    [model,y] = nan_kmeans(y8,k_value);
    y8 = detectOrder_dtw(model.X,y,k_value);
    
    [model,y] = nan_kmeans(y9,k_value);
    y9 = detectOrder_dtw(model.X,y,k_value);
    
    printf("1st time\n");
    
    printf("0 processing\n");x(1,1) = digitRecog_dtw(x_0_1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("1 processing\n");x(1,2) = digitRecog_dtw(x_1_1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("2 processing\n");x(1,3) = digitRecog_dtw(x_2_1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("3 processing\n");x(1,4) = digitRecog_dtw(x_3_1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("4 processing\n");x(1,5) = digitRecog_dtw(x_4_1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("5 processing\n");x(1,6) = digitRecog_dtw(x_5_1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("6 processing\n");x(1,7) = digitRecog_dtw(x_6_1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("7 processing\n");x(1,8) = digitRecog_dtw(x_7_1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("8 processing\n");x(1,9) = digitRecog_dtw(x_8_1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("9 processing\n");x(1,10) = digitRecog_dtw(x_9_1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    
    printf("2st time\n");
    
    printf("0 processing\n");x(2,1) = digitRecog_dtw(x_0_2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("1 processing\n");x(2,2) = digitRecog_dtw(x_1_2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("2 processing\n");x(2,3) = digitRecog_dtw(x_2_2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("3 processing\n");x(2,4) = digitRecog_dtw(x_3_2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("4 processing\n");x(2,5) = digitRecog_dtw(x_4_2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("5 processing\n");x(2,6) = digitRecog_dtw(x_5_2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("6 processing\n");x(2,7) = digitRecog_dtw(x_6_2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("7 processing\n");x(2,8) = digitRecog_dtw(x_7_2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("8 processing\n");x(2,9) = digitRecog_dtw(x_8_2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("9 processing\n");x(2,10) = digitRecog_dtw(x_9_2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    
    printf("3st time\n");
    printf("0 processing\n");x(3,1) = digitRecog_dtw(x_0_3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("1 processing\n");x(3,2) = digitRecog_dtw(x_1_3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("2 processing\n");x(3,3) = digitRecog_dtw(x_2_3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("3 processing\n");x(3,4) = digitRecog_dtw(x_3_3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("4 processing\n");x(3,5) = digitRecog_dtw(x_4_3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("5 processing\n");x(3,6) = digitRecog_dtw(x_5_3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("6 processing\n");x(3,7) = digitRecog_dtw(x_6_3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("7 processing\n");x(3,8) = digitRecog_dtw(x_7_3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("8 processing\n");x(3,9) = digitRecog_dtw(x_8_3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("9 processing\n");x(3,10) = digitRecog_dtw(x_9_3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    
    printf("4st time\n");
    printf("0 processing\n");x(4,1) = digitRecog_dtw(x_0_4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("1 processing\n");x(4,2) = digitRecog_dtw(x_1_4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("2 processing\n");x(4,3) = digitRecog_dtw(x_2_4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("3 processing\n");x(4,4) = digitRecog_dtw(x_3_4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("4 processing\n");x(4,5) = digitRecog_dtw(x_4_4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("5 processing\n");x(4,6) = digitRecog_dtw(x_5_4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("6 processing\n");x(4,7) = digitRecog_dtw(x_6_4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("7 processing\n");x(4,8) = digitRecog_dtw(x_7_4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("8 processing\n");x(4,9) = digitRecog_dtw(x_8_4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("9 processing\n");x(4,10) = digitRecog_dtw(x_9_4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    
endfunction;

function[x1_0,x1_1,x1_2,x1_3,x1_4,x1_5,x1_6,x1_7,x1_8,x1_9] = database_PR_dtw(speaker_no,utterance)
    a = ascii('/home/achyutha/Music/PROJECT_Voice/Files/Recordings/SpeakerX/dis_XXX.wav');
    a(60) = speaker_no+48;
    a(66) = int((utterance+1)/2)+48;
    
    digit = 0;
    a(67) = int((modulo(utterance-1,2) + digit*2)/10) +48;
    a(68) = modulo((modulo(utterance-1,2) + digit*2),10)+48;
    s = loadwave(ascii(a));
    x1_0 = mfcc(s);
    
    digit = 1;
    a(67) = int((modulo(utterance-1,2) + digit*2)/10) +48;
    a(68) = modulo((modulo(utterance-1,2) + digit*2),10)+48;
    s = loadwave(ascii(a));
    x1_1 = mfcc(s);
    
    digit = 2;
    a(67) = int((modulo(utterance-1,2) + digit*2)/10) +48;
    a(68) = modulo((modulo(utterance-1,2) + digit*2),10)+48;
    s = loadwave(ascii(a));
    x1_2 = mfcc(s);
    
    digit = 3;
    a(67) = int((modulo(utterance-1,2) + digit*2)/10) +48;
    a(68) = modulo((modulo(utterance-1,2) + digit*2),10)+48;
    s = loadwave(ascii(a));
    x1_3 = mfcc(s);
    
    digit = 4;
    a(67) = int((modulo(utterance-1,2) + digit*2)/10) +48;
    a(68) = modulo((modulo(utterance-1,2) + digit*2),10)+48;
    s = loadwave(ascii(a));
    x1_4 = mfcc(s);
    
    digit = 5;
    a(67) = int((modulo(utterance-1,2) + digit*2)/10) +48;
    a(68) = modulo((modulo(utterance-1,2) + digit*2),10)+48;
    s = loadwave(ascii(a));
    x1_5 = mfcc(s);
    
    digit = 6;
    a(67) = int((modulo(utterance-1,2) + digit*2)/10) +48;
    a(68) = modulo((modulo(utterance-1,2) + digit*2),10)+48;
    s = loadwave(ascii(a));
    x1_6 = mfcc(s);
    
    digit = 7;
    a(67) = int((modulo(utterance-1,2) + digit*2)/10) +48;
    a(68) = modulo((modulo(utterance-1,2) + digit*2),10)+48;
    s = loadwave(ascii(a));
    x1_7 = mfcc(s);
    
    digit = 8;
    a(67) = int((modulo(utterance-1,2) + digit*2)/10) +48;
    a(68) = modulo((modulo(utterance-1,2) + digit*2),10)+48;
    s = loadwave(ascii(a));
    x1_8 = mfcc(s);
    
    digit = 9;
    a(67) = int((modulo(utterance-1,2) + digit*2)/10) +48;
    a(68) = modulo((modulo(utterance-1,2) + digit*2),10)+48;
    s = loadwave(ascii(a));
    x1_9 = mfcc(s);

endfunction;

function[x] = speakRecog_PR_dtw(speaker_no,utterance)
    count = 1;
    for i = 1:6
        if(i ~= speaker_no) then
            db(count) = i;
            count = count+1;
        end;
    end
    printf("speaker no %d processing\n",db(1));
    [x1_0,x1_1,x1_2,x1_3,x1_4,x1_5,x1_6,x1_7,x1_8,x1_9] = database_PR_dtw(db(1),utterance);
    printf("speaker no %d processing\n",db(2));
    [x2_0,x2_1,x2_2,x2_3,x2_4,x2_5,x2_6,x2_7,x2_8,x2_9] = database_PR_dtw(db(2),utterance);
    printf("speaker no %d processing\n",db(3));
    [x3_0,x3_1,x3_2,x3_3,x3_4,x3_5,x3_6,x3_7,x3_8,x3_9] = database_PR_dtw(db(3),utterance);
    printf("speaker no %d processing\n",db(4));
    [x4_0,x4_1,x4_2,x4_3,x4_4,x4_5,x4_6,x4_7,x4_8,x4_9] = database_PR_dtw(db(4),utterance);
    printf("speaker no %d processing\n",db(5));
    [x5_0,x5_1,x5_2,x5_3,x5_4,x5_5,x5_6,x5_7,x5_8,x5_9] = database_PR_dtw(db(5),utterance);

    a = ascii('/home/achyutha/Music/PROJECT_Voice/Files/Recordings/SpeakerX/dis_XXX.wav');
    a(60) = speaker_no+48;
    for temp_utterance = 1:4
        printf("temp_utterance = %d \n\n\n\n\n",temp_utterance);
        a(66) = int((temp_utterance+1)/2)+48;
        for digit_temp = 0:9;
            printf("digit_temp = %d \n",digit_temp);
            a(67) = int((modulo(temp_utterance-1,2) + digit_temp*2)/10) +48;
            a(68) = modulo((modulo(temp_utterance-1,2) + digit_temp*2),10)+48;
            s = loadwave(ascii(a));
            dig_mat = mfcc(s);
            [dig(1),d(1)]= digitRecog_dtw(dig_mat,x1_0,x1_1,x1_2,x1_3,x1_4,x1_5,x1_6,x1_7,x1_8,x1_9);
            [dig(2),d(2)]= digitRecog_dtw(dig_mat,x2_0,x2_1,x2_2,x2_3,x2_4,x2_5,x2_6,x2_7,x2_8,x2_9);
            [dig(3),d(3)]= digitRecog_dtw(dig_mat,x3_0,x3_1,x3_2,x3_3,x3_4,x3_5,x3_6,x3_7,x3_8,x3_9);
            [dig(4),d(4)]= digitRecog_dtw(dig_mat,x4_0,x4_1,x4_2,x4_3,x4_4,x4_5,x4_6,x4_7,x4_8,x4_9);
            [dig(5),d(5)]= digitRecog_dtw(dig_mat,x5_0,x5_1,x5_2,x5_3,x5_4,x5_5,x5_6,x5_7,x5_8,x5_9);
            [d_min,pos] = min(d);
            x(temp_utterance,digit_temp+1) =dig(pos);
        end;
    end
endfunction;
