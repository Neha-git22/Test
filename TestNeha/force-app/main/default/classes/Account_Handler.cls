public class Account_Handler {
    //this code was initially written for activation Summary validation. but later understood to handle it in the ui button
   /* public static void Handlebefore(List<Account> accL){
        for(Account A:accL){
            if(A.Active_Bool__c==true){
                if(A.Acc_Activation_Summary__c==null){
                    A.Acc_Activation_Summary__c.addError('Please complete this field for account activation!');
                }
            }
        }
        
    }*/
    
    public static void Handleafter(List<Account> NaccL,List<Account> OaccL){
        List<Contact> InsconL = new List<Contact>();
        
        //Set to store accIds coming from trigger.new
        Set<Id> accountIds = new Set<Id>();
        
        for(Account A : NaccL){
            accountIds.add(A.Id);
        }
        
        List<Contact> RelCons=[SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds];
        
        //Storing ConIds corresponding to New Accounts 
        Map<Id, Id> AccConMap = new Map<Id, Id>();
        for(Contact C :RelCons ){
            AccConMap.put(C.AccountId, C.Id);
        }
        
        for(Account A : NaccL){
            if(A.Type == 'Customer - Direct'  && A.Acc_Activation_Summary__c != null){
                
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