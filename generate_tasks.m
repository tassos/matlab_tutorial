function generate_tasks
%GENERATE_TASKS Generate the tasks database
%   It is much easier to define the tasks and all the required information
%   in a YAML file, but a YAML file is much easier read by the students.
%   That's why it can be useful to convert the YAML file into a matlab
%   structure. If a student can browse through the matlab structure, then
%   she probably aleady knows MATLAB and does not need this tutorial.
%
%   Prerequisites: YAMLMatlab library, that can be found here:
%   https://code.google.com/archive/p/yamlmatlab/

if ~exist('tasks.yml','file')
    tasks = ReadYaml(uiopen);
else
    tasks = ReadYaml('tasks.yml');
end

save('tasks.mat','tasks');
end
