trigger Account_Trigger on Account (before insert,before update,after insert,after update) {
    
   /* if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
         Account_Handler.Handlebefore(Trigger.new);
    }*/
    
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        Account_Handler.Handleafter(trigger.new,trigger.old);
    }

}