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
    
    % Getting a list of questions
    questions = fieldnames(tasks);
    
    % Checking if the user exists. If not, then create her
    if ~ismember(user,users)
        progress.(user) = 1;
    end
    level = progress.(user);
    repeat = 0;
    
    % Loop over all the questions
    while level<=length(questions)
        task = tasks.(questions{level});
        if ~repeat
            fprintf('Background:\n=====================================================\n\n')
            % Print the background information
            fprintf([task.background,'\n'])
            fprintf('=====================================================\n\n')
        end
        
        % Providing the option to go back one question and practise
        % again
        fprintf('Type ''previous'' for going one question back, ''background'' for reading the background again, or exit to leave the tutorial\n\n')

        % Print the question and wait for input from the user
        answer = input(['Question ',num2str(level),'/',num2str(length(questions)),':\n\n',task.question,': '],'s');
        
        % Going back a level, if the user wants to
        switch answer
            case 'previous'
                level = max(level-1,1);
                continue
            case 'exit'
                return
            case 'background'
                repeat = 0;
                continue
        end
        
        % Pre-evaluation events, in case some workspace preparation is
        % needed
        for command=task.preeval
            try
                eval([command{:},';'])
            catch e
                fprintf(2,'MATLAB error message:\n%s \n',e.message);
                fname=e.stack.name; 
                if ~(strcmp(fname,'tutorial')==1)
                    l=e.stack.line;
                    fprintf(2,'Error in %s.m file, at line %d\n',fname, l);
                end
            end
        end
        
        switch task.type
            case 'string'
                % Check if the input matches the possible answers registered. If
                % yes, then print a congratulatory message and update the progress.
                % If not then ask the question again
                correct = find(ismember(task.evaluation, answer));
            case 'commands'
                % Do several evaluations to check if the code is behaving
                % the way it should. The evaluations should all give a 1 if
                % they are successful or 0 if they are not. If a 0 is
                % generated the evaluation sequence is stopping.
                correct = 1;
                command = 1;
                try
                    eval(answer)
                catch e
                    fprintf(2,'MATLAB error message:\n%s \n',e.message);
                    fname=e.stack.name;
                    if ~(strcmp(fname,'tutorial')==1)
                        l=e.stack.line;
                        fprintf(2,'Error in %s.m file, at line %d\n',fname, l);
                    end
                    correct = 0;
                end
                while (command<=length(task.evaluation) && correct>0)
                    try
                        correct = eval(task.evaluation{command})*correct;
                        command = command+1;
                    catch e
                        fprintf(2,'MATLAB error message:\n%s \n',e.message);
                        fname=e.stack.name; 
                        if ~(strcmp(fname,'tutorial')==1)
                            l=e.stack.line;
                            fprintf(2,'Error in %s.m file, at line %d\n',fname, l);
                        end
                        correct = 0;
                        break
                    end
                end
        end
        
        % Post-evaluation events, in case some cleaning-up is required
        for command=task.posteval
            try
                eval([command{:},';'])
            catch e
                fprintf(2,'MATLAB error message:\n%s \n',e.message);
                fname=e.stack.name; 
                if ~(strcmp(fname,'tutorial')==1)
                    l=e.stack.line;
                    fprintf(2,'Error in %s.m file, at line %d\n',fname, l);
                end  
            end
        end
        
        if all(correct)
            cmessage = randperm(numel(congrats)); %#ok<USENS> Loaded at the beginning of the function
            fprintf([congrats{cmessage(1)},'\n\nPress enter to continue\n\n'])
            level = level+1;
            progress.(user) = level;
            save('progress.mat','progress')
            repeat = 0;
            pause
        else
            rmessage = randperm(numel(retry)); %#ok<USENS> Loaded at the beginning of the function
            fprintf([retry{rmessage(1)},'\n\n'])
            repeat = 1;
        end
    end
    
    % When all questions are completed, then congratulate the user and
    % direct her to the github repository.
    sound(handel.y,handel.Fs)
    fprintf(['\n\nWell done! You have completed all the questions!\nYou are now ready to dive deeper into MATLAB and become a guru one day!\n',...
            'We hope you enjoyed. You can find updates of this tutorial on our github repository https://www.github.com/tassos/matlab_tutorial\n\n'])
end