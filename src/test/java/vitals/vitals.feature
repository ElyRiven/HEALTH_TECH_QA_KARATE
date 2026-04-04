Feature: Vitals API - HealthTech Backend

  Background:
    * url baseUrl
    * def vitalsData = read('vitals-data.json')

  Scenario: Create vital signs for a patient successfully
    # Create a patient with a unique ID using a timestamp-based identification
    * def uniqueId = karate.call('classpath:utils/uniqueId.js')
    * def newPatient = karate.merge(vitalsData.patient_for_successful_vitals, { identificacion: uniqueId })
    Given path patientsEndpoint
    And request newPatient
    When method POST
    Then status 201
    * def patientId = response.id

    # Register vital signs for the created patient
    Given path vitalsEndpoint, patientId
    And request vitalsData.valid_vitals
    When method POST
    Then status 201
    And match response.message == 'Signos vitales registrados exitosamente'

  Scenario: Get error when creating vital signs with missing required fields
    # Create a patient with a unique ID
    * def uniqueId = karate.call('classpath:utils/uniqueId.js')
    * def newPatient = karate.merge(vitalsData.patient_for_missing_fields, { identificacion: uniqueId })
    Given path patientsEndpoint
    And request newPatient
    When method POST
    Then status 201
    * def patientId = response.id

    # Attempt to register empty vital signs
    Given path vitalsEndpoint, patientId
    And request vitalsData.empty_vitals
    When method POST
    Then status 400
    And match response.message == 'Campos obligatorios faltantes'

  Scenario: Get error when creating vital signs for a non-existent patient
    Given path vitalsEndpoint, vitalsData.nonexistent_patient_id
    And request vitalsData.valid_vitals
    When method POST
    Then status 404
    And match response.message == 'El paciente con Id enviado no fue encontrado'

  Scenario: Get error when creating vital signs with values outside valid ranges
    # Create a patient with a unique ID
    * def uniqueId = karate.call('classpath:utils/uniqueId.js')
    * def newPatient = karate.merge(vitalsData.patient_for_out_of_range, { identificacion: uniqueId })
    Given path patientsEndpoint
    And request newPatient
    When method POST
    Then status 201
    * def patientId = response.id

    # Attempt to register vitals with out-of-range values
    Given path vitalsEndpoint, patientId
    And request vitalsData.out_of_range_vitals
    When method POST
    Then status 422
    And match response.message == 'Los datos no cumplen con las validaciones'
