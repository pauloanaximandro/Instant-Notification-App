@isTest
private class LeadProcessorTest {
    @TestSetup
    static void setup(){
        List<Account> accounts = new List<Account>();        
        List<Lead> leads = new List<Lead>();

        for(Integer i = 0; i < 200; i++) {
            accounts.add(new Account(
                name='Account '+i
            ));
        }
        insert accounts;
        
        for(Account account : [SELECT Id FROM account]) {
            leads.add(new Lead(FirstName = 'Lead FName '+account.Id, LastName = 'Lead LName '+account.Id, Company = 'Lead Company '+account.Id));
        }
        insert leads;
    }

    @isTest
    static void test() {
        Test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Id batchId = Database.executeBatch(lp);
        Test.stopTest();
    }
}