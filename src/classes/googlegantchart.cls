global with sharing class googlegantchart {
 
    public String taskList { get; set; }
    
    
    
    @RemoteAction
    global static CM_Task__c[] loadrecords() {
    String Id = ApexPages.currentPage().getParameters().get('id');
    return [Select id,Name,Start_Dates__c,Due_Date__c,Task_Stage__c,Task_Completion__c,Task_Duration__c From CM_Task__c];
    }
}