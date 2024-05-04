package com.dclass.backend.config

import com.dclass.support.util.logger
import org.springframework.batch.core.configuration.JobRegistry
import org.springframework.batch.core.configuration.support.JobRegistryBeanPostProcessor
import org.springframework.batch.core.launch.JobLauncher
import org.springframework.context.annotation.Bean
import org.springframework.stereotype.Component


@Component
class BatchScheduler(
    private val jobLauncher: JobLauncher,
    private val jobRegistry: JobRegistry
) {
    private val log = logger()

    @Bean
    fun jobRegistryBeanPostProcessor(): JobRegistryBeanPostProcessor {
        val postProcessor = JobRegistryBeanPostProcessor()
        postProcessor.setJobRegistry(jobRegistry)
        return postProcessor
    }

    /*  @Scheduled(fixedRate = 5000)
      fun cleanUpJob() {

          val parameter = mapOf(
              "requestDate" to JobParameter(System.currentTimeMillis().toString(), String::class.java),
              "jobName" to JobParameter("cleanUpJob", String::class.java)
          )
          val jobParameters = JobParameters(parameter)

          jobLauncher.run(jobRegistry.getJob("cleanUpJob"), jobParameters)
          log.info("job started")
      }*/


}