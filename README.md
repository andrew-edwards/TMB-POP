# TMB-POP
Template Model Builder Code for Pacific Ocean Perch

## Background

This is initially the TMB and R code that William Aeberhard wrote (as a contract) to run our Pacific Ocean Perch model for the west coast of Vancouver Island [available here](http://www.dfo-mpo.gc.ca/Csas-sccs/publications/resdocs-docrech/2013/2013_093-eng.pdf). 

Initially this is to easily share with fellow Pacific participants of the TMB course in Halifax, lest they go their own way and spend time starting from scratch. I ran this code on Friday in the workshop and it worked fine and was very fast. It will be a good starting point for future assessments.

I haven't had time to check it, test it, or think about it in detail. But that can happen soon now that we understand TMB.

An ideal plan would be something like

1. Test and understand the code.
1. Compare to previous results.
1. If satisfied then this could be used for the next POP assessment, or in conjunction with exiting (Awatea) code. Using the TMB code for a full assessment will initially require a lot of setting up of directories and structure and writing code for figures and tables, but we can utilise the structures that Chris developed for hake and then herring, and have code we can adapt for the figures and tables.
1. Maybe there should be a knitr file that plots results for a single model run (for quick understanding, and checking of convergence etc.), and also an assessment file that builds the assessment (with sensitivities and bridging analyses as necessary).

Thinking and discussing this stuff before starting will help a lot. 

If you want to add to this repository please **fork** (on GitHub) and then **clone** to your machine.

## Directory structure

**POP-code/orig-code/** the original code from William - do not edit this code (so that we always have the original version available). Includes his original ```.zip``` file.

**POP-code/extend-code/** the original code from William to be edited and tested as necessary.
