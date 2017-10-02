## Interactive MATLAB tutorial

An interactive environment, working inside MATLAB, to teach basic concepts and syntax of MATLAB to students.

## Prerequisites

MATLAB 2015 (haven't tested it with older versions, but it should work)

[YAMLMatlab library](https://code.google.com/archive/p/yamlmatlab/)

## Project overview

This project aims to create an interactive environment that allows users to learn by trying different MATLAB commands. The idea is to make this extensible in order to allow the easy introduction of additional exercises.

The main problem with such an interactive environment is the way to verify whether the user input is correct or not. Therefore, the idea is to allow for different types of evaluation of the user input, depending on the type of exercise.

Furthermore, as this tutorial can be extended, it is sane to have a way to save progress for a user, so that (s)he does not have to repeat all the exercises every time it is executed.

## Usage

In order to start the tutorial, simply run the function 'tutorial' in your MATLAB command line.

## Preparing exercises

The main way to introduce new exercises, is by extending the 'tasks.yml' file. Each element of the yaml file corresponds to a new exercise, and the exercises are displayed in the order they are defined. The structure of each exercise is the following:

Question1:
  * background: Here comes the background that is displayed before the question
  * question: Here you can add the question
  * type: (string|commands) (more details on this later)
  * evaluation: [an array of correct answers, or commands to be evaluated]
  * preeval: [an array of commands to be executed before the evaluation]
  * posteval: [an array of commands to be executed after the evaluation]

### Background

What is inserted here will be displayed before the exercise, so that the student can learn something. You can insert pre-formated text (with multiple line breaks), by using the pipe character (|) on the first line and indenting all the rest

### Question

This is the text that will appear as a question to the user

### Type

This defines the way the answer will be evaluated. Currently there are two methods supported. String evaluation, and commands evaluation.

#### String evaluation

If the string evaluation is used for a specific exercise, the user input is compared against the strings contained in the 'evaluation' array. This is a string comparison, and if a hit is found, the evaluation is successful and the user input is considered correct

#### Commands evaluation

A series of commands are executed to verify that the user answered the question correctly. The commands are defined in the 'evaluation' array and are executed serially. Each command is expected to provide a '1' as an answer if it is successful or a '0' if it fails. If one of the commands fail, then the answer to the question is considered wrong.

### Evaluation

An array which contains either strings of correct answers, or a series of commands to be executed and evaluate whether the user solved the problem correctly.

### Preeval

An array of commands to be executed prior to the evaluation. This is useful in case some data structures or variables need to be prepared before evaluating the answer.

### Posteval

An array of commands to be executed after the evaluation. This is useful in case some clean-up is required in order to avoid conflicts with future exercises.

## Preparing the tasks database

The tutorial is reading the tasks from the 'tasks.mat' structure. However, since it is difficult to create it manually, the structure can be generated from the corresponding tasks.yml file. To do that, simply execute the generate_tasks.m script. Make sure you install the [prerequisites](#prerequisites) of the project!

## Contact

If you have questions or ideas, contact [Tassos Natsakis](https://www.natsakis.com).

## Contributors

Many thanks to [Zoltan Nagy](https://github.com/zoltan21) for contributing with questions and feedback!
