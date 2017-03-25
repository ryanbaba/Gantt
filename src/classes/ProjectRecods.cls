public with sharing class ProjectRecods {

    public String str1 {get;set;}
    public String str2 {get;set;}
    Public String str4 {get;set;}
    public String scaleUnit{get;set;}
    public String id;
    public ProjectRecods (){
         
          id = ApexPages.currentPage().getParameters().get('id');
          setScaleUnit();   
          
          List<CM_Task__c> taskList= [Select id,text__c,Name,start_date__c,end_date__c,Task_Stage__c,Assigned_To__r.Name,color__c,progress__c From CM_Task__c Where ProjectName__c=:id];
          String str1  = JSON.serialize(taskList);
          str2  = str1.remove('__c');
          str4 = '{"data":'+str2+','+'"links":[{"id":"10","source":"11","target":"1","type":"1"}]}';
         
       
      }    
      
      Public PageReference  retProject(){
      
          PageReference pageRef = new PageReference('/'+id);
          pageRef.setRedirect(true);

          return pageRef ;
      
      }
      
      public void setScaleUnit(){
          
          CM_Project__c proj = [select id,Duration__c from CM_Project__c where id=:id];
         
          if(proj.Duration__c==1){
              scaleUnit  ='day'; 
          }else if(proj.Duration__c>1 && proj.Duration__c<=7){
              scaleUnit  ='week'; 
          }else if(proj.Duration__c>7 && proj.Duration__c<=31){
              scaleUnit  ='month'; 
          }else if(proj.Duration__c>31 && proj.Duration__c<=90){
              scaleUnit  ='quarter'; 
          }else if(proj.Duration__c>90 && proj.Duration__c<=366){
              scaleUnit  ='year'; 
          }
      }
    
    }