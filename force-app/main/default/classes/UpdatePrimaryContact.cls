public with sharing class UpdatePrimaryContact {

    @future
    // TO DO: Have this @future method receive the list of contacts to be updated
    // WHERE AM I WITH IT? I'm calling this @future method on the trigger class AddPrimaryContactNumber. Being a static method (because it is a @future method) it doesn't accept a List<Contact> as a parameter, so I'll have to find a way to workaround that.
    public static void addPrimaryContact(List<Contact> cttList) { // this isn't working, bc @future methods don't accept List<Contact> as argument.
        
        // upsert list via database method. It's the exact same call as is being done at the trigger class AddPrimaryContactNumber
        if(cttList.size() > 0) {
            List<Database.UpsertResult> upsertion = Database.upsert(cttList, false);
            System.debug(upsertion);
        }

    }

}