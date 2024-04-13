@isTest
private class Test_Accounttrigger {

    @testSetup 
    public static void setupTestData() {
        
        Account At1 = new Account();
            At1.Name = 'Test Account';
            At1.Type = 'Customer - Direct';
            At1.Active_Bool__c = true;
            At1.Acc_Activation_Summary__c = 'Activation Summary';
            At1.Comp_Email__c = 'test11@gmail.com';
            At1.Phone = '9999604953';
        
        insert At1;
        Account At2 = new Account();
            At2.Name = 'Test Account2';
            At2.Type = 'Customer - Direct';
            At2.Active_Bool__c = false;
            //At2.Acc_Activation_Summary__c = 'Activation Summary';
            At2.Comp_Email__c = 'test22@gmail.com';
            At2.Phone = '3456986590';
        
        insert At2;
        
        
    }

    @isTest 
    public static void Test_trig() {
        Test.startTest();
        
        Account TAcc1 = [SELECT Id, Name, Type, Acc_Activation_Summary__c, Comp_Email__c, Phone FROM Account WHERE Active_Bool__c=true LIMIT 1];
        Account TAcc2 = [SELECT Id, Name, Type,Active_Bool__c, Acc_Activation_Summary__c, Comp_Email__c, Phone FROM Account WHERE Active_Bool__c=false LIMIT 1];
        
        TAcc1.Acc_Activation_Summary__c='updated11';
        update TAcc1;
        
        TAcc2.Active_Bool__c=true;
        TAcc2.Acc_Activation_Summary__c='updated';
        update TAcc2;
 
        List<Contact> conL1 = [SELECT Id, AccountId, FirstName, LastName, Email, Phone FROM Contact WHERE AccountId = :TAcc1.Id];
        System.assertEquals(1, conL1.size());
        List<Contact> conL2 = [SELECT Id, AccountId, FirstName, LastName, Email, Phone FROM Contact WHERE AccountId = :TAcc2.Id];
        System.assertEquals(1, conL2.size());

        
        Contact createdContact = conL1[0];
        System.assertEquals('Test Account', createdContact.FirstName);
        System.assertEquals('Customer Representative', createdContact.LastName);
        System.assertEquals('test11@gmail.com', createdContact.Email);
        System.assertEquals('9999604953', createdContact.Phone);
        Test.stopTest();
    }
}