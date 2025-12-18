# COBNet 🏥
### Coordination of Benefits - Healthcare Insurance Management System

**COBNet** is a robust Spring Boot application designed to streamline the **Coordination of Benefits (COB)** process. In healthcare, when a patient is covered by multiple insurance plans, COB rules determine which plan pays first (Primary) and which pays the remainder (Secondary). This project automates that logic to ensure accuracy and prevent overpayment.

---

## 🛠️ Tech Stack

| Layer | Technology |
| :--- | :--- |
| **Backend** | Java 17, Spring Boot |
| **Database** | MySQL |
| **ORM/Query** | Spring Data JPA, JPQL |
| **Frontend** | JSP (JavaServer Pages), JSTL, CSS3, HTML5 |
| **Architecture** | REST API, MVC Pattern |
| **Build Tool** | Maven |

---

## ✨ Key Features

- **Member Enrollment:** Manage member profiles and multiple insurance policy attachments.
- **COB Logic Engine:** Automated determination of Primary vs. Secondary insurance based on "Birthday Rule" or "Subscriber vs. Dependent" logic.
- **RESTful Integration:** API endpoints for third-party providers to check member eligibility and claim status.
- **Dynamic Frontend:** Interactive UI built with JSP and JSTL for real-time data rendering.
- **Advanced Querying:** Custom JPQL (Java Persistence Query Language) used for complex reporting and cross-referencing insurance data.

---

## 📐 System Architecture

The application follows a standard **N-Tier Architecture**:

1.  **Presentation Layer:** JSP files using JSTL tags for dynamic content.
2.  **Controller Layer:** Spring MVC Controllers and `@RestController` for API endpoints.
3.  **Service Layer:** Business logic for insurance rules and claim calculations.
4.  **Data Access Layer:** JPA Repositories utilizing JPQL to interact with the MySQL database.



---

## 🚀 Getting Started

### Prerequisites
* JDK 17+
* MySQL Server
* Maven 3.6+
