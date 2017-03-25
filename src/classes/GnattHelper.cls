public with sharing class GnattHelper {

	public String myId {get;set;}
	public Boolean allowView {get;set;}
	
	ApexPages.StandardController stdCont;
	
	public GnattHelper(ApexPages.StandardController stc){
		myId = stc.getId();
		//allowView = Apexpages.currentPage().getParameters().get('p') == null;
	}
}