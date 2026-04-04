Feature: Patients API - HealthTech Backend

  Background:
    * url baseUrl
    * def patientData = read('patient-data.json')

  Scenario: Get empty patient list when database has no records
    Given path patientsEndpoint
    When method GET
    Then status 200
    And match response == []

  Scenario: Create a new patient successfully
    * def uniqueId = karate.call('classpath:utils/uniqueId.js')
    * def newPatient = karate.merge(patientData.valid_patient, { identificacion: uniqueId })
    Given path patientsEndpoint
    And request newPatient
    When method POST
    Then status 201
    And match response.message == 'Paciente registrado exitosamente'
    And match response.id == '#notnull'
    * def createdPatientId = response.id

  Scenario: Get error when creating a patient with duplicate identification
    * def uniqueId = karate.call('classpath:utils/uniqueId.js')
    * def firstPatient = karate.merge(patientData.valid_patient, { identificacion: uniqueId })
    # Create the first patient
    Given path patientsEndpoint
    And request firstPatient
    When method POST
    Then status 201

    # Attempt to create another patient with the same identification
    * def duplicatePatient = karate.merge(patientData.duplicate_patient, { identificacion: uniqueId })
    Given path patientsEndpoint
    And request duplicatePatient
    When method POST
    Then status 409
    And match response.message == 'Identificación duplicada'

  Scenario: Get error when creating a patient with missing required fields
    Given path patientsEndpoint
    And request patientData.empty_patient
    When method POST
    Then status 400
    And match response.message == 'Error de validación'
    And match response.errors.identificacion == 'El id debe ser un número'
    And match response.errors.nombres == 'Debe escribir tus nombres'
    And match response.errors.apellidos == 'Debe escribir tus apellidos'
    And match response.errors.fecha_de_nacimiento == 'Debe tener un formato de yyyy-MM-dd'
    And match response.errors.genero == 'Debes poner genero: masculino, femenino u otro'
    And match response.errors.estado == 'Debe ser: En espera, Siendo atendido, Finalizado'

  Scenario: Get patient by ID successfully
    # Create a unique patient to ensure it exists
    * def uniqueId = karate.call('classpath:utils/uniqueId.js')
    * def newPatient = karate.merge(patientData.patient_for_get_by_id, { identificacion: uniqueId })
    Given path patientsEndpoint
    And request newPatient
    When method POST
    Then status 201
    * def patientId = response.id

    # Now query the created patient
    Given path patientsEndpoint, patientId
    When method GET
    Then status 200
    And match response.id == patientId

  Scenario: Get error when querying a non-existent patient by ID
    Given path patientsEndpoint, patientData.nonexistent_patient_id
    When method GET
    Then status 404
    And match response.message == 'Paciente no encontrado'

  Scenario: Get error when querying a patient with an invalid ID
    Given path patientsEndpoint, patientData.invalid_patient_id
    When method GET
    Then status 400
    And match response.message == 'El id debe ser un número entero válido'

  Scenario: Get list of patients with registered vital signs sorted by criticality
    # Create a patient and register vitals to ensure the list is populated
    * def uniqueId = karate.call('classpath:utils/uniqueId.js')
    * def listTestPatient = { identificacion: '#(uniqueId)', nombres: 'Lista Prueba', apellidos: 'Paciente Lista', fecha_de_nacimiento: '1988-06-15', genero: 'masculino', estado: 'En espera' }
    Given path patientsEndpoint
    And request listTestPatient
    When method POST
    Then status 201
    * def listPatientId = response.id

    * def vitalsData = read('classpath:vitals/vitals-data.json')
    Given path vitalsEndpoint, listPatientId
    And request vitalsData.valid_vitals
    When method POST
    Then status 201

    # Now query the full list
    Given path patientsEndpoint
    When method GET
    Then status 200
    And match response == '#array'
    And match response[0] == { identificacion: '#number', nombres: '#string', apellidos: '#string', fecha_de_nacimiento: '#string', genero: '#string', criticidad: '#number', hora_de_registro: '#string', estado: '#string' }
