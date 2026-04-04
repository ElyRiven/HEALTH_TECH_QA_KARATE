# Reglas de formato para Karate

Este documento define ejemplos de la sintaxis a usar en los diferentes archivos dentro de los directorios del proyecto de Karate.

## `app/src/test/java`

Directorio principal del proyecto.

### `users/`

Directorio para agrupar las pruebas. Estos directorios pueden tener distintos nombres dependiendo de su propósito o contexto.

#### `user-crud.feature`

Archivo de definición de los escenarios a testear en la automatización usando Gherkin y sus palabras clave (GIVEN, WHEN, THEN, AND, etc).

```gherkin
Feature: User CRUD - AutomationExercise API

  Background:
    * url baseUrl
    * def userEmail = 'ellie@test.com'
    * def userPassword = 'password_ellie10'

  Scenario: Create a new user
    * def createData = read('user-data.json')
    Given path '/createAccount'
    And form fields createData
    When method POST
    Then status 200
    And match response.responseCode == 201
    And match response.message == 'User created!'

  Scenario: Get created user details
    Given path '/getUserDetailByEmail'
    And param email = userEmail
    When method GET
    Then status 200
    And match response.responseCode == 200
    And match response.user.name == 'Ellie Tamayo'
    And match response.user.email == userEmail

  Scenario: Update user data
    * def updateData = read('update-user-data.json')
    Given path '/updateAccount'
    And form fields updateData
    When method PUT
    Then status 200
    And match response.responseCode == 200
    And match response.message == 'User updated!'

    # Verification of update
    Given path '/getUserDetailByEmail'
    And param email = userEmail
    When method GET
    Then status 200
    And match response.responseCode == 200
    And match response.user.name == 'Diana Tamayo'
    And match response.user.address1 == 'Guayaquil'

  Scenario: Delete user account
    Given path '/deleteAccount'
    And form fields { email: '#(userEmail)', password: '#(userPassword)' }
    When method DELETE
    Then status 200
    And match response.responseCode == 200
    And match response.message == 'Account deleted!'

    # Verification of deletion
    Given path '/getUserDetailByEmail'
    And param email = userEmail
    When method GET
    And match response.responseCode == 404
```

#### `user-data.json`

Archivo de definición de datos a usar en el escenario en formato JSON.

```json
{
  "name": "Ellie Tamayo",
  "email": "#(userEmail)",
  "password": "#(userPassword)",
  "title": "Miss",
  "birth_date": "24",
  "birth_month": "10",
  "birth_year": "1999",
  "firstname": "Elizabeth",
  "lastname": "Tamayo",
  "company": "Sofka",
  "address1": "Quito",
  "address2": "Quito",
  "country": "Ecuador",
  "zipcode": "180625",
  "state": "Pichincha",
  "city": "Quito",
  "mobile_number": "0987654321"
}
```

#### `UserRunner.java`

Es el runner que especifica la ejecución las pruebas

```java
package users;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

class UserRunner {

    @Test
    void testAll() {
        Results results = Runner.path("classpath:users")
                .outputCucumberJson(true)
                .parallel(1);

        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
```

### `karate-config.js`

Archivo de configuración global de Karate.

```javascript
function fn() {
  var env = karate.env;
  karate.log("karate.env:", env);

  var config = {
    baseUrl: "https://baseurl.com/api",
  };

  return config;
}
```
