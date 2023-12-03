trigger AddPrimaryContactNumber on Contact (before insert, after update) {
    
    //will get contacts' accountId
    Set<Id> accountIds = new Set<Id>();
    for(Contact c : trigger.new) {
        if(c.AccountId != null) {
            accountIds.add(c.AccountId);
        }
    }

    Map<Id,Account> mappedAccounts = new Map<Id,Account>([SELECT Id, (SELECT id, Primary_Contact_Phone__c, Is_Primary_Contact__c from Contacts) FROM Account WHERE Id IN : accountIds]);

    if(Trigger.isBefore && Trigger.isInsert) {
        for(Contact c : Trigger.new) {
            if(c.AccountId != null && mappedAccounts.containsKey(c.AccountId)) {
                for(Contact innerC : mappedAccounts.get(c.AccountId).Contacts) {
                    if(innerC.Is_Primary_Contact__c == true) {
                        c.addError('A primary contact number is already set.');
                    }
                }
            }
        }
    }

    // add Primary Contact Phone to related contacts
    if(Trigger.isAfter && Trigger.isUpdate) {
        List<Contact> cttList = new List<Contact>(); //list of contacts to be updated
        for(contact c : Trigger.new) {
            if(c.Is_Primary_Contact__c == true && c.Is_Primary_Contact__c != Trigger.oldMap.get(c.Id).Is_Primary_Contact__c && mappedAccounts.containsKey(c.AccountId)) {
                for(Contact innerC : mappedAccounts.get(c.AccountId).Contacts) {
                    innerC.Primary_Contact_Phone__c = c.Primary_Contact_Phone__c;
                    cttList.add(innerC);
                }
            }
        }

        System.debug('cttList content: '+cttList);
        
        // upsert list via database method
        if(cttList.size() > 0) {
            List<Database.SaveResult> updating = Database.update(cttList, false);
            System.debug(updating);
        }

        // TO DO: call another class to upsert list asynchronously
        // WHERE AM I WITH IT? I'm calling a @future method of the class UpdatePrimaryContact. Being a static method (because it is a @future method) it doesn't accept a List<Contact> as a parameter, so I'll have to find a way to workaround that.
        
        // UpdatePrimaryContact doUpdateExternally = new UpdatePrimaryContact();
        // doUpdateExternally.addPrimaryContact(cttList); // NOT WORKING YET
    }
}