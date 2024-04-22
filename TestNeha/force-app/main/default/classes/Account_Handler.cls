public class Account_Handler { 
    public static void Handleafter(List<Account> NaccL,List<Account> OaccL){
        List<Contact> InsconL = new List<Contact>();
        
        //Set to store accIds coming from trigger.new
        Set<Id> accountIds = new Set<Id>();
        
        if(NaccL!=null){
            for(Account A : NaccL){
                if((A.Type == 'Customer - Direct' || A.Type == 'Customer - Channel') && A.Active_Bool__c==true)
                    accountIds.add(A.Id);
            }
        }
        if(OaccL!=null){
            for(Account A : OaccL){
                if((A.Type == 'Customer - Direct' || A.Type == 'Customer - Channel') && A.Active_Bool__c==true)
                    accountIds.add(A.Id);
            }
        }
        
        List<Contact> RelCons=[SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds];
        
        //Storing ConIds corresponding to New Accounts 
        Map<Id, Id> AccConMap = new Map<Id, Id>();
        for(Contact C :RelCons ){
            AccConMap.put(C.AccountId, C.Id);
        }
        
        for(Account A : NaccL){
            if((A.Type == 'Customer - Direct' || A.Type == 'Customer - Channel')  && A.Active_Bool__c==true){
                if(!AccConMap.containsKey(A.Id)){
                    Contact con = new Contact();
                        con.FirstName = A.Name;
                        con.LastName = 'Customer Representative';
                        con.AccountId = A.Id;
                        con.Email=A.Comp_Email__c;
                        con.Phone=A.Phone;
                    
                    InsconL.add(con);
                }
            }
        }
        //null check for inserting list
        if(!InsconL.isEmpty()){
            insert InsconL;
        }     
    }
}
