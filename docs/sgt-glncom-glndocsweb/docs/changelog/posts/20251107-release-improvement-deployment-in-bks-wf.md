---
title: Blue/Green Deployment Improvements and New Client Integration
categories:
  - Banksphere
date:
  created: 2025-11-07
tags:
  - Improvement
---
 
![Improvement](../assets/images/improvement-blog.png)

### What's Changing?

Enhanced client support with updated Harbor repository paths for proper image distribution across all supported clients.
Fixed HTTP 400 Bad Request errors when publication parameters contain special characters (@\) by implementing proper URL encoding in API calls.
Standardized Blue/Green deployment behavior across all clients with consistent b-g/g-b service naming and unified switch functionality aligned with Shuttle platform.  

### Why Is This Important?

This optimization eliminates issues that were impacting release processes, ensuring smooth CI/CD operations for all teams.
By standardizing deployment behavior and fixing API integration issues, teams now have predictable and reliable deployment patterns regardless of their target environment.
These improvements reduce operational complexity, maintenance overhead, and allow teams to focus on development rather than dealing with deployment inconsistencies.
