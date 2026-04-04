# CasoS de Prueba a automatizar

## Contexto

Necesito que implementes una automatización de API en mi aplicación de Backend ubicada en la URL `http://localhost:3000/api/v1`.
La automatización debe cubrir la creación de pacientes (POST), creación de signos vitales de un paciente (POST), consulta de un paciente por su ID (GET) y la consulta de todos los pacientes con signos vitales registrados ordenados por su criticidad descendentemente (GET). El contenido que acepta la API es `application/json`.

## Endpoints a probar (archivos .feature)

### Creación de un paciente (POST):

**Creación exitosa**

- Definir los datos de prueba para crear un nuevo paciente en el sistema.
- Hacer una petición POST al endpoint `/pacients` con los datos en formato JSON:

```json
{
  "identificacion": 1002003000,
  "nombres": "Datos Prueba",
  "apellidos": "Datos Prueba",
  "fecha_de_nacimiento": "1990-05-15", // formato yyyy-MM-dd
  "genero": "femenino", // Valores permitidos: "masculino", "femenino", "otro"
  "estado": "En espera" // valores permitidos: "En espera", "Siendo atendido", "Finalizado"
}
```

- Comprobar que el código de la respuesta del endpoint sea 201.
- Comprobar que el body de la respuesta tenga en la propiedad "message" = "Paciente registrado exitosamente".
- Comprobar que el body de la respuesta tenga en la propiedad "id" = [id del paciente registrado]].

**Error de creación por identificación duplicada**

- Definir datos de prueba, que incluyan identificaciones anteriormente usadas.
- Hacer una petición POST al endpoint `/pacients` con los datos en formato JSON.
- Comprobar que el código de respuesta es 409.
- Comprobar que el body de la respuesta tenga en la propiedad "message" = "Identificación duplicada".

**Error de creación por valores obligatorios faltantes**

- Definir datos de prueba con datos faltantes.
- Hacer una petición POST al endpoint `/pacients` con los datos en formato JSON.
- Comprobar que el código de respuesta es 400.
- Comprobar que el body de la respuesta tenga los errores correspondientes dependiendo del dato o datos omitidos, ejemplo de respuesta al enviar una petición con un body vacío ({}):

```json
{
  "message": "Error de validación",
  "errors": {
    "identificacion": "El id debe ser un número",
    "nombres": "Debe escribir tus nombres",
    "apellidos": "Debe escribir tus apellidos",
    "fecha_de_nacimiento": "Debe tener un formato de yyyy-MM-dd",
    "genero": "Debes poner genero: masculino, femenino u otro",
    "estado": "Debe ser: En espera, Siendo atendido, Finalizado"
  }
}
```

### Creación de signos vitales de un paciente (POST):

- ENDPOINT: `/vitals/{patientId}`
- Parámetro de URL: patientId (1002003001, 0987654321, etc) debe ser un número
- Valores permitidos: revisa el documento `MANCHESTER_PROTOCOL.md` para definir los datos

**Creación exitosa**

- Definir los datos de prueba válidos en el sistema `MANCHESTER_PROTOCOL.md`.
- Hacer una petición POST al endpoint `/vitals/{patientId}` con el ID de paciente como parámetro de ruta y los datos en formato JSON:

```json
{
  "frecuencia_cardiaca": 72,
  "frecuencia_respiratoria": 16,
  "saturacion_o2": 98.0,
  "temperatura": 36.8,
  "presion": "118/76",
  "nivel_de_conciencia": "Alerta",
  "nivel_de_dolor": 1
}
```

- Comprobar que el código de la respuesta del endpoint sea 201.
- Comprobar que el body de la respuesta tenga en la propiedad "message" = "Signos vitales registrados exitosamente".

**Error de creación por valores obligatorios faltantes**

- Definir los datos de prueba con datos faltantes.
- Hacer una petición POST al endpoint `/vitals/{patientId}` con el ID de paciente como parámetro de ruta y los datos en formato JSON:
  ejemplo:

```json
{
    "frecuencia_cardiaca": "",
    "frecuencia_respiratoria": "",
}

O un JSON completamente vacío

{
}
```

