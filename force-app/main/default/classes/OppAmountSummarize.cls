public with sharing class OppAmountSummarize implements Database.Batchable<sObject>, Database.Stateful {

    // querying Accounts and its Opportunities
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, (SELECT Id, Status FROM Opportunity) FROM Account '
        );
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {

        for(Account a : scope) {
            // for every account, reset the sum of the stages' amounts
            Double closedWonAmount = 0;
            Double openAmount = 0;
            Double closedLostAmount = 0;
            for(Opportunity oppo : a.opportunities) {
                if(oppo.StageName == 'Closed Won') {
                    closedWonAmount += oppo.Amount;
                } else if(oppo.StageName == 'Open') {
                    openAmount += oppo.Amount;
                } else if(oppo.StageName == 'Closed Lost') {
                    closedLostAmount += oppo.Amount;
                }

                // I thought better to stringify the e-mail body right here instead of doing that inside the .setHtmlBody call over there below
                String htmlBody = '<p>Below is a table of opportunities related to the account: '+a.Name+'.</p> <table><thead> <th>Account</th> <th>Stage</th> <th>Amount</th> <tbody> <tr> <td>'+a.Name+'</td> <td>Closed Won</td> <td>'+closedWonAmount+'</td> </tr> <tr> <td>'+a.Name+'</td> <td>Open</td> <td>'+openAmount+'</td> </tr> <tr> <td>'+a.Name+'</td> <td>Closed Lost</td> <td>'+closedLostAmount+'</td> </tr> </tbody></table>';

                List<String>emails = new List<String>();
                emails.add(a.Account_Email__c); // I created a custom field for the e-mail

                Messaging.reserveSingleEmailCapacity(2);
                Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();

                mymail.setToAddresses(emails);
                mymail.setSubject('Opportunity Amounts');
                mymail.setHtmlBody(htmlBody);

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mymail });
            }
        }

    }

    public void finish(Database.BatchableContext bc) {
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
        JobItemsProcessed,
        TotalJobItems, CreatedBy.Email
        FROM AsyncApexJob
        WHERE Id = :bc.getJobId()];
    }
}