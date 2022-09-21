[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-c66648af7eb3fe8bc4f294546bfd86ef473780cde1dea487d3c4ff354943c9ae.svg)](https://classroom.github.com/online_ide?assignment_repo_id=8587471&assignment_repo_type=AssignmentRepo)
| EAPS 591 - Numerical Modeling of Planetary Orbits | Fall 2022 | Rolfe Power |
| ----------------------------- | --------- | ------------------ |

# Module 5 - Symplectic Integrators - Code infrastructure

## Getting Started

### Setting up the Julia environment

The first step in using the code in the current repository is setting up the Julia environment.
The instructions in this section assume that a working Julia install already exists on your system.
If that is not the case, se [here](https://julialang.org/downloads/) for instructions on getting started.

Now, open up a terminal where Julia is on the path and `cd` to the current repository's directory.
Launch Julia activating the current project as
```bash
$ julia --project=.
```
This should open up the repl. 
Press the `]` key to enter `Pkg` mode and you should have a prompt like
```
(module05-prob01-03-kepler_solvers-rjpower4) pkg> 
```
where the content in parentheses should reflect the current directory's name.
Now, run `instantiate`
```
(module05-prob01-03-kepler_solvers-rjpower4) pkg> instantiate
```
The project's dependencies will be fetched if needed and precompiled.
After this is done, you can exit the repl via `Ctrl-d`.

### Running the solution script

Assuming the Julia environment has been set up, the problem 1, 2, and 3 solution script may be run from the command line as
```bash
$ julia --project=.  .\src\solution_123.jl
```
Note, if the output files already exist in the `data` directory, this will throw warnings that it is not overwriting them.
To regenerate the output files and overwrite those in the `data` directory, simply pass the `-f` flag
```bash
$ julia --project=.  .\src\solution_123.jl -f
```