- Comprobar que el código de respuesta es 400.
- Comprobar que el body de la respuesta tenga en la propiedad "message" = "Campos obligatorios faltantes".

**Error de creación al no encontrar el paciente**

- Definir los signos vitales de prueba y definir un ID de paciente que no exista en el sistema.
- Hacer una petición POST al endpoint `/vitals/{patientId}` con el ID de paciente que no existe como parámetro de ruta y los datos en formato JSON.
- Comprobar que el código de respuesta es 404.
- Comprobar que el body de la respuesta tenga en la propiedad "message" = "El paciente con Id enviado no fue encontrado".

**Error de creación por datos fuera de rangos válidos**

- Definir los datos de prueba fuera de los rangos permitidos por el sistema.
- Hacer una petición POST al endpoint `/vitals/{patientId}` con el ID de paciente como parámetro de ruta y los datos en formato JSON.
- Comprobar que el código de respuesta es 422.
- Comprobar que el body de la respuesta tenga en la propiedad "message" = "Los datos no cumplen con las validaciones".

### Consulta de un paciente por ID (GET):

**Consulta exitosa de paciente existente**

- Definir un ID de paciente que exista en el sistema.
- Hacer una petición GET al endpoint `/pacients/{patientId}` con el ID de paciente como parámetro de ruta.
- Comprobar que el código de respuesta es 200
- Comprobar que el body de la respuesta tenga la propiedad "id" = [id del paciente consultado]

**Error de consulta por paciente no existente**

- Definir un ID de paciente que NO exista en el sistema
- Hacer una petición GET al endpoint `/pacients/{patientId}` con el ID de paciente como parámetro de ruta.
- Comprobar que el código de respuesta es 404
- Comprobar que el body de la respuesta tenga la propiedad "message" = "Paciente no encontrado"

**Error de consulta por ID inválido**

- Definir un ID de paciente inválido (caracteres especiales o letras)
- Hacer una petición GET al endpoint `/pacients/{patientId}` con el ID de paciente como parámetro de ruta.
- Comprobar que el código de respuesta es 400
- Comprobar que el body de la respuesta tenga la propiedad "message" = "El id debe ser un número entero válido"

### Consultar lista de pacientes registrados (GET):

**Consulta exitosa de lista de pacientes**

- Hacer una petición GET al endpoint `/pacients`.
- Comprobar que el código de respuesta es 200
- Comprobar que el body de la respuesta contenga la estructura JSON de datos:

```json
[
  {
    "identificacion": 1002003000,
    "nombres": "Datos Prueba",
    "apellidos": "Datos Prueba",
    "fecha_de_nacimiento": "1990-05-15",
    "genero": "femenino",
    "criticidad": 5,
    "hora_de_registro": "10:28:16 PM",
    "estado": "asda"
  },
  {
    "identificacion": 1002003001,
    "nombres": "Datos Prueba",
    "apellidos": "Datos Prueba",
    "fecha_de_nacimiento": "1990-05-15",
    "genero": "femenino",
    "criticidad": 5,
    "hora_de_registro": "10:28:18 PM",
    "estado": "asda"
  }
]
```

**Consulta exitosa cuando la base de datos no tiene registros**

IMPORTANTE: Haz que esta sea EL PRIMER ESCENARIO en ejecutarse, ya que requiere que la base de datos esté vacía.

- Hacer una petición GET al endpoint `/pacients`.
- Comprobar que el código de respuesta es 200
- Comprobar que el body de la respuesta contenga un array vacío:

```json
[]
```

## Objetivo

Debes crear la automatización de estos escenarios mediante Karate DSL, generando los escenarios, sus pasos en Gherkin haciendo uso de sus palabras clave (GIVEN, WHEN, THEN, AND, etc) con la sintaxis propia de Karate, sus datos de prueba en archivos .json e implementar el código necesario en los diferentes directorios del proyecto.
Optimiza el proyecto para su correcta ejecución en el pipeline de CI/CD en el que se va a implementar mediante Github Actions.
Finalmente debes asegurar que el proyecto permita la ejecución correcta de las pruebas y la generación del reporte HTML de Karate con los resultados de los escenarios y sus pasos de ejecución.
