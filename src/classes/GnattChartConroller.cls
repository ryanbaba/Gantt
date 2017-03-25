public with sharing class GnattChartConroller {

    public String mytarget {get; 
        set{
            this.mytarget = value;
            init();
        }
    }
    
    public String objectType {get;set;}
    public String startDateFieldName {get;set;}
    public String endDateFieldName {get;set;}
    public String idFieldName {get;set;}
    public String fullViewURL {get;set;}
    public String projectGanttJson{get;set;}
 
    private String nameFieldName;
    private String completedFieldName;
    private String filterFieldName;
    
    
    private List<CM_Task__c> TaskList;
    private static final String REGEXP_QUOTES    = '(?<!\\\\)"';
    
    public static final String COLOR_COMPLETE = '#333333';
    public static final String COLOR_LATE = '#ee3322';
    public static final String COLOR_FUTURE = '#666666';
    public static final String COLOR_CURRENT = '#2299bb';
    
    public GnattChartConroller()
    {
        init();
    }
    
    private void init()
    {
        if (myTarget != null)
        {
         retrieveData();
         projectGanttJson = toJSon();
        
        }
    }
    
    public String getProjectGanttJson() {
        
        init();
        return projectGanttJson;
    }
    
    /*
    *   Retrieve the data doing a dynamic query by object type.
    */
    private void retrieveData(){
        
        TaskList = [Select id ,Name,Task_Stage__c,Complete__c From CM_Task__c Where ProjectName__c=:mytarget];
    system.debug('current.TaskList+++'+TaskList);    
    }
    
    /**
    *   Generate the output in json format to be rendered in the jquery gantt.
    */
    private String toJSon(){
        
        String ret = 'var ganttData' +mytarget + ' = [{id: 1, name: "", series: [';
        Boolean addComma=false,completed;
        Date startDate,endDate;
        String name,id;
        for (CM_Task__c current : TaskList){ 
    system.debug('current.Start_Dates__c+++'+current.Start_Dates__c);    
            
            if(current.Start_Dates__c == null){
                startDate = Date.today();
            }else{
                startDate = Date.valueOf(current.Start_Dates__c);
            }
            if(current.Due_Date__c == null){
                endDate = startDate;
            }else{
                endDate = current.Due_Date__c;
            }
            completed = current.Complete__c;
            name = current.name;
            id = current.Id;
            if (addComma) { ret += ','; }
            
            String color=COLOR_CURRENT;
            
            if (completed) {
                color=COLOR_COMPLETE;
            } else if (endDate < Date.today()) {
                color=COLOR_LATE;
            } else if (startDate > Date.today()) {
                color=COLOR_FUTURE;
            }
            
            ret +=  '{'+
                    'id:"'+id+'",'+ 
                    'name: "'+name+'",'+
                    'start: new Date(' +startDate.year() +',' + (startDate.month()-1) +',' + startDate.day() +'),'+
                    'end: new Date(' +endDate.year() +',' + (endDate.month()-1) + ',' + endDate.day() +'), ' +
                    'color: "' + color + '"'+
                    '}';
                    
            addComma=true;
            
        }
        
        ret+=']}];';
        return ret;     
    }
    
    private String escapeDoubleQuotes(String word){
        return word.replaceAll(REGEXP_QUOTES,'\\\\"');
    }
}