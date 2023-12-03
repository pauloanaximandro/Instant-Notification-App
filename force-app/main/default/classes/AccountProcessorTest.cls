@isTest
public class AccountProcessorTest {

    @testSetup 
    static void setupAccount(){
        List<Account> accounts = RandomAccountContactFactory.generateRandomAccounts(1);
        insert accounts;
        List<Contact> contacts = RandomAccountContactFactory.generateRandomContacts(3, 'TestAP' , accounts.get(0).id);
        insert contacts;
    }

	 @isTest
     static void testAccountProcessor(){
     List<id> accIds = new List<id>();

		for(Account a : [select id from Account]){
            accIds.add(a.id);
        }

         Test.startTest();
         AccountProcessor.countContacts(accIds);
         Test.stopTest();
     }
}