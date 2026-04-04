package healthtech;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

class HealthTechSuiteRunner {

    @Test
    void testAll() {
        Results results = Runner.path(
                "classpath:patients",
                "classpath:vitals"
        )
                .outputCucumberJson(true)
                .parallel(1);

        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
