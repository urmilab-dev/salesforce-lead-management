public with sharing class LeadAssignmentService {

    private static final Map<String, String> INDUSTRY_OWNER_MAP = new Map<String, String>{
        'Finance' => 'finance_team@sigmainfotech.com',
        'Healthcare' => 'healthcare_team@sigmainfotech.com',
        'Technology' => 'tech_team@sigmainfotech.com',
        'Retail' => 'retail_team@sigmainfotech.com',
        'Manufacturing' => 'manufacturing_team@sigmainfotech.com'
    };

    private static final Map<String, Integer> INDUSTRY_SCORE_MAP = new Map<String, Integer>{
        'Finance' => 30,
        'Healthcare' => 25,
        'Technology' => 20,
        'Retail' => 15,
        'Manufacturing' => 10
    };

    public static void processLeads(List<Lead> leads) {

        Set<String> emails = new Set<String>();
        for (Lead ld : leads) {
            if (ld.Industry != null && INDUSTRY_OWNER_MAP.containsKey(ld.Industry)) {
                emails.add(INDUSTRY_OWNER_MAP.get(ld.Industry));
            }
        }

        Map<String, User> usersByEmail = new Map<String, User>();
        for (User u : [SELECT Id, Email FROM User WHERE Email IN :emails AND IsActive = true]) {
            usersByEmail.put(u.Email, u);
        }

        for (Lead ld : leads) {
            Integer score = 0;

            if (ld.AnnualRevenue != null) {
                if (ld.AnnualRevenue > 10000000) {
                    score += 40;
                } else if (ld.AnnualRevenue > 1000000) {
                    score += 20;
                } else {
                    score += 5;
                }
            }

            if (ld.Industry != null && INDUSTRY_SCORE_MAP.containsKey(ld.Industry)) {
                score += INDUSTRY_SCORE_MAP.get(ld.Industry);
            }

            if (ld.Country == 'US' || ld.Country == 'CA' || ld.Country == 'GB') {
                score += 20;
            } else if (ld.Country != null) {
                score += 10;
            }

            ld.Lead_Score__c = score;

            if (score >= 70) {
                ld.Lead_Priority__c = 'Hot';
                ld.Rating = 'Hot';
            } else if (score >= 40) {
                ld.Lead_Priority__c = 'Warm';
                ld.Rating = 'Warm';
            } else {
                ld.Lead_Priority__c = 'Cold';
                ld.Rating = 'Cold';
            }

            if (ld.Industry != null && INDUSTRY_OWNER_MAP.containsKey(ld.Industry)) {
                String ownerEmail = INDUSTRY_OWNER_MAP.get(ld.Industry);
                if (usersByEmail.containsKey(ownerEmail)) {
                    ld.OwnerId = usersByEmail.get(ownerEmail).Id;
                }
            }
        }
    }
}
