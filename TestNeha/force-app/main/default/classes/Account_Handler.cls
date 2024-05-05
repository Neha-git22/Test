public class Account_Handler { 
    public static void Handleafter(Map<Id,Account> NaccM,Map<Id,Account> OaccM){
        List<Contact> InsconL = new List<Contact>();
        
        //Set to store accIds coming from trigger.newMap
        Set<Id> accountIds = new Set<Id>();
        List<Contact> RelCons=[SELECT Id, AccountId FROM Contact WHERE AccountId IN :NaccM.keyset()];
        for(Contact C:RelCons){
            accountIds.add(C.AccountId);
        }
     
        //Storing ConIds corresponding to New Accounts 

        
        for(Id key : NaccM.keyset()){
            Account AccOld=new Account();
            if(OaccM!=null){
                 AccOld=OaccM.get(key);
            }
            else{ 
                AccOld=null;
            }
                
            if (NaccM.get(key).Type.contains('Customer') && NaccM.get(key).Active_Bool__c && (AccOld == null || !AccOld.Active_Bool__c)) {
                if (!accountIds.contains(key)) {
                    InsconL.add(new Contact(
                        FirstName = NaccM.get(key).Name,
                        LastName = 'Customer Representative',
                        Phone = NaccM.get(key).Phone,
                        Email = NaccM.get(key).Comp_Email__c,
                        AccountId = key
                    ));
                    accountIds.add(key); 
                }
            }
        }
        //null check for inserting list
        if(!InsconL.isEmpty()){
            insert InsconL;
        }     
    }
   }

