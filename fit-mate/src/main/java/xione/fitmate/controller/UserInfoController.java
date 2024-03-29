package xione.fitmate.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import xione.fitmate.domain.Sex;
import xione.fitmate.domain.User;
import xione.fitmate.payload.request.RegisterUserInfoRequest;
import xione.fitmate.payload.response.StatusResponse;
import xione.fitmate.payload.response.UserInfoResponse;
import xione.fitmate.repository.UserRepository;
import xione.fitmate.security.oauth2.CustomUserDetails;
import xione.fitmate.service.UserInfoService;

import javax.validation.Valid;
import java.time.LocalDate;
import java.util.List;

@Log4j2
@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/userinfo")
@RequiredArgsConstructor
public class UserInfoController {

    private final UserInfoService userinfoService;
    private final UserRepository userRepository;


    @PostMapping
    public ResponseEntity<?> registerUserInfo(@Valid @RequestBody RegisterUserInfoRequest loginRequest) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = Long.valueOf(userDetails.getName());

        String nickname = loginRequest.getNickname();
        String region = loginRequest.getRegion();
        LocalDate birth = loginRequest.getBirth();
        Sex sex = loginRequest.getSex();
        List<String> sports = loginRequest.getSports();
        log.info(sports.getClass());
        log.info(userId);
        log.info(region);
        log.info(birth);
        log.info(sex);
        log.info(sports);
        userinfoService.register(userId, nickname, sex, birth, region, sports);




        return ResponseEntity.status(HttpStatus.OK).body(new StatusResponse("User registered successfully!"));    }

    @GetMapping("/{user_id}")
    public ResponseEntity<?> readUserInfo( @PathVariable Long user_id) {
        User user = userRepository.findById(user_id).orElseThrow(IllegalAccessError::new);

        UserInfoResponse response = new UserInfoResponse(
                                                        user.getId(),
                                                        user.getName(),
                                                        user.getSex(),
                                                        user.getEmail(),
                                                        user.getBirth(),
                                                        user.getSports(),
                                                        user.getImg(),
                                                        user.getCash(),
                                                        user.getRegion());
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

}
