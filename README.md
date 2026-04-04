# HealthTech QA — Automatización de Pruebas API con Karate DSL

## Descripción

Proyecto de automatización de pruebas de API REST para el backend de **HealthTech**, una plataforma de gestión de pacientes con protocolo de triaje Manchester. Cubre los flujos de creación y consulta de pacientes, registro de signos vitales y listado de pacientes ordenados por criticidad.

Los escenarios automatizados incluyen casos de éxito y error para los endpoints `/pacients` y `/vitals`, validando respuestas HTTP, estructuras JSON y mensajes del sistema según el Protocolo Manchester de clasificación clínica.

---

## Stack Tecnológico

| Tecnología | Versión |
| ---------- | ------- |
| Java       | 17      |
| Gradle     | 9.4.0   |
| Karate DSL | 1.4.1   |
| JUnit 5    | 5.x     |

---

## Estructura del Proyecto

```
HEALTH_TECH_QA_KARATE/
├── src/
│   └── test/
│       └── java/
│           ├── healthtech/
│           │   └── HealthTechSuiteRunner.java   # Runner principal de toda la suite
│           ├── patients/
│           │   ├── PatientsRunner.java           # Runner individual de pacientes
│           │   ├── patients.feature              # Escenarios Gherkin de pacientes
│           │   └── patient-data.json             # Datos de prueba de pacientes
│           ├── vitals/
│           │   ├── VitalsRunner.java             # Runner individual de signos vitales
│           │   ├── vitals.feature                # Escenarios Gherkin de signos vitales
│           │   └── vitals-data.json              # Datos de prueba de signos vitales
│           ├── utils/
│           │   └── uniqueId.js                   # Utilidad para generación de IDs únicos
│           └── karate-config.js                  # Configuración global (baseUrl, endpoints)
├── API_DOCUMENTATION.md              # Documentación de la API
├── build.gradle                      # Configuración de Gradle
├── gradle.properties
├── settings.gradle
└── README.md
```

### Descripción de componentes clave

| Componente                   | Propósito                                                                          |
| ---------------------------- | ---------------------------------------------------------------------------------- |
| `HealthTechSuiteRunner.java` | Runner principal que ejecuta todos los escenarios en orden controlado              |
| `patients.feature`           | Escenarios de creación, consulta individual y listado de pacientes                 |
| `vitals.feature`             | Escenarios de registro de signos vitales con validaciones del Protocolo Manchester |
| `karate-config.js`           | Configuración global: `baseUrl`, `patientsEndpoint`, `vitalsEndpoint`              |
| `patient-data.json`          | Datos estáticos de prueba para pacientes                                           |
| `vitals-data.json`           | Datos de prueba para signos vitales (válidos, vacíos y fuera de rango)             |
| `uniqueId.js`                | Genera números de identificación únicos para evitar conflictos entre ejecuciones   |

---

## Escenarios Automatizados

### Pacientes (`/pacients`)

| #   | Escenario                                      | Método | Código Esperado |
| --- | ---------------------------------------------- | ------ | --------------- |
| 1   | Consulta lista vacía (requiere BD vacía)       | GET    | 200             |
| 2   | Creación exitosa de paciente                   | POST   | 201             |
| 3   | Error por identificación duplicada             | POST   | 409             |
| 4   | Error por campos obligatorios faltantes        | POST   | 400             |
| 5   | Consulta exitosa de paciente por ID            | GET    | 200             |
| 6   | Error al consultar paciente no existente       | GET    | 404             |
| 7   | Error al consultar con ID inválido             | GET    | 400             |
| 8   | Consulta lista de pacientes con signos vitales | GET    | 200             |

### Signos Vitales (`/vitals/{patientId}`)

| #   | Escenario                                               | Método | Código Esperado |
| --- | ------------------------------------------------------- | ------ | --------------- |
| 9   | Registro exitoso de signos vitales                      | POST   | 201             |
| 10  | Error por campos obligatorios faltantes                 | POST   | 400             |
| 11  | Error al registrar signos para paciente no existente    | POST   | 404             |
| 12  | Error por valores fuera de rango (Protocolo Manchester) | POST   | 422             |

> **Nota:** El escenario #1 (lista vacía) requiere una base de datos sin registros. En pipelines de CI/CD donde la base de datos se inicializa vacía en cada ejecución, todos los escenarios pasan exitosamente.

---

## Ejecución del Proyecto

### Requisitos previos

- Java 17 instalado
- La aplicación backend corriendo en `http://localhost:3000`

### Comandos de ejecución

**Con Gradle Wrapper (recomendado):**

```bash
./gradlew clean test
```

**O con Gradle instalado globalmente:**

```bash
gradle clean test
```

### Reporte de resultados

Tras la ejecución, los reportes se generan automáticamente en:

- **Reporte Karate HTML** (detalle por escenario y paso):
  ```
  build/karate-reports/karate-summary.html
  ```
- **Reporte HTML de Gradle** (resumen de ejecución JUnit):
  ```
  build/reports/tests/test/index.html
  ```

Abre cualquiera de estos archivos en un navegador para visualizar los resultados.
