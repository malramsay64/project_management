Project Management for Reproducible Science
==========================================

---

## Reproducible Science

- How do I repeat the experiment I conducted 6 months ago?
    - Which codebase?
    - Which compiler?
    - What versions of all the programs/libraries are required?
- How does someone else understand and build on my code/project?
    - How do I compile this for my system?
    - How do I install this program?
- How do I regenerate this dataset?

???

- What does reproducible science mean for us in the computational field.
- With these constraints, how do we manage a project?
- How do I manage a project with *my* requirements?

---

### Resources

- Software Carpentry [Reproducible Science with R](https://swcarpentry.github.io/r-novice-gapminder/)
- [Cookiecutter Data Science](https://drivendata.github.io/cookiecutter-data-science/#cookiecutter-data-science)
- Chodera Lab's [Computational Chemistry Cookiecutter](https://github.com/choderalab/cookiecutter-compchem)

???

- These are resources I have based much of my talk off
- Best practice guides
- Useful to specific research environments
- I have adapted to the resources we have available at USYD
    - Hopefully also more related to the work we do

- If you look at *one*, Cookiecutter Data Science is excellent

---

## GitHub for Project Management

- Idea came from the [Open Source Malaria](https://github.com/OpenSourceMalaria) Project
- [Bitbucket](https://bitbucket.org/product) and [GitLab](https://about.gitlab.com/) are alternatives

---

### Why GitHub?

- Rarely single project
    - code and simulations
- Linking between projects, issues, commits
- Issues are a TODO list
- Collaborative
    - easy to have multiple collaborators on the same project
- Students get a bunch of [free stuff](https://education.github.com/pack)
- USYD has [enterprise licence](https://informatics.sydney.edu.au/code-repository/)

???

- More than just having a project on GitHub
    - Actually using the tools
    - Project Kanban boards

- Github is where a lot of open source development occurs
    - Gives you exposure
    - Recruiters actually look at it
    - Contribute back to projects you use

---

## Project Structure

```
├── LICENSE
├── Makefile           <- Makefile with commands like `make data` or `make train`
├── README.md          <- The top-level README for developers using this project.
├── data
│   ├── processed      <- The final, canonical data sets for modeling.
│   └── simulation     <- The original, immutable simulation data.
│
├── notebooks          <- Jupyter notebooks.
│
├── logbook            <- Project logbook
│
├── reports            <- Generated analysis as markdown, HTML, PDF, LaTeX, etc.
│   └── figures        <- Generated graphics and figures to be used in reporting
│
├── environment.yml    <- The requirements file for reproducing the analysis/simulation environment
│
└── src                <- Source code for use in this project.
    ├── __init__.py    <- Makes src a Python module
    │
    └── visualization  <- Scripts to create exploratory and results oriented visualizations
        └── visualize.py
```

???

- High level overview of what I will talk about
- Adapted from the cookiecutter data science example
- This is a starting point, adapt it for *your* project

---

## Version Control

- Hopefully using Git already
    - if not check out the [Software Carpentry lessons](http://swcarpentry.github.io/git-novice/)
    - also a good tutorial at [git-scm.com](https://git-scm.com/docs/gittutorial)
    - SVN and Mercurial are legitimate alternatives

- Keeps track of state
    - Can move between states
    - See what was changed at each stage

- Atomic commits
    - Each state single change

???

- Single change
    - Implement algorithm for clustering
    - Update logbook
    - Refactor read_file into smaller functions

---

### Semantic Versioning


.center[<img height=500 src='assets/phd101212s.gif'></img>]

---

### Semantic Versioning

- Version numbers can convey information
- [A standard for versioning](https://semver.org/)
- Of form `X.Y.Z`
    - `X` -> Major
    - `Y` -> Minor
    - `Z` -> Patch

- `git tag -a v1.0.0`


???

- not not the only way to do versioning
    - I like this way the best

- Example of a paper or thesis
    - Patch -> I made some corrections / addressed some comments
    - Minor -> I wrote new paragraphs / added new figures
    - Major -> I rewrote everything
        - Or 1.0 -> I submitted my thesis

---

## Environment

- How do I set this computer up to run my simulation/analysis/...?
- Which programs (including version numbers)
- Dependencies

---

### Containerisation

- 'Perfect' description of environment
    - reproducible
    - describes everything required

- [Docker](https://www.docker.com/)
    - Standard for containerisation
    - Huge user and container base
    - Not suitable for shared environment i.e. HPC

- [Singularity](https://singularity.lbl.gov/)
    - Container for Science
    - Is actually installed on Artemis
        - `module load singularity`

---

#### Docker Example

Docker file for [lammps](https://github.com/malramsay64/lammps-docker/blob/master/Dockerfile),
the start of which is below.

```docker
FROM centos:7.2.1511

RUN yum -y update &&\
    yum -y install git make gcc-c++ wget bc python-devel zlib-devel fftw3-devel mpich-devel && \
    yum clean all

RUN git clone git://git.lammps.org/lammps-ro.git /srv/lammps &&\
    cd /srv/lammps && \
    git checkout r15407 && \
    cd src && \
    mkdir -p MAKE/MINE
```

To run the resulting container:

```bash
docker run -it malramsay/lammps
```

???

- Getting docker configured is not entirely straightforward
- Starting from nothing (base container) is hard
    - There are lots of dependencies you don't think about

---

### Conda

- Package management for [scientific computing](https://conda.io/docs/)
    - Install any software in user space
    - Supports any language
- Supports [environments](https://conda.io/docs/user-guide/tasks/manage-environments.html)
    - Can resolve incompatible dependencies
    - similar to modules
- Generate complete specification of environment
    - installs everything for your project in a single command
- Create your [own packages](https://conda.io/docs/user-guide/tasks/build-packages/index.html)

???

- Completely compatible with HPC systems
- Excellent support for both R and Python
- You can create and upload your own code

---

#### Conda Environment Specification

```yaml
name: dynamics
dependencies:
  - python=3.6
  - ipykernel
  - conda-forge::holoviews
  - malramsay::sdanalysis=0.4.8
  - malramsay::sdrun=0.4.2
  - pip:
    - experi==0.2.1
```

Installation/Update

```bash
conda env update
```

???

- Commit the file to version control
    - If you specify versions properly you have the same environment as when you initially wrote the code / ran the analysis.

---

## Data Storage

- RDS Classic
    - mount to any computer
    - run all analysis on network drive

- Entire project in a single directory
    - Raw data is not version controlled

- Cron job copying data from HPC to RDS

???

- Single source of truth
- RDS is backed up
    - More reliable than your desktop
- Storage space is unlimited
- Possible to mount RIOS as a drive, but not simple

---

### Ignoring Data in Git

- Can specify files that git will ignore
    - `.gitignore`

To ignore all data files

```
# .gitignore

# Ignore all files in data directory
data

# Don't ignore yaml files in data directory
!data/*.yml

```

???

- why not ignoring yaml files will make sense later

---

## Data Analysis

- Raw data is immutable

- [Jupyter Notebooks](https://jupyter-notebook-beginner-guide.readthedocs.io/en/latest/)
    - Use basically [any language](https://github.com/jupyter/jupyter/wiki/Jupyter-kernels)
    - Standard tool across disciplines
    - Code + logbook + results in single document
    - Web interface -> use anywhere
    - Long running calculations keep running

- For remote server: `jupyter notebook --ip=* --no-browser`

- Also [Jupyter Lab](https://blog.jupyter.org/jupyterlab-is-ready-for-users-5a6f039b8906) is awesome

???

- New files are fine
    - easier to delete extra files than regenerate simulation data
    - save everything

- Recommend setting up a server to do this
    - You can request one from ICT
    - Also Quartz
    - Or make a request as a group to the informatics hub

- Develop code and ideas quickly in notebook
    - move to script once developed
    - much easier to iterate, test things, debug issues

- GitHub will render juptyer notebooks in the browser

- Note that writing text is hard
    - you won't come back and do it later

---

### Data Analysis with Python

- [Pandas](https://pandas.pydata.org/)
    - Reading/Writing/Analysing data
- [Scipy](https://docs.scipy.org/doc/scipy-1.0.0/reference/)
    - [Spatial Data](https://docs.scipy.org/doc/scipy-1.0.0/reference/spatial.html) `scipy.spatial`
    - [Statistics](https://docs.scipy.org/doc/scipy-1.0.0/reference/tutorial/stats.html) `scipy.stats`
    - [Functions and optimization](https://docs.scipy.org/doc/scipy/reference/optimize.html) `scipy.optimize`
- [Scikit-learn](http://scikit-learn.org/stable/)
    - Classification
    - Clustering

- No point reinventing the wheel
    - Already highly optimised algorithms out there
    - Actually tested

???

- I know python really well
- R is another excellent tool for data analysis

- Pandas
    - Once beyond a single numpy array, use it

- Scipy
    - Spatial -> Voronoi, Nearest Neighbours, Convex Hulls, Distances
    - Statistics -> Correlations, Pearson
    - Optimize -> root finding, curve fitting, equation solvers

- Scikit Learn
    - Machine Learning


---

## Project Setup

- [Cookiecutter](https://cookiecutter.readthedocs.io/en/latest/)
    - Use template to create projects
    - Create your own

- Standardise projects
    - All folders have same name/structure

???

- I (or anyone else) can create a cookie cutter template based on this talk

- DEMO

```bash
cookiecutter https://github.com/drivendata/cookiecutter-data-science
```

- All this work, still haven't got to actually running an experiment yet

---

## Running an Experiment

1. Test command locally
2. Write pbs script
3. Submit job on HPC
4. Error in script, go back to 2.

???

- I hate writing pbs scripts
    - Errors typically in having multiple variables
    - 5 temperatures and 3 pressures.
- Bash loops are horrible
- Bash arrays are even worse

- I have a command or set of commands to run with different variables to insert
- Variables change, commands don't
- Express in a simple to understand format

---

### Experi

- A [python module](https://github.com/malramsay64/experi) I wrote to solve my problems

- Specify the commands and variables using yaml syntax
- Handle creation of pbs files and submission
- Re-run the same experiment months later
- Complete description of experiment in version control

???

- Project I have been working on to make running experiments easier
- You declare some stuff you want done, experi does it.
- Incomplete and there are some bugs
    - Happy for testing, ideas, help
- Rather than placing the data from the experiment in version control
    place the description of the experiment.
    - can be referenced in issues / logbook

---

#### Example 1

```yaml
command: >
    simulation
    --temperature {temperature}
    --pressure {pressure}
    --steps {steps}

variables:
    temperature:
        - 1
        - 2
        - 3
        - 4
        - 5
    pressure:
        - 1
        - 2
    steps: 1_000_000
```

???

- By defualt we have the product of all possible variables
    - This will run 10 simulations

---

#### Example 2

```yaml
command: >
  simulation
  --temperature {temperature}
  --pressure {pressure}
  --steps {steps}

variables:
  zip:
    temperature:
      - 1
      - 2
      - 3
      - 4
      - 5
    steps:
      - 1_000_000
      - 1_000_000
      - 100_000
      - 100_000
      - 10_000
  pressure:
    - 1
    - 2
```

???

- Long simulations for lower temperatures, high T just waste
- Still have 10 simulations

---

#### Example 3

```yaml
command:
  - >
    equilibration
    --temperature {temperature}
    --pressure {pressure}
    --steps {steps}
  - >
    production
    --temperature {temperature}
    --pressure {pressure}
    --steps {steps}

variables:
  zip:
    temperature: [ 1, 2, 3, 4 ]
    steps:
      - 1_000_000
      - 100_000
      - 100_000
      - 10_000
  pressure: [ 1, 2 ]
```

???

- String together commands
- Experi handles the dependencies
- Second command won't run until the first is finished

---

#### Example 4

```yaml
command:
  - >
    equilibration
    --temperature {temperature}
    --pressure {pressure}
    --steps {steps}
  - >
    production
    --temperature {temperature}
    --pressure {pressure}
    --steps {steps}

variables:
  zip:
    temperature: [ 1, 2, 3, 4 ]
    steps:
      - 1_000_000
      - 100_000
      - 100_000
      - 10_000
  pressure: [ 1, 2 ]

pbs: True
```

???

- To run as a pbs job
- This doesn't work where you need to specify a project
- Sets a 'sensible' default walltime of 1 hour

---

### Creating commands with variables

- Lammps input scripts can use [variables](http://lammps.sandia.gov/doc/variable.html)
    - pass variable using `--var` flag

- Python has [Click](http://click.pocoo.org/5/)

- C/C++ has [getopt](https://www.gnu.org/savannah-checkouts/gnu/libc/manual/html_node/Getopt.html)

???

- Far more flexible method of writing code
- Much simpler than recompiling

---

## Lab Notebooks

- Markdown files in repository
    - readable on github with formatting
    - Allows for referencing to commits, issues, notebooks
- Tied to commits
- Notebook for each project
    - Track the progress, and ideas individually

- [LabArchives](https://aushib.labarchives.com/select_institution)

???

- This is a far more personal choice 
- LabArchives is the new electronic notebooks the Honours students are using

---

## Projects in Practice

- Checkout project on each computer
- Create environment `conda env create`
- Run simulations/create new one

- Canonical Data store on RDS

- [Crystal_Melting](https://github.com/malramsay64/Crystal_Melting)
    - Opened up as a public repository
    - Not a perfect example

???

- Everything required to run the simulations is in version control

- Linking commits to issues
- Projects
- Jupyter notebooks
- Logbooks

---

## Summary

- If someone else can understand your project now, you will in 2 years
- Your code has dependencies, make them explicit
- Version Control is your friend
