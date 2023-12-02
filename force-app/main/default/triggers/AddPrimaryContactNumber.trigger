trigger AddPrimaryContactNumber on Contact (before insert, before update) {

    List<Contact> cttList = new List<Contact>();

    //Get related contacts
    List<Contact> accountContacts = new List<Contact>(
        [SELECT AccountId, Primary_Contact_Phone__c FROM Contact WHERE Id IN : Trigger.new]
    );

    // Map<Id,Contact> accountContacts = new Map<Id, Contact>(
    //     [SELECT AccountId, Primary_Contact_Phone__c FROM Contact WHERE Id IN : Trigger.new]
    // );

    System.debug(accountContacts);

    //Add Primary Contact Phone number to every related account
    for(Contact cc : accountContacts) {
        cttList.add(new Contact(
            Id = cc.Id,
            AccountId = cc.AccountId,
            Primary_Contact_Phone__c = cc.Primary_Contact_Phone__c
        ));
    }

    //Update contacts (OBS.: Validation for primary contact number already set is done on platform using validation rules)
    if(cttList.size() > 0) {
        Database.upsert(cttList, false);
    }
}