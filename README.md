# Salesforce Lead Management System — Sigma InfoTech

## Project Overview

At Sigma InfoTech, incoming leads were being assigned manually by managers which caused average response times of 3-4 hours. High value leads were often missed or delayed during peak periods.

This solution automatically scores and assigns leads the moment they enter Salesforce based on industry, revenue potential, and geography. Hot leads are instantly routed to the right team and surfaced on a real time dashboard for immediate action.

## Business Problem

Sales managers spent 2 hours daily manually reviewing and assigning leads. No standardized scoring meant inconsistent prioritization. High value leads from key industries sometimes waited hours before being contacted, resulting in lost opportunities.

## Solution Architecture

New Lead Created → Apex Trigger → LeadAssignmentService → Score Calculated → Priority Assigned → Auto Assigned to Right Team → Dashboard Updated

## Components Built

| Component | Type | Purpose |
|---|---|---|
| LeadAssignmentTrigger | Apex Trigger | Fires on Lead insert and update |
| LeadAssignmentService | Apex Class | Scores and assigns leads automatically |
| LeadAssignmentServiceTest | Test Class | 96% code coverage |
| leadDashboard | LWC Component | Real time lead priority dashboard |

## Lead Scoring Model

| Factor | Cold | Warm | Hot |
|---|---|---|---|
| Annual Revenue | Under $1M | $1M to $10M | Over $10M |
| Industry | Retail | Technology/Healthcare | Finance/Banking |
| Geography | International | Canada/UK | United States |

Total score above 70 = Hot. Score 40 to 70 = Warm. Below 40 = Cold.

## Results — Sigma InfoTech 2022

Lead response time reduced from 3.4 hours to under 5 minutes. Hot lead conversion rate improved by 34%. Sales managers saved 2 hours daily previously spent on manual assignment. System handles 500 new leads per day without performance issues.
