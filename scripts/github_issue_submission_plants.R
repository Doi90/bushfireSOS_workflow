df <- openxlsx::read.xlsx("bushfireResponse_documents/interim-priority-list-plants_DB.xlsx",
                          sheet = 1)

df$State <- toupper(df$State)

for(i in seq_len(nrow(df))){
        
        species <- df$taxon[i]
        
        region <- df$State[i]
        
        issue_title <- sprintf("%s workflow",
                               species)
        
        issue_body <- sprintf("**Workflow details**

Species: %s
Region: %s
Analyst:
Reviewer (code): 
Reviewer (output):

**Progress**

- [ ] Obtained data
- [ ] Fit presence background model workflow
- [ ] (Optional) Fit presence absence model workflow
- [ ] (Optional) Fit hybrid model workflow
- [ ] Workflow reviewed by Reviewer (code)
- [ ] Output reviewed by Reviewer (output)
- [ ] Workflow complete",
                              species,
                              region)
        
        command <- sprintf('gh issue create --title "%s" --body "%s" --label unassigned',
                           issue_title,
                           issue_body)
        
        system(command)
        
}



