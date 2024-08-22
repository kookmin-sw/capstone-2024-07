package com.dclass.backend.domain.recommend

import org.springframework.data.jpa.repository.JpaRepository

interface RecommendRepository : JpaRepository<Recommend, Long>

