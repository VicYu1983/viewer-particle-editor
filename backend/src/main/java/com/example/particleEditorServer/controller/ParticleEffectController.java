package com.example.particleEditorServer.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.example.particleEditorServer.dao.ParticleEffectRepository;
import com.example.particleEditorServer.dto.ParticleEffectParam;
import com.example.particleEditorServer.entity.ParticleEffectEntity;


@RestController
@RequestMapping("/api/particleEffect")
public class ParticleEffectController {
	
	@Autowired
	ParticleEffectRepository particleEffectRepository;
    
    @GetMapping("/list")
    @ResponseBody
    public ResponseEntity<List<ParticleEffectEntity>> list() {
        return ResponseEntity.ok().body(particleEffectRepository.findAll());
    }
    
    @GetMapping("/list/{particleEffectId}")
    @ResponseBody
    public ResponseEntity<ParticleEffectEntity> list(@PathVariable(name = "particleEffectId") int particleEffectId) {
    	if(particleEffectRepository.existsById(particleEffectId)) {
    		return ResponseEntity.ok().body(particleEffectRepository.findById(particleEffectId).get());
    	}
        return ResponseEntity.badRequest().body(null);
    }
    
    @DeleteMapping("/list/{particleEffectId}")
    @ResponseBody
    public ResponseEntity<List<ParticleEffectEntity>> deleteById(@PathVariable(name = "particleEffectId") int particleEffectId) {
    	if(particleEffectRepository.existsById(particleEffectId)) {
    		particleEffectRepository.deleteById(particleEffectId);
    		return ResponseEntity.ok().body(particleEffectRepository.findAll());
    	}
        return ResponseEntity.badRequest().body(null);
    }
	
    @PostMapping("/save")
    @ResponseBody
    public ResponseEntity<List<ParticleEffectEntity>> save(@RequestBody ParticleEffectParam param) {
    	
    	ParticleEffectEntity particleEffect = particleEffectRepository.findByName(param.getName());
    	if(particleEffect == null) {
    		particleEffect = new ParticleEffectEntity();
    		particleEffect.setName(param.getName());
    	}
    	particleEffect.setJson(param.getJson());
    	particleEffect.setDescribtion(param.getDescribtion());
    	particleEffectRepository.save(particleEffect);
        return ResponseEntity.ok().body(particleEffectRepository.findAll());
    }
    
//    @DeleteMapping("/delete")
//    @ResponseBody
//    public ResponseEntity<List<ParticleEffectEntity>> delete(@RequestParam(value="id", required=true) int id){
//    	if(particleEffectRepository.existsById(id)) {
//    		particleEffectRepository.deleteById(id);
//    	}
//    	return ResponseEntity.ok().body(particleEffectRepository.findAll());
//    }
}
