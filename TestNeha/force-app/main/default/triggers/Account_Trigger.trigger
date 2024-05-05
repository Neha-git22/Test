trigger Account_Trigger on Account (after insert,after update) {
    
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        Account_Handler.Handleafter(trigger.newMap,trigger.oldMap);
    }

}
