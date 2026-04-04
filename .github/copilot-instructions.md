## Instrucciones para GitHub Copilot y agentes de IA

### Stack Tecnológico

- **Java v17**
- **Gradle v9.4.0**
- **Karate DSL v1.4.1**
- **JUnit 5**

### Contexto del Proyecto

- Proyecto de Automatización de pruebas Backend de API en Java.
- El proyecto utiliza Gradle como sistema de construcción.
- Framework principal: Karate DSL.
- Los casos de prueba se reconocen y ejecutan usando archivos `.feature` escritos en lenguaje Gherkin.

### Buenas Prácticas de Desarrollo

- Mantener el código limpio, modular y reutilizable.
- Escribir métodos y clases con una única responsabilidad.
- Evitar la duplicidad de código; reutilizar componentes y utilidades.
- Escribir pruebas independientes y repetibles.
- Validar los resultados esperados usando aserciones claras.
- Mantener la estructura de carpetas organizada según convenciones de Karate y Gradle.

### Importaciones

- **No** se deben realizar importaciones directamente dentro del cuerpo del código (métodos, clases, etc.).
- Todas las importaciones deben declararse al inicio de cada archivo Java, antes de la declaración de la clase.
- Usar las importaciones dentro del código únicamente después de haberlas declarado al inicio.

### Lineamientos de Nomenclatura y Sintaxis

- Todas las variables, archivos y métodos deben nombrarse en **inglés**.
- Los archivos .feature deben seguir la nomenclatura Kebab Case, ejemplo: `user-authentication.feature`.
- Utilizar el formato **lowerCamelCase** para utilidades, ejemplo: `userName.js`, `inputCredentials.js`).
- Los Test Runners y Test Suites deben usar PascalCase y estar en inglés (ejemplo: `UsersRunner.java`).
- Los archivos de datos deben usar Kebab Case y tener la extensión .json, ejemplo: `valid-user-data.json`.
- Usa los ejemplos del documento `.github/instructions/karate-sintax.instructions.md` para definir la implementación de las pruebas.
- Los archivos de documentación como el README.md son la única excepción de idioma, los cuales deben estar redactados en español.

### Uso de Gherkin

- Los archivos `.feature` deben estar escritos en lenguaje Gherkin para describir los escenarios de prueba.
- Utilizar pasos claros y descriptivos en inglés.
- Mantener la consistencia en la redacción de los escenarios.

### Otros Lineamientos

- Seguir las convenciones de Karate para la estructura del proyecto.
- Seguir **siempre** esta estructura de directorios:


src/
    └── test/
        └── java/
            ├── users/                    # Directorios para agrupar las pruebas
            │   └── users.feature         # Escenarios Gherkin que describe la prueba a ejecutar
            │   └── user-data.json        # Datos de prueba en formato json
            │   └── UserRunner.json       # Runner de la suite de pruebas
            ├── products/                 # Directorios para agrupar las pruebas
            │   └── products.feature      # Escenarios Gherkin que describe la prueba a ejecutar
            └── karate-config.js          # Configuración global de karate (baseUrl, endpoints, etc)
  
- Mantener dependencias actualizadas en el archivo `build.gradle`.
- Priorizar la legibilidad y mantenibilidad del código.
