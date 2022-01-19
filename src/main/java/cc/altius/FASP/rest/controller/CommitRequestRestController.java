/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.rest.controller;

import cc.altius.FASP.exception.CouldNotSaveException;
import cc.altius.FASP.model.CommitRequest;
import cc.altius.FASP.model.CustomUserDetails;
import cc.altius.FASP.model.DatasetData;
import cc.altius.FASP.model.ProgramData;
import cc.altius.FASP.model.ResponseCode;
import cc.altius.FASP.model.report.CommitRequestInput;
import cc.altius.FASP.service.CommitRequestService;
import cc.altius.FASP.service.ProgramService;
import cc.altius.FASP.service.UserService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

/**
 *
 * @author akil
 */
@RestController
@RequestMapping("/api")
public class CommitRequestRestController {

    @Autowired
    private UserService userService;
    @Autowired
    private CommitRequestService commitRequestService;
    @Autowired
    private ProgramService programService;

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    // Part 1 of the Commit Request for Supply Plan
    @PutMapping("/programData/{comparedVersionId}")
    public ResponseEntity putProgramData(@PathVariable(value = "comparedVersionId", required = true) int comparedVersionId, HttpServletRequest request, Authentication auth) {
        try {
            String json = IOUtils.toString(request.getReader());
            Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").setLenient().create();
            ProgramData programData = gson.fromJson(json, new TypeToken<DatasetData>() {
            }.getType());
            int latestVersion = this.programService.getLatestVersionForPrograms("" + programData.getProgramId()).get(0).getVersionId();
            if (latestVersion == comparedVersionId) {
                boolean checkIfRequestExists = this.commitRequestService.checkIfCommitRequestExistsForProgram(programData.getProgramId());
                if (!checkIfRequestExists) {
                    CustomUserDetails curUser = this.userService.getCustomUserByUserId(((CustomUserDetails) auth.getPrincipal()).getUserId());
                    int commitRequestId = this.commitRequestService.saveProgramData(programData, json, curUser);
                    return new ResponseEntity(commitRequestId, HttpStatus.OK);
                } else {
                    logger.error("Request already exists");
                    return new ResponseEntity(new ResponseCode("static.commitVersion.requestAlreadyExists"), HttpStatus.NOT_ACCEPTABLE);
                }
            } else {
                logger.error("Compared version is not latest");
                return new ResponseEntity(new ResponseCode("static.commitVersion.versionIsOutDated"), HttpStatus.NOT_ACCEPTABLE);
            }
//            this.programDataService.getProgramData(programData.getProgramId(), v.getVersionId(), curUser,false)
        } catch (CouldNotSaveException e) {
            logger.error("Error while trying to update ProgramData", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.PRECONDITION_FAILED);
        } catch (EmptyResultDataAccessException e) {
            logger.error("Error while trying to update ProgramData", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.NOT_FOUND);
        } catch (AccessDeniedException e) {
            logger.error("Error while trying to update ProgramData", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.FORBIDDEN);
        } catch (Exception e) {
            logger.error("Error while trying to update ProgramData", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // Part 1 of the Commit Request for Dataset
    @PutMapping("/datasetData/{comparedVersionId}")
    public ResponseEntity putDatasetData(@PathVariable(value = "comparedVersionId", required = true) int comparedVersionId, HttpServletRequest request, Authentication auth) {
        try {
            String json = IOUtils.toString(request.getReader());
            Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").setLenient().create();
            DatasetData datasetData = gson.fromJson(json, new TypeToken<DatasetData>() {
            }.getType());
            int latestVersion = this.programService.getLatestVersionForPrograms("" + datasetData.getProgramId()).get(0).getVersionId();
            if (latestVersion == comparedVersionId) {
                boolean checkIfRequestExists = this.commitRequestService.checkIfCommitRequestExistsForProgram(datasetData.getProgramId());
                if (!checkIfRequestExists) {
                    CustomUserDetails curUser = this.userService.getCustomUserByUserId(((CustomUserDetails) auth.getPrincipal()).getUserId());
                    int commitRequestId = this.commitRequestService.saveDatasetData(datasetData, json, curUser);
                    return new ResponseEntity(commitRequestId, HttpStatus.OK);
                } else {
                    logger.error("Request already exists");
                    return new ResponseEntity(new ResponseCode("static.commitVersion.requestAlreadyExists"), HttpStatus.NOT_ACCEPTABLE);
                }
            } else {
                logger.error("Compared version is not latest");
                return new ResponseEntity(new ResponseCode("static.commitVersion.versionIsOutDated"), HttpStatus.NOT_ACCEPTABLE);
            }
//            this.programDataService.getProgramData(programData.getProgramId(), v.getVersionId(), curUser,false)
        } catch (CouldNotSaveException e) {
            logger.error("Error while trying to update ProgramData", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.PRECONDITION_FAILED);
        } catch (EmptyResultDataAccessException e) {
            logger.error("Error while trying to update ProgramData", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.NOT_FOUND);
        } catch (AccessDeniedException e) {
            logger.error("Error while trying to update ProgramData", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.FORBIDDEN);
        } catch (Exception e) {
            logger.error("Error while trying to update ProgramData", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // Part 2 of the Commit Request
    @GetMapping("/processCommitRequest")
    //sec min hour day_of_month month day_of_week
    @Scheduled(cron = "00 */1 * * * *")
    public ResponseEntity processCommitRequest() {
        try {
            CustomUserDetails curUser = this.userService.getCustomUserByUserId(1);
            this.commitRequestService.processCommitRequest(curUser);
            return new ResponseEntity(HttpStatus.OK);
//        } catch (CouldNotSaveException e) {
//            logger.error("Error while trying to processCommitRequest", e);
//            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.PRECONDITION_FAILED);
        } catch (EmptyResultDataAccessException e) {
            logger.error("Error while trying to processCommitRequest", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.NOT_FOUND);
        } catch (AccessDeniedException e) {
            logger.error("Error while trying to processCommitRequest", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.FORBIDDEN);
        } catch (Exception e) {
            logger.error("Error while trying to processCommitRequest", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/getCommitRequest/{requestStatus}")
    public ResponseEntity getProgramDataCommitRequest(@RequestBody CommitRequestInput spcr, @PathVariable(value = "requestStatus", required = true) int requestStatus, Authentication auth) {
        try {
            CustomUserDetails curUser = this.userService.getCustomUserByUserId(((CustomUserDetails) auth.getPrincipal()).getUserId());
            List<CommitRequest> spcrList = this.commitRequestService.getCommitRequestList(spcr, requestStatus, curUser);
            return new ResponseEntity(spcrList, HttpStatus.OK);
//            this.programDataService.getProgramData(programData.getProgramId(), v.getVersionId(), curUser,false)
        } catch (AccessDeniedException e) {
            logger.error("Error while trying to get SupplyPlanCommitRequest list", e);
            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.FORBIDDEN);
        } catch (Exception e) {
            logger.error("Error while trying to get SupplyPlanCommitRequest list", e);
            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    /**
     * Asynchronous API used to get the commit status
     *
     *
     * @return returns the commit status
     */
    @Operation(description = "Asynchronous API used to get the commit status.", summary = "Asynchronous API to get commit status", tags = ("commitStatus"))
    @ApiResponse(content = @Content(mediaType = "text/json"), responseCode = "200", description = "Returns the Integration Program list")
    @GetMapping("sendNotification/{commitRequestId}")
    public @ResponseBody
    CompletableFuture<ResponseEntity> sendNotification(@PathVariable("commitRequestId") int commitRequestId) throws InterruptedException {
//        System.out.println("inside send notification"+commitRequestId);
        return this.commitRequestService.getCommitRequestStatusByCommitRequestId(commitRequestId).thenApplyAsync(ResponseEntity -> {
//            System.out.println("ResponseEntity+++"+ResponseEntity);
            return new ResponseEntity(ResponseEntity, HttpStatus.OK);
        });
    }
}