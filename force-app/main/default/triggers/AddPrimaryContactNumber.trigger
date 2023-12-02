trigger AddPrimaryContactNumber on Contact (before insert, before update) {

    List<Contact> cttList = new List<Contact>(); //list of contacts to be updated
    Set<Id> accountIds = new Set<Id>(); //will get contacts' accountId
    Contact triggerStarterContact = [SELECT Id, Primary_Contact_Phone__c FROM Contact WHERE Id IN : Trigger.new];
    cttList.add(triggerStarterContact); //
    String primaryContactPhone = triggerStarterContact.Primary_Contact_Phone__c; //Primary Contact Phone field value

    //Get Account Id
    for(Contact c : Trigger.new) {
        if(c.AccountId != null) {
            accountIds.add(c.AccountId);
        }
    }

    //Get related contacts
    List<Contact>accountContacts = [SELECT Id, AccountId FROM Contact WHERE AccountId IN : accountIds];

    //Add Primary Contact Phone number to every related account
    for(Contact cc : accountContacts) {
        if(cc.Id != triggerStarterContact.Id) {
            cttList.add(new Contact(
            Id = cc.Id,
            AccountId = cc.AccountId,
            Primary_Contact_Phone__c = primaryContactPhone
            ));
        }
    }

    //Update contacts (OBS.: Validation for primary contact number already set via platform using validation rules)
    if(cttList.size() > 0) {
        List<Database.UpsertResult> result = Database.upsert(cttList, false);
        System.debug(result);
    }
}