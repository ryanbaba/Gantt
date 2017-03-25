public class GanttChartv2_Ctrl {
    
    public GanttChartv2_Ctrl(){
        
    }
    
    @RemoteAction
    public static projectInfo getProjectInfo(Id projectId){
        
        
        system.debug('projectId '+projectId);
        projectInfo info = new projectInfo();
        List<data> tasks = new List<data>();
        
        for(CM_Project__c proj : [Select Id,Name,Duration__c,Kickoff__c,DeadLine__c,
                                  (Select Id,Name,start_date__c,end_date__c,Task_Stage__c,Assigned_To__c,Predecessor_Task__c,Task_Progress__c from Tasks__r) 
                                  from CM_Project__c where Id =:projectId])
        {
            
            data pk = new data();
            pk.id = proj.Id;
            pk.text = proj.Name;
            pk.start_date = proj.Kickoff__c.day()+'-'+proj.Kickoff__c.month()+'-'+proj.Kickoff__c.year();
            pk.end_date = proj.DeadLine__c.day()+'-'+proj.DeadLine__c.month()+'-'+proj.DeadLine__c.year(); 
            pk.duration = String.valueOf(proj.Duration__c);                    
            pk.open = true;
            
            system.debug('start_date '+pk.start_date);                               
            
            tasks.add(pk);                         
            
            //Get the Task-Details                          
            for(CM_Task__c task : proj.Tasks__r){
                
                data tk = new data();

                tk.staus = task.Task_Stage__c;
                tk.id = task.Id;
                tk.text = task.Name;
				tk.progress = task.Task_Progress__c!=null?task.Task_Progress__c/100 :null;
                if(task.Predecessor_Task__c != null){
                    tk.parent = task.Predecessor_Task__c;
                }else{
                    tk.parent = proj.Id;
                }
                tk.assignedTo = task.Assigned_To__c!=null?string.valueOf(task.Assigned_To__c):null;
                tk.status = task.Task_Stage__c;
                tk.start_date = task.start_date__c;
                tk.end_date = task.end_date__c;
                tk.open = true;
                tasks.add(tk);
            }            
        }
        //Get the Link Details
        List<link> links = new List<link>();
        
        info.data = tasks;
        info.link = links;
        
        system.debug(info);
        return info;
    }
    
    @RemoteAction
    public static List<Contact> getContacts(){
        return [Select Id,Name from Contact limit 10];
    }
    
    @RemoteAction
    public static Id upsertTask(String projectId, data newData,Boolean isNew){
        Id taskId = null;
        system.debug('newData '+newData);
        
        CM_Task__c newTask = new CM_Task__c();
        
        Id parentId = (Id)newData.parent;
        
        String parentObj = parentId.getSObjectType().getDescribe().getName();
        system.debug('parentObj '+parentObj);
        
        if(parentObj == 'CM_Task__c'){
            newTask.Predecessor_Task__c = parentId;
        }

        if(!isNew){
            system.debug('isNew '+isNew+newData.id);
            newTask.Id = newData.id;           
        }else{
            newTask.ProjectName__c = projectId; 
        }
       
        newTask.Name = newData.text;
        newTask.Start_Dates__c = Date.parse(newData.start_date);
       
        newTask.Task_Stage__c = newData.status;
        newTask.Due_Date__c = Date.parse(newData.end_date);
        newTask.Assigned_To__c = newData.users[0];
        
        system.debug('newTask '+newTask);
        upsert newTask;
        
        return newTask.Id;
    }
    
     @RemoteAction
    public static Boolean deleteTask(String taskId){
        Delete [Select Id from CM_Task__c where id =: taskId];
        return true;
    }
    
    @RemoteAction
    public static Id udpateTask(updateTask task){
        
        CM_Task__c upTask = new CM_Task__c();
        upTask.id = task.id;
        upTask.Start_Dates__c = Date.parse(task.start_date);
        upTask.Due_Date__c = Date.parse(task.end_date);
       
        update upTask;
        return upTask.id;
    }
    //Task_Progress__c
	
    @RemoteAction
    public static Id udpateProgressTask(String taskId, Decimal progress){
        
        CM_Task__c upTask = new CM_Task__c();
        upTask.id = taskId;
        upTask.Task_Progress__c = progress*100;
        update upTask;
        
        return upTask.id;
    }
    
    public class updateTask{
        public string id;
        public string start_date;
        public string end_date;
    }
    
    
    public class projectInfo{
        public List<data> data;
        public List<link> link;
    }
    
    public class data{
        public string id;
        public string text;
        public string start_date;
        public string end_date;
        public string duration;
        public string status;
        public string parent;
        public string assignedTo;
        public string staus;
        public Decimal progress;
        public Boolean open;
        public String[] users;
        public String priority;
    }
    
    public class link{
        public string id;
        public string source;
        public string target;
        public string type;
    }
    
}