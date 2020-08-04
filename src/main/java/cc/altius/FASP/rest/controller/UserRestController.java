/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.rest.controller;

import cc.altius.FASP.jwt.JwtTokenUtil;
import cc.altius.FASP.jwt.resource.JwtTokenResponse;
import cc.altius.FASP.model.CustomUserDetails;
import cc.altius.FASP.model.EmailUser;
import cc.altius.FASP.model.ForgotPasswordToken;
import cc.altius.FASP.model.LanguageUser;
import cc.altius.FASP.model.Password;
import cc.altius.FASP.model.ResponseCode;
import cc.altius.FASP.model.Role;
import cc.altius.FASP.model.User;
import cc.altius.FASP.security.CustomUserDetailsService;
import cc.altius.FASP.service.UserService;
import cc.altius.utils.PassPhrase;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
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
public class UserRestController {

    private final Logger auditLogger = LoggerFactory.getLogger(UserRestController.class);
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private UserService userService;
    @Autowired
    private CustomUserDetailsService customUserDetailsService;
    @Autowired
    private JwtTokenUtil jwtTokenUtil;
    @Value("${session.expiry.time}")
    private int sessionExpiryTime;
    @Value("${jwt.http.request.header}")
    private String tokenHeader;

    @GetMapping(value = "/userDetails")
    public ResponseEntity getUserDetails(Authentication auth) {
        CustomUserDetails curUser = this.userService.getCustomUserByUserId(((CustomUserDetails) auth.getPrincipal()).getUserId());
        try {
            return new ResponseEntity(this.userService.getUserByUserId(curUser.getUserId()), HttpStatus.OK);
        } catch (Exception e) {
            logger.error("Error while trying to get User details", e);
            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping(value = "/role")
    public ResponseEntity getRoleList() {
        try {
            return new ResponseEntity(this.userService.getRoleList(), HttpStatus.OK);
        } catch (Exception e) {
            logger.error("Error while trying to list Role", e);
            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping(value = "/role/{roleId}")
    public ResponseEntity getRoleById(@PathVariable("roleId") String roleId) {
        try {
            return new ResponseEntity(this.userService.getRoleById(roleId), HttpStatus.OK);
        } catch (Exception e) {
            logger.error("Error while trying to get Role for roleId", e);
            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping(value = "/role")
    public ResponseEntity addNewRole(@RequestBody Role role, Authentication auth) {
        try {
            CustomUserDetails curUser = this.userService.getCustomUserByUserId(((CustomUserDetails) auth.getPrincipal()).getUserId());
            int row = this.userService.addRole(role, curUser);
            if (row > 0) {
                auditLogger.error(role + " added successfully");
                return new ResponseEntity(new ResponseCode("static.message.addSuccess"), HttpStatus.OK);
            } else {
                auditLogger.error("Could not add " + role + " 0 rows updated");
                return new ResponseEntity(new ResponseCode("static.message.addFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
            }
        } catch (DuplicateKeyException e) {
            auditLogger.error("Could no add " + role, e);
            return new ResponseEntity(new ResponseCode("static.message.alreadyExists"), HttpStatus.NOT_ACCEPTABLE);
        } catch (Exception e) {
            auditLogger.error("Could not add " + role, e);
            return new ResponseEntity(new ResponseCode("static.message.addFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping(value = "/role")
    public ResponseEntity editRole(@RequestBody Role role, Authentication auth) {
        try {
            CustomUserDetails curUser = this.userService.getCustomUserByUserId(((CustomUserDetails) auth.getPrincipal()).getUserId());
            int row = this.userService.updateRole(role, curUser);
            if (row > 0) {
                auditLogger.error(role + " updated successfully");
                return new ResponseEntity(new ResponseCode("static.message.updateSuccess"), HttpStatus.OK);
            } else {
                auditLogger.error("Could not updated " + role + " 0 rows updated");
                return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
            }
        } catch (DuplicateKeyException e) {
            auditLogger.error("Error while trying to Add Role", e);
            return new ResponseEntity(new ResponseCode("static.message.alreadyExists"), HttpStatus.NOT_ACCEPTABLE);
        } catch (Exception e) {
            auditLogger.error("Error while trying to Add Role", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping(value = "/businessFunction")
    public ResponseEntity getBusinessFunctionList() {
        try {
            return new ResponseEntity(this.userService.getBusinessFunctionList(), HttpStatus.OK);
        } catch (Exception e) {
            logger.error("Could not get BF list", e);
            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping(value = "/user")
    public ResponseEntity getUserList() {
        try {
            return new ResponseEntity(this.userService.getUserList(), HttpStatus.OK);
        } catch (Exception e) {
            logger.error("Could not get User list", e);
            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping(value = "/user/realmId/{realmId}")
    public ResponseEntity getUserList(@PathVariable("realmId") int realmId, Authentication auth) {
        try {
            CustomUserDetails curUser = this.userService.getCustomUserByUserId(((CustomUserDetails) auth.getPrincipal()).getUserId());
            return new ResponseEntity(this.userService.getUserListForRealm(realmId, curUser), HttpStatus.OK);
        } catch (EmptyResultDataAccessException e) {
            logger.error("Could not get User list for RealmId=" + realmId, e);
            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.NOT_FOUND);
        } catch (AccessDeniedException e) {
            logger.error("Could not get User list for RealmId=" + realmId, e);
            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.FORBIDDEN);
        } catch (Exception e) {
            logger.error("Could not get User list for RealmId=" + realmId, e);
            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping(value = "/user/{userId}")
    public ResponseEntity getUserByUserId(@PathVariable int userId) {
        try {
            auditLogger.info("userId " + userId);
            return new ResponseEntity(this.userService.getUserByUserId(userId), HttpStatus.OK);
        } catch (AccessDeniedException e) {
            logger.error(("Could not get User list for UserId=" + userId));
            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.FORBIDDEN);
        } catch (EmptyResultDataAccessException e) {
            logger.error(("Could not get User list for UserId=" + userId));
            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            logger.error(("Could not get User list for UserId=" + userId));
            auditLogger.info("Could not get User list for UserId=" + e);
            return new ResponseEntity(new ResponseCode("static.message.listFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping(value = "/user")
    public ResponseEntity addUser(@RequestBody User user, Authentication authentication, HttpServletRequest request) {
        CustomUserDetails curUser = (CustomUserDetails) authentication.getPrincipal();
        auditLogger.info("Adding new User " + user.toString(), request.getRemoteAddr(), curUser.getUsername());
        try {
            PasswordEncoder encoder = new BCryptPasswordEncoder();
            String password = PassPhrase.getPassword();
            String hashPass = encoder.encode(password);
            user.setPassword(hashPass);
            String msg = this.userService.checkIfUserExistsByEmailIdAndPhoneNumber(user, 1);
            if (msg.isEmpty()) {
                int userId = this.userService.addNewUser(user, curUser.getUserId());
                if (userId > 0) {
                    String token = this.userService.generateTokenForEmailId(user.getEmailId(), 2);
                    if (token == null || token.isEmpty()) {
                        auditLogger.info("Could not generate a Token for the new user");
                        return new ResponseEntity(new ResponseCode("static.message.tokenNotGenerated"), HttpStatus.INTERNAL_SERVER_ERROR);
                    } else {
                        auditLogger.info("User has been created and credentials link sent on email");
                        return new ResponseEntity(new ResponseCode("static.message.addSuccess"), HttpStatus.OK);
                    }
                } else {
                    auditLogger.info("Failed to add the User");
                    return new ResponseEntity(new ResponseCode("static.message.addFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
                }
            } else {
                auditLogger.info("Failed to add the User beacuse the Username or email id already exists");
                return new ResponseEntity(new ResponseCode(msg), HttpStatus.PRECONDITION_FAILED);
            }
        } catch (Exception e) {
            auditLogger.error("Error", e);
            auditLogger.info("Failed to add the User");
            return new ResponseEntity(new ResponseCode("static.message.addFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping(value = "/user")
    public ResponseEntity editUser(@RequestBody User user, Authentication authentication, HttpServletRequest request) {
        CustomUserDetails curUser = (CustomUserDetails) authentication.getPrincipal();
        auditLogger.info("Going to update User " + user.toString(), request.getRemoteAddr(), curUser.getUsername());
        try {
            String msg = this.userService.checkIfUserExistsByEmailIdAndPhoneNumber(user, 2);
            if (msg.isEmpty()) {
                int row = this.userService.updateUser(user, curUser.getUserId());
                if (row > 0) {
                    auditLogger.info("User updated successfully");
                    return new ResponseEntity(new ResponseCode("static.message.updateSuccess"), HttpStatus.OK);
                } else {
                    auditLogger.info("User could not be updated");
                    return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
                }
            } else {
                auditLogger.info("Failed to add the User beacuse the Username or email id already exists");
                return new ResponseEntity(new ResponseCode(msg), HttpStatus.PRECONDITION_FAILED);
            }
        } catch (Exception e) {
            auditLogger.info("User could not be updated", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping(value = "/unlockAccount/{userId}/{emailId}")
    public ResponseEntity unlockAccount(@PathVariable int userId, @PathVariable String emailId, Authentication authentication, HttpServletRequest request) throws UnsupportedEncodingException {
        CustomUserDetails curUser = (CustomUserDetails) authentication.getPrincipal();
        auditLogger.info("Going to unlock account for userId: " + userId + " emailId:" + emailId, request.getRemoteAddr(), curUser.getUsername());
        try {
            User user = this.userService.getUserByUserId(userId);
            if (!user.getEmailId().equals(emailId)) {
                auditLogger.info("Incorrect emailId or UserId");
                return new ResponseEntity(new ResponseCode("static.message.accountUnlocked"), HttpStatus.OK);
            }
            PasswordEncoder encoder = new BCryptPasswordEncoder();
            String password = PassPhrase.getPassword();
            String hashPass = encoder.encode(password);
            int row = this.userService.unlockAccount(userId, hashPass);
            if (row > 0) {
                String token = this.userService.generateTokenForEmailId(user.getEmailId(), 1);
                if (token == null || token.isEmpty()) {
                    auditLogger.info("User could not be unlocked as Token could not be generated");
                    return new ResponseEntity(new ResponseCode("static.message.tokenNotGenerated"), HttpStatus.INTERNAL_SERVER_ERROR);
                } else {
                    auditLogger.info("User unlocked and email sent with credentials link");
                    return new ResponseEntity(new ResponseCode("static.message.accountUnlocked"), HttpStatus.OK);
                }
            } else {
                auditLogger.info("User could not be unlocked");
                return new ResponseEntity(new ResponseCode("static.message.tokenNotGenerated"), HttpStatus.INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            auditLogger.info("User could not be unlocked", e);
            return new ResponseEntity(new ResponseCode("static.message.tokenNotGenerated"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping(value = "/updateExpiredPassword")
    public ResponseEntity updateExpiredPassword(@RequestBody Password password) {
        try {
            if (password.getOldPassword().equals(password.getNewPassword())) {
                return new ResponseEntity(new ResponseCode("static.message.passwordSame"), HttpStatus.PRECONDITION_FAILED);
            }
            if (!this.userService.confirmPassword(password.getEmailId(), password.getOldPassword().trim())) {
                return new ResponseEntity(new ResponseCode("static.message.incorrectPassword"), HttpStatus.FORBIDDEN);
            } else {
                final CustomUserDetails userDetails = this.customUserDetailsService.loadUserByUsername(password.getEmailId());
                PasswordEncoder encoder = new BCryptPasswordEncoder();
                String hashPass = encoder.encode(password.getNewPassword());
                password.setNewPassword(hashPass);
                int row = this.userService.updatePassword(userDetails.getUserId(), password.getNewPassword(), 90);
                if (row > 0) {
                    userDetails.setSessionExpiresOn(sessionExpiryTime);
                    userDetails.setPassword(hashPass);
                    final String token = jwtTokenUtil.generateToken(userDetails);
                    this.userService.updateSuncExpiresOn(password.getEmailId());
                    return ResponseEntity.ok(new JwtTokenResponse(token));
                } else {
                    return new ResponseEntity(new ResponseCode("static.message.failedPasswordUpdate"), HttpStatus.PRECONDITION_FAILED);
                }
            }
        } catch (Exception e) {
            return new ResponseEntity(new ResponseCode("static.message.failedPasswordUpdate"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping(value = "/changePassword")
    public ResponseEntity changePassword(@RequestBody Password password) {
        try {
            User user = this.userService.getUserByUserId(password.getUserId());
            if (!this.userService.confirmPassword(user.getEmailId(), password.getOldPassword().trim())) {
                return new ResponseEntity(new ResponseCode("static.message.incorrectPassword"), HttpStatus.FORBIDDEN);
            } else {
                PasswordEncoder encoder = new BCryptPasswordEncoder();
                String hashPass = encoder.encode(password.getNewPassword());
                password.setNewPassword(hashPass);
                int row = this.userService.updatePassword(password.getUserId(), password.getNewPassword(), 90);
                if (row > 0) {
                    Map<String, String> params = new HashMap<>();
                    params.put("hashPass", hashPass);
                    return new ResponseEntity(params, HttpStatus.OK);
                } else {
                    return new ResponseEntity(new ResponseCode("static.message.failedPasswordUpdate"), HttpStatus.PRECONDITION_FAILED);
                }
            }
        } catch (Exception e) {
            return new ResponseEntity(new ResponseCode("static.message.failedPasswordUpdate"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping(value = "/forgotPassword")
    public ResponseEntity forgotPassword(@RequestBody EmailUser user, HttpServletRequest request) {
        auditLogger.info("Forgot password action triggered for Email Id:" + user.getEmailId(), request.getRemoteAddr());
        try {
            CustomUserDetails customUser = this.userService.getCustomUserByEmailId(user.getEmailId());
            if (customUser != null) {
                if (customUser.isActive()) {
                    String token = this.userService.generateTokenForEmailId(user.getEmailId(), 1);
                    if (token == null || token.isEmpty()) {
                        auditLogger.info("Could not process request as Token could not be generated");
                        return new ResponseEntity(new ResponseCode("static.message.tokenNotGenerated"), HttpStatus.INTERNAL_SERVER_ERROR);
                    } else {
                        auditLogger.info("Forgot password request processed for Email Id: " + user.getEmailId() + " email with password reset link sent");
                        Map<String, String> params = new HashMap<>();
                        params.put("token", token);
                        return new ResponseEntity(params, HttpStatus.OK);
                    }
                } else {
                    auditLogger.info("User is disabled Email Id: " + user.getEmailId());
                    return new ResponseEntity(new ResponseCode("static.message.user.disabled"), HttpStatus.FORBIDDEN);
                }
            } else {
                auditLogger.info("User does not exists with this Email Id " + user.getEmailId());
                return new ResponseEntity(new ResponseCode("static.message.user.forgotPasswordSuccess"), HttpStatus.NOT_FOUND);
            }
        } catch (Exception e) {
            auditLogger.info("Error while generating Token for forgot password", e);
            return new ResponseEntity(new ResponseCode("static.message.tokenNotGenerated"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/confirmForgotPasswordToken")
    public ResponseEntity confirmForgotPasswordToken(@RequestBody EmailUser user, HttpServletRequest request) {
        try {
            ForgotPasswordToken fpt = this.userService.getForgotPasswordToken(user.getEmailId(), user.getToken());
            auditLogger.info("Confirm forgot password has been triggered for Username:" + user.getUsername(), request.getRemoteAddr());
            if (fpt.isValidForTriggering()) {
                this.userService.updateTriggeredDateForForgotPasswordToken(user.getEmailId(), user.getToken());
                auditLogger.info("Token is valid and reset can proceed");
                return new ResponseEntity(HttpStatus.OK);
            } else {
                this.userService.updateCompletionDateForForgotPasswordToken(user.getEmailId(), user.getToken());
                auditLogger.info("Token is not valid or has expired");
                return new ResponseEntity(new ResponseCode(fpt.inValidReasonForTriggering()), HttpStatus.FORBIDDEN);
            }
        } catch (Exception e) {
            auditLogger.info("Could not confirm Token", e);
            return new ResponseEntity(new ResponseCode("static.message.forgotPasswordTokenError"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/updatePassword")
    public ResponseEntity updatePaassword(@RequestBody EmailUser user, HttpServletRequest request) {
        try {
            auditLogger.info("Update password triggered for Username: " + user.getUsername(), request.getRemoteAddr());
            ForgotPasswordToken fpt = this.userService.getForgotPasswordToken(user.getEmailId(), user.getToken());
            if (fpt.isValidForCompletion()) {
                // Go ahead and reset the password
                CustomUserDetails curUser = this.userService.getCustomUserByEmailId(user.getEmailId());
                BCryptPasswordEncoder bcrypt = new BCryptPasswordEncoder();
                if (bcrypt.matches(user.getPassword(), curUser.getPassword())) {
                    auditLogger.info("Failed to reset the password because New password is same as current password");
                    return new ResponseEntity(new ResponseCode("static.message.user.previousPasswordSame"), HttpStatus.PRECONDITION_FAILED);
                } else {
                    this.userService.updatePassword(user.getEmailId(), user.getToken(), user.getHashPassword(), 90);
                    auditLogger.info("Password has now been updated successfully for Username: " + user.getUsername());
                    return new ResponseEntity(new ResponseCode("static.message.passwordSuccess"), HttpStatus.OK);
                }
            } else {
                auditLogger.info("Failed to reset the password invlaid Token");
                return new ResponseEntity(new ResponseCode(fpt.inValidReasonForCompletion()), HttpStatus.FORBIDDEN);
            }
        } catch (Exception e) {
            auditLogger.info("Could not update password", e);
            return new ResponseEntity(new ResponseCode("static.message.user.forgotPasswordTokenError"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping(value = "/logout")
    public ResponseEntity logout(Authentication authentication, HttpServletRequest request) {
        CustomUserDetails curUser = (CustomUserDetails) authentication.getPrincipal();
        try {
            auditLogger.info("Received a Logout request for Username: " + curUser.getUsername(), request.getRemoteAddr());
            final String requestTokenHeader = request.getHeader(this.tokenHeader);
            String jwtToken;
            if (requestTokenHeader != null && requestTokenHeader.startsWith("Bearer ")) {
                jwtToken = requestTokenHeader.substring(7);
                this.userService.addTokenToLogout(jwtToken);
                auditLogger.info("Successfully logged out Username: " + curUser.getUsername());
                return new ResponseEntity(HttpStatus.OK);
            } else {
                auditLogger.info("Could not logout Invalid Token Username: " + curUser.getUsername());
                return new ResponseEntity(new ResponseCode("static.message.logoutFailed"), HttpStatus.FORBIDDEN);
            }
        } catch (Exception e) {
            auditLogger.info("Error while trying to logout Username: " + curUser.getUsername(), e);
            return new ResponseEntity(new ResponseCode("static.message.logoutFailed"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping(value = "/checkIfUserExists")
    public ResponseEntity checkIfUserExists(HttpServletRequest request) throws UnsupportedEncodingException {
        try {
            String username = request.getHeader("username");
            String password = request.getHeader("password");
            if (username == null || password == null) {
                return new ResponseEntity("static.message.notExist", HttpStatus.NOT_ACCEPTABLE);
            }
            Map<String, Object> responseMap = this.userService.checkIfUserExists(username, password);
            CustomUserDetails customUserDetails = (CustomUserDetails) responseMap.get("customUserDetails");
            if (customUserDetails != null) {
                return new ResponseEntity(customUserDetails, HttpStatus.OK);
            } else {
                return new ResponseEntity("static.message.listFailed", HttpStatus.NOT_ACCEPTABLE);
            }
        } catch (Exception e) {
            logger.error("Error", e);
            return new ResponseEntity("static.message.listFailed", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping(value = "/accessControls")
    public ResponseEntity accessControl(@RequestBody User user, Authentication auth) {
        try {
            CustomUserDetails curUser = this.userService.getCustomUserByUserId(((CustomUserDetails) auth.getPrincipal()).getUserId());
            int row = this.userService.mapAccessControls(user, curUser);
            if (row > 0) {
                auditLogger.error(user + " updated successfully");
                return new ResponseEntity(new ResponseCode("static.message.accessControlSuccess"), HttpStatus.OK);
            } else if (row == -2) {
                auditLogger.error("Either add All access or specific access " + user);
                return new ResponseEntity(new ResponseCode("static.message.allAclAccess"), HttpStatus.INTERNAL_SERVER_ERROR);
            } else {
                auditLogger.error("Could not updated " + user + " 0 rows updated");
                return new ResponseEntity(new ResponseCode("static.message.updateFailedAcl"), HttpStatus.INTERNAL_SERVER_ERROR);
            }
        } catch (DuplicateKeyException e) {
//            System.out.println("Duplicate Access Controls");
            auditLogger.error("Duplicate Access Controls", e);
            return new ResponseEntity(new ResponseCode("static.message.user.duplicateacl"), HttpStatus.INTERNAL_SERVER_ERROR);
        } catch (Exception e) {
            auditLogger.error("Error while trying to Add Access Controls", e);
            return new ResponseEntity(new ResponseCode("static.message.updateFailedAcl"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/user/language")
    public ResponseEntity updateUserLanguage(@RequestBody LanguageUser languageUser, Authentication auth) {
        try {
            CustomUserDetails curUser = this.userService.getCustomUserByUserId(((CustomUserDetails) auth.getPrincipal()).getUserId());
            auditLogger.info("Update language change triggered for Username: " + curUser.getUsername());
            this.userService.updateUserLanguage(curUser.getUserId(), languageUser.getLanguageCode());
            auditLogger.info("Preferred language updated successfully for Username: " + curUser.getUsername());
            return new ResponseEntity("", HttpStatus.OK);
        } catch (Exception e) {
            auditLogger.info("Could not update preferred language", e);
            return new ResponseEntity(new ResponseCode("static.message.user.languageChangeError"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/user/agreement")
    public ResponseEntity acceptUserAgreement(Authentication auth) {
        try {
//            CustomUserDetails curUser = this.userService.getCustomUserByUserId(((CustomUserDetails) auth.getPrincipal()).getUserId());
//            System.out.println("cur user---"+curUser);
            auditLogger.info("auth 1: " + (CustomUserDetails) auth.getPrincipal());
            auditLogger.info("auth 2: " + auth);
            auditLogger.info("auth 3: " + ((CustomUserDetails) auth.getPrincipal()).getUserId());
//            auditLogger.info("Update agreement for Username: " + curUser);
            this.userService.acceptUserAgreement(((CustomUserDetails) auth.getPrincipal()).getUserId());
//            auditLogger.info("Agreement updated successfully for Username: " + curUser.getUsername());
            return new ResponseEntity("", HttpStatus.OK);
        } catch (Exception e) {
            auditLogger.info("Could not update agreement", e);
            return new ResponseEntity(new ResponseCode("static.message.user.languageChangeError"), HttpStatus.INTERNAL_SERVER_ERROR);
        }

    }
}
