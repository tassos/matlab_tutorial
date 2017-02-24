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
    load messages.mat
    gong = load('gong');
    handel = load('handel');
    
    % Checking to see if a progress file exists. If not, then it will be
    % created later on
    if exist('progress.mat','file')
        load progress.mat
    else
        progress = struct;
    end
    
    % Getting the username, for storing progress of a student
    user = input('Please provide your username (no numbers please): ','s');
    users = fieldnames(progress);
    sound(gong.y,gong.Fs)
    
    % Checking if the user exists. If not, then create her
    if ~ismember(user,users)
        progress.(user) = 1;
    end
    level = progress.(user);
    repeat = 0;

    % Loop over all the questions
    while level<=length(tasks) %#ok<USENS> This variable is loaded from the file above
        if ~repeat
            fprintf('=====================================================\n\n')
            % Print the background information
            fprintf([tasks{level}.background,'\n\n'])
            fprintf('=====================================================\n')
        end
        
        % Providing the option to go back one question and practise
        % again
        fprintf('Type ''previous'' for going one question back\n\n')

        % Print the question and wait for input from the user
        answer = input(['Question ',num2str(level),'/',num2str(length(tasks)),':\n\n',tasks{level}.question,': '],'s');
        
        % Going back a level, if the user wants to
        if strcmp(answer,'previous')
            level = max(level-1,1);
            continue
        end
        
        % Pre-evaluation events, in case some workspace preparation is
        % needed
        for command=tasks{level}.preeval
            eval([command{:},';'])
        end
        
        
        switch tasks{level}.type
            case 'string'
                % Check if the input matches the possible answers registered. If
                % yes, then print a congratulatory message and update the progress.
                % If not then ask the question again
                correct = find(ismember(tasks{level}.evaluation, answer));
            case 'evaluation'
                % Do several evaluations to check if the code is behaving
                % the way it should. The evaluations should all give a 1 if
                % they are successful or 0 if they are not. If a 0 is
                % generated the evaluation sequence is stopping.
                correct = 1;
                command = 1;
                try
                    eval([answer,';']);
                catch
                    correct = 0;
                end
                while (command<=length(tasks{level}.evaluation) && correct>0)
                    correct = eval(tasks{level}.evaluation{command})*correct;
                    command = command+1;
                end
        end
        
        if correct
            fprintf([congrats{randperm(numel(congrats),1)},'\n\nPress enter to continue\n\n']) %#ok<USENS> Loaded at the beginning of the function
            % Post-evaluation events, in case some cleaning-up is required
            for command=tasks{level}.posteval
                eval([command{:},';'])
            end
            level = level+1;
            progress.(user) = level;
            save('progress.mat','progress')
            repeat = 0;
            pause
        else
            fprintf([retry{randperm(numel(retry),1)},'\n\n']) %#ok<USENS> Loaded at the beginning of the function
            repeat = 1;
        end
    end
    
    % When all questions are completed, then contratulate the user and
    % direct her to the github repository.
    sound(handel.y,handel.Fs)
    fprintf(['\n\nWell done! You have completed all the questions!\nYou are now ready to dive deeper into MATLAB and become a guru one day!\n',...
            'We hope you enjoyed. You can find updates of this tutorial on our github repository https://www.github.com/tassos/matlab_tutorial\n\n'])
end
