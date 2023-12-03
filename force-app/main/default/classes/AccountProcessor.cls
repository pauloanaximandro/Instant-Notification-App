public class AccountProcessor {
    @future
    public static void countContacts(List<Id> accountIds) {
        Map<Id,List<Contact>> accContacts = new Map<Id,List<Contact>>();
        List<Account> accsForUpdate = new List<Account>();
        if(accountIds != null){
            For(Account acc : [SELECT id,(SELECT id,Name FROM Contacts)FROM Account where id in: accountIds]){
                  accContacts.put(acc.Id,acc.contacts);
             }
            
            for(Id key : accContacts.keySet()){
                Account a = New Account(id = key);
                a.Number_of_Contacts__c = accContacts.get(key).size();
                accsForUpdate.add(a);
            }

            update accsForUpdate;
        }
    }
}