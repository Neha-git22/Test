@isTest
private class Test_Accounttrigger {

    @testSetup 
    public static void setupTestData() {
        
        Profile StanPro = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];
        
        PermissionSet AccManagerPs=[SELECT Id From PermissionSet WHERE Name='Account_Manager'];
        
        User U1=new User();
        U1.UserName='TestCuser@abcomp.com';
        U1.LastName='TestClass-User';
        U1.Alias = 'Tuse';
        U1.Email='TestCuser@abcomp.com';
        U1.EmailEncodingKey='UTF-8'; 
        U1.LanguageLocaleKey='en_US';
        U1.LocaleSidKey='en_US';
        U1.ProfileId = StanPro.Id;
        U1.TimeZoneSidKey='America/Los_Angeles'; 
        insert U1;
        
        PermissionSetAssignment PSAssign = new PermissionSetAssignment();
        PSAssign.AssigneeId = U1.Id;
        PSAssign.PermissionSetId = AccManagerPs.Id;
        insert PSAssign;
        
        
    }

    @isTest 
    public static void Test_trig_INS_POS() {
        //Method to Test the Positive Insertion case i.e Acc inserted with Active_Bool as true.
        User U1=[SELECT Id, Name FROM User WHERE Username='TestCuser@abcomp.com'];
        
        //Account TAcc1 = [SELECT Id, Name, Type, Acc_Activation_Summary__c, Comp_Email__c, Phone FROM Account WHERE Active_Bool__c=true LIMIT 1];
        System.runAs(U1){
            Account At1 = new Account();
            At1.Name = 'Test Account';
            At1.Type = 'Customer - Direct';
            At1.Active_Bool__c = true;
            At1.Acc_Activation_Summary__c = 'Activation Summary';
            At1.Comp_Email__c = 'test11@gmail.com';
            At1.Phone = '9999604953';
            
            insert At1;
            
        
        
        List<Contact> conL1 = [SELECT Id, AccountId, FirstName, LastName, Email, Phone FROM Contact WHERE AccountId = :At1.Id];
        System.assertEquals(1, conL1.size());
        
        Contact createdContact = conL1[0];
        System.assertEquals(At1.Name, createdContact.FirstName);
        System.assertEquals('Customer Representative', createdContact.LastName);
        System.assertEquals(At1.Comp_Email__c, createdContact.Email);
        System.assertEquals(At1.Phone, createdContact.Phone);
        }
        
    }
    @isTest 
    public static void Test_trig_INS_NEG() {
        //Method to Test the Negative Insertion case i.e Acc inserted with Active_Bool as false.
        User U1=[SELECT Id, Name FROM User WHERE Username='TestCuser@abcomp.com'];
        System.runAs(U1){
            Account At1 = new Account();
            At1.Name = 'Test Account';
            At1.Type = 'Customer - Direct';
            At1.Active_Bool__c = false;
            At1.Acc_Activation_Summary__c = 'Activation Summary';
            At1.Comp_Email__c = 'test11@gmail.com';
            At1.Phone = '9999604953';
            
            insert At1;
        
        //Account TAcc2 = [SELECT Id, Name, Type,Active_Bool__c, Acc_Activation_Summary__c, Comp_Email__c, Phone FROM Account WHERE Active_Bool__c=false LIMIT 1];
        
        //TAcc2.Acc_Activation_Summary__c='updated';
        //update TAcc2;
        
        List<Contact> conL2 = [SELECT Id, AccountId, FirstName, LastName, Email, Phone FROM Contact WHERE AccountId = :At1.Id];
        System.assertNotEquals(1, conL2.size());
        }
        
    }
    
    @isTest 
    public static void Test_trig_UPD() {
        //Method to test the updation case.
        User U1=[SELECT Id, Name FROM User WHERE Username='TestCuser@abcomp.com'];
        System.runAs(U1){
            Account At1 = new Account();
            At1.Name = 'Test Account';
            At1.Type = 'Customer - Direct';
            At1.Active_Bool__c = false;
            At1.Acc_Activation_Summary__c = 'Activation Summary';
            At1.Comp_Email__c = 'test11@gmail.com';
            At1.Phone = '9999604953';
            
            insert At1;
        //Account TAcc2 = [SELECT Id, Name, Type,Active_Bool__c, Acc_Activation_Summary__c, Comp_Email__c, Phone FROM Account WHERE Active_Bool__c=false LIMIT 1];
        At1.Active_Bool__c=true;
        //At1.Acc_Activation_Summary__c='updated';
        update At1;
        
        List<Contact> conL2 = [SELECT Id, AccountId, FirstName, LastName, Email, Phone FROM Contact WHERE AccountId = :At1.Id];
            System.assertEquals(true, At1.Active_Bool__c);
            System.assertEquals(1, conL2.size());
        }

    }
}

