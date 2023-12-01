trigger CheckPrimaryContactPhone on Contact (before update) {
    List<Contact> cttList = new List<Contact>();
    Map<Id,Contact> relatedContacts = new Map<Id,Contact>(
        [ 	SELECT Id, AccountId FROM Contact
        	WHERE Id IN : Trigger.new ]
    );
    for(Contact c : Trigger.old) {
        System.debug('Primary Contact: '+c.Primary_Contact_Phone__c);
        if(String.isBlank(c.Primary_Contact_Phone__c)) {
            cttList.add(new Contact(Id = c.Id, Primary_Contact_Phone__c=c.Primary_Contact_Phone__c));
        } else {
             Trigger.oldMap.get(c.Id).addError('Invalid Data.');
        }
    }
    if(cttList.size() > 0) {
        update cttList;
    }
}