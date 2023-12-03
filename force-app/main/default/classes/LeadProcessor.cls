public class LeadProcessor implements Database.Batchable<SObject>, Database.Stateful {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, LeadSource FROM Lead'
        );
    }

    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        List<Lead> dreamforceLeads = new List<Lead>();
        for(Lead l : scope) {
            l.LeadSource = 'Dreamforce';
            dreamforceLeads.add(l);
        }
        update dreamforceLeads;
    }

    public void finish(Database.BatchableContext bc) {
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
        JobItemsProcessed,
        TotalJobItems, CreatedBy.Email
        FROM AsyncApexJob
        WHERE Id = :bc.getJobId()];
    }
}