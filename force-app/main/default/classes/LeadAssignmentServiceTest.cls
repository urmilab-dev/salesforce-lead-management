@isTest
private class LeadAssignmentServiceTest {

    @isTest
    static void testHotLead() {
        Lead ld = new Lead(
            FirstName = 'John',
            LastName = 'Smith',
            Company = 'Big Finance Corp',
            Industry = 'Finance',
            AnnualRevenue = 15000000,
            Country = 'US',
            Email = 'john@bigfinance.com'
        );

        Test.startTest();
        insert ld;
        Test.stopTest();

        Lead result = [SELECT Lead_Score__c, Lead_Priority__c, Rating
                       FROM Lead WHERE Id = :ld.Id];
        System.assertEquals('Hot', result.Lead_Priority__c, 'Expected Hot priority');
        System.assert(result.Lead_Score__c >= 70, 'Score should be 70 or above');
    }

    @isTest
    static void testColdLead() {
        Lead ld = new Lead(
            FirstName = 'Jane',
            LastName = 'Doe',
            Company = 'Small Shop',
            Industry = 'Retail',
            AnnualRevenue = 100000,
            Country = 'IN',
            Email = 'jane@smallshop.com'
        );

        Test.startTest();
        insert ld;
        Test.stopTest();

        Lead result = [SELECT Lead_Score__c, Lead_Priority__c
                       FROM Lead WHERE Id = :ld.Id];
        System.assertEquals('Cold', result.Lead_Priority__c, 'Expected Cold priority');
        System.assert(result.Lead_Score__c < 40, 'Score should be below 40');
    }

    @isTest
    static void testLeadRescoreOnUpdate() {
        Lead ld = new Lead(
            FirstName = 'Mike',
            LastName = 'Johnson',
            Company = 'Tech Startup',
            Industry = 'Technology',
            AnnualRevenue = 500000,
            Country = 'IN',
            Email = 'mike@techstartup.com'
        );
        insert ld;

        Test.startTest();
        ld.AnnualRevenue = 20000000;
        ld.Country = 'US';
        update ld;
        Test.stopTest();

        Lead result = [SELECT Lead_Priority__c FROM Lead WHERE Id = :ld.Id];
        System.assertEquals('Hot', result.Lead_Priority__c, 'Updated lead should be Hot');
    }

    @isTest
    static void testBulkLeadInsert() {
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            leads.add(new Lead(
                FirstName = 'Test',
                LastName = 'Lead ' + i,
                Company = 'Test Company ' + i,
                Industry = 'Technology',
                AnnualRevenue = 1000000 * i,
                Country = 'US',
                Email = 'test' + i + '@test.com'
            ));
        }

        Test.startTest();
        insert leads;
        Test.stopTest();

        List<Lead> results = [SELECT Lead_Priority__c FROM Lead WHERE LastName LIKE 'Lead %'];
        System.assertEquals(200, results.size(), 'All 200 leads should be inserted and scored');
    }

    @isTest
    static void testNullFieldsSafeHandling() {
        Lead ld = new Lead(
            FirstName = 'Empty',
            LastName = 'Fields',
            Company = 'Unknown Corp',
            Email = 'empty@unknown.com'
        );

        Test.startTest();
        insert ld;
        Test.stopTest();

        Lead result = [SELECT Lead_Priority__c FROM Lead WHERE Id = :ld.Id];
        System.assertNotEquals(null, result.Lead_Priority__c, 'Priority should always be assigned');
    }
}
