public with sharing class OppAmountScheduleCaller {
    
    OppAmountScheduler scheduler = new OppAmountScheduler();
    
    // Seconds Minutes Hours Day_of_month Month Day_of_week
    String sch1 = '00 00 10 * * ?';
    String sch2 = '00 00 13 ? * 6';
    String sch3 = '00 00 18 ? * 6L';
    
    // I'm not sure if this is a good practice, but here it goes, three schedule calls on the same class
    String jobID_1 = System.schedule('Schedule Opp Amount Summary', sch1, scheduler);
    String jobID_2 = System.schedule('Schedule Opp Amount Summary', sch2, scheduler);
    String jobID_3 = System.schedule('Schedule Opp Amount Summary', sch3, scheduler);
}