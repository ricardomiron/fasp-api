/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.rest.controller;

import cc.altius.FASP.model.CustomUserDetails;
import cc.altius.FASP.model.HealthArea;
import cc.altius.FASP.model.ResponseFormat;
import cc.altius.FASP.service.HealthAreaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 *
 * @author akil
 */
@RestController
@RequestMapping("/api")
@CrossOrigin(origins = {"http://localhost:4202", "https://faspdeveloper.github.io", "chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop"})
public class HealthAreaRestController {

    @Autowired
    private HealthAreaService healthAreaService;

    @PostMapping(path = "/api/healthArea")
    public ResponseFormat postHealthArea(@RequestBody HealthArea heatlhArea, Authentication auth) {
        try {
            int curUser = ((CustomUserDetails) auth.getPrincipal()).getUserId();
            int healthAreaId = this.healthAreaService.addHealthArea(heatlhArea, curUser);
            return new ResponseFormat("Successfully added HealthArea with Id " + healthAreaId);
        } catch (Exception e) {
            return new ResponseFormat("Failed", e.getMessage());
        }
    }

    @PutMapping(path = "/api/healthArea")
    public ResponseFormat putHealhArea(@RequestBody HealthArea heatlhArea, Authentication auth) {
        try {
            int curUser = ((CustomUserDetails) auth.getPrincipal()).getUserId();
            int rows = this.healthAreaService.updateHealthArea(heatlhArea, curUser);
            return new ResponseFormat("Successfully updated HealthArea");
        } catch (Exception e) {
            return new ResponseFormat("Failed", e.getMessage());
        }
    }

    @GetMapping("/api/healthArea")
    public ResponseFormat getHealthArea() {
        try {
            return new ResponseFormat("Success", "", this.healthAreaService.getHealthAreaList());
        } catch (Exception e) {
            return new ResponseFormat("Failed", e.getMessage());
        }
    }

    @GetMapping("/api/healthArea/{healthAreaId}")
    public ResponseFormat getHealthArea(@PathVariable("healthAreaId") int healthAreaId) {
        try {
            return new ResponseFormat("Success", "", this.healthAreaService.getHealthAreaById(healthAreaId));
        } catch (Exception e) {
            return new ResponseFormat("Failed", e.getMessage());
        }
    }
}
