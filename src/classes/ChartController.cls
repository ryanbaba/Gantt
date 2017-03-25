public class ChartController {
    
    public Integer BudgetedHours{get;set;}
    public Integer estimatedHours{get;set;}
      
    public ChartController(){
        
        BudgetedHours = 0;
        estimatedHours = 0;

		CM_Project__c projectValue = [SELECT Total_Hours_Budget__c,Project_Balance_Hours__c,Task_Estimated_Hours__c from CM_Project__c limit 1];
		BudgetedHours = Integer.valueOf(projectValue.Total_Hours_Budget__c);
		estimatedHours = Integer.valueOf(projectValue.Task_Estimated_Hours__c);
    }
}