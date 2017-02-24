function tutorial
%TUTORIAL An interactive tutorial to teach people how to use basic MATLAB
%functionality
%   The user just needs to execute the function and answer the questions by
%   filling in MATLAB commands. First a brief background on each topic is
%   provided, followed by a question. The function waits for input from the
%   user and checks if the answer is correct. This is done in form of
%   string comparison.
%   
%   The background, questions and possible answers are all stored in a cell
%   inside the 'tasks.mat' file. The progress for the questions is saved in
%   the 'progress.mat' file and multiple users are supported. The
%   progress.mat file is not part of the git repository so that the
%   progress is not erased when pull updates from the server.

    % Loading the matlab structure that contains the tasks for the tutorial
    load tasks.mat
    
    % Checking to see if a progress file exists. If not, then it will be
    % created later on
    if exist('progress.mat','file')
        load progress.mat
    else
        progress = struct;
    end
    
    % Getting the username, for storing progress of a student
    user = input('Please provide your username: ','s');
    users = fieldnames(progress);
    
    % Checking if the user exists. If not, then create her
    if ~ismember(user,users)
        progress.(user) = 1;
    end
    level = progress.(user);

    % Loop over all the questions
    while level<=length(tasks) %#ok<USENS> This variable is loaded from the file above
        
        fprintf('=====================================================\n\n')
        % Print the background information
        fprintf([tasks{level}{1},'\n\n\n'])
        
        fprintf('=====================================================\n\n')
        % Print the question and wait for input from the user
        answer = input(['Question ',num2str(level),'/',num2str(length(tasks)),':\n\n',tasks{level}{2},': '],'s');
        
        % Check if the input matches the possible answers registered. If
        % yes, then print a congratulatory message and update the progress.
        % If not then ask the question again
        if find(ismember(tasks{1}{3}, answer))
            fprintf('Bravo this is correct!\n\n')
            level = level+1;
            progress.(user) = level;
            save('progress.mat','progress')
        else
            fprintf('This is not a general way of doing things, maybe try again?\n')
        end
    end
    
    % When all questions are completed, then contratulate the user and
    % direct her to the github repository.
    fprintf(['Well done! You have completed all the questions!\n\nYou are now ready to dive deeper intp MATLAB and become a guru one day!\n\n',...
            'We hope you enjoyed. You can find updates on this tutorial on our github repository https://www.github.com/tassos/matlab_tutorial\n\n'])
end
