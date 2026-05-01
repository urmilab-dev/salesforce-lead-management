trigger LeadAssignmentTrigger on Lead (before insert, before update) {

    List<Lead> leadsToProcess = new List<Lead>();

    for (Lead ld : Trigger.new) {
        if (Trigger.isInsert) {
            leadsToProcess.add(ld);
        } else if (Trigger.isUpdate) {
            Lead oldLead = Trigger.oldMap.get(ld.Id);
            Boolean relevantFieldChanged = (
                ld.Industry != oldLead.Industry ||
                ld.Country != oldLead.Country ||
                ld.AnnualRevenue != oldLead.AnnualRevenue
            );
            if (relevantFieldChanged) {
                leadsToProcess.add(ld);
            }
        }
    }

    if (!leadsToProcess.isEmpty()) {
        LeadAssignmentService.processLeads(leadsToProcess);
    }
}
