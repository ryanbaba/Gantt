public class ganttChart {
  
  public CM_Project__c thisProject;
  public List<CM_Task__c> milestones;
  
  public String projectId;

  public ganttChart(ApexPages.Standardcontroller std)
  {
    projectId = std.getId();
    
    thisProject = [select Id, Kickoff__c, DeadLine__c from CM_Project__c where Id = :projectId];
    
    milestones = [Select id,text__c,Name,Start_Dates__c,Due_Date__c,Task_Stage__c,Overall_Status__c From CM_Task__c Where ProjectName__c=:projectId];
    
  }
  
  public String getMilestoneData()
  {
    String milestoneData = '';
    Integer counter = 0;
    
    String draftData = '';
    String activeData = '';
    String completeData = '';
    String cancelData = '';
    String holdData = '';
    
    for (CM_Task__c m : milestones)
    {
      counter++;
      Integer daysBetween = 2*m.Start_Dates__c.daysBetween(m.Due_Date__c);

      if(m.Overall_Status__c== 'Open')
      {
        draftData += daysBetween;
        activeData += '0';
        completeData += '0';
        cancelData += '0';
        holdData += '0';
      }      
      else if(m.Overall_Status__c== 'Open None')
      {
        draftData += '0';
        activeData += daysBetween;
        completeData += '0';
        cancelData += '0';
        holdData += '0';
      }
      else if(m.Overall_Status__c== 'Complete')
      {
        draftData += '0';
        activeData += '0';
        completeData += daysBetween;
        cancelData += '0';
        holdData += '0';
      }
      else if(m.Overall_Status__c== 'Late')
      {
        draftData += '0';
        activeData += '0';
        completeData += '0';
        cancelData += daysBetween;
        holdData += '0';
      }
      else if(m.Overall_Status__c== 'Blocked__c ')
      {
        draftData += '0';
        activeData += '0';
        completeData += '0';
        cancelData += '0';
        holdData += daysBetween;
      }
      
      if(counter != milestones.size())
      {
          draftData += ',';
          activeData += ',';
          completeData += ',';
          cancelData += ',';
          holdData += ',';
      }
    }
    
    milestoneData = draftData + '|' + activeData + '|' + completeData + '|' + cancelData + '|' + holdData;
    
    return milestoneData;
  }
  
  public String getWhiteData()
  {
    String whiteData = '';
    Integer counter = 0;
    
    for (CM_Task__c m : milestones)
    {
      counter++;
      Integer whiteSpace = 2*thisProject.Kickoff__c.daysBetween(m.Start_Dates__c);
      whiteData += whitespace;
      
      if(counter != milestones.size())
      {
        whiteData += ',';
      }
    }
    
    return whiteData;
  }

  public String getProjectDateRange()
  {
    String dateString = '|';
    Integer projectDays = thisProject.Kickoff__c.daysBetween(thisProject.DeadLine__c );
    Integer interval = projectDays / 10;
    
    Date tempDate = thisProject.Kickoff__c;
    
    for(Integer x = 1; x <= 10; x++)
    {
      dateString += tempDate.month() + '/' + tempDate.day() + '|';
      tempDate = tempDate.addDays(interval);
    }
    
    dateString += thisProject.DeadLine__c.month() + '/' + thisProject.DeadLine__c.day() + '|';
    
    return dateString;
  }
  
  public String getMilestoneNames()
  {
    String milestoneNames = '|';
    
    for(Integer back = milestones.size() - 1; back >= 0; back--)
    {
      milestoneNames += milestones.get(back).Name + '|';  
    }
    
    return milestoneNames;
  }
}