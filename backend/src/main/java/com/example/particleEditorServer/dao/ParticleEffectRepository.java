package com.example.particleEditorServer.dao;
import org.springframework.data.jpa.repository.JpaRepository;

import com.example.particleEditorServer.entity.ParticleEffectEntity;

public interface ParticleEffectRepository extends JpaRepository<ParticleEffectEntity, Integer> {
	ParticleEffectEntity findByName(String name);
}
