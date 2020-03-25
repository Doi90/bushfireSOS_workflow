# bushfireSOS_workflow

This repository contains all of the species-specific workflow scripts for the bushfire analysis.

## Instructions for analysts

Hereafter, "analyst" refers to anyone putting a species-specific workflow together.

For each species you choose/are assigned to work on you should follow these steps:
- Find the GitHub issue for the appropriate species; a skeleton workflow template will already be in place for each species. 
- Leave a comment stating that you are going to work on that species so we don't accidentally double up. The person who created the issue will update the workflow template with your name.
- Remove the `unassigned` label and add the `in progress` label for that issue.
- Create a new branch on your local version of the repository entitled "Species Name". This can be done either with RStudio's point and click interface or through the command line with `git branch <Species_Name>_pb` (without the brackets).
- Create a workflow script file for this species. Copy the `scripts/workflow_template/workflow_template.R` file and make a duplicate at `scripts/workflows/<species_name>_workflow.R` (without the brackets).
- Commit the file to your new branch.
- When you have successfully obtained the data required for the workflow tick the `Obtained data` checkbox in the issue.
- When you have completed the presence-background workflow push your changes up to GitHub and submit a pull request to merge your `<Species_Name>_pb` branch into the `master` branch. At this stage the assigned code reviewer will assess the workflow before merging the changes themselves and ticking the `Workflow reviewed by Reviewer (code)` checkbox.
- The outputs of the workflow now need to be assessed by the output reviewer (map verification). Once the outputs have been satisfactorily assessed by the output reviewer we can consider the presence bacground workflow complete. Tick the `Fit presence background model workflow` and `Output reviewed by Reviewer (output)`, and `Workflow complete` checkboxes. Assign the `complete (PB)` label to the issue.
- Delete the now no longer required branch using `git branch -d <Species_Name>_pb`.
- If presence absence data becomes available the workflow can be updated to use the additional data at a later date. If appropriate we can add the `complete (PA)` and `complete (Hy)` labels.
- If you run in to problems fitting the workflow to a particular species for any reason then leave a comment on the GitHub issue outlining the problem, tag the code reviewer (e.g. @Doi90) and anyone else appropriate, and add the `help wanted` label to the issue.