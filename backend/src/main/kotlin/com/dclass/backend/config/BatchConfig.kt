package com.dclass.backend.config

import com.dclass.backend.domain.blocklist.BlocklistRepository
import com.dclass.support.util.logger
import org.springframework.batch.core.Job
import org.springframework.batch.core.Step
import org.springframework.batch.core.StepContribution
import org.springframework.batch.core.configuration.support.DefaultBatchConfiguration
import org.springframework.batch.core.job.builder.JobBuilder
import org.springframework.batch.core.repository.JobRepository
import org.springframework.batch.core.scope.context.ChunkContext
import org.springframework.batch.core.step.builder.StepBuilder
import org.springframework.batch.core.step.tasklet.Tasklet
import org.springframework.batch.repeat.RepeatStatus
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.transaction.PlatformTransactionManager
import java.time.LocalDateTime

@Configuration
class BatchConfig(
    private val blocklistRepository: BlocklistRepository
) : DefaultBatchConfiguration() {

    companion object {
        const val JOB_NAME = "cleanUpJob"
        const val STEP_NAME = "cleanUpStep"
    }

    private val log = logger()

    @Bean
    fun cleanUpStep(jobRepository: JobRepository, tasklet: Tasklet, tm: PlatformTransactionManager): Step {
        return StepBuilder(STEP_NAME, jobRepository)
            .tasklet(tasklet, tm)
            .build()
    }

    @Bean(name = [JOB_NAME])
    fun cleanUpJob(jobRepository: JobRepository, step: Step): Job {
        return JobBuilder(JOB_NAME, jobRepository)
            .start(step)
            .build()
    }

    @Bean
    fun cleanUpTasklet(): Tasklet {
        return Tasklet { contribution: StepContribution, chunkContext: ChunkContext ->
            val ninetyDaysAgo = LocalDateTime.now().minusDays(90)
            blocklistRepository.deleteAllByCreatedDateTimeBefore(ninetyDaysAgo)
            log.info("Cleaned up blocklist entries created before")
            RepeatStatus.FINISHED
        }
    }
}