function position_mat = run_single_model_video(N, W, delta_t, tau, iter_num, activation_func, noise_vector, s_in)
    %This function runs a single ring attractor model, and gives as output
    %the mean placement of the neuron activation. 
    if nargin < 8
        s_in = 2000 * exp(-((1:N) - N / 2).^2);  %default origin state s_in
        s_in = s_in.';
        
    end
    if nargin < 7
        noise_vector = zeros([1,N]); % repmat(some_noise,[1,N]) default noise vector
    end
    
    %b = repmat(0,[1,N]);

    % initialization

    s = s_in;

    position_mat = zeros([iter_num,N]);
    sum_activation = zeros([1,iter_num]);

    for i = 1:iter_num
        
        g = W*s;% + b;
        rate = activation_func(g);
        spike_vector = poissrnd(delta_t * rate);
        s = (1 - delta_t / tau) * s + spike_vector;% + noise_vector.';  % activation_func(g) = spike_vector
        % # noise_vector = np.array(list(map(int, np.random.uniform(size=N) < delta_t * noise_rate_vector)))
        position_mat(i,:) = s;
        bump_activation(i) = find_average_bump_location(s);
        
    end
    figure('Name','all activation');
    image(position_mat);
    colorbar
    figure('Name','average_msd');
    msd = (bump_activation - bump_activation(1)).^2;
    plot(msd);
    
%     for i = 1:N
%         figure(1)  
%         imshow(position_mat(i))
%         hold on
%         plot(X,Y,'o')
%         plot(X0,Y0,'o')
%         plot(X1,Y1,'o')
%         plot(X2,Y2,'o')
%         plot(X3,Y3,'o')
%         hold off
%         F(i) = getframe(gcf) ;
%         drawnow
%     end
%     % create the video writer with 1 fps
%     writerObj = VideoWriter('myVideo.avi');
%     writerObj.FrameRate = 10;
%     % set the seconds per image
%     % open the video writer
%     open(writerObj);
%     % write the frames to the video
%     for i=1:length(F)
%         % convert the image to a frame
%         frame = F(i) ;    
%         writeVideo(writerObj, frame);
%     end
%     % close the writer object
%     close(writerObj);

end