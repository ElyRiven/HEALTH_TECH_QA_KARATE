# API Documentation — HealthTech Backend

## Base URL

```
http://localhost:3000/api/v1
```

## Content Type

```
application/json
```

---

## Endpoints

### Patients (`/pacients`)

#### Create Patient

| Method | URL       | Description             |
| ------ | --------- | ----------------------- |
| POST   | /pacients | Registers a new patient |

**Request Body:**

```json
{
  "identificacion": 1002003000,
  "nombres": "Datos Prueba",
  "apellidos": "Datos Prueba",
  "fecha_de_nacimiento": "1990-05-15",
  "genero": "femenino",
  "estado": "En espera"
}
```

**Field validations:**

| Field               | Type   | Allowed Values                                     |
| ------------------- | ------ | -------------------------------------------------- |
| identificacion      | number | Any valid integer                                  |
| nombres             | string | Required                                           |
| apellidos           | string | Required                                           |
| fecha_de_nacimiento | string | Format `yyyy-MM-dd`                                |
| genero              | string | `"masculino"`, `"femenino"`, `"otro"`              |
| estado              | string | `"En espera"`, `"Siendo atendido"`, `"Finalizado"` |

**Responses:**

| Status | Message                          | Description                                       |
| ------ | -------------------------------- | ------------------------------------------------- |
| 201    | Paciente registrado exitosamente | Patient created successfully                      |
| 400    | Error de validación              | Missing or invalid required fields                |
| 409    | Identificación duplicada         | Patient with same `identificacion` already exists |

**201 Response Body:**

```json
{
  "message": "Paciente registrado exitosamente",
  "id": 1
}
```

**400 Response Body (empty body `{}`):**

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

**409 Response Body:**

```json
{
  "message": "Identificación duplicada"
}
```

---

#### Get Patient by ID

| Method | URL                   | Description               |
| ------ | --------------------- | ------------------------- |
| GET    | /pacients/{patientId} | Retrieves a patient by ID |

**Path Parameters:**

| Parameter | Type    | Description        |
| --------- | ------- | ------------------ |
| patientId | integer | Patient identifier |

**Responses:**

| Status | Message                                | Description                        |
| ------ | -------------------------------------- | ---------------------------------- |
| 200    | —                                      | Patient found                      |
| 400    | El id debe ser un número entero válido | Invalid ID (letters/special chars) |
| 404    | Paciente no encontrado                 | No patient with the given ID       |

**200 Response Body:**

```json
{
  "id": 1,
  "identificacion": 1002003000,
  "nombres": "Datos Prueba",
  "apellidos": "Datos Prueba",
  "fecha_de_nacimiento": "1990-05-15",
  "genero": "femenino",
  "estado": "En espera"
}
```

**404 Response Body:**

```json
{
  "message": "Paciente no encontrado"
}
```

**400 Response Body:**

```json
{
  "message": "El id debe ser un número entero válido"
}
```

---

#### Get All Patients

| Method | URL       | Description                                                          |
| ------ | --------- | -------------------------------------------------------------------- |
| GET    | /pacients | Retrieves all patients with vitals, sorted by criticality descending |

**Responses:**

| Status | Description                          |
| ------ | ------------------------------------ |
| 200    | List of patients (may be empty `[]`) |

**200 Response Body:**

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
    "estado": "En espera"
  }
]
```

---

### Vitals (`/vitals`)

#### Create Vital Signs for a Patient

| Method | URL                 | Description                         |
| ------ | ------------------- | ----------------------------------- |
| POST   | /vitals/{patientId} | Registers vital signs for a patient |

**Path Parameters:**

| Parameter | Type    | Description        |
| --------- | ------- | ------------------ |
| patientId | integer | Patient identifier |

**Request Body:**

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

**Field validations (from Manchester Protocol):**

| Field                   | Type    | Unit         | Min  | Max   | Allowed Values                                                                           |
| ----------------------- | ------- | ------------ | ---- | ----- | ---------------------------------------------------------------------------------------- |
| frecuencia_cardiaca     | integer | bpm          | 20   | 300   | —                                                                                        |
| frecuencia_respiratoria | integer | rpm          | 1    | 60    | —                                                                                        |
| saturacion_o2           | decimal | %            | 50.0 | 100.0 | —                                                                                        |
| temperatura             | decimal | °C           | 25.0 | 45.0  | —                                                                                        |
| presion                 | string  | mmHg         | —    | —     | Format `sistolica/diastolica` (e.g., `"120/80"`)                                         |
| nivel_de_conciencia     | string  | —            | —    | —     | `"Alerta"`, `"Confuso"`, `"Responde a la voz"`, `"Responde al dolor"`, `"Sin respuesta"` |
| nivel_de_dolor          | integer | Scale 0 – 10 | 0    | 10    | —                                                                                        |

**Responses:**

| Status | Message                                      | Description                            |
| ------ | -------------------------------------------- | -------------------------------------- |
| 201    | Signos vitales registrados exitosamente      | Vital signs created successfully       |
| 400    | Campos obligatorios faltantes                | One or more required fields are absent |
| 404    | El paciente con Id enviado no fue encontrado | Patient ID does not exist              |
| 422    | Los datos no cumplen con las validaciones    | Values are outside permitted ranges    |

**201 Response Body:**

```json
{
  "message": "Signos vitales registrados exitosamente"
}
```

**400 Response Body:**

```json
{
  "message": "Campos obligatorios faltantes"
}
```

**404 Response Body:**

```json
{
  "message": "El paciente con Id enviado no fue encontrado"
}
```

**422 Response Body:**

```json
{
  "message": "Los datos no cumplen con las validaciones"
}
```
