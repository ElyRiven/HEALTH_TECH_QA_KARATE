function fn() {
  var env = karate.env;
  karate.log("karate.env:", env);

  var config = {
    baseUrl: "http://localhost:3000/api/v1",
    patientsEndpoint: "/pacients",
    vitalsEndpoint: "/vitals",
  };

  return config;
}
