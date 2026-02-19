

**CSC1049 Year 3 Project**

**Functional Specification**

**Project Title: Finance Coach**

**Student(s) Name and ID**

| Aaron O’Shea | 23368161 |
| :---- | :---- |
| **Anthony Chukwuemeka Kalu** | **23395331** |

**Supervisor Name: Irina Tal**

**Module Coordinator: Dr. David Sinclair**

**Date: 28 November 2025**

**Table of Contents**

**[1\. Introduction	3](#1.-introduction)**

[1.2 Business Context	3](#1.2-business-context)

[**2\. General Description	4**](#2.-general-description)

[2.1 Product / System Functions	4](#2.1-product-/-system-functions)

[2.2 User Characteristics and Objectives	5](#2.2-user-characteristics-and-objectives)

[2.3 Operational Scenarios	6](#2.3-operational-scenarios)

[2.4 Constraints	7](#2.4-constraints)

[**3\. Functional Requirements	7**](#3.-functional-requirements)

[3.1 User Authentication and Account Management	7](#3.1-user-authentication-and-account-management)

[3.2 User Login	8](#3.2-user-login)

[3.3 Core Budgeting Functionality	8](#3.3-core-budgeting-functionality)

[3.4 Education Content/Learning	9](#3.4-education-content/learning)

[3.5 AI Powered Features	9](#3.5-ai-powered-features)

[3.6 Data Visualization and Goals	10](#3.6-data-visualization-and-goals)

[**4\. System Architecture	11**](#4.-system-architecture)

[**5\. High level design	12**](#5.-high-level-design)

[5.1 Use cases	12](#5.1-use-cases)

[**6\. Preliminary Schedule	18**](#6.-preliminary-schedule)

[**7\. Other Nonfunctional Requirements	19**](#7.-other-nonfunctional-requirements)

[7.1 Performance Requirements	19](#7.1-performance-requirements)

[7.2 Safety Requirements	20](#7.2-safety-requirements)

[7.3 Security Requirements	20](#7.3-security-requirements)

[7.4 Software Quality Attributes	20](#7.4-software-quality-attributes)

[7.5 Business Rules	20](#7.5-business-rules)

[**8\. Appendix	21**](#8.-appendix)

[Appendix 1 \- Resources	21](#appendix-1---resources)

[Appendix 2 \- Glossary	22](#appendix-2---glossary)

[Database Schema	22](#database-schema)

[Data Anonymisation	23](#data-anonymisation)

# 

# 

# 

# **1\. Introduction** {#1.-introduction}

**1.1 Overview**

The AI-Powered Finance Coach is a mobile application designed to improve financial literacy for students and young adults through interactive lessons, budgeting tools, and a personalized AI tutor. Research indicates that many individuals lack basic financial management skills, such as budgeting, saving, and understanding financial terminology. Traditional financial education is often complex, inaccessible, or unengaging. This system aims to address these challenges by providing a practical, simple, and adaptive learning experience.

The product combines three core components:

1. **Budgeting Module** \-  where users manually input income, expenses, and financial goals.  
2. **Interactive Learning System** \- educational modules and quizzes covering essential financial topics.  
3. **AI tutor** \- a personalized assistant that uses user progress and budgeting patterns to give tailored financial guidance

The system will be built using Flutter for the mobile interface and Django for the backend. The AI tutor will be powered by an external LLM API (e.g., OpenAI API or Microsoft Phi-3), but only receives anonymized user lessons and budgeting summaries. No banking or sensitive financial data is handled.

The application operates independently, though it may optionally integrate with open-banking APIs in the future.

## **1.2 Business Context** {#1.2-business-context}

This system is intended for deployment in educational environments, personal finance learning contexts, or as a standalone budgeting and financial literacy tool. It addresses a clear need for accessible financial education among students, young professionals, and adults who want better control over their finances.

While this project is developed in an academic context (School of Computing, Dublin City University), the product has potential for real-world use by:

* Universities providing financial literacy support,  
* Financial well-being programs,  
* Budgeting and personal development platforms,  
* Young adults seeking beginner-friendly financial education tools.

There is no external business sponsor; however, the system aligns with industry trends toward AI-assisted financial planning and educational mobile applications.

# **2\. General Description** {#2.-general-description}

## **2.1 Product / System Functions** {#2.1-product-/-system-functions}

The AI-Powered Finance Coach provides the following core functions:

* **Budget Creation:** Users set monthly income, spending categories, and savings targets.  
* **Expense Tracking:** Users manually enter expenses which are categorized and stored.  
* **Interactive Lessons:** The system includes short, module-based lessons on budgeting, saving, financial terms, and basic investing.  
* **Quizzes and Assessments:** Users complete short quizzes that evaluate their understanding.  
* **AI-Powered Feedback:** The AI tutor provides explanations, personalized lesson recommendations, and spending insights.  
* **Progress Tracking:** Visual dashboards show user performance, spending patterns, and completed lessons.  
* **Secure User Accounts:** Authentication and data storage via Django’s backend system.

Initially, no external financial API is used; all budgeting data is user-entered to ensure safety, simplicity, and privacy.

The AI-Powered Finance Coach relies on two primary categories of financial data: educational financial content and user-provided budgeting data. The learning modules and interactive lessons use publicly available, non-sensitive educational material sourced from reputable financial literacy resources such as government consumer finance portals, banking education sites, OECD financial literacy frameworks, and publicly accessible financial knowledge platforms such as Investopedia. For simple market-related lessons (e.g., “What is a stock?”, “How does crypto volatility work?”), the system may also retrieve general, non-personalised market data from free public APIs such as Yahoo Finance, Alpha Vantage, or CoinGecko. This data is used purely for explanatory and educational purposes and does not provide trading or investment advice.

User-specific financial data comes only from information the user manually inputs into the application, such as income, expenses, budgeting categories, savings goals, and lesson or quiz progress. This information is stored securely in the local application database and is not shared with any third-party financial service. When users interact with the AI tutor, the system only sends anonymised, aggregated insights (for example: “user spends 30% on food” or “user struggles with saving goals”) to the AI provider. No names, raw expenses, or personal identifiers are ever transmitted. This ensures that all personalised recommendations remain private, ethical, and compliant with standard data protection expectations. The system therefore combines curated educational content, safe API-based general market data, and locally stored user inputs to provide personalised and responsible financial guidance.

## **2.2 User Characteristics and Objectives** {#2.2-user-characteristics-and-objectives}

### **User Group**

The main users include:

* Students aged 16–25  
* Young adults with limited financial knowledge  
* Individuals seeking to improve budgeting habits  
* Beginners to personal finance

### **User Expertise**

* Basic mobile app skills  
* Limited or no understanding of financial concepts  
* No technical background required

### **User Objectives**

Users aim to:

* Learn how to budget effectively  
* Track and manage their expenses  
* Improve financial literacy  
* Understand basic investing concepts  
* Receive personalized guidance on spending habits  
* Develop better financial decision-making skills

### **Desirable (Wish-List) Features**

* Automatic bank transaction imports (future enhancement)  
* Gamification features (badges, streaks)  
* Personalized learning paths  
* Voice-based AI guidance  
* Multi-language support

### **Feasible Features for This Project**

* Manual budgeting and expense tracking  
* Interactive educational modules  
* AI-powered personalized explanations  
* Secure authentication  
* Progress dashboard

## 

## **2.3 Operational Scenarios** {#2.3-operational-scenarios}

### **Scenario 1: Creating a Budget**

A user launches the app for the first time, enters their monthly income and selects budget categories. They assign spending limits, and the app generates a visual budget overview.

### **Scenario 2: Adding an Expense**

The user buys groceries and opens the app to log the expense (€20). The system updates their Food category and shows the remaining budget for the month.

### **Scenario 3: Completing a Lesson**

The user starts the “Budgeting Basics” lesson, reads the material, and completes a 5-question quiz. The app stores their score and updates their progress.

### **Scenario 4: Using the AI Tutor**

The user types: *“How do I improve my savings?”*

The backend retrieves the user’s spending pattern (e.g., overspending on food) and sends it to the AI API.

The AI responds:“You spent €180 of your €150 food budget. Reducing takeaway purchases could help you save €30–€40 monthly.”

### **Scenario 5: Setting a Goal**

The user sets a goal to save €200 this month. The app tracks user progress and the AI offers motivational tips.

## **2.4 Constraints** {#2.4-constraints}

* **Technical Constraints:**  
  * Mobile app built in Flutter (Dart)  
  * Backend implemented using Django (Python)  
  * SQL database for data persistence  
  * AI requires stable internet connection to access external LLM API  
* **Privacy & Security Constraints:**  
  * No handling of sensitive bank credentials  
  * All personal data must comply with GDPR  
  * AI receives only anonymized spending summaries  
* **Resource Constraints:**  
  * Limited development time (academic project)  
  * No requirement for embedded banking APIs  
* **Performance Constraints:**  
  * AI responses must be near real-time  
  * App should run smoothly on standard iOS/Android devices

# **3\. Functional Requirements** {#3.-functional-requirements}

## **3.1 User Authentication and Account Management** {#3.1-user-authentication-and-account-management}

**Functional requirement 1: User Registration**

**Description:** Our system must allow new users to create their account using email address and a password. The registration process must validate the email address format, enforce password strength requirements (minimum 8 characters and a capital letter), and also be able to store credentials safely in the database.

**Criticality:** Very High, essential for our system to function properly. Without user accounst, personalization, tracking of progress and AI recommendations cannot be provided.

**Technical Issues:**

**Password:** Users password must be hashed using a secure algorithm (Django)

**Email Validation:** To prevent duplicate accounts

**Email Verification:** To prevent fake accounts being created

**Dependancies:** None, This is a foundational requirement which other features depend on

## **3.2 User Login** {#3.2-user-login}

**Functional Requirement 2: User Login/Session Management**

**Description:** Our system must allow registered users to log in using their email address and password. After successful authentication, our system must create a secure session that continues until the user logs out of the application or the session expires.

**Criticality:** High, Required for accessing personal information/features and maintaining  the user’s data securely.

**Technical Issues:**

**Session Token Management:** Between the frontend and backend Flutter \- React.

**Token Expiration/ Refresh Mechanism**

**Secure Storage of Session Tokens on mobile device**

**Failed Login Attempts:** Lockout after multiple failed attempts.

**Dependancies: Functional Requirement 1**

## **3.3 Core Budgeting Functionality** {#3.3-core-budgeting-functionality}

**Functional Requirement 3: Budget/Expense Tracking**

**Description:** Our system must allow users to enter their monthly/yearly income, add their expenses manually with the appropriate amount and what category. Also, the user must be able to set spending limits for each category. Our system must track expenses against the user-set limits, calculating the budget in real-time, and then alert the user when approaching/exceeding limits.

**Criticality:** High. This functionality enables financial tracking and user control.

**Technical Issues:**

**Input Validation:** Income and expense amounts.

**Real-Time budget calculations across categories**

**Database schema design:** Income/expenses and category limits.

**Notification System:** For budget thresholds.

**Dependancies: Functional Requirement 1 & 2**

## **3.4 Education Content/Learning** {#3.4-education-content/learning}

**Functional Requirement 4: Interactive Educational Content**

**Description:** Our system must provide educational lessons on financial topics including the basics of budgeting, strategies to save money as well as basic investing concepts. Each lesson module must include readable content with examples. Quizzes will also be included, and the system will score automatically based on user responses. These quizzes will provide immediate feedback to the user, and track their progress.

**Criticality:** High. This is a core feature that differentiates our application from others.

**Technical Issues:**

**Content Management System:** For storing/organizing lesson modules in the database.

**Design of the Quiz Database:** Questions/Answers/Explanations.

**Scoring Algorithm:** Automatic quiz grading and pass/fail determination.

**Progress Tracking:** Recording lesson states, and past quiz scores.

**Dependancies: Functional Requirement 1, requires an authenticated user.**

## **3.5 AI Powered Features** {#3.5-ai-powered-features}

**Functional Requirement 5: AI Powered Personalized Tutor**

**Description:** Our system must integrate with an external LLM API such as OpenAI or Microsoft Phi-3 to provide an AI tutor that answers financial questions asked by the user in natural language. The AI must analyse user spending patterns, their adherence to budgets, and their learning progress. The AI will then suggest specific spending adjustments, tips on saving and relevant lesson recommendations. For privacy, only anonymized, aggregated data will be transmitted to the AI provider. No personally identifiable information will be sent.

**Criticality:** High. This is a key differentiating feature.

**Technical Issues:**

**LLM API Integration:** Authentication and secure API key management. 

**Data Anonymization Pipeline:** Aggregating and anonymizing user data before transmission.

**Response Time Optimization:** Ensuring Real-Time responses.

**Error Handling:** Managing API downtime, timeout errors and invalid responses.

**Privacy Compliance:** Audit logging of all data transmitted to external API’s.

**Dependancies: Functional Requirement 1, 3 and 4**

## **3.6 Data Visualization and Goals** {#3.6-data-visualization-and-goals}

**Functional Requirement 6: Visual Dashboard/Financial Goal Tracking**

**Description:** Our systems must provide a comprehensive visual dashboard which displays user income and expenses by category, their current budget status and spending trends. Users must be able to set savings goals with specific target amounts and deadlines, and the dashboard must display goal progress as a percentage of completion. All visualizations must update in real time.

**Criticality:** High. Essential for users to quickly understand their financial situation.

**Technical Issues**

**Chart Rendering:** Implementing Charts using Flutter’s libraries for finance tracking.

**Performance Optimization:** Efficient real time calculations and rendering.

**Data Refresh:** Implementing pull to refresh and automatic updates.

**Dependancies: Functional Requirement 1, 3 and 4**

# 

# 

# 

# 

# 

# 

# 

# 

# 

# 

# 

# 

# **4\. System Architecture** {#4.-system-architecture}

## ![][image1]

# 

# 

# 

# **5\. High level design** {#5.-high-level-design}

## **5.1 Use cases** {#5.1-use-cases}

The following section outlines the key use cases for the AI-Powered Finance Coach system. Use cases describe the interactions between external actors and the system in order to achieve specific goals. They help define the functional requirements of the application by identifying what the system must allow users and external services to do. Each use case captures a distinct piece of functionality, such as budgeting, learning, or interacting with the AI tutor, and illustrates the sequence of actions required to complete that task. Together, these use cases provide a comprehensive overview of the system’s expected behaviour and serve as the foundation for later design, implementation, and testing activities.

## **![][image2]**

| Use case 1: Create Account / Login |  |
| :---- | :---- |
| **Field**  | **Description** |
| Primary Actor | User |
| Secondary Actor | None |
| Description | User creates an account or logs into the system to access personalised features |
| Precondictions | User has a valid email or device |
| Criticality | High |
| Dependencies  | None |

| Use case 2: Enter Income |  |
| :---- | :---- |
| **Field**  | **Description** |
| Primary Actor  | User |
| Description | User enters their monthly/weekly income into the budgeting system |
| Preconditions | User is logged in |
| Postconditions | Income is stored in the database |
| Criticality | High |
| Dependencies | UC1 |

| Use case 3: Enter Expenses |  |
| :---- | :---- |
| **Field**  | **Description** |
| Primary Actor  | User |
| Description | User records expenses manually and categories them |
| Preconditions | User is logged in |
| Postconditions | Expense is saved and included in dashboard calculations |
| Criticality | High |
| Dependencies | UC1, UC2 |

| Use case 4: Set Financial Goals |  |
| :---- | :---- |
| **Field**  | **Description** |
| Primary Actor  | User |
| Description | User defines savings or budgeting goals |
| Preconditions | User is logged in. Income entered |
| Postconditions | Goals stored in the database |
| Criticality | Medium |
| Dependencies | UC1, UC2 |

| Use case 5: View Budget Dashboard |  |
| :---- | :---- |
| **Field**  | **Description** |
| Primary Actor  | User |
| Description | System displays budgets, spending progress, and financial summaries. |
| Preconditions | User has entered income/expenses |
| Postconditions | User sees updated dashboard |
| Criticality | High |
| Dependencies | UC2, UC3 |

| Use case 6: Take Interactive lessons |  |
| :---- | :---- |
| **Field**  | **Description** |
| Primary Actor  | User |
| Description | User reads lesson content on budgeting, saving, and markets. |
| Preconditions | User is logged in |
| Postconditions | Lesson progress stored. |
| Criticality | High |
| Dependencies | UC |

| Use case 7: Complete Quizzes |  |
| :---- | :---- |
| **Field**  | **Description** |
| Primary Actor  | User |
| Description | User answers lesson questions to test their understanding |
| Preconditions | Lesson opened |
| Postconditions | Quiz scores recorder |
| Criticality | Medium |
| Dependencies | UC6 |

| Use case 8: Receive Lesson Recommendations |  |
| :---- | :---- |
| **Field**  | **Description** |
| Primary Actor  | User |
| Secondary Actor | AI provider |
| Description | System recommends lessons based on profile, quiz results, or spending behaviour. |
| Preconditions | User has completed lessons/quizzes |
| Postconditions | Recommended content shown |
| Criticality | Medium |
| Dependencies | UC6, UC7 |

| Use case 9: Ask AI Tutor Questions |  |
| :---- | :---- |
| **Field**  | **Description** |
| Primary Actor  | User |
| Secondary Actor | AI Provider |
| Description | User asks a financial question and receives an AI-generated explanation |
| Preconditions | User is logged in |
| Postconditions | AI response displayed |
| Criticality | High |
| Dependencies | UC1 |

| Use case 10: View market Insights |  |
| :---- | :---- |
| **Field**  | **Description** |
| Primary Actor  | User |
| Secondary Actor | Market Data API |
| Description | User views simple educational market insights retrieved via API |
| Preconditions | Internet connection |
| Postconditions | Market data shown |
| Criticality | Low |
| Dependencies | UC1 |

# **6\. Preliminary Schedule** {#6.-preliminary-schedule}

**This section outlines the main phases for developing our AI Powered Finance Coach Application and an indicative timeline.**

**Major Tasks and Timeline**

**Submission of Project Proposal \-** 17th October 2025

**Presentation of Project Proposal \-** 31st October 2025

**Submission of Functional Specification \-** 28th November 2025

**Backend Implementation (Django) \-** 28th November 2025 \- 1st January 2026

**Mobile App Implementation (Flutter) \-** 28th November 2025 \- 1st January 2026

**AI Tutor Integration \-** 28th November \- 15th January 2026

**Testing and Bug Fixing \-** 11th February 2026 \- 17th February 2026

**Documentation \-** 8th February 2026 \- 19th February 2026

**Final Submission \-** 20th February 2026

**Project Demonstration \-** 27th February 2026

**Below is a Gantt chart illustrating these tasks, durations, overlaps and dependencies.**

# **7\. Other Nonfunctional Requirements**  {#7.-other-nonfunctional-requirements}

## **7.1 Performance Requirements** {#7.1-performance-requirements}

* Dashboard and budgeting data should load within 2 seconds.  
* AI Tutor responses should return within 3–5 seconds.  
* Backend API responses should complete within 300–500 ms.  
* The app must run efficiently on standard iOS and Android devices.

## **7.2 Safety Requirements** {#7.2-safety-requirements}

* All financial content must remain educational only, not investment advice.  
* Data must not be lost during normal use; integrity checks required.  
* System must prevent harmful or misleading AI output through prompt filtering.  
* App must fail gracefully with user-friendly error messages.


## **7.3 Security Requirements** {#7.3-security-requirements}

* All communication must use HTTPS/TLS encryption.  
* User passwords must be hashed using Django’s secure authentication system.  
* Only anonymised summaries may be sent to AI providers, never raw financial data.  
* Users must be able to delete their account and associated data.  
* Access to personal data requires authentication; no third-party sharing.

## **7.4 Software Quality Attributes** {#7.4-software-quality-attributes}

* Usability: Simple, intuitive UI for beginners.  
* Reliability: Aim for high availability and stable backend operation.  
* Maintainability: Modular code structure for easy updates.  
* Portability: Cross-platform (iOS/Android) via Flutter.  
* Scalability: Should handle more lessons, users, and data without redesign.

## 

## 

## 

## **7.5 Business Rules** {#7.5-business-rules}

* Only registered users can use budgeting and AI features.  
* Users must manually enter income and expenses (no bank connections).  
* AI outputs must be labelled as educational guidance.  
* Lesson recommendations depend on user progress and quiz performance.  
* Admins manage lesson and quiz content; users cannot modify it.

# **8\. Appendix**  {#8.-appendix}

## **Appendix 1 \- Resources** {#appendix-1---resources}

* **Similar Sites:**  
- [https://mint.intuit.com/](https://mint.intuit.com/)  
- [https://www.investopedia.com/](https://www.investopedia.com/)  
- [https://web.meetcleo.com/](https://web.meetcleo.com/)

* **Research Tools**:  
- [https://www.sqlcourse.com/](https://www.sqlcourse.com/)  
- [https://www.coingecko.com/en/api?utm\_source=chatgpt.com](https://www.coingecko.com/en/api?utm_source=chatgpt.com)  
- [https://www.khanacademy.org/college-careers-more/personal-finance](https://www.khanacademy.org/college-careers-more/personal-finance)

## 

## 

## 

## 

## 

## 

## **Appendix 2 \- Glossary** {#appendix-2---glossary}

| Term | Definition |
| :---- | :---- |
| **AI Tutor** | An artificial intelligence system that provides personalized explanations and recommendations based on user data. |
| **Budgeting Module**  | The part of the system where users enter income, expenses, and goals. |
| **LLM (Large Language Model)**  | An AI model capable of understanding and generating natural language. |
| **Financial Literacy**  | Understanding money management, including budgeting, saving, and basic investing. |
| **User Progress Data**  | Data stored about completed lessons, quiz scores, and learning performance. |
| **Manual Financial Entry**  | User-provided input of expenses and income, as opposed to automated bank imports. |
| **Open Banking API**  | APIs (e.g., Plaid, TrueLayer) that allow apps to access financial transactions with user consent. |
| **REST API** | A standard method for communication between the mobile app (frontend) and the server (backend).  |
| **Database Schema** | The structure of the stored data (tables, fields, and relationships). |
| **Data Anonymisation** | Removing personal identifiers from data before sending it to the AI model. |

[image1]: <data:image/png;base64,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iA5ECyBGIFokjCBaANGBaAHECESLhBFECyA6EC2AGIFokTCCaAFEB6IFECMQLRJGEC2A6EC0AGIEokXCCKIFEB2IFkCMiLtoXbz4t+9zquRxMnbNzK233u75jKtNm771zckV+RT1bNvIJxcu1D5ip9DIMxDNvuxXhw6VvnlxCqIFEB2IFkCMiLtotWjR0ic82URr6dKVnrE9e06ovjwX0Z6bLfUpWjezHlm2a9centozz/zbOXPmd9/cOAXRAogORAsgRsRdtII+eT2baNWewdrtq+n58jpmzF2emv38RKlp0dLp2LGzZ539+t3ijn3yyde+bZnbC6qdO/eHp9a2bTu3L7KYaX2PP75EteXfQM8pK2vizjl79rKqbdy4yzl0qNqtt25d4dn/sINoAUQHogUQI6ISrUOHzjunT//mq5vp2bOP07hxY2fx4mXOyJFj3Hou0bJr+uHKelxSXX3VeeKJf7mS1bJlazU+b95i9apFa9GiZe5yL730tmprsZH2M8+86LYrKzs5HTp0VG1TzOx90vtw7NhPzquvvqdq8nXKq2zPnC9t84zW8eM/q5oWLb0uaY8ePd5ti2hJe+3a9e683buPefYjzCBaANGBaAHEiChES8uBRITGHjfn6cfcmPKRr2jJZTZdl9eePft45gctY186LC0t9azjxIn/upGzW6tWveE8/PATaqy62ntPlr1+6dv3XUmee+4ltW/mfGnblw6lZoqWPSZfr4iW7JdZb9asuW+bYQXRAogORAsgRkQtWq+//pFv3Jxntjds2KHa+YrWAw884tblVS4dmvM7d+7qW8YWrVatWnvWIWevzHz++TdqrKKirfu1mdsw1y19uXRo1+Ss2tKlK3zL5iNaJSWlzvbthwJFq0mTJp65YQbRAogORAsgRkQhWr179/PJiJ3u3Xu5c8zIWC7Rss/cSE3OSOm2LVpB68olWvZ8O+Yce770TdEaP/7ujPOl3alTF9/ymURL+nJGDdECSC+IFkCMiEK06hJbIMxaNtHS8wYNutXZvHmvatviYoqWrsk9UlVVPzqTJk1VtWyi1aRJU9Xeu/eks3NnlVtfsOAp5913P3f27Tvt2+acOfOdgwfPun1TtN55Z6Nbe/HFN1T744+3q7FRo8a621qyZLm7vH2PlvxVpT6bJnVECyC9IFoAMSKOoiWyY4qKjtQOHjznLF/+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>

[image2]: <data:image/png;base64,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>