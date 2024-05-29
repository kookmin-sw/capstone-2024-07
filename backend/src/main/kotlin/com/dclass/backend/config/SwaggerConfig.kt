package com.dclass.backend.config

import io.swagger.v3.oas.models.Components
import io.swagger.v3.oas.models.OpenAPI
import io.swagger.v3.oas.models.info.Info
import io.swagger.v3.oas.models.security.SecurityScheme
import io.swagger.v3.oas.models.servers.Server
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

const val ACCESS_TOKEN_SECURITY_SCHEME_KEY = "AccessToken(Bearer)"

@Configuration
class SwaggerConfig {

    @Bean
    fun openAPI(): OpenAPI {
        return OpenAPI()
            .components(authComponents())
            .addServersItem(server())
            .info(info())
    }

    private fun server(): Server {
        return Server().url("/")
    }

    private fun authComponents(): Components {
        return Components().addSecuritySchemes(
            ACCESS_TOKEN_SECURITY_SCHEME_KEY,
            accessTokenSecurityScheme(),
        )
    }

    private fun accessTokenSecurityScheme(): SecurityScheme {
        return SecurityScheme()
            .name(ACCESS_TOKEN_SECURITY_SCHEME_KEY)
            .type(SecurityScheme.Type.HTTP)
            .scheme("bearer")
            .bearerFormat("JWT")
    }

    private fun info(): Info {
        return Info()
            .title("디클래스 API 명세서")
            .description("Swagger UI")
            .version("0.0.1")
    }
}